const express = require("express");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

const pools = [
  {
    id: "move-usdc",
    name: "MOVE / USDC",
    tvl: 42500000,
    apr: 18.2,
    volume24h: 12100000
  },
  {
    id: "meth-move",
    name: "mETH / MOVE",
    tvl: 18900000,
    apr: 14.7,
    volume24h: 4600000
  },
  {
    id: "mbtc-usdt",
    name: "mBTC / USDT",
    tvl: 9300000,
    apr: 11.3,
    volume24h: 3200000
  }
];

const routes = [
  {
    id: "route-1",
    path: "MOVE -> mUSDC",
    venues: ["Wave AMM", "Meridian Pool"],
    estimatedImpact: 0.38,
    savingsUsd: 18.4
  },
  {
    id: "route-2",
    path: "mETH -> MOVE",
    venues: ["Yuzu v2", "MoveX"],
    estimatedImpact: 0.52,
    savingsUsd: 11.2
  }
];

app.get("/health", (_, res) => {
  res.json({ status: "ok", network: "movement" });
});

app.get("/api/pools", (_, res) => {
  res.json({ data: pools });
});

app.get("/api/aggregator/routes", (_, res) => {
  res.json({ data: routes });
});

app.post("/api/swap/quote", (req, res) => {
  const { from, to, amount } = req.body || {};
  res.json({
    data: {
      from,
      to,
      amount,
      minOut: Number(amount || 0) * 0.98,
      priceImpact: 0.34,
      fee: 0.12
    }
  });
});

const port = process.env.PORT || 4000;
app.listen(port, () => {
  console.log(`Movement DEX backend running on port ${port}`);
});
