# Codebase overview — Devs & Contributors

*Generated: 2026-03-15T08:05:41.322800 UTC*

## Quick stats

- Root: `ARC`
- Files indexed: **404**
- Total size: **24.1MB**

## Top-level directories

- **.eslintrc.json** — 1 files, 827.0B
- **.githooks** — 2 files, 2.7KB
- **.github** — 5 files, 13.8KB
- **.gitignore** — 1 files, 453.0B
- **.hardhatignore** — 1 files, 22.0B
- **.npmrc** — 1 files, 237.0B
- **.openzeppelin** — 2 files, 53.6KB
- **.prettierrc.json** — 1 files, 199.0B
- **.solhintignore** — 1 files, 51.0B
- **address.book** — 1 files, 4.3KB
- **ai-engine** — 25 files, 81.3KB
- **arc-cli** — 17 files, 170.5KB
- **arc_preview.html** — 1 files, 17.0KB
- **audit** — 4 files, 20.5KB
- **check-positions.js** — 1 files, 4.5KB
- **code_indexer.ps1** — 1 files, 941.0B
- **CODEBASE_OVERVIEW.md** — 1 files, 49.2KB
- **contracts** — 153 files, 962.1KB
- **contracts-new** — 5 files, 53.6KB
- **css** — 2 files, 14.7KB
- **deploy_auction.ps1** — 1 files, 5.2KB
- **deployment** — 2 files, 332.0B
- **docs** — 86 files, 21.9MB
- **echidna.yaml** — 1 files, 1.1KB
- **eslint.config.js** — 1 files, 1.6KB
- **foundry-scripts** — 8 files, 56.6KB
- **ganache-db** — 4 files, 112.0B
- **gas-report.txt** — 1 files, 3.6KB
- **gas-reports** — 2 files, 41.5KB
- **hardhat.config.ts** — 1 files, 5.7KB
- **js** — 3 files, 38.9KB
- **LICENSE** — 1 files, 2.9KB
- **OVERVIEW.md** — 1 files, 47.5KB
- **package.json** — 1 files, 8.0KB
- **README.md** — 1 files, 14.7KB
- **run-audit-and-append.ps1** — 1 files, 3.0KB
- **scripts** — 29 files, 167.4KB
- **site** — 1 files, 20.6KB
- **src** — 3 files, 58.4KB
- **SYSTEM_MAP.md** — 1 files, 32.6KB
- **TERMINAL_UI_DEMO.txt** — 1 files, 16.3KB
- **tests** — 24 files, 224.0KB
- **tools** — 2 files, 8.1KB
- **trader.py** — 1 files, 6.0KB
- **tsconfig.json** — 1 files, 589.0B

## Table of contents

### .eslintrc.json

- [.eslintrc.json](.eslintrc.json) — 827.0B / 2026-03-15T08:05:40.507962
### .githooks

- [.githooks/pre-commit](.githooks/pre-commit) — 1.8KB / 2026-03-15T08:05:40.507962
- [.githooks/pre-push](.githooks/pre-push) — 904.0B / 2026-03-15T08:05:40.509486
### .github

- [.github/FUNDING.yml](.github/FUNDING.yml) — 464.0B / 2026-03-15T08:05:40.509486
- [.github/pull_request_template.md](.github/pull_request_template.md) — 1.5KB / 2026-03-15T08:05:40.509559
- [.github/workflows/ci.yml](.github/workflows/ci.yml) — 1.6KB / 2026-03-15T08:05:40.509559
- [.github/workflows/code_indexer.yml](.github/workflows/code_indexer.yml) — 1.3KB / 2026-03-15T08:05:40.509622
- [.github/workflows/security.yml](.github/workflows/security.yml) — 8.9KB / 2026-03-15T08:05:40.509622
### .gitignore

- [.gitignore](.gitignore) — 453.0B / 2026-03-15T08:05:40.509622
### .hardhatignore

- [.hardhatignore](.hardhatignore) — 22.0B / 2026-03-15T08:05:40.509622
### .npmrc

- [.npmrc](.npmrc) — 237.0B / 2026-03-15T08:05:40.509622
### .openzeppelin

- [.openzeppelin/base-sepolia.json](.openzeppelin/base-sepolia.json) — 30.7KB / 2026-03-15T08:05:40.509622
- [.openzeppelin/base.json](.openzeppelin/base.json) — 22.9KB / 2026-03-15T08:05:40.509881
### .prettierrc.json

- [.prettierrc.json](.prettierrc.json) — 199.0B / 2026-03-15T08:05:40.509881
### .solhintignore

- [.solhintignore](.solhintignore) — 51.0B / 2026-03-15T08:05:40.509881
### address.book

- [address.book](address.book) — 4.3KB / 2026-03-15T08:05:40.509962
### ai-engine

- [ai-engine/backend/.dockerignore](ai-engine/backend/.dockerignore) — 40.0B / 2026-03-15T08:05:40.511119
- [ai-engine/backend/DEPLOYMENT.md](ai-engine/backend/DEPLOYMENT.md) — 6.2KB / 2026-03-15T08:05:40.511142
- [ai-engine/backend/docker-compose.yml](ai-engine/backend/docker-compose.yml) — 926.0B / 2026-03-15T08:05:40.511142
- [ai-engine/backend/Dockerfile](ai-engine/backend/Dockerfile) — 341.0B / 2026-03-15T08:05:40.511142
- [ai-engine/backend/healthcheck.js](ai-engine/backend/healthcheck.js) — 324.0B / 2026-03-15T08:05:40.511142
- [ai-engine/backend/package.json](ai-engine/backend/package.json) — 1.1KB / 2026-03-15T08:05:40.511142
- [ai-engine/backend/README.md](ai-engine/backend/README.md) — 5.9KB / 2026-03-15T08:05:40.511142
- [ai-engine/backend/scripts/generate-backend.sh](ai-engine/backend/scripts/generate-backend.sh) — 9.9KB / 2026-03-15T08:05:40.511142
- [ai-engine/backend/scripts/setup.sh](ai-engine/backend/scripts/setup.sh) — 2.5KB / 2026-03-15T08:05:40.511374
- [ai-engine/backend/src/config/index.ts](ai-engine/backend/src/config/index.ts) — 858.0B / 2026-03-15T08:05:40.511420
- [ai-engine/backend/src/controllers/ChatController.ts](ai-engine/backend/src/controllers/ChatController.ts) — 1.1KB / 2026-03-15T08:05:40.511420
- [ai-engine/backend/src/controllers/ContractController.ts](ai-engine/backend/src/controllers/ContractController.ts) — 1.7KB / 2026-03-15T08:05:40.511502
- [ai-engine/backend/src/index.ts](ai-engine/backend/src/index.ts) — 552.0B / 2026-03-15T08:05:40.511502
- [ai-engine/backend/src/routes/chat.ts](ai-engine/backend/src/routes/chat.ts) — 345.0B / 2026-03-15T08:05:40.511502
- [ai-engine/backend/src/routes/contract.ts](ai-engine/backend/src/routes/contract.ts) — 409.0B / 2026-03-15T08:05:40.511575
- [ai-engine/backend/src/routes/index.ts](ai-engine/backend/src/routes/index.ts) — 233.0B / 2026-03-15T08:05:40.511575
- [ai-engine/backend/src/services/BlockchainService.ts](ai-engine/backend/src/services/BlockchainService.ts) — 1.3KB / 2026-03-15T08:05:40.511575
- [ai-engine/backend/src/services/ContractService.ts](ai-engine/backend/src/services/ContractService.ts) — 907.0B / 2026-03-15T08:05:40.511647
- [ai-engine/backend/src/services/LLMService.ts](ai-engine/backend/src/services/LLMService.ts) — 2.1KB / 2026-03-15T08:05:40.511647
- [ai-engine/backend/src/services/MCPService.ts](ai-engine/backend/src/services/MCPService.ts) — 2.2KB / 2026-03-15T08:05:40.511647
- [ai-engine/backend/src/services/VectorDBService.ts](ai-engine/backend/src/services/VectorDBService.ts) — 1.4KB / 2026-03-15T08:05:40.511647
- [ai-engine/backend/src/utils/logger.ts](ai-engine/backend/src/utils/logger.ts) — 179.0B / 2026-03-15T08:05:40.511647
- [ai-engine/backend/tsconfig.json](ai-engine/backend/tsconfig.json) — 449.0B / 2026-03-15T08:05:40.511647
- [ai-engine/frontend/ai-assistant.html](ai-engine/frontend/ai-assistant.html) — 29.6KB / 2026-03-15T08:05:40.511647
- [ai-engine/README.md](ai-engine/README.md) — 10.7KB / 2026-03-15T08:05:40.509962
### arc-cli

