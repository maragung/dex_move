const pools = [
  {
    name: "MOVE / USDC",
    tvl: "$42.5M",
    apr: "18.2%",
    volume: "$12.1M"
  },
  {
    name: "mETH / MOVE",
    tvl: "$18.9M",
    apr: "14.7%",
    volume: "$4.6M"
  },
  {
    name: "mBTC / USDT",
    tvl: "$9.3M",
    apr: "11.3%",
    volume: "$3.2M"
  }
];

export default function Pools() {
  return (
    <section className="container">
      <h2>Pools & Liquidity</h2>
      <div className="section-grid">
        <div className="card">
          <h3>Liquidity Dashboard</h3>
          <p>Manage concentrated liquidity positions and rewards.</p>
          <div className="stack">
            <div className="table">
              <div className="table-row header">
                <span>Pool</span>
                <span>TVL</span>
                <span>APR</span>
                <span>Volume</span>
              </div>
              {pools.map((pool) => (
                <div key={pool.name} className="table-row">
                  <span>{pool.name}</span>
                  <span>{pool.tvl}</span>
                  <span>{pool.apr}</span>
                  <span className="badge">{pool.volume}</span>
                </div>
              ))}
            </div>
            <button className="primary-btn">Add Liquidity</button>
          </div>
        </div>
        <div className="card">
          <h3>Pool Tools</h3>
          <ul className="stack">
            <li>Automated fee compounding and vault strategy templates.</li>
            <li>Risk dashboards with impermanent loss estimates.</li>
            <li>Rewards optimizer for multi-incentive campaigns.</li>
          </ul>
        </div>
      </div>
    </section>
  );
}
