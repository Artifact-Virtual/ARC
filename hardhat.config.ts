import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
import "@openzeppelin/hardhat-upgrades";
import "hardhat-gas-reporter";
import "solidity-coverage";
import "dotenv/config";

const { 
  ALCHEMY_API_KEY, 
  INFURA_PROJECT_ID,
  DEPLOYER_PRIVATE_KEY, 
  ETHERSCAN_API_KEY,
  POLYGONSCAN_API_KEY,
  GAS_PRICE_MAINNET = "20",
  GAS_PRICE_TESTNET = "10",
  REPORT_GAS = "true"
} = process.env;

const config: HardhatUserConfig = {
  paths: {
    sources: "./contracts",
    tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  solidity: {
    compilers: [
      {
        // Primary version for ARCx V2 and main contracts
        // Uses aggressive optimization (runs: 1) to minimize contract size
        version: "0.8.21",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1, // Maximum size reduction for large contracts
          },
          viaIR: true,
          metadata: {
            bytecodeHash: "none"
          },
          outputSelection: {
            "*": {
              "*": ["evm.bytecode", "evm.deployedBytecode", "devdoc", "userdoc", "metadata", "abi", "storageLayout"]
            }
          }
        },
      },
      {
        // For NFT contracts and frequently called functions
        // Uses balanced optimization (runs: 200) for gas efficiency
        version: "0.8.19",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        // For Genesis and ADAM policy contracts
        // Uses balanced optimization (runs: 200) + viaIR to avoid stack-too-deep
        version: "0.8.26",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
          viaIR: true,
        },
      }
    ]
  },
  networks: {
    hardhat: {
      // Local development network
      accounts: {
        count: 20,
        accountsBalance: "100000000000000000000", // 100 ETH
      },
    },
    // Ganache local network
    ganache: {
      url: "http://127.0.0.1:8545",
      accounts: [
        "0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d",
        "0x6cbed15c793ce57650b9877cf6fa156fbef513c4e6134f022a85b1ffdd59b2a1",
        "0x6370fd033278c143179d81c5526140625662b8daa446c22ee2d73db3707e620c",
        "0x646f1ce2fdad0e6deeeb5c7e8e5543bdde65e86029e2fd9fc169899c440a7913",
        "0xadd53f9a7e588d003326d1cbf9e4a43c061aadd9bc938c843a79e7b4fd2ad743",
        "0x395df67f0c2d2d9fe1ad08d1bc8b6627011959b79c53d7dd6a3536a33ab8a4fd",
        "0xe485d098507f54e7733a205420dfddbe58db035fa577fc294ebd14db90767a52",
        "0xa453611d9419d0e56f499079478fd72c37b251a94bfde4d19872c44cf65386e3",
        "0x829e924fdf021ba3dbbc4225edfece9aca04b929d6e75613329ca6f1d31c0bb4",
        "0xb0057716d5917badaf911b193b12b910811c1497b5bada8d7711f758981c3773"
      ],
      gasPrice: 2000000000, // 2 gwei
      timeout: 60000,
    },
    // Ethereum Mainnet
    ...(INFURA_PROJECT_ID && DEPLOYER_PRIVATE_KEY && DEPLOYER_PRIVATE_KEY.length === 64 ? {
      mainnet: {
        url: `https://mainnet.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        gasPrice: parseInt(GAS_PRICE_MAINNET) * 1000000000, // Convert gwei to wei
        timeout: 60000,
      }
    } : {}),
    // Ethereum Sepolia Testnet
    ...(INFURA_PROJECT_ID && DEPLOYER_PRIVATE_KEY && DEPLOYER_PRIVATE_KEY.length === 64 ? {
      sepolia: {
        url: `https://sepolia.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        gasPrice: parseInt(GAS_PRICE_TESTNET) * 1000000000,
        timeout: 60000,
      }
    } : {}),
    // Base L2
    ...(INFURA_PROJECT_ID && DEPLOYER_PRIVATE_KEY && DEPLOYER_PRIVATE_KEY.length === 64 ? {
      base: {
        url: `https://base-mainnet.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        gasPrice: Math.max(parseInt(GAS_PRICE_MAINNET) * 100000000, 50000000), // Minimum 0.05 gwei for Base
        timeout: 60000,
      }
    } : {}),
    // Base Sepolia Testnet
    ...(INFURA_PROJECT_ID && DEPLOYER_PRIVATE_KEY && DEPLOYER_PRIVATE_KEY.length === 64 ? {
      "base-sepolia": {
        url: `https://base-sepolia.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        gasPrice: parseInt(GAS_PRICE_TESTNET) * 1000000000,
        timeout: 60000,
      }
    } : {}),
    // Polygon
    ...(ALCHEMY_API_KEY && DEPLOYER_PRIVATE_KEY && DEPLOYER_PRIVATE_KEY.length === 64 ? {
      polygon: {
        url: `https://polygon-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        gasPrice: parseInt(GAS_PRICE_MAINNET) * 1000000000,
        timeout: 60000,
      }
    } : {}),
  },
  etherscan: {
    // Etherscan v2 API configuration
    apiKey: ETHERSCAN_API_KEY || "",
    customChains: [
      {
        network: "base",
        chainId: 8453,
        urls: {
          apiURL: "https://api.basescan.org/api",
          browserURL: "https://basescan.org"
        }
      },
      {
        network: "base-sepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org"
        }
      }
    ]
  },
  sourcify: {
    enabled: true
  },
  gasReporter: {
    enabled: REPORT_GAS === "true",
    currency: "USD",
    outputFile: "gas-report.txt",
    noColors: true,
    gasPrice: 20, // 20 gwei for mainnet estimation
    coinmarketcap: process.env.COINMARKETCAP_API_KEY,
  },
  mocha: {
    timeout: 40000,
    grep: process.env.GREP || "",
    invert: process.env.INVERT !== undefined,
  },
};

export default config;