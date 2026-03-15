import { ethers } from "hardhat";

/**
 * Deploy ArtifactSnapshot NFT contract to Base Sepolia.
 * 
 * Usage:
 *   npx hardhat run scripts/deploy-snapshot.ts --network base_sepolia
 */
async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deployer:", deployer.address);

  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Balance:", ethers.formatEther(balance), "ETH");

  if (balance < ethers.parseEther("0.001")) {
    throw new Error("Insufficient balance for deployment — need at least 0.001 ETH");
  }

  console.log("\nDeploying ArtifactSnapshot...");
  const factory = await ethers.getContractFactory("ArtifactSnapshot");
  const contract = await factory.deploy();
  await contract.waitForDeployment();

  const address = await contract.getAddress();
  console.log("✅ ArtifactSnapshot deployed to:", address);
  console.log("   Owner:", deployer.address);
  console.log("   Network:", (await ethers.provider.getNetwork()).name);
  console.log("   Chain ID:", (await ethers.provider.getNetwork()).chainId.toString());

  // Save deployment info
  const fs = require("fs");
  const deploymentInfo = {
    contract: "ArtifactSnapshot",
    address: address,
    deployer: deployer.address,
    network: (await ethers.provider.getNetwork()).name,
    chainId: (await ethers.provider.getNetwork()).chainId.toString(),
    deployedAt: new Date().toISOString(),
    txHash: contract.deploymentTransaction()?.hash
  };

  const deployDir = "./deployment/snapshot";
  fs.mkdirSync(deployDir, { recursive: true });
  fs.writeFileSync(
    `${deployDir}/deployment.json`,
    JSON.stringify(deploymentInfo, null, 2)
  );
  console.log("\n📄 Deployment info saved to", `${deployDir}/deployment.json`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