- [arc-cli/DEMO.md](arc-cli/DEMO.md) — 27.9KB / 2026-03-15T08:05:40.511647
- [arc-cli/index.js](arc-cli/index.js) — 5.2KB / 2026-03-15T08:05:40.512002
- [arc-cli/lib/config.js](arc-cli/lib/config.js) — 9.6KB / 2026-03-15T08:05:40.512002
- [arc-cli/lib/deployments.js](arc-cli/lib/deployments.js) — 6.7KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/ecosystem.js](arc-cli/lib/ecosystem.js) — 15.2KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/management.js](arc-cli/lib/management.js) — 18.2KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/monitoring.js](arc-cli/lib/monitoring.js) — 15.5KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/navigation.js](arc-cli/lib/navigation.js) — 7.2KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/nfts.js](arc-cli/lib/nfts.js) — 6.1KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/sbts.js](arc-cli/lib/sbts.js) — 8.5KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/theme.js](arc-cli/lib/theme.js) — 2.5KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/tokens.js](arc-cli/lib/tokens.js) — 13.1KB / 2026-03-15T08:05:40.512278
- [arc-cli/lib/utils.js](arc-cli/lib/utils.js) — 6.3KB / 2026-03-15T08:05:40.512278
- [arc-cli/package.json](arc-cli/package.json) — 770.0B / 2026-03-15T08:05:40.512278
- [arc-cli/README.md](arc-cli/README.md) — 15.2KB / 2026-03-15T08:05:40.512002
- [arc-cli/start.sh](arc-cli/start.sh) — 2.0KB / 2026-03-15T08:05:40.512278
- [arc-cli/USAGE.md](arc-cli/USAGE.md) — 10.4KB / 2026-03-15T08:05:40.512002
### arc_preview.html

- [arc_preview.html](arc_preview.html) — 17.0KB / 2026-03-15T08:05:40.512278
### audit

- [audit/FINDING_TEMPLATE.md](audit/FINDING_TEMPLATE.md) — 2.6KB / 2026-03-15T08:05:40.512278
- [audit/README.md](audit/README.md) — 2.3KB / 2026-03-15T08:05:40.513015
- [audit/scripts/generate-report.ts](audit/scripts/generate-report.ts) — 2.8KB / 2026-03-15T08:05:40.513137
- [audit/security-report.md](audit/security-report.md) — 12.9KB / 2026-03-15T08:05:40.513137
### check-positions.js

- [check-positions.js](check-positions.js) — 4.5KB / 2026-03-15T08:05:40.513137
### code_indexer.ps1

- [code_indexer.ps1](code_indexer.ps1) — 941.0B / 2026-03-15T08:05:40.513137
### CODEBASE_OVERVIEW.md

- [CODEBASE_OVERVIEW.md](CODEBASE_OVERVIEW.md) — 49.2KB / 2026-03-15T08:05:40.509881
### contracts-new

- [contracts-new/ARCStakingVault.sol](contracts-new/ARCStakingVault.sol) — 12.8KB / 2026-03-15T08:05:40.513137
- [contracts-new/ARCsV1.sol](contracts-new/ARCsV1.sol) — 7.4KB / 2026-03-15T08:05:40.513511
- [contracts-new/ARCxV3.sol](contracts-new/ARCxV3.sol) — 9.0KB / 2026-03-15T08:05:40.513511
- [contracts-new/ArtifactTreasury.sol](contracts-new/ArtifactTreasury.sol) — 11.7KB / 2026-03-15T08:05:40.513511
- [contracts-new/ComputeGateway.sol](contracts-new/ComputeGateway.sol) — 12.6KB / 2026-03-15T08:05:40.513511
### contracts

