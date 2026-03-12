/**
 * ARC V2 — Smoke Test
 * Verifies end-to-end flow: stake ARCx → earn ARCs → spend on compute → treasury logs
 *
 * Usage (after deploy):
 *   npx hardhat run scripts/v2/smoke_test.ts --network base-sepolia
 *
 * Requires: scripts/v2/addresses.json to exist (written by deploy script)
 */

import { ethers } from "hardhat";
import * as addresses from "./addresses.json";

async function main() {
  const [deployer, testAgent] = await ethers.getSigners();
  const agent = testAgent || deployer; // Use deployer if no second signer

  console.log("═══════════════════════════════════════════════════════");
  console.log("  ARC V2 — Smoke Test");
  console.log("═══════════════════════════════════════════════════════");
  console.log(`  Agent:    ${agent.address}`);

  const arcx    = await ethers.getContractAt("ARCxV3",          addresses.ARCxV3_proxy);
  const arcs    = await ethers.getContractAt("ARCsV1",          addresses.ARCsV1_proxy);
  const vault   = await ethers.getContractAt("ARCStakingVault", addresses.StakingVault);
  const gateway = await ethers.getContractAt("ComputeGateway",  addresses.ComputeGateway);

  // ── Step 1: Check balances ─────────────────────────────────────────

  const arcxBal = await arcx.balanceOf(agent.address);
  const arcsBal = await arcs.balanceOf(agent.address);
  console.log(`\n📊 Balances:`);
  console.log(`   ARCx: ${ethers.formatEther(arcxBal)}`);
  console.log(`   ARCs: ${ethers.formatEther(arcsBal)}`);

  // ── Step 2: Stake ARCx ────────────────────────────────────────────

  const stakeAmount = ethers.parseEther("100"); // Stake 100 ARCx
  if (arcxBal < stakeAmount) {
    console.log(`\n⚠️  Insufficient ARCx. Need 100, have ${ethers.formatEther(arcxBal)}`);
    console.log(`   Skipping stake test — agent wallet may need ARCx transferred first.`);
  } else {
    console.log(`\n⚡ Step 1: Staking 100 ARCx...`);
    let tx = await arcx.connect(agent).approve(addresses.StakingVault, stakeAmount);
    await tx.wait();
    tx = await vault.connect(agent).stake(stakeAmount);
    await tx.wait();

    const [staked, pending] = await vault.getPosition(agent.address);
    console.log(`   ✅ Staked: ${ethers.formatEther(staked)} ARCx`);
    console.log(`   Pending ARCs: ${ethers.formatEther(pending)} (accruing...)`);
  }

  // ── Step 3: Check ARCs balance (from genesis or prior stake) ─────

  const arcsAfter = await arcs.balanceOf(agent.address);
  if (arcsAfter === 0n) {
    console.log(`\n⚠️  No ARCs to spend. Agent needs ARCs from genesis bootstrap or staking.`);
    console.log(`   Smoke test complete (partial) — stake and wait 7 days for ARCs.`);
    return;
  }

  // ── Step 4: Request compute ───────────────────────────────────────

  console.log(`\n⚡ Step 2: Requesting compute (burning 1 ARCs)...`);
  const burnAmount = ethers.parseEther("1");
  const jobId = ethers.keccak256(ethers.toUtf8Bytes(`smoke-test-${Date.now()}`));

  // Agent must approve gateway to burn their ARCs
  // (ARCs non-transferable but gateway has GATEWAY_ROLE — burn is via role, not allowance)
  let tx = await gateway.connect(agent).requestCompute(burnAmount, jobId);
  const receipt = await tx.wait();

  const event = receipt?.logs?.find((l: any) => {
    try { return gateway.interface.parseLog(l)?.name === "ComputeRequested"; }
    catch { return false; }
  });

  if (event) {
    const parsed = gateway.interface.parseLog(event);
    console.log(`   ✅ ComputeRequested emitted`);
    console.log(`   JobId:        ${parsed?.args.jobId}`);
    console.log(`   ARCs burned:  ${ethers.formatEther(parsed?.args.arcsAmount)}`);
    console.log(`   Compute units: ${parsed?.args.computeUnits}`);
    console.log(`\n   🔔 Mach6 bridge should now catch this event and route to Copilot.`);
  }

  console.log("\n═══════════════════════════════════════════════════════");
  console.log("  ✅ SMOKE TEST COMPLETE");
  console.log("═══════════════════════════════════════════════════════");
}

main().catch((err) => {
  console.error("❌ Smoke test failed:", err);
  process.exit(1);
});
