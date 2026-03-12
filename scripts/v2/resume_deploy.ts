/**
 * ARC V2 — Resume Deploy (Phase 4+)
 * Use this when deployment was interrupted after ARCxV3, ARCsV1, StakingVault were deployed.
 * Picks up from ComputeGateway deployment.
 *
 * Usage:
 *   npx hardhat run scripts/v2/resume_deploy.ts --network base-sepolia
 *
 * Prerequisites:
 *   - addresses.json exists with ARCxV3_proxy, ARCsV1_proxy, StakingVault already set
 *   - Deployer wallet has been refueled (~0.05 ETH)
 */

import { ethers, upgrades } from "hardhat";
import * as addresses from "./addresses.json";

const STATIC_CONFIG = {
  TREASURY_SAFE:   process.env.TREASURY_SAFE  || "0x8F8fdBFa1AF9f53973a7003CbF26D854De9b2f38",
  ECOSYSTEM_SAFE:  process.env.ECOSYSTEM_SAFE || "0x2ebCb38562051b02dae9cAca5ed8Ddb353d225eb",
  BRIDGE_WALLET:   process.env.BRIDGE_WALLET  || "0x21E914dFBB137F7fEC896F11bC8BAd6BCCDB147B",
  SHARD_CONTRACT:  process.env.SHARD_CONTRACT || "0xE89704585FD4Dc8397CE14e0dE463B53746049F5",
  COMPUTE_RATE:       ethers.parseEther("1"),
  AGENT_GENESIS_ARCS: ethers.parseEther("10000"),
  TREASURY_ETH:       ethers.parseEther("0.01"),  // reduced for testnet
};

