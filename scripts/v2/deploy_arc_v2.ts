/**
 * ARC V2 — Deploy Script
 * Deploys all 5 new contracts in order, wires roles, and runs genesis distribution.
 *
 * Usage:
 *   npx hardhat run scripts/v2/deploy_arc_v2.ts --network base
 *   npx hardhat run scripts/v2/deploy_arc_v2.ts --network base-sepolia
 *
 * Prerequisites:
 *   - .env has: DEPLOYER_PRIVATE_KEY, BASE_RPC_URL, BASESCAN_API_KEY
 *   - Deployer wallet funded (0.1+ ETH on Base mainnet)
 *   - TREASURY_SAFE, ECOSYSTEM_SAFE, BRIDGE_WALLET set in .env
 *   - All agent wallets (AVA, Aria, Singularity) = deployer wallet (Infura-keyed)
 *     Override per-env if separate wallets are provisioned later.
 */

import { ethers, upgrades } from "hardhat";
import { Contract } from "ethers";

// ── Static config (no agent addresses here — resolved at runtime from deployer) ──

const STATIC_CONFIG = {
  TREASURY_SAFE:   process.env.TREASURY_SAFE  || "0x8F8fdBFa1AF9f53973a7003CbF26D854De9b2f38",
  ECOSYSTEM_SAFE:  process.env.ECOSYSTEM_SAFE || "0x2ebCb38562051b02dae9cAca5ed8Ddb353d225eb",
  BRIDGE_WALLET:   process.env.BRIDGE_WALLET  || "",  // Required — Mach6 hot wallet
  SHARD_CONTRACT:  process.env.SHARD_CONTRACT || "0xE89704585FD4Dc8397CE14e0dE463B53746049F5",

  // Tokenomics (10M total supply)
  ARCX_TOTAL_SUPPLY:  ethers.parseEther("10000000"),

  // Compute rate: 1 ARCs per compute unit (1 unit ≈ 1K Copilot tokens)
  COMPUTE_RATE:       ethers.parseEther("1"),

  // Genesis ARCs bootstrap per agent (covers ~30 days of inference)
  AGENT_GENESIS_ARCS: ethers.parseEther("10000"),  // 10K ARCs each

  // Treasury bootstrap
  TREASURY_ETH:       ethers.parseEther("0.5"),
};

// ARCx distribution (must sum to ARCX_TOTAL_SUPPLY)
const ARCX_DISTRIBUTION = {
  LP_STAGING:    ethers.parseEther("3000000"),  // 30% — LP seeding
  TREASURY:      ethers.parseEther("2500000"),  // 25% — ecosystem treasury
  VESTING:       ethers.parseEther("2000000"),  // 20% — team vesting
  AVA:           ethers.parseEther("300000"),   //  3% — agent
  ARIA:          ethers.parseEther("300000"),   //  3% — agent
  SINGULARITY:   ethers.parseEther("300000"),   //  3% — agent
  AGENT_RESERVE: ethers.parseEther("600000"),   //  6% — future agents (→ treasury)
  AIRDROP:       ethers.parseEther("1000000"),  // 10% — community
};

// ── Helpers ──────────────────────────────────────────────────────────────────

function require_env(value: string, name: string) {
  if (!value || value === "" || value === ethers.ZeroAddress) {
    throw new Error(`❌ Missing required config: ${name}. Set in .env`);
  }
}

async function deployProxy(contractName: string, initArgs: any[]): Promise<Contract> {
  console.log(`\n📦 Deploying ${contractName}...`);
  const Factory = await ethers.getContractFactory(contractName);
  const proxy = await upgrades.deployProxy(Factory, initArgs, {
    initializer: "initialize",
    kind: "uups",
  });
  await proxy.waitForDeployment();
  const addr = await proxy.getAddress();
  console.log(`   Proxy:  ${addr}`);
  // Note: impl address lookup skipped here — OZ v3.x has timing issues on live networks.
  // Run `npx hardhat run scripts/v2/get_impls.ts` after deploy to log implementation addresses.
  return proxy;
}

// ── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  const [deployer] = await ethers.getSigners();

  // Resolve agent wallets — all use deployer for now (Infura-keyed account)
  // Override via env if separate wallets are provisioned later
  const AGENT_WALLETS = {
    AVA:         process.env.AVA_WALLET         || deployer.address,
    ARIA:        process.env.ARIA_WALLET        || deployer.address,
    SINGULARITY: process.env.SINGULARITY_WALLET || deployer.address,
  };

  console.log("═══════════════════════════════════════════════════════");
  console.log("  ARC V2 — Full Deploy");
  console.log("═══════════════════════════════════════════════════════");
  console.log(`  Deployer:       ${deployer.address}`);
  console.log(`  Network:        ${(await ethers.provider.getNetwork()).name}`);
  console.log(`  Balance:        ${ethers.formatEther(await ethers.provider.getBalance(deployer.address))} ETH`);
  console.log(`  AVA wallet:     ${AGENT_WALLETS.AVA}`);
  console.log(`  Aria wallet:    ${AGENT_WALLETS.ARIA}`);
  console.log(`  Singularity:    ${AGENT_WALLETS.SINGULARITY}`);

  // Validate only bridge wallet (agents default to deployer, safe to skip validation)
  require_env(STATIC_CONFIG.BRIDGE_WALLET, "BRIDGE_WALLET");

  // ── PHASE 1: Deploy contracts ─────────────────────────────────────────────

  // 1. ARCxV3
  const arcx = await deployProxy("ARCxV3", [
    STATIC_CONFIG.TREASURY_SAFE,
    STATIC_CONFIG.ECOSYSTEM_SAFE,
    deployer.address,       // minter (genesis only, revoked after)
  ]);
  const arcxAddr = await arcx.getAddress();

  // 2. ARCsV1
  const arcs = await deployProxy("ARCsV1", [
    STATIC_CONFIG.TREASURY_SAFE,
    STATIC_CONFIG.ECOSYSTEM_SAFE,
  ]);
  const arcsAddr = await arcs.getAddress();

  // 3. ARCStakingVault
  const vault = await deployProxy("ARCStakingVault", [
    STATIC_CONFIG.TREASURY_SAFE,
    STATIC_CONFIG.ECOSYSTEM_SAFE,
    arcxAddr,
    arcsAddr,
  ]);
  const vaultAddr = await vault.getAddress();

  // 4. ComputeGateway
  const gateway = await deployProxy("ComputeGateway", [
    STATIC_CONFIG.TREASURY_SAFE,
    STATIC_CONFIG.ECOSYSTEM_SAFE,
    STATIC_CONFIG.BRIDGE_WALLET,
    arcsAddr,
    STATIC_CONFIG.SHARD_CONTRACT,
    STATIC_CONFIG.COMPUTE_RATE,
  ]);
  const gatewayAddr = await gateway.getAddress();

  // 5. ArtifactTreasury
  const treasury = await deployProxy("ArtifactTreasury", [
    STATIC_CONFIG.TREASURY_SAFE,
    STATIC_CONFIG.ECOSYSTEM_SAFE,
    STATIC_CONFIG.BRIDGE_WALLET,
  ]);
  const treasuryAddr = await treasury.getAddress();

  // ── PHASE 2: Wire roles ───────────────────────────────────────────────────

  console.log("\n🔗 Wiring roles...");

  const VAULT_ROLE   = await (arcs as any).VAULT_ROLE();
  const GATEWAY_ROLE = await (arcs as any).GATEWAY_ROLE();

  let tx = await (arcs as any).grantRole(VAULT_ROLE, vaultAddr);
  await tx.wait();
  console.log(`   ✅ VAULT_ROLE → StakingVault`);

  tx = await (arcs as any).grantRole(GATEWAY_ROLE, gatewayAddr);
  await tx.wait();
  console.log(`   ✅ GATEWAY_ROLE → ComputeGateway`);

  // Whitelist agent wallets for pre-SHARD access
  // (if all resolve to deployer, this is one wallet whitelisted three times — harmless)
  const agentAddrs = [...new Set([AGENT_WALLETS.AVA, AGENT_WALLETS.ARIA, AGENT_WALLETS.SINGULARITY])];
  for (const addr of agentAddrs) {
    tx = await (gateway as any).setWhitelist(addr, true);
    await tx.wait();
    console.log(`   ✅ Whitelisted: ${addr}`);
  }

  // ── PHASE 3: Genesis ARCx distribution ───────────────────────────────────

  console.log("\n🪙 Genesis ARCx distribution...");

  const MINTER_ROLE = await (arcx as any).MINTER_ROLE();

  tx = await (arcx as any).mint(deployer.address, STATIC_CONFIG.ARCX_TOTAL_SUPPLY);
  await tx.wait();
  console.log(`   ✅ Minted 10M ARCx to deployer`);

  // Transfer to non-deployer destinations
  // (agent shares stay with deployer since agent wallets = deployer)
  const transfers: Array<{ to: string; amount: bigint; label: string }> = [
    { to: treasuryAddr,            amount: ARCX_DISTRIBUTION.TREASURY,      label: "ArtifactTreasury" },
    { to: AGENT_WALLETS.AVA,       amount: ARCX_DISTRIBUTION.AVA,           label: "AVA" },
    { to: AGENT_WALLETS.ARIA,      amount: ARCX_DISTRIBUTION.ARIA,          label: "Aria" },
    { to: AGENT_WALLETS.SINGULARITY, amount: ARCX_DISTRIBUTION.SINGULARITY, label: "Singularity" },
    { to: treasuryAddr,            amount: ARCX_DISTRIBUTION.AGENT_RESERVE, label: "Agent Reserve → Treasury" },
    // LP_STAGING, VESTING, AIRDROP stay with deployer — staged separately
  ];

  for (const t of transfers) {
    if (t.to.toLowerCase() !== deployer.address.toLowerCase()) {
      tx = await (arcx as any).transfer(t.to, t.amount);
      await tx.wait();
      console.log(`   ✅ ${ethers.formatEther(t.amount)} ARCx → ${t.label} (${t.to})`);
    } else {
      console.log(`   📌 ${ethers.formatEther(t.amount)} ARCx stays with deployer (${t.label})`);
    }
  }

  // Revoke MINTER_ROLE — no more minting
  tx = await (arcx as any).revokeRole(MINTER_ROLE, deployer.address);
  await tx.wait();
  console.log(`   ✅ MINTER_ROLE revoked from deployer`);

  tx = await (arcx as any).finalizeSupply();
  await tx.wait();
  console.log(`   ✅ Supply finalized — immutable`);

  // ── PHASE 4: Genesis ARCs bootstrap (agent cold start) ────────────────────

  console.log("\n⚡ Genesis ARCs bootstrap...");

  // Temporarily grant VAULT_ROLE to deployer for genesis mint
  tx = await (arcs as any).grantRole(VAULT_ROLE, deployer.address);
  await tx.wait();

  // Mint to each unique agent address (if all same, mint once)
  const agentMints: Array<{ addr: string; label: string }> = [
    { addr: AGENT_WALLETS.AVA,         label: "AVA" },
    { addr: AGENT_WALLETS.ARIA,        label: "Aria" },
    { addr: AGENT_WALLETS.SINGULARITY, label: "Singularity" },
  ];

  // Track minted per address to avoid double-minting when all resolve to deployer
  const minted = new Map<string, bigint>();
  for (const { addr, label } of agentMints) {
    const key = addr.toLowerCase();
    const already = minted.get(key) || 0n;
    tx = await (arcs as any).mint(addr, STATIC_CONFIG.AGENT_GENESIS_ARCS);
    await tx.wait();
    minted.set(key, already + STATIC_CONFIG.AGENT_GENESIS_ARCS);
    console.log(`   ✅ ${ethers.formatEther(STATIC_CONFIG.AGENT_GENESIS_ARCS)} ARCs → ${label} (${addr})`);
  }

  // Revoke deployer VAULT_ROLE immediately
  tx = await (arcs as any).revokeRole(VAULT_ROLE, deployer.address);
  await tx.wait();
  console.log(`   ✅ Deployer VAULT_ROLE revoked`);

  // ── PHASE 5: Fund treasury ────────────────────────────────────────────────

  console.log("\n💰 Funding ArtifactTreasury...");
  tx = await deployer.sendTransaction({ to: treasuryAddr, value: STATIC_CONFIG.TREASURY_ETH });
  await tx.wait();
  console.log(`   ✅ 0.5 ETH → ArtifactTreasury`);

  // ── Summary ───────────────────────────────────────────────────────────────

  console.log("\n═══════════════════════════════════════════════════════");
  console.log("  ✅ ARC V2 DEPLOY COMPLETE");
  console.log("═══════════════════════════════════════════════════════");
  console.log(`  ARCxV3 Proxy:       ${arcxAddr}`);
  console.log(`  ARCsV1 Proxy:       ${arcsAddr}`);
  console.log(`  StakingVault:       ${vaultAddr}`);
  console.log(`  ComputeGateway:     ${gatewayAddr}`);
  console.log(`  ArtifactTreasury:   ${treasuryAddr}`);
  console.log("───────────────────────────────────────────────────────");
  console.log("  NEXT STEPS:");
  console.log("  1. Verify contracts on BaseScan");
  console.log("  2. Update scripts/v2/addresses.json");
  console.log("  3. Seed Uniswap V4 LP from deployer staging allocation");
  console.log("  4. Deploy Mach6 bridge listener service");
  console.log("  5. Run: npx hardhat run scripts/v2/smoke_test.ts --network <net>");
  console.log("═══════════════════════════════════════════════════════");

  // Write addresses for downstream scripts
  const addresses = {
    network:         (await ethers.provider.getNetwork()).name,
    deployedAt:      new Date().toISOString(),
    ARCxV3_proxy:    arcxAddr,
    ARCxV3_impl:     "lookup-post-deploy",  // run get_impls.ts
    ARCsV1_proxy:    arcsAddr,
    ARCsV1_impl:     "lookup-post-deploy",  // run: npx hardhat run scripts/v2/get_impls.ts
    StakingVault:    vaultAddr,
    ComputeGateway:  gatewayAddr,
    ArtifactTreasury: treasuryAddr,
    // Config addresses
    SHARD:           STATIC_CONFIG.SHARD_CONTRACT,
    TREASURY_SAFE:   STATIC_CONFIG.TREASURY_SAFE,
    ECOSYSTEM_SAFE:  STATIC_CONFIG.ECOSYSTEM_SAFE,
    BRIDGE_WALLET:   STATIC_CONFIG.BRIDGE_WALLET,
    // Agent wallets (all deployer for now)
    AVA_WALLET:      AGENT_WALLETS.AVA,
    ARIA_WALLET:     AGENT_WALLETS.ARIA,
    SINGULARITY_WALLET: AGENT_WALLETS.SINGULARITY,
    DEPLOYER:        deployer.address,
    // Legacy
    ARCxV2_LEGACY:   "0xDb3C3f9ECb93f3532b4FD5B050245dd2F2Eec437",
    ARCxMath_LEGACY: "0xdfB7271303467d58F6eFa10461c9870Ed244F530",
  };

  const fs = require("fs");
  fs.writeFileSync("./scripts/v2/addresses.json", JSON.stringify(addresses, null, 2));
  console.log("\n  📄 Addresses written to scripts/v2/addresses.json");
}

main().catch((err) => {
  console.error("❌ Deploy failed:", err);
  process.exit(1);
});
