import { ethers } from "hardhat";

async function main() {
  const contract = await ethers.getContractAt("ArtifactSnapshot", "0xC54D2194B464e9cbaFdD88f6F500Ae2622474daC");
  const snap = await contract.getSnapshot(0);
  console.log("=== TOKEN #0 (GENESIS) ===");
  console.log("CID:", snap.cid);
  console.log("Content Hash:", snap.contentHash);
  console.log("Encrypted Hash:", snap.encryptedHash);
  console.log("Files:", snap.fileCount.toString());
  console.log("Size:", snap.sizeBytes.toString(), "bytes (" + (Number(snap.sizeBytes) / 1024 / 1024).toFixed(1) + "MB)");
  console.log("Timestamp:", new Date(Number(snap.timestamp) * 1000).toISOString());
  console.log("Genesis:", snap.isGenesis);
  console.log("Pipeline Healthy:", await contract.pipelineHealthy());
  console.log("Next Token:", (await contract.nextTokenId()).toString());
  console.log("Latest CID:", await contract.getLatestCID());
}
main().catch(console.error);
