export default function Header() {
  return (
    <header className="container">
      <div className="hero">
        <div>
          <span className="badge">Movement Network • Mainnet ready</span>
          <h1>DEX + Aggregator + Pools for Movement Network</h1>
          <p>
            Trade, route, and manage liquidity with a unified experience inspired by
            Yuzu and Meridian, built for Movement.
          </p>
          <div className="cta">
            <button className="primary-btn">Open DEX</button>
            <button className="secondary-btn">Connect Wallet</button>
          </div>
        </div>
        <div className="stack">
          <div className="card">
            <h3>Wallet adapters</h3>
            <p>Nightly, Razor, and Petra adapters pre-wired for Movement.</p>
            <div className="wallet-grid">
              <span className="wallet-pill">Nightly</span>
              <span className="wallet-pill">Razor</span>
              <span className="wallet-pill">Petra</span>
            </div>
          </div>
          <div className="card">
            <h3>Network status</h3>
            <ul className="stack">
              <li>RPC: https://rpc.movementlabs.xyz</li>
              <li>Indexer: https://indexer.movementlabs.xyz</li>
              <li>Gas: 0.001 MOVE</li>
            </ul>
          </div>
        </div>
      </div>
    </header>
  );
}
