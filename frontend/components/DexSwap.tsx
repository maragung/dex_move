const swapSteps = [
  {
    title: "Swap",
    description:
      "Price impact guard, slippage presets, and dynamic fee tiers for Movement pools."
  },
  {
    title: "Limit Orders",
    description:
      "Place maker orders with on-chain triggers and MEV-protected routing."
  },
  {
    title: "Bridge",
    description:
      "Move assets from EVM and Aptos ecosystems in one flow."
  }
];

export default function DexSwap() {
  return (
    <section className="container">
      <h2>DEX Experience</h2>
      <div className="section-grid">
        <div className="card">
          <h3>Swap Terminal</h3>
          <p>Instant trades with deep routing across Movement AMMs.</p>
          <div className="stack">
            <div className="table">
              <div className="table-row header">
                <span>Token</span>
                <span>Balance</span>
                <span>Price</span>
                <span>Change</span>
              </div>
              <div className="table-row">
                <span>MOVE</span>
                <span>1,245.23</span>
                <span>$0.38</span>
                <span className="badge">+2.4%</span>
              </div>
              <div className="table-row">
                <span>USDC</span>
                <span>8,120.50</span>
                <span>$1.00</span>
                <span className="badge">Stable</span>
              </div>
              <div className="table-row">
                <span>mETH</span>
                <span>3.40</span>
                <span>$3,420.00</span>
                <span className="badge">-1.1%</span>
              </div>
            </div>
            <button className="primary-btn">Preview Swap</button>
          </div>
        </div>
        <div className="stack">
          {swapSteps.map((step) => (
            <div key={step.title} className="card">
              <h3>{step.title}</h3>
              <p>{step.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
