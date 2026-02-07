# Movement DEX Suite

A full English demo implementation of a DEX + Aggregator + Pools dashboard for the Movement Network, with:

- **Frontend:** Next.js (responsive UI inspired by Yuzu + Meridian).
- **Backend:** Node.js + Express API for pools, routes, and swap quotes.
- **Wallet adapters:** Nightly, Razor, and Petra (UI wiring ready for adapter integration).

## Frontend

```bash
cd frontend
npm install
npm run dev
```

## Backend

```bash
cd backend
npm install
npm run dev
```

## API endpoints

- `GET /health`
- `GET /api/pools`
- `GET /api/aggregator/routes`
- `POST /api/swap/quote`

## Notes

This is a UI/UX and API skeleton for Movement Network and can be wired to real adapters, indexers, and on-chain contracts.

## Smart contract (Move)

The Move package lives in `contracts/movement-dex` and provides a constant-product AMM module you can deploy and use immediately.

### Deploy

1. Update the `MovementDex` address in `contracts/movement-dex/Move.toml` to your account address.
2. Publish the package with the Movement CLI:

```bash
cd contracts/movement-dex
movement move publish
```

### Use

Initialize a pool and interact with it using entry functions:

```move
MovementDex::amm::init_pool<0x1::aptos_coin::AptosCoin, 0x1::aptos_coin::AptosCoin>(admin_signer);
MovementDex::amm::add_liquidity<0x1::aptos_coin::AptosCoin, 0x1::aptos_coin::AptosCoin>(provider, admin_addr, coin_x, coin_y);
MovementDex::amm::swap_x_for_y<0x1::aptos_coin::AptosCoin, 0x1::aptos_coin::AptosCoin>(trader, admin_addr, amount_in);
```

The module supports:

- Pool initialization per token pair.
- Add/remove liquidity with share accounting.
- Swaps in both directions with a 0.30% fee and events emitted for analytics.
