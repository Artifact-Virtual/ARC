/**
 * ARC V2 — Get Implementation Addresses
 * Run after deploy to log implementation addresses for each proxy.
 * Usage: npx hardhat run scripts/v2/get_impls.ts --network base-sepolia
 */
import { ethers, upgrades } from "hardhat";
import * as fs from "fs";
import * as path from "path";

async function main() {
  const addrFile = path.join(__dirname, "addresses.json");
  if (!fs.existsSync(addrFile)) {
    console.error("❌ addresses.json not found. Run deploy_arc_v2.ts first.");
    process.exit(1);
  }

  const addresses = JSON.parse(fs.readFileSync(addrFile, "utf8"));
  const proxies = [
    { name: "ARCxV3",     addr: addresses.ARCxV3_proxy,    key: "ARCxV3_impl" },
    { name: "ARCsV1",     addr: addresses.ARCsV1_proxy,    key: "ARCsV1_impl" },
    { name: "StakingVault", addr: addresses.StakingVault,  key: "StakingVault_impl" },
    { name: "ComputeGateway", addr: addresses.ComputeGateway, key: "ComputeGateway_impl" },
    { name: "ArtifactTreasury", addr: addresses.ArtifactTreasury, key: "ArtifactTreasury_impl" },
  ];

  console.log("\n🔍 Implementation Addresses");
  console.log("═══════════════════════════════════════════════════════");

  for (const { name, addr, key } of proxies) {
    if (!addr || addr === "pending") {
      console.log(`  ${name}: not deployed yet`);
      continue;
    }
    try {
      const impl = await upgrades.erc1967.getImplementationAddress(addr);
      addresses[key] = impl;
      console.log(`  ${name}:`);
      console.log(`    Proxy: ${addr}`);
      console.log(`    Impl:  ${impl}`);
    } catch (e: any) {
      console.log(`  ${name}: ⚠️  ${e.message}`);
    }
  }

  fs.writeFileSync(addrFile, JSON.stringify(addresses, null, 2));
  console.log("\n✅ addresses.json updated with impl addresses");
}

main().catch(console.error);