- [contracts/ai/AIAttestation.sol](contracts/ai/AIAttestation.sol) — 16.2KB / 2026-03-15T08:05:40.513807
- [contracts/contracts_registry.json](contracts/contracts_registry.json) — 7.8KB / 2026-03-15T08:05:40.513807
- [contracts/contracts_registry.md](contracts/contracts_registry.md) — 8.7KB / 2026-03-15T08:05:40.513807
- [contracts/dao/adam/AdamHost.sol](contracts/dao/adam/AdamHost.sol) — 13.9KB / 2026-03-15T08:05:40.514015
- [contracts/dao/adam/AdamRegistry.sol](contracts/dao/adam/AdamRegistry.sol) — 10.9KB / 2026-03-15T08:05:40.514099
- [contracts/dao/adam/functions.json](contracts/dao/adam/functions.json) — 19.8KB / 2026-03-15T08:05:40.514099
- [contracts/dao/adam/interfaces/IAdamHost.sol](contracts/dao/adam/interfaces/IAdamHost.sol) — 3.4KB / 2026-03-15T08:05:40.514099
- [contracts/dao/adam/interfaces/IAdamPolicy.sol](contracts/dao/adam/interfaces/IAdamPolicy.sol) — 837.0B / 2026-03-15T08:05:40.514328
- [contracts/dao/adam/interfaces/IAdamRegistry.sol](contracts/dao/adam/interfaces/IAdamRegistry.sol) — 3.1KB / 2026-03-15T08:05:40.514328
- [contracts/dao/adam/policies/Dual2FAPolicy.sol](contracts/dao/adam/policies/Dual2FAPolicy.sol) — 7.1KB / 2026-03-15T08:05:40.514328
- [contracts/dao/adam/policies/ParamsGuardPolicy.sol](contracts/dao/adam/policies/ParamsGuardPolicy.sol) — 6.6KB / 2026-03-15T08:05:40.514442
- [contracts/dao/adam/policies/RWARecencyPolicy.sol](contracts/dao/adam/policies/RWARecencyPolicy.sol) — 9.0KB / 2026-03-15T08:05:40.514442
- [contracts/dao/adam/policies/TreasuryLimiterPolicy.sol](contracts/dao/adam/policies/TreasuryLimiterPolicy.sol) — 10.5KB / 2026-03-15T08:05:40.514442
- [contracts/dao/adam/README.md](contracts/dao/adam/README.md) — 7.4KB / 2026-03-15T08:05:40.514099
- [contracts/dao/governance/AdamGovernorIntegration.sol](contracts/dao/governance/AdamGovernorIntegration.sol) — 9.1KB / 2026-03-15T08:05:40.514812
- [contracts/dao/governance/arc-genesis/AUDIT_REPORT_V2.md](contracts/dao/governance/arc-genesis/AUDIT_REPORT_V2.md) — 20.8KB / 2026-03-15T08:05:40.514812
- [contracts/dao/governance/arc-genesis/contracts/genesis/ARCGenesis.sol](contracts/dao/governance/arc-genesis/contracts/genesis/ARCGenesis.sol) — 1.5KB / 2026-03-15T08:05:40.515913
- [contracts/dao/governance/arc-genesis/contracts/genesis/IARCGenesis.sol](contracts/dao/governance/arc-genesis/contracts/genesis/IARCGenesis.sol) — 459.0B / 2026-03-15T08:05:40.515947
- [contracts/dao/governance/arc-genesis/contracts/libraries/Errors.sol](contracts/dao/governance/arc-genesis/contracts/libraries/Errors.sol) — 1.7KB / 2026-03-15T08:05:40.515947
- [contracts/dao/governance/arc-genesis/contracts/libraries/MODEL_CLASS_SCHEMA.md](contracts/dao/governance/arc-genesis/contracts/libraries/MODEL_CLASS_SCHEMA.md) — 8.5KB / 2026-03-15T08:05:40.516031
- [contracts/dao/governance/arc-genesis/contracts/libraries/ModelClass.sol](contracts/dao/governance/arc-genesis/contracts/libraries/ModelClass.sol) — 1.0KB / 2026-03-15T08:05:40.516031
- [contracts/dao/governance/arc-genesis/contracts/libraries/ModelClassSchema.sol](contracts/dao/governance/arc-genesis/contracts/libraries/ModelClassSchema.sol) — 11.2KB / 2026-03-15T08:05:40.516031
- [contracts/dao/governance/arc-genesis/contracts/registry/ARCModelRegistry.sol](contracts/dao/governance/arc-genesis/contracts/registry/ARCModelRegistry.sol) — 1.9KB / 2026-03-15T08:05:40.516031
- [contracts/dao/governance/arc-genesis/contracts/registry/ARCModelRegistryV2.sol](contracts/dao/governance/arc-genesis/contracts/registry/ARCModelRegistryV2.sol) — 9.0KB / 2026-03-15T08:05:40.516364
- [contracts/dao/governance/arc-genesis/contracts/registry/IARCModelRegistry.sol](contracts/dao/governance/arc-genesis/contracts/registry/IARCModelRegistry.sol) — 660.0B / 2026-03-15T08:05:40.516364
- [contracts/dao/governance/arc-genesis/contracts/registry/IARCModelRegistryV2.sol](contracts/dao/governance/arc-genesis/contracts/registry/IARCModelRegistryV2.sol) — 2.6KB / 2026-03-15T08:05:40.516364
- [contracts/dao/governance/arc-genesis/contracts/registry/RegistryProxy.sol](contracts/dao/governance/arc-genesis/contracts/registry/RegistryProxy.sol) — 4.4KB / 2026-03-15T08:05:40.516364
- [contracts/dao/governance/arc-genesis/contracts/sbt/ARCModelSBT.sol](contracts/dao/governance/arc-genesis/contracts/sbt/ARCModelSBT.sol) — 2.8KB / 2026-03-15T08:05:40.516364
- [contracts/dao/governance/arc-genesis/contracts/sbt/ARCModelSBTV2.sol](contracts/dao/governance/arc-genesis/contracts/sbt/ARCModelSBTV2.sol) — 6.4KB / 2026-03-15T08:05:40.516568
- [contracts/dao/governance/arc-genesis/contracts/sbt/IARCModelSBT.sol](contracts/dao/governance/arc-genesis/contracts/sbt/IARCModelSBT.sol) — 814.0B / 2026-03-15T08:05:40.516568
- [contracts/dao/governance/arc-genesis/contracts/sbt/SBTProxy.sol](contracts/dao/governance/arc-genesis/contracts/sbt/SBTProxy.sol) — 2.2KB / 2026-03-15T08:05:40.516568
- [contracts/dao/governance/arc-genesis/contracts/utils/Immutable.sol](contracts/dao/governance/arc-genesis/contracts/utils/Immutable.sol) — 1.4KB / 2026-03-15T08:05:40.516568
- [contracts/dao/governance/arc-genesis/DEPLOYMENT_GUIDE.md](contracts/dao/governance/arc-genesis/DEPLOYMENT_GUIDE.md) — 13.1KB / 2026-03-15T08:05:40.515545
- [contracts/dao/governance/arc-genesis/DOCUMENTATION.md](contracts/dao/governance/arc-genesis/DOCUMENTATION.md) — 23.6KB / 2026-03-15T08:05:40.515545
- [contracts/dao/governance/arc-genesis/foundry.toml](contracts/dao/governance/arc-genesis/foundry.toml) — 661.0B / 2026-03-15T08:05:40.516568
- [contracts/dao/governance/arc-genesis/INTEGRATION_GUIDE.md](contracts/dao/governance/arc-genesis/INTEGRATION_GUIDE.md) — 15.6KB / 2026-03-15T08:05:40.515545
- [contracts/dao/governance/arc-genesis/README.md](contracts/dao/governance/arc-genesis/README.md) — 8.9KB / 2026-03-15T08:05:40.515545
- [contracts/dao/governance/arc-protocol-genesis/contracts/ARCProtocolGenesis.sol](contracts/dao/governance/arc-protocol-genesis/contracts/ARCProtocolGenesis.sol) — 16.4KB / 2026-03-15T08:05:40.516972
- [contracts/dao/governance/arc-protocol-genesis/contracts/IARCProtocolGenesis.sol](contracts/dao/governance/arc-protocol-genesis/contracts/IARCProtocolGenesis.sol) — 3.3KB / 2026-03-15T08:05:40.517144
- [contracts/dao/governance/arc-protocol-genesis/contracts/L2GenesisVerifier.sol](contracts/dao/governance/arc-protocol-genesis/contracts/L2GenesisVerifier.sol) — 6.9KB / 2026-03-15T08:05:40.517144
- [contracts/dao/governance/arc-protocol-genesis/DESIGN_BLUEPRINT.md](contracts/dao/governance/arc-protocol-genesis/DESIGN_BLUEPRINT.md) — 37.8KB / 2026-03-15T08:05:40.516568
- [contracts/dao/governance/arc-protocol-genesis/foundry.toml](contracts/dao/governance/arc-protocol-genesis/foundry.toml) — 966.0B / 2026-03-15T08:05:40.517144
- [contracts/dao/governance/arc-protocol-genesis/README.md](contracts/dao/governance/arc-protocol-genesis/README.md) — 14.9KB / 2026-03-15T08:05:40.516972
- [contracts/dao/governance/ARCDAO.sol](contracts/dao/governance/ARCDAO.sol) — 15.1KB / 2026-03-15T08:05:40.514442
- [contracts/dao/governance/ARCGovernor.sol](contracts/dao/governance/ARCGovernor.sol) — 22.0KB / 2026-03-15T08:05:40.514812
- [contracts/dao/governance/ARCProposal.sol](contracts/dao/governance/ARCProposal.sol) — 21.1KB / 2026-03-15T08:05:40.514812
- [contracts/dao/governance/ARCTimelock.sol](contracts/dao/governance/ARCTimelock.sol) — 16.9KB / 2026-03-15T08:05:40.514812
- [contracts/dao/governance/ARCTreasury.sol](contracts/dao/governance/ARCTreasury.sol) — 17.5KB / 2026-03-15T08:05:40.514812
- [contracts/dao/governance/ARCVoting.sol](contracts/dao/governance/ARCVoting.sol) — 18.0KB / 2026-03-15T08:05:40.514812
- [contracts/dao/governance/interfaces/IEligibility.sol](contracts/dao/governance/interfaces/IEligibility.sol) — 2.5KB / 2026-03-15T08:05:40.517144
- [contracts/dao/governance/README.md](contracts/dao/governance/README.md) — 10.9KB / 2026-03-15T08:05:40.514812
- [contracts/dao/interfaces/IARCDAO.sol](contracts/dao/interfaces/IARCDAO.sol) — 2.6KB / 2026-03-15T08:05:40.517144
- [contracts/dao/interfaces/IARCGovernor.sol](contracts/dao/interfaces/IARCGovernor.sol) — 2.5KB / 2026-03-15T08:05:40.517336
- [contracts/dao/interfaces/IARCProposal.sol](contracts/dao/interfaces/IARCProposal.sol) — 2.7KB / 2026-03-15T08:05:40.517336
- [contracts/dao/interfaces/IARCTimelock.sol](contracts/dao/interfaces/IARCTimelock.sol) — 2.3KB / 2026-03-15T08:05:40.517336
- [contracts/dao/interfaces/IARCTreasury.sol](contracts/dao/interfaces/IARCTreasury.sol) — 2.7KB / 2026-03-15T08:05:40.517336
- [contracts/dao/interfaces/IARCVoting.sol](contracts/dao/interfaces/IARCVoting.sol) — 2.7KB / 2026-03-15T08:05:40.517336
- [contracts/defi/ARCSwap.sol](contracts/defi/ARCSwap.sol) — 16.4KB / 2026-03-15T08:05:40.517336
- [contracts/defi/hooks/ARCxHook.sol](contracts/defi/hooks/ARCxHook.sol) — 0.0B / 2026-03-15T08:05:40.517568
- [contracts/defi/hooks/ARCxLPHook.sol](contracts/defi/hooks/ARCxLPHook.sol) — 9.9KB / 2026-03-15T08:05:40.517772
- [contracts/defi/infrastructure/ARCBridge.sol](contracts/defi/infrastructure/ARCBridge.sol) — 20.3KB / 2026-03-15T08:05:40.517772
- [contracts/defi/MockPoolManager.sol](contracts/defi/MockPoolManager.sol) — 3.3KB / 2026-03-15T08:05:40.517568
- [contracts/defi/PenaltyVault.sol](contracts/defi/PenaltyVault.sol) — 1.2KB / 2026-03-15T08:05:40.517568
- [contracts/defi/rwa/ARC_RWARegistry.sol](contracts/defi/rwa/ARC_RWARegistry.sol) — 16.7KB / 2026-03-15T08:05:40.517772
- [contracts/defi/rwa/IRWARegistry.sol](contracts/defi/rwa/IRWARegistry.sol) — 8.0KB / 2026-03-15T08:05:40.518058
- [contracts/defi/rwa/SlashingVault.sol](contracts/defi/rwa/SlashingVault.sol) — 14.0KB / 2026-03-15T08:05:40.518058
- [contracts/defi/StakingVault.sol](contracts/defi/StakingVault.sol) — 5.5KB / 2026-03-15T08:05:40.517568
- [contracts/defi/TreasuryRewards.sol](contracts/defi/TreasuryRewards.sol) — 4.5KB / 2026-03-15T08:05:40.517568
- [contracts/gateway/ComputeGateway.sol](contracts/gateway/ComputeGateway.sol) — 12.6KB / 2026-03-15T08:05:40.518058
- [contracts/mocks/MockEligibility.sol](contracts/mocks/MockEligibility.sol) — 2.2KB / 2026-03-15T08:05:40.518058
- [contracts/pool/IPoolManager.sol](contracts/pool/IPoolManager.sol) — 1.6KB / 2026-03-15T08:05:40.518058
- [contracts/pool/IPositionManager.sol](contracts/pool/IPositionManager.sol) — 715.0B / 2026-03-15T08:05:40.518319
- [contracts/pool/IWETH.sol](contracts/pool/IWETH.sol) — 234.0B / 2026-03-15T08:05:40.518319
- [contracts/snapshot/ArtifactSnapshot.sol](contracts/snapshot/ArtifactSnapshot.sol) — 7.0KB / 2026-03-15T08:05:40.518319
- [contracts/staking/ARCStakingVault.sol](contracts/staking/ARCStakingVault.sol) — 12.8KB / 2026-03-15T08:05:40.518319
- [contracts/thirdparty/GasOptimization.sol](contracts/thirdparty/GasOptimization.sol) — 8.6KB / 2026-03-15T08:05:40.518319
- [contracts/thirdparty/uniswap-v4-core/ProtocolFees.sol](contracts/thirdparty/uniswap-v4-core/ProtocolFees.sol) — 0.0B / 2026-03-15T08:05:40.518511
- [contracts/thirdparty/uniswap-v4/base/ERC721Permit_v4.sol](contracts/thirdparty/uniswap-v4/base/ERC721Permit_v4.sol) — 0.0B / 2026-03-15T08:05:40.518553
- [contracts/thirdparty/uniswap-v4/hooks/WETHHook.sol](contracts/thirdparty/uniswap-v4/hooks/WETHHook.sol) — 0.0B / 2026-03-15T08:05:40.518553
- [contracts/thirdparty/uniswap-v4/hooks/WstETHHook.sol](contracts/thirdparty/uniswap-v4/hooks/WstETHHook.sol) — 0.0B / 2026-03-15T08:05:40.518553
- [contracts/thirdparty/uniswap-v4/interfaces/IHooks.sol](contracts/thirdparty/uniswap-v4/interfaces/IHooks.sol) — 3.7KB / 2026-03-15T08:05:40.518608
- [contracts/thirdparty/uniswap-v4/interfaces/IPermit2Forwarder.sol](contracts/thirdparty/uniswap-v4/interfaces/IPermit2Forwarder.sol) — 0.0B / 2026-03-15T08:05:40.518608
- [contracts/thirdparty/uniswap-v4/libraries/Descriptor.sol](contracts/thirdparty/uniswap-v4/libraries/Descriptor.sol) — 0.0B / 2026-03-15T08:05:40.518683
- [contracts/thirdparty/uniswap-v4/libraries/SafeCurrencyMetadata.sol](contracts/thirdparty/uniswap-v4/libraries/SafeCurrencyMetadata.sol) — 0.0B / 2026-03-15T08:05:40.518727
- [contracts/thirdparty/uniswap-v4/libraries/SVG.sol](contracts/thirdparty/uniswap-v4/libraries/SVG.sol) — 0.0B / 2026-03-15T08:05:40.518683
- [contracts/thirdparty/uniswap-v4/NonfungiblePositionManager.sol](contracts/thirdparty/uniswap-v4/NonfungiblePositionManager.sol) — 0.0B / 2026-03-15T08:05:40.518511
- [contracts/thirdparty/uniswap-v4/permit2/src/interfaces/IAllowanceTransfer.sol](contracts/thirdparty/uniswap-v4/permit2/src/interfaces/IAllowanceTransfer.sol) — 0.0B / 2026-03-15T08:05:40.518763
- [contracts/thirdparty/uniswap-v4/permit2/src/libraries/SignatureVerification.sol](contracts/thirdparty/uniswap-v4/permit2/src/libraries/SignatureVerification.sol) — 0.0B / 2026-03-15T08:05:40.518763
- [contracts/thirdparty/uniswap-v4/PositionManager.sol](contracts/thirdparty/uniswap-v4/PositionManager.sol) — 0.0B / 2026-03-15T08:05:40.518511
- [contracts/tokens/airdrop/ARCxAirdropContract.sol](contracts/tokens/airdrop/ARCxAirdropContract.sol) — 14.2KB / 2026-03-15T08:05:40.518852
- [contracts/tokens/arc-s/ARCs.sol](contracts/tokens/arc-s/ARCs.sol) — 3.8KB / 2026-03-15T08:05:40.518852
- [contracts/tokens/arc-s/ARCsV1.sol](contracts/tokens/arc-s/ARCsV1.sol) — 7.4KB / 2026-03-15T08:05:40.519021
- [contracts/tokens/arc-s/DEPLOYMENT_CHECKLIST.md](contracts/tokens/arc-s/DEPLOYMENT_CHECKLIST.md) — 4.8KB / 2026-03-15T08:05:40.519021
- [contracts/tokens/arc-s/deployment_notes.md](contracts/tokens/arc-s/deployment_notes.md) — 4.1KB / 2026-03-15T08:05:40.519021
- [contracts/tokens/arc-x/ARCxMath.sol](contracts/tokens/arc-x/ARCxMath.sol) — 1.8KB / 2026-03-15T08:05:40.519021
- [contracts/tokens/arc-x/ARCxV2.sol](contracts/tokens/arc-x/ARCxV2.sol) — 16.1KB / 2026-03-15T08:05:40.519180
- [contracts/tokens/arc-x/ARCxV3.sol](contracts/tokens/arc-x/ARCxV3.sol) — 9.0KB / 2026-03-15T08:05:40.519180
- [contracts/tokens/arc-x/GasOptimizedARCx.sol](contracts/tokens/arc-x/GasOptimizedARCx.sol) — 8.4KB / 2026-03-15T08:05:40.519180
- [contracts/tokens/arc-x/interfaces/IERC20.sol](contracts/tokens/arc-x/interfaces/IERC20.sol) — 712.0B / 2026-03-15T08:05:40.519180
- [contracts/tokens/arc-x/README.md](contracts/tokens/arc-x/README.md) — 24.9KB / 2026-03-15T08:05:40.519180
- [contracts/tokens/MockARCxToken.sol](contracts/tokens/MockARCxToken.sol) — 359.0B / 2026-03-15T08:05:40.518763
- [contracts/tokens/MockWETH.sol](contracts/tokens/MockWETH.sol) — 560.0B / 2026-03-15T08:05:40.518852
- [contracts/tokens/nft/CONTRACT_MAPPING.md](contracts/tokens/nft/CONTRACT_MAPPING.md) — 2.9KB / 2026-03-15T08:05:40.519180
- [contracts/tokens/nft/contracts/CompanionGovernance.sol](contracts/tokens/nft/contracts/CompanionGovernance.sol) — 5.2KB / 2026-03-15T08:05:40.519637
- [contracts/tokens/nft/contracts/EmergencyManager.sol](contracts/tokens/nft/contracts/EmergencyManager.sol) — 1016.0B / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/EvolvingCompanion.sol](contracts/tokens/nft/contracts/EvolvingCompanion.sol) — 5.0KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/EvolvingCompanionUpgradeable.sol](contracts/tokens/nft/contracts/EvolvingCompanionUpgradeable.sol) — 3.4KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/ModelRegistry.sol](contracts/tokens/nft/contracts/ModelRegistry.sol) — 903.0B / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/ModelRegistryUpgradeable.sol](contracts/tokens/nft/contracts/ModelRegistryUpgradeable.sol) — 11.6KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/ModelRegistryUpgradeableSimple.sol](contracts/tokens/nft/contracts/ModelRegistryUpgradeableSimple.sol) — 1.5KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/ModuleManager.sol](contracts/tokens/nft/contracts/ModuleManager.sol) — 1.7KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/ModuleMock.sol](contracts/tokens/nft/contracts/ModuleMock.sol) — 1.2KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/ProverRegistry.sol](contracts/tokens/nft/contracts/ProverRegistry.sol) — 1.0KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/TokenBoundAccount.sol](contracts/tokens/nft/contracts/TokenBoundAccount.sol) — 2.2KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/TokenBoundAccountRegistry.sol](contracts/tokens/nft/contracts/TokenBoundAccountRegistry.sol) — 2.3KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/TraitVault.sol](contracts/tokens/nft/contracts/TraitVault.sol) — 3.9KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/contracts/TraitVaultUpgradeable.sol](contracts/tokens/nft/contracts/TraitVaultUpgradeable.sol) — 3.9KB / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/frontend/.gitignore](contracts/tokens/nft/frontend/.gitignore) — 480.0B / 2026-03-15T08:05:40.519771
- [contracts/tokens/nft/frontend/data/archetypes.json](contracts/tokens/nft/frontend/data/archetypes.json) — 1.3KB / 2026-03-15T08:05:40.520180
- [contracts/tokens/nft/frontend/data/traits.json](contracts/tokens/nft/frontend/data/traits.json) — 1022.0B / 2026-03-15T08:05:40.520294
- [contracts/tokens/nft/frontend/eslint.config.mjs](contracts/tokens/nft/frontend/eslint.config.mjs) — 524.0B / 2026-03-15T08:05:40.520294
- [contracts/tokens/nft/frontend/next.config.ts](contracts/tokens/nft/frontend/next.config.ts) — 133.0B / 2026-03-15T08:05:40.520294
- [contracts/tokens/nft/frontend/package.json](contracts/tokens/nft/frontend/package.json) — 794.0B / 2026-03-15T08:05:40.520294
- [contracts/tokens/nft/frontend/postcss.config.mjs](contracts/tokens/nft/frontend/postcss.config.mjs) — 81.0B / 2026-03-15T08:05:40.520294
- [contracts/tokens/nft/frontend/public/file.svg](contracts/tokens/nft/frontend/public/file.svg) — 391.0B / 2026-03-15T08:05:40.520294
- [contracts/tokens/nft/frontend/public/globe.svg](contracts/tokens/nft/frontend/public/globe.svg) — 1.0KB / 2026-03-15T08:05:40.520424
- [contracts/tokens/nft/frontend/public/next.svg](contracts/tokens/nft/frontend/public/next.svg) — 1.3KB / 2026-03-15T08:05:40.520424
- [contracts/tokens/nft/frontend/public/vercel.svg](contracts/tokens/nft/frontend/public/vercel.svg) — 128.0B / 2026-03-15T08:05:40.520424
- [contracts/tokens/nft/frontend/public/window.svg](contracts/tokens/nft/frontend/public/window.svg) — 385.0B / 2026-03-15T08:05:40.520424
- [contracts/tokens/nft/frontend/README.md](contracts/tokens/nft/frontend/README.md) — 13.3KB / 2026-03-15T08:05:40.520180
- [contracts/tokens/nft/frontend/src/app/companion/[id]/page.tsx](contracts/tokens/nft/frontend/src/app/companion/[id]/page.tsx) — 1.2KB / 2026-03-15T08:05:40.520547
- [contracts/tokens/nft/frontend/src/app/favicon.ico](contracts/tokens/nft/frontend/src/app/favicon.ico) — 25.3KB / 2026-03-15T08:05:40.520547
- [contracts/tokens/nft/frontend/src/app/globals.css](contracts/tokens/nft/frontend/src/app/globals.css) — 488.0B / 2026-03-15T08:05:40.520547
- [contracts/tokens/nft/frontend/src/app/layout.tsx](contracts/tokens/nft/frontend/src/app/layout.tsx) — 831.0B / 2026-03-15T08:05:40.520547
- [contracts/tokens/nft/frontend/src/app/page.tsx](contracts/tokens/nft/frontend/src/app/page.tsx) — 8.5KB / 2026-03-15T08:05:40.520547
- [contracts/tokens/nft/frontend/src/components/CompanionMint.tsx](contracts/tokens/nft/frontend/src/components/CompanionMint.tsx) — 5.7KB / 2026-03-15T08:05:40.520547
- [contracts/tokens/nft/frontend/src/components/CompanionProfile.tsx](contracts/tokens/nft/frontend/src/components/CompanionProfile.tsx) — 13.9KB / 2026-03-15T08:05:40.520875
- [contracts/tokens/nft/frontend/src/components/providers.tsx](contracts/tokens/nft/frontend/src/components/providers.tsx) — 792.0B / 2026-03-15T08:05:40.520875
- [contracts/tokens/nft/frontend/src/components/TraitGallery.tsx](contracts/tokens/nft/frontend/src/components/TraitGallery.tsx) — 4.8KB / 2026-03-15T08:05:40.520875
- [contracts/tokens/nft/frontend/tsconfig.json](contracts/tokens/nft/frontend/tsconfig.json) — 602.0B / 2026-03-15T08:05:40.520875
- [contracts/tokens/nft/hardhat.config.js](contracts/tokens/nft/hardhat.config.js) — 526.0B / 2026-03-15T08:05:40.520875
- [contracts/tokens/nft/package.json](contracts/tokens/nft/package.json) — 723.0B / 2026-03-15T08:05:40.520875
- [contracts/tokens/nft/README.md](contracts/tokens/nft/README.md) — 11.3KB / 2026-03-15T08:05:40.519637
- [contracts/tokens/nft/scripts/deploy.js](contracts/tokens/nft/scripts/deploy.js) — 1.8KB / 2026-03-15T08:05:40.520875
- [contracts/tokens/nft/scripts/deploy_roles_and_demo.js](contracts/tokens/nft/scripts/deploy_roles_and_demo.js) — 1.8KB / 2026-03-15T08:05:40.521075
- [contracts/tokens/nft/scripts/upgrade.js](contracts/tokens/nft/scripts/upgrade.js) — 1.3KB / 2026-03-15T08:05:40.521075
- [contracts/tokens/nft/test/EvolvingCompanionAccessControl.test.js](contracts/tokens/nft/test/EvolvingCompanionAccessControl.test.js) — 7.0KB / 2026-03-15T08:05:40.521075
- [contracts/tokens/nft/test/phase1.test.js](contracts/tokens/nft/test/phase1.test.js) — 7.7KB / 2026-03-15T08:05:40.521167
- [contracts/tokens/sbt/ARC_Eligibility.sol](contracts/tokens/sbt/ARC_Eligibility.sol) — 14.3KB / 2026-03-15T08:05:40.521167
- [contracts/tokens/sbt/ARC_IdentitySBT.sol](contracts/tokens/sbt/ARC_IdentitySBT.sol) — 18.6KB / 2026-03-15T08:05:40.521290
- [contracts/tokens/sbt/readme.md](contracts/tokens/sbt/readme.md) — 3.0KB / 2026-03-15T08:05:40.521290
- [contracts/tokens/vesting/ARCxVestingContract.sol](contracts/tokens/vesting/ARCxVestingContract.sol) — 13.7KB / 2026-03-15T08:05:40.521290
- [contracts/treasury/ArtifactTreasury.sol](contracts/treasury/ArtifactTreasury.sol) — 11.7KB / 2026-03-15T08:05:40.521290
### css

- [css/lines.svg](css/lines.svg) — 413.0B / 2026-03-15T08:05:40.521290
- [css/style.css](css/style.css) — 14.3KB / 2026-03-15T08:05:40.521616
### deploy_auction.ps1

- [deploy_auction.ps1](deploy_auction.ps1) — 5.2KB / 2026-03-15T08:05:40.521616
### deployment

- [deployment/snapshot/deployment.json](deployment/snapshot/deployment.json) — 332.0B / 2026-03-15T08:05:40.521796
- [deployment/testnet/deploy-ganache.ts](deployment/testnet/deploy-ganache.ts) — 0.0B / 2026-03-15T08:05:40.521796
### docs

- [docs/00_INDEX.md](docs/00_INDEX.md) — 7.9KB / 2026-03-15T08:05:40.521796
- [docs/01_INTRODUCTION.md](docs/01_INTRODUCTION.md) — 3.1KB / 2026-03-15T08:05:40.521914
- [docs/02_ARCHITECTURE.md](docs/02_ARCHITECTURE.md) — 11.0KB / 2026-03-15T08:05:40.521914
- [docs/03_DEVELOPMENT.md](docs/03_DEVELOPMENT.md) — 14.8KB / 2026-03-15T08:05:40.521914
- [docs/04_TOKENS.md](docs/04_TOKENS.md) — 12.7KB / 2026-03-15T08:05:40.521914
- [docs/05_GOVERNANCE.md](docs/05_GOVERNANCE.md) — 13.8KB / 2026-03-15T08:05:40.521914
- [docs/06_DEFI.md](docs/06_DEFI.md) — 12.1KB / 2026-03-15T08:05:40.521914
- [docs/07_SECURITY.md](docs/07_SECURITY.md) — 12.5KB / 2026-03-15T08:05:40.521914
- [docs/08_API_REFERENCE.md](docs/08_API_REFERENCE.md) — 15.7KB / 2026-03-15T08:05:40.521914
- [docs/09_DEPLOYMENT.md](docs/09_DEPLOYMENT.md) — 11.9KB / 2026-03-15T08:05:40.521914
- [docs/10_SCRIPTS.md](docs/10_SCRIPTS.md) — 13.1KB / 2026-03-15T08:05:40.521914
- [docs/11_TROUBLESHOOTING.md](docs/11_TROUBLESHOOTING.md) — 15.2KB / 2026-03-15T08:05:40.521962
- [docs/ADAM_INTEGRATION_GUIDE.md](docs/ADAM_INTEGRATION_GUIDE.md) — 12.8KB / 2026-03-15T08:05:40.521962
- [docs/AI_ATTESTATION_SERVICE.md](docs/AI_ATTESTATION_SERVICE.md) — 11.9KB / 2026-03-15T08:05:40.521962
- [docs/archive/README.md](docs/archive/README.md) — 350.0B / 2026-03-15T08:05:40.521962
- [docs/archive/README_legacy_full.md](docs/archive/README_legacy_full.md) — 11.6KB / 2026-03-15T08:05:40.522929
- [docs/arcx-v2-enhanced-features.md](docs/arcx-v2-enhanced-features.md) — 5.7KB / 2026-03-15T08:05:40.522929
- [docs/assets/images/SBT_bg.jpeg](docs/assets/images/SBT_bg.jpeg) — 85.9KB / 2026-03-15T08:05:40.523144
- [docs/assets/images/system_diagram20250830.drawio](docs/assets/images/system_diagram20250830.drawio) — 46.0KB / 2026-03-15T08:05:40.523604
- [docs/assets/images/system_overview.mermaid](docs/assets/images/system_overview.mermaid) — 6.6KB / 2026-03-15T08:05:40.523604
- [docs/assets/index-CXsZFpx3.js](docs/assets/index-CXsZFpx3.js) — 549.2KB / 2026-03-15T08:05:40.524962
- [docs/assets/lod (1).fbx](docs/assets/lod (1).fbx) — 2.1MB / 2026-03-15T08:05:40.535962
- [docs/assets/lod (2).fbx](docs/assets/lod (2).fbx) — 2.1MB / 2026-03-15T08:05:40.537962
- [docs/assets/lod (3).fbx](docs/assets/lod (3).fbx) — 2.1MB / 2026-03-15T08:05:40.538962
- [docs/assets/lod.fbx](docs/assets/lod.fbx) — 2.1MB / 2026-03-15T08:05:40.539962
- [docs/assets/logos/arcx_logo.png](docs/assets/logos/arcx_logo.png) — 1.4MB / 2026-03-15T08:05:40.541962
- [docs/assets/logos/arcx_logo.svg](docs/assets/logos/arcx_logo.svg) — 1.2MB / 2026-03-15T08:05:40.546962
- [docs/assets/logos/av-black-logo-removebg-preview.png](docs/assets/logos/av-black-logo-removebg-preview.png) — 28.0KB / 2026-03-15T08:05:40.547962
- [docs/assets/logos/av-white-logo-removebg-preview.png](docs/assets/logos/av-white-logo-removebg-preview.png) — 33.1KB / 2026-03-15T08:05:40.547962
- [docs/assets/logos/base-logo.png](docs/assets/logos/base-logo.png) — 2.2KB / 2026-03-15T08:05:40.547962
- [docs/community_message.md](docs/community_message.md) — 5.9KB / 2026-03-15T08:05:40.547962
- [docs/diagrams/arc.png](docs/diagrams/arc.png) — 198.8KB / 2026-03-15T08:05:40.548962
- [docs/diagrams/arc_map.md](docs/diagrams/arc_map.md) — 7.1KB / 2026-03-15T08:05:40.548962
- [docs/diagrams/enerygy_cap.md](docs/diagrams/enerygy_cap.md) — 3.9KB / 2026-03-15T08:05:40.548962
- [docs/diagrams/layers.md](docs/diagrams/layers.md) — 2.1KB / 2026-03-15T08:05:40.548962
- [docs/diagrams/lifecycle.md](docs/diagrams/lifecycle.md) — 1.9KB / 2026-03-15T08:05:40.548962
- [docs/environment/CODE_OF_CONDUCT.md](docs/environment/CODE_OF_CONDUCT.md) — 6.2KB / 2026-03-15T08:05:40.548962
- [docs/environment/CONTRIBUTING.md](docs/environment/CONTRIBUTING.md) — 11.9KB / 2026-03-15T08:05:40.550269
- [docs/environment/DEPLOYMENT_README.md](docs/environment/DEPLOYMENT_README.md) — 5.8KB / 2026-03-15T08:05:40.550269
- [docs/environment/ENVIRONMENT_SETUP.md](docs/environment/ENVIRONMENT_SETUP.md) — 5.4KB / 2026-03-15T08:05:40.550269
- [docs/environment/README.md](docs/environment/README.md) — 1.1KB / 2026-03-15T08:05:40.550269
- [docs/environment/SBT_TOKENS_DEPLOYMENT_README.md](docs/environment/SBT_TOKENS_DEPLOYMENT_README.md) — 4.9KB / 2026-03-15T08:05:40.550269
- [docs/governance/assets/arcx_lp_nft.mp4](docs/governance/assets/arcx_lp_nft.mp4) — 353.2KB / 2026-03-15T08:05:40.550962
- [docs/governance/assets/lod (1).fbx](docs/governance/assets/lod (1).fbx) — 2.1MB / 2026-03-15T08:05:40.551962
- [docs/governance/assets/lod (2).fbx](docs/governance/assets/lod (2).fbx) — 2.1MB / 2026-03-15T08:05:40.552962
- [docs/governance/assets/lod (3).fbx](docs/governance/assets/lod (3).fbx) — 2.1MB / 2026-03-15T08:05:40.553962
- [docs/governance/assets/lod.fbx](docs/governance/assets/lod.fbx) — 2.1MB / 2026-03-15T08:05:40.554962
- [docs/governance/deployment_plan.md](docs/governance/deployment_plan.md) — 828.0B / 2026-03-15T08:05:40.554962
- [docs/governance/energy_cap.md](docs/governance/energy_cap.md) — 2.3KB / 2026-03-15T08:05:40.554962
- [docs/governance/governance_model.md](docs/governance/governance_model.md) — 10.1KB / 2026-03-15T08:05:40.554962
- [docs/governance/whitepaper-adam.md](docs/governance/whitepaper-adam.md) — 12.0KB / 2026-03-15T08:05:40.555962
- [docs/governance/whitepaper-SBT.md](docs/governance/whitepaper-SBT.md) — 12.5KB / 2026-03-15T08:05:40.554962
- [docs/html/airdrop_interface.html](docs/html/airdrop_interface.html) — 10.1KB / 2026-03-15T08:05:40.555962
- [docs/html/artifact_development_engine.html](docs/html/artifact_development_engine.html) — 22.4KB / 2026-03-15T08:05:40.556770
- [docs/html/auction_interface.html](docs/html/auction_interface.html) — 8.0KB / 2026-03-15T08:05:40.556770
- [docs/html/bridge.html](docs/html/bridge.html) — 31.1KB / 2026-03-15T08:05:40.556770
- [docs/html/contract_deployment_ide.html](docs/html/contract_deployment_ide.html) — 30.0KB / 2026-03-15T08:05:40.556770
- [docs/html/documentation.html](docs/html/documentation.html) — 24.1KB / 2026-03-15T08:05:40.556770
- [docs/html/index.html](docs/html/index.html) — 21.4KB / 2026-03-15T08:05:40.556770
- [docs/html/index_horizontal.html](docs/html/index_horizontal.html) — 72.5KB / 2026-03-15T08:05:40.556962
- [docs/html/transparency.html](docs/html/transparency.html) — 24.5KB / 2026-03-15T08:05:40.556962
- [docs/html/whitepaper.html](docs/html/whitepaper.html) — 7.8KB / 2026-03-15T08:05:40.556962
- [docs/real_world_assets.md](docs/real_world_assets.md) — 12.8KB / 2026-03-15T08:05:40.556962
- [docs/research/00_START_HERE.md](docs/research/00_START_HERE.md) — 24.9KB / 2026-03-15T08:05:40.557962
- [docs/research/01_ECOSYSTEM.md](docs/research/01_ECOSYSTEM.md) — 37.1KB / 2026-03-15T08:05:40.557962
- [docs/research/02_GOVERNANCE.md](docs/research/02_GOVERNANCE.md) — 49.3KB / 2026-03-15T08:05:40.557962
- [docs/research/03_ATTRIBUTES.md](docs/research/03_ATTRIBUTES.md) — 54.8KB / 2026-03-15T08:05:40.557962
- [docs/research/04_GENESIS.md](docs/research/04_GENESIS.md) — 115.7KB / 2026-03-15T08:05:40.558962
- [docs/research/05_REGISTRY.md](docs/research/05_REGISTRY.md) — 102.9KB / 2026-03-15T08:05:40.558962
- [docs/research/06_IDENTITY.md](docs/research/06_IDENTITY.md) — 55.7KB / 2026-03-15T08:05:40.559962
- [docs/research/07_MODELS.md](docs/research/07_MODELS.md) — 60.9KB / 2026-03-15T08:05:40.559962
- [docs/research/08_JOBS.md](docs/research/08_JOBS.md) — 65.9KB / 2026-03-15T08:05:40.559962
- [docs/research/misc/banking_2.md](docs/research/misc/banking_2.md) — 48.8KB / 2026-03-15T08:05:40.559962
- [docs/research/misc/crypt_vs_banking.md](docs/research/misc/crypt_vs_banking.md) — 68.4KB / 2026-03-15T08:05:40.561484
- [docs/research/misc/dev_thesis.md](docs/research/misc/dev_thesis.md) — 8.6KB / 2026-03-15T08:05:40.561484
- [docs/research/misc/gmi.md](docs/research/misc/gmi.md) — 42.7KB / 2026-03-15T08:05:40.561484
- [docs/research/misc/imf_international_sc.md](docs/research/misc/imf_international_sc.md) — 101.4KB / 2026-03-15T08:05:40.561484
- [docs/research/misc/index.md](docs/research/misc/index.md) — 2.0KB / 2026-03-15T08:05:40.561484
- [docs/research/misc/new_money.md](docs/research/misc/new_money.md) — 27.1KB / 2026-03-15T08:05:40.561962
- [docs/research/misc/sc_revolution.md](docs/research/misc/sc_revolution.md) — 38.4KB / 2026-03-15T08:05:40.561962
- [docs/research/misc/stablecoins.md](docs/research/misc/stablecoins.md) — 226.0KB / 2026-03-15T08:05:40.562962
- [docs/research/misc/tokenization.md](docs/research/misc/tokenization.md) — 6.7KB / 2026-03-15T08:05:40.562962
- [docs/research/misc/tokenization_infra.jpg](docs/research/misc/tokenization_infra.jpg) — 21.6KB / 2026-03-15T08:05:40.562962
- [docs/SECURITY.md](docs/SECURITY.md) — 3.2KB / 2026-03-15T08:05:40.521962
- [docs/tokenlists/arcx.tokenlist.json](docs/tokenlists/arcx.tokenlist.json) — 905.0B / 2026-03-15T08:05:40.564055
- [docs/tokenlists/README.md](docs/tokenlists/README.md) — 947.0B / 2026-03-15T08:05:40.562962
### echidna.yaml

- [echidna.yaml](echidna.yaml) — 1.1KB / 2026-03-15T08:05:40.564055
### eslint.config.js

- [eslint.config.js](eslint.config.js) — 1.6KB / 2026-03-15T08:05:40.564055
### foundry-scripts

- [foundry-scripts/DeployGenesis.s.sol](foundry-scripts/DeployGenesis.s.sol) — 5.3KB / 2026-03-15T08:05:40.564055
- [foundry-scripts/DeployGenesisV2.s.sol](foundry-scripts/DeployGenesisV2.s.sol) — 3.0KB / 2026-03-15T08:05:40.564176
- [foundry-scripts/DeployProtocolGenesis.s.sol](foundry-scripts/DeployProtocolGenesis.s.sol) — 9.0KB / 2026-03-15T08:05:40.564176
- [foundry-scripts/Genesis.t.sol](foundry-scripts/Genesis.t.sol) — 5.0KB / 2026-03-15T08:05:40.564176
- [foundry-scripts/L2GenesisVerifier.t.sol](foundry-scripts/L2GenesisVerifier.t.sol) — 4.9KB / 2026-03-15T08:05:40.564176
- [foundry-scripts/ProtocolGenesis.t.sol](foundry-scripts/ProtocolGenesis.t.sol) — 17.4KB / 2026-03-15T08:05:40.564176
- [foundry-scripts/Registry.t.sol](foundry-scripts/Registry.t.sol) — 5.8KB / 2026-03-15T08:05:40.564176
- [foundry-scripts/SBT.t.sol](foundry-scripts/SBT.t.sol) — 6.3KB / 2026-03-15T08:05:40.564176
### ganache-db

