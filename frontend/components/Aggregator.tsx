const routes = [
  {
    path: "MOVE → mUSDC",
    venues: "Wave AMM → Meridian Pool",
    est: "0.38%",
    savings: "$18.40"
  },
  {
    path: "mETH → MOVE",
    venues: "Yuzu v2 → MoveX",
    est: "0.52%",
    savings: "$11.20"
  },
  {
    path: "USDT → mBTC",
    venues: "CrossPool → Drift",
    est: "0.61%",
    savings: "$7.05"
  }
];

export default function Aggregator() {
  return (
    <section className="container">
      <h2>Smart Aggregator</h2>
      <div className="section-grid">
        <div className="card">
          <h3>Route Optimizer</h3>
          <p>
            Finds the best price across Movement AMMs, stable pools, and RFQ
            market makers.
          </p>
          <ul className="stack">
            <li>Split routing with dynamic rebalancing.</li>
            <li>Simulated execution with MEV shielding.</li>
            <li>One-click execution with batch settlement.</li>
          </ul>
        </div>
        <div className="card">
          <h3>Live Route Snapshot</h3>
          <div className="table">
            <div className="table-row header">
              <span>Route</span>
              <span>Venues</span>
              <span>Impact</span>
              <span>Savings</span>
            </div>
            {routes.map((route) => (
              <div key={route.path} className="table-row">
                <span>{route.path}</span>
                <span>{route.venues}</span>
                <span>{route.est}</span>
                <span className="badge">{route.savings}</span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
