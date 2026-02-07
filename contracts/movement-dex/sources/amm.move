module MovementDex::amm {
  use aptos_framework::coin;
  use aptos_framework::table;
  use aptos_framework::event;
  use aptos_framework::signer;

  const EPOOL_EXISTS: u64 = 1;
  const EPOOL_NOT_FOUND: u64 = 2;
  const EZERO_AMOUNT: u64 = 3;
  const EINSUFFICIENT_LIQUIDITY: u64 = 4;

  struct Pool<phantom X, phantom Y> has key {
    reserve_x: coin::Coin<X>,
    reserve_y: coin::Coin<Y>,
    total_shares: u128,
    shares: table::Table<address, u128>,
    add_liquidity_events: event::EventHandle<AddLiquidityEvent>,
    remove_liquidity_events: event::EventHandle<RemoveLiquidityEvent>,
    swap_events: event::EventHandle<SwapEvent>
  }

  struct AddLiquidityEvent has drop, store {
    provider: address,
    amount_x: u64,
    amount_y: u64,
    shares_minted: u128
  }

  struct RemoveLiquidityEvent has drop, store {
    provider: address,
    amount_x: u64,
    amount_y: u64,
    shares_burned: u128
  }

  struct SwapEvent has drop, store {
    trader: address,
    input_amount: u64,
    output_amount: u64,
    fee_bps: u64,
    direction: u8
  }

  public entry fun init_pool<X: store, Y: store>(admin: &signer) {
    let admin_addr = signer::address_of(admin);
    assert!(!exists<Pool<X, Y>>(admin_addr), EPOOL_EXISTS);
    let shares = table::new<address, u128>(admin_addr);
    let add_events = event::new_event_handle<AddLiquidityEvent>(admin);
    let remove_events = event::new_event_handle<RemoveLiquidityEvent>(admin);
    let swap_events = event::new_event_handle<SwapEvent>(admin);

    move_to(admin, Pool<X, Y> {
      reserve_x: coin::zero<X>(),
      reserve_y: coin::zero<Y>(),
      total_shares: 0,
      shares,
      add_liquidity_events: add_events,
      remove_liquidity_events: remove_events,
      swap_events
    });
  }

  fun borrow_pool<X: store, Y: store>(admin_addr: address): &mut Pool<X, Y> {
    assert!(exists<Pool<X, Y>>(admin_addr), EPOOL_NOT_FOUND);
    borrow_global_mut<Pool<X, Y>>(admin_addr)
  }

  public entry fun add_liquidity<X: store, Y: store>(
    provider: &signer,
    admin_addr: address,
    mut amount_x: coin::Coin<X>,
    mut amount_y: coin::Coin<Y>
  ) {
    let provider_addr = signer::address_of(provider);
    let pool = borrow_pool<X, Y>(admin_addr);
    let input_x = coin::value(&amount_x);
    let input_y = coin::value(&amount_y);
    assert!(input_x > 0 && input_y > 0, EZERO_AMOUNT);

    let shares_to_mint = if (pool.total_shares == 0) {
      (input_x as u128) * (input_y as u128)
    } else {
      let share_x = (input_x as u128) * pool.total_shares / (coin::value(&pool.reserve_x) as u128);
      let share_y = (input_y as u128) * pool.total_shares / (coin::value(&pool.reserve_y) as u128);
      if (share_x < share_y) share_x else share_y
    };

    pool.total_shares = pool.total_shares + shares_to_mint;
    let current_share = if (table::contains(&pool.shares, provider_addr)) {
      table::borrow(&pool.shares, provider_addr)
    } else {
      0
    };
    table::upsert(&mut pool.shares, provider_addr, current_share + shares_to_mint);

    coin::merge(&mut pool.reserve_x, amount_x);
    coin::merge(&mut pool.reserve_y, amount_y);

    event::emit_event(
      &mut pool.add_liquidity_events,
      AddLiquidityEvent {
        provider: provider_addr,
        amount_x: input_x,
        amount_y: input_y,
        shares_minted: shares_to_mint
      }
    );
  }

  public entry fun remove_liquidity<X: store, Y: store>(
    provider: &signer,
    admin_addr: address,
    shares_to_burn: u128
  ): (coin::Coin<X>, coin::Coin<Y>) {
    let provider_addr = signer::address_of(provider);
    let pool = borrow_pool<X, Y>(admin_addr);
    assert!(shares_to_burn > 0, EZERO_AMOUNT);
    let current_share = if (table::contains(&pool.shares, provider_addr)) {
      table::borrow(&pool.shares, provider_addr)
    } else {
      0
    };
    assert!(current_share >= shares_to_burn, EINSUFFICIENT_LIQUIDITY);

    let reserve_x_value = coin::value(&pool.reserve_x);
    let reserve_y_value = coin::value(&pool.reserve_y);

    let amount_x = (reserve_x_value as u128) * shares_to_burn / pool.total_shares;
    let amount_y = (reserve_y_value as u128) * shares_to_burn / pool.total_shares;

    pool.total_shares = pool.total_shares - shares_to_burn;
    table::upsert(&mut pool.shares, provider_addr, current_share - shares_to_burn);

    let out_x = coin::extract(&mut pool.reserve_x, amount_x as u64);
    let out_y = coin::extract(&mut pool.reserve_y, amount_y as u64);

    event::emit_event(
      &mut pool.remove_liquidity_events,
      RemoveLiquidityEvent {
        provider: provider_addr,
        amount_x: amount_x as u64,
        amount_y: amount_y as u64,
        shares_burned: shares_to_burn
      }
    );

    (out_x, out_y)
  }

  public entry fun swap_x_for_y<X: store, Y: store>(
    trader: &signer,
    admin_addr: address,
    mut amount_in: coin::Coin<X>
  ): coin::Coin<Y> {
    let pool = borrow_pool<X, Y>(admin_addr);
    let input_value = coin::value(&amount_in);
    assert!(input_value > 0, EZERO_AMOUNT);

    let fee_bps = 30;
    let input_after_fee = (input_value as u128) * (10000 - fee_bps) / 10000;

    let reserve_x = coin::value(&pool.reserve_x) as u128;
    let reserve_y = coin::value(&pool.reserve_y) as u128;

    let new_reserve_x = reserve_x + input_after_fee;
    let k = reserve_x * reserve_y;
    let new_reserve_y = k / new_reserve_x;
    let output_value = reserve_y - new_reserve_y;

    assert!(output_value > 0, EINSUFFICIENT_LIQUIDITY);

    coin::merge(&mut pool.reserve_x, amount_in);
    let out = coin::extract(&mut pool.reserve_y, output_value as u64);

    event::emit_event(
      &mut pool.swap_events,
      SwapEvent {
        trader: signer::address_of(trader),
        input_amount: input_value,
        output_amount: output_value as u64,
        fee_bps,
        direction: 0
      }
    );

    out
  }

  public entry fun swap_y_for_x<X: store, Y: store>(
    trader: &signer,
    admin_addr: address,
    mut amount_in: coin::Coin<Y>
  ): coin::Coin<X> {
    let pool = borrow_pool<X, Y>(admin_addr);
    let input_value = coin::value(&amount_in);
    assert!(input_value > 0, EZERO_AMOUNT);

    let fee_bps = 30;
    let input_after_fee = (input_value as u128) * (10000 - fee_bps) / 10000;

    let reserve_x = coin::value(&pool.reserve_x) as u128;
    let reserve_y = coin::value(&pool.reserve_y) as u128;

    let new_reserve_y = reserve_y + input_after_fee;
    let k = reserve_x * reserve_y;
    let new_reserve_x = k / new_reserve_y;
    let output_value = reserve_x - new_reserve_x;

    assert!(output_value > 0, EINSUFFICIENT_LIQUIDITY);

    coin::merge(&mut pool.reserve_y, amount_in);
    let out = coin::extract(&mut pool.reserve_x, output_value as u64);

    event::emit_event(
      &mut pool.swap_events,
      SwapEvent {
        trader: signer::address_of(trader),
        input_amount: input_value,
        output_amount: output_value as u64,
        fee_bps,
        direction: 1
      }
    );

    out
  }
}