- [ganache-db/CURRENT](ganache-db/CURRENT) — 16.0B / 2026-03-15T08:05:40.564176
- [ganache-db/LOCK](ganache-db/LOCK) — 0.0B / 2026-03-15T08:05:40.564176
- [ganache-db/LOG](ganache-db/LOG) — 46.0B / 2026-03-15T08:05:40.564484
- [ganache-db/MANIFEST-000002](ganache-db/MANIFEST-000002) — 50.0B / 2026-03-15T08:05:40.564484
### gas-report.txt

- [gas-report.txt](gas-report.txt) — 3.6KB / 2026-03-15T08:05:40.564484
### gas-reports

- [gas-reports/gas-analysis-1756553019749.json](gas-reports/gas-analysis-1756553019749.json) — 20.7KB / 2026-03-15T08:05:40.564484
- [gas-reports/gas-analysis-1756553056888.json](gas-reports/gas-analysis-1756553056888.json) — 20.7KB / 2026-03-15T08:05:40.564614
### hardhat.config.ts

- [hardhat.config.ts](hardhat.config.ts) — 5.7KB / 2026-03-15T08:05:40.564614
### js

- [js/airdrop.js](js/airdrop.js) — 7.6KB / 2026-03-15T08:05:40.564614
- [js/auction-gh-pages.js](js/auction-gh-pages.js) — 17.3KB / 2026-03-15T08:05:40.564845
- [js/auction.js](js/auction.js) — 14.0KB / 2026-03-15T08:05:40.564845
### LICENSE

