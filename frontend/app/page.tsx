import Aggregator from "../components/Aggregator";
import DexSwap from "../components/DexSwap";
import Footer from "../components/Footer";
import Header from "../components/Header";
import Pools from "../components/Pools";

export default function Home() {
  return (
    <main>
      <Header />
      <DexSwap />
      <Aggregator />
      <Pools />
      <Footer />
    </main>
  );
}