async function main() {
  const [deployer] = await ethers.getSigners();
  const agentWallet = deployer.address; // all agents = deployer

  console.log("═══════════════════════════════════════════════════════");
  console.log("  ARC V2 — Resume Deploy");
  console.log("═══════════════════════════════════════════════════════");
  console.log(`  Deployer:   ${deployer.address}`);
  console.log(`  Balance:    ${ethers.formatEther(await ethers.provider.getBalance(deployer.address))} ETH`);
  console.log(`  Resuming from: ComputeGateway`);

  const arcxAddr  = addresses.ARCxV3_proxy;
  const arcsAddr  = addresses.ARCsV1_proxy;
  const vaultAddr = addresses.StakingVault;

  console.log(`\n  ARCxV3:       ${arcxAddr} ✅ (existing)`);
  console.log(`  ARCsV1:       ${arcsAddr} ✅ (existing)`);
  console.log(`  StakingVault: ${vaultAddr} ✅ (existing)`);

  const arcs = await ethers.getContractAt("ARCsV1", arcsAddr);

  // ── Deploy ComputeGateway ─────────────────────────────────────────────────
  console.log(`\n📦 Deploying ComputeGateway...`);
  const GatewayFactory = await ethers.getContractFactory("ComputeGateway");
  const gateway = await upgrades.deployProxy(GatewayFactory, [
    STATIC_CONFIG.TREASURY_SAFE,
    STATIC_CONFIG.ECOSYSTEM_SAFE,
    STATIC_CONFIG.BRIDGE_WALLET,
    arcsAddr,
    STATIC_CONFIG.SHARD_CONTRACT,
    STATIC_CONFIG.COMPUTE_RATE,
  ], { initializer: "initialize", kind: "uups" });
  await gateway.waitForDeployment();
  const gatewayAddr = await gateway.getAddress();
  console.log(`   Proxy:  ${gatewayAddr}`);

  // ── Deploy ArtifactTreasury ───────────────────────────────────────────────
  console.log(`\n📦 Deploying ArtifactTreasury...`);
  const TreasuryFactory = await ethers.getContractFactory("ArtifactTreasury");
  const treasury = await upgrades.deployProxy(TreasuryFactory, [
    STATIC_CONFIG.TREASURY_SAFE,
    STATIC_CONFIG.ECOSYSTEM_SAFE,
    STATIC_CONFIG.BRIDGE_WALLET,
  ], { initializer: "initialize", kind: "uups" });
  await treasury.waitForDeployment();
  const treasuryAddr = await treasury.getAddress();
  console.log(`   Proxy:  ${treasuryAddr}`);

  // ── Wire roles ────────────────────────────────────────────────────────────
  console.log("\n🔗 Wiring roles...");

  const VAULT_ROLE   = await (arcs as any).VAULT_ROLE();
  const GATEWAY_ROLE = await (arcs as any).GATEWAY_ROLE();

  let tx = await (arcs as any).grantRole(VAULT_ROLE, vaultAddr);
  await tx.wait();
  console.log(`   ✅ VAULT_ROLE → StakingVault`);

  tx = await (arcs as any).grantRole(GATEWAY_ROLE, gatewayAddr);
  await tx.wait();
  console.log(`   ✅ GATEWAY_ROLE → ComputeGateway`);

  tx = await (gateway as any).setWhitelist(agentWallet, true);
  await tx.wait();
  console.log(`   ✅ Whitelisted deployer (AVA + Aria + Singularity)`);

  // ── Genesis ARCx distribution ─────────────────────────────────────────────
  console.log("\n🪙 Genesis ARCx distribution...");
  const arcx = await ethers.getContractAt("ARCxV3", arcxAddr);
  const MINTER_ROLE = await (arcx as any).MINTER_ROLE();

  // Mint 10M to deployer
  tx = await (arcx as any).mint(deployer.address, ethers.parseEther("10000000"));
  await tx.wait();
  console.log(`   ✅ Minted 10M ARCx`);

  // Transfer treasury + agent reserve to ArtifactTreasury
  tx = await (arcx as any).transfer(treasuryAddr, ethers.parseEther("2500000"));
  await tx.wait();
  console.log(`   ✅ 2.5M ARCx → ArtifactTreasury`);

  tx = await (arcx as any).transfer(treasuryAddr, ethers.parseEther("600000"));
  await tx.wait();
  console.log(`   ✅ 600K ARCx (Agent Reserve) → ArtifactTreasury`);

  // Agent allocations stay with deployer (agent wallet = deployer)
  console.log(`   📌 3x 300K ARCx (agents) stay with deployer`);
  console.log(`   📌 3M ARCx (LP staging) stays with deployer`);
  console.log(`   📌 2M ARCx (vesting) stays with deployer`);
  console.log(`   📌 1M ARCx (airdrop) stays with deployer`);

  // Revoke MINTER_ROLE and finalize
  tx = await (arcx as any).revokeRole(MINTER_ROLE, deployer.address);
  await tx.wait();
  console.log(`   ✅ MINTER_ROLE revoked`);

  tx = await (arcx as any).finalizeSupply();
  await tx.wait();
  console.log(`   ✅ Supply finalized — immutable`);

  // ── Genesis ARCs bootstrap ────────────────────────────────────────────────
  console.log("\n⚡ Genesis ARCs bootstrap...");
  tx = await (arcs as any).grantRole(VAULT_ROLE, deployer.address);
  await tx.wait();

  tx = await (arcs as any).mint(agentWallet, STATIC_CONFIG.AGENT_GENESIS_ARCS);
  await tx.wait();
  console.log(`   ✅ 10,000 ARCs → deployer (covers all agents)`);

  // 3 agents same wallet — just mint once
  tx = await (arcs as any).revokeRole(VAULT_ROLE, deployer.address);
  await tx.wait();
  console.log(`   ✅ Deployer VAULT_ROLE revoked`);

  // ── Fund treasury ─────────────────────────────────────────────────────────
  console.log("\n💰 Funding ArtifactTreasury (testnet: 0.01 ETH)...");
  tx = await deployer.sendTransaction({ to: treasuryAddr, value: STATIC_CONFIG.TREASURY_ETH });
  await tx.wait();
  console.log(`   ✅ 0.01 ETH → ArtifactTreasury`);

  // ── Final summary ─────────────────────────────────────────────────────────
  console.log("\n═══════════════════════════════════════════════════════");
  console.log("  ✅ ARC V2 DEPLOY COMPLETE");
  console.log("═══════════════════════════════════════════════════════");
  console.log(`  ARCxV3:          ${arcxAddr}`);
  console.log(`  ARCsV1:          ${arcsAddr}`);
  console.log(`  StakingVault:    ${vaultAddr}`);
  console.log(`  ComputeGateway:  ${gatewayAddr}`);
  console.log(`  ArtifactTreasury: ${treasuryAddr}`);

  // Update addresses.json
  const fs = require("fs");
  const updated = {
    ...addresses,
    ComputeGateway:   gatewayAddr,
    ArtifactTreasury: treasuryAddr,
    _status:          "COMPLETE",
    completedAt:      new Date().toISOString(),
  };
  fs.writeFileSync("./scripts/v2/addresses.json", JSON.stringify(updated, null, 2));
  console.log("\n  📄 addresses.json updated");
  console.log("  Next: npx hardhat run scripts/v2/smoke_test.ts --network base-sepolia");
}

main().catch((err) => {
  console.error("❌ Resume deploy failed:", err);
  process.exit(1);
});