- [LICENSE](LICENSE) — 2.9KB / 2026-03-15T08:05:40.509881
### OVERVIEW.md

- [OVERVIEW.md](OVERVIEW.md) — 47.5KB / 2026-03-15T08:05:40.509881
### package.json

- [package.json](package.json) — 8.0KB / 2026-03-15T08:05:40.564845
### README.md

- [README.md](README.md) — 14.7KB / 2026-03-15T08:05:40.509962
### run-audit-and-append.ps1

- [run-audit-and-append.ps1](run-audit-and-append.ps1) — 3.0KB / 2026-03-15T08:05:40.565516
### scripts

- [scripts/airdrop-manager.ts](scripts/airdrop-manager.ts) — 6.9KB / 2026-03-15T08:05:40.565697
- [scripts/check-deployer-nfts-standalone.ts](scripts/check-deployer-nfts-standalone.ts) — 3.0KB / 2026-03-15T08:05:40.565697
- [scripts/check-deployer-nfts.ts](scripts/check-deployer-nfts.ts) — 2.8KB / 2026-03-15T08:05:40.565697
- [scripts/check-lp-compat-fixed.ts](scripts/check-lp-compat-fixed.ts) — 1.7KB / 2026-03-15T08:05:40.565697
- [scripts/check-specific-positions.ts](scripts/check-specific-positions.ts) — 1.9KB / 2026-03-15T08:05:40.565697
- [scripts/check-uniswap-positions.ts](scripts/check-uniswap-positions.ts) — 3.5KB / 2026-03-15T08:05:40.565697
- [scripts/config.ts](scripts/config.ts) — 8.6KB / 2026-03-15T08:05:40.565697
- [scripts/deploy-snapshot.ts](scripts/deploy-snapshot.ts) — 1.8KB / 2026-03-15T08:05:40.565697
- [scripts/deploy-test-ecosystem.ts](scripts/deploy-test-ecosystem.ts) — 19.3KB / 2026-03-15T08:05:40.565697
- [scripts/deploy_adam.ts](scripts/deploy_adam.ts) — 10.0KB / 2026-03-15T08:05:40.565697
- [scripts/deploy_defi.ts](scripts/deploy_defi.ts) — 2.5KB / 2026-03-15T08:05:40.565697
- [scripts/deployment-manager.ts](scripts/deployment-manager.ts) — 5.7KB / 2026-03-15T08:05:40.565697
- [scripts/ecosystem-manager.ts](scripts/ecosystem-manager.ts) — 8.5KB / 2026-03-15T08:05:40.565697
- [scripts/lp-manager.ts](scripts/lp-manager.ts) — 6.7KB / 2026-03-15T08:05:40.565697
- [scripts/monitor.ts](scripts/monitor.ts) — 8.3KB / 2026-03-15T08:05:40.565697
- [scripts/README.md](scripts/README.md) — 10.2KB / 2026-03-15T08:05:40.565516
- [scripts/setup_adam_policies.ts](scripts/setup_adam_policies.ts) — 4.1KB / 2026-03-15T08:05:40.565697
- [scripts/shared/constants.ts](scripts/shared/constants.ts) — 3.6KB / 2026-03-15T08:05:40.565697
- [scripts/shared/utils.ts](scripts/shared/utils.ts) — 9.7KB / 2026-03-15T08:05:40.566362
- [scripts/transfer-positions.ts](scripts/transfer-positions.ts) — 1.7KB / 2026-03-15T08:05:40.566362
- [scripts/txdata/generate-vesting-txdata.ts](scripts/txdata/generate-vesting-txdata.ts) — 4.8KB / 2026-03-15T08:05:40.566362
- [scripts/v2/addresses.json](scripts/v2/addresses.json) — 1.2KB / 2026-03-15T08:05:40.566538
- [scripts/v2/deploy_arc_v2.ts](scripts/v2/deploy_arc_v2.ts) — 13.8KB / 2026-03-15T08:05:40.566538
- [scripts/v2/get_impls.ts](scripts/v2/get_impls.ts) — 1.9KB / 2026-03-15T08:05:40.566538
- [scripts/v2/PREEXISTING_ERRORS.md](scripts/v2/PREEXISTING_ERRORS.md) — 2.1KB / 2026-03-15T08:05:40.566362
- [scripts/v2/resume_deploy.ts](scripts/v2/resume_deploy.ts) — 8.3KB / 2026-03-15T08:05:40.566538
- [scripts/v2/smoke_test.ts](scripts/v2/smoke_test.ts) — 4.7KB / 2026-03-15T08:05:40.566538
- [scripts/verify-snapshot.ts](scripts/verify-snapshot.ts) — 936.0B / 2026-03-15T08:05:40.566538
- [scripts/vesting-manager.ts](scripts/vesting-manager.ts) — 9.1KB / 2026-03-15T08:05:40.566538
### site

- [site/index.html](site/index.html) — 20.6KB / 2026-03-15T08:05:40.566538
### src

- [src/components/arc_roadmap.html](src/components/arc_roadmap.html) — 9.0KB / 2026-03-15T08:05:40.566931
- [src/components/roadmap.tsx](src/components/roadmap.tsx) — 22.6KB / 2026-03-15T08:05:40.566995
- [src/components/votingsystem.tsx](src/components/votingsystem.tsx) — 26.8KB / 2026-03-15T08:05:40.566995
### SYSTEM_MAP.md

- [SYSTEM_MAP.md](SYSTEM_MAP.md) — 32.6KB / 2026-03-15T08:05:40.509962
### TERMINAL_UI_DEMO.txt

- [TERMINAL_UI_DEMO.txt](TERMINAL_UI_DEMO.txt) — 16.3KB / 2026-03-15T08:05:40.509962
### tests

- [tests/ARCx.test.ts](tests/ARCx.test.ts) — 2.8KB / 2026-03-15T08:05:40.566995
- [tests/ARCxDutchAuction.test.ts](tests/ARCxDutchAuction.test.ts) — 2.3KB / 2026-03-15T08:05:40.567320
- [tests/ARCxMasterVesting.test.ts](tests/ARCxMasterVesting.test.ts) — 17.8KB / 2026-03-15T08:05:40.567320
- [tests/ARCxSmartAirdrop.test.ts](tests/ARCxSmartAirdrop.test.ts) — 8.1KB / 2026-03-15T08:05:40.567320
- [tests/ARCxToken.test.ts](tests/ARCxToken.test.ts) — 11.6KB / 2026-03-15T08:05:40.567320
- [tests/dao/adam/ContextEncoding.test.ts](tests/dao/adam/ContextEncoding.test.ts) — 7.7KB / 2026-03-15T08:05:40.567466
- [tests/dao/adam/GovernanceLifecycle.integration.test.ts](tests/dao/adam/GovernanceLifecycle.integration.test.ts) — 13.2KB / 2026-03-15T08:05:40.567537
- [tests/dao/adam/TreasuryLimiter.test.ts](tests/dao/adam/TreasuryLimiter.test.ts) — 6.4KB / 2026-03-15T08:05:40.567537
- [tests/fuzz/AdamPolicyFuzzTest.sol](tests/fuzz/AdamPolicyFuzzTest.sol) — 11.3KB / 2026-03-15T08:05:40.567537
- [tests/fuzz/ContractInvariants.t.sol](tests/fuzz/ContractInvariants.t.sol) — 14.5KB / 2026-03-15T08:05:40.567699
- [tests/governance/TimelockRoles.test.ts](tests/governance/TimelockRoles.test.ts) — 7.0KB / 2026-03-15T08:05:40.567699
- [tests/integration/integration.test.ts](tests/integration/integration.test.ts) — 14.9KB / 2026-03-15T08:05:40.567699
- [tests/mocha.opts](tests/mocha.opts) — 140.0B / 2026-03-15T08:05:40.567699
- [tests/phase1-modules.test.js](tests/phase1-modules.test.js) — 14.3KB / 2026-03-15T08:05:40.567699
- [tests/security/AdamHostSecurity.test.ts](tests/security/AdamHostSecurity.test.ts) — 12.1KB / 2026-03-15T08:05:40.568039
- [tests/security/AdamRegistrySecurity.test.ts](tests/security/AdamRegistrySecurity.test.ts) — 14.6KB / 2026-03-15T08:05:40.568039
- [tests/security/ARCBridgeSecurity.test.ts](tests/security/ARCBridgeSecurity.test.ts) — 10.9KB / 2026-03-15T08:05:40.567699
- [tests/security/ARCGovernorSecurity.test.ts](tests/security/ARCGovernorSecurity.test.ts) — 10.3KB / 2026-03-15T08:05:40.568039
- [tests/security/ARCTimelockSecurity.test.ts](tests/security/ARCTimelockSecurity.test.ts) — 8.1KB / 2026-03-15T08:05:40.568039
- [tests/security/BridgeSecurity.test.ts](tests/security/BridgeSecurity.test.ts) — 3.0KB / 2026-03-15T08:05:40.568039
- [tests/security/security.test.ts](tests/security/security.test.ts) — 18.9KB / 2026-03-15T08:05:40.568039
- [tests/security/TokenSecurity.test.ts](tests/security/TokenSecurity.test.ts) — 4.1KB / 2026-03-15T08:05:40.568039
- [tests/shared/test-helpers.ts](tests/shared/test-helpers.ts) — 6.0KB / 2026-03-15T08:05:40.568039
- [tests/test_results.md](tests/test_results.md) — 3.9KB / 2026-03-15T08:05:40.568039
### tools

- [tools/code_indexer.py](tools/code_indexer.py) — 7.2KB / 2026-03-15T08:05:40.568039
- [tools/install_git_hooks.ps1](tools/install_git_hooks.ps1) — 851.0B / 2026-03-15T08:05:40.568523
### trader.py

- [trader.py](trader.py) — 6.0KB / 2026-03-15T08:05:40.568523
### tsconfig.json

- [tsconfig.json](tsconfig.json) — 589.0B / 2026-03-15T08:05:40.568523

---

### Notes for contributors

- This file is generated automatically by `tools/code_indexer.py`.
- It excludes some common build and dependency folders (see script EXCLUDE_DIRS).
- If you need more detailed per-file descriptions, open issues or submit a PR to improve this document.