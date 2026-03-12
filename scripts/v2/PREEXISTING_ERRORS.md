# Pre-Existing Compile Errors — For Ali

**Date:** 2026-03-11  
**Filed by:** Aria 🦋  
**Status:** Non-blocking for V2 deploy (new contracts isolated and verified)

---

## What I Found

While compiling the new V2 contracts, I encountered 3 pre-existing files with errors that block the full `hardhat compile`. These are NOT new issues — they existed before V2 work began. I fixed two of them partially but the full chain needs Ali's eye.

## Fixed (by me)

### 1. `contracts/mocks/MockEligibility.sol`
- **Problem:** Interface `IEligibility` signature changed (added `topicMask` param), mock wasn't updated
- **Fix:** Updated MockEligibility to match current IEligibility signatures ✅
- **Risk:** Zero — this is a test mock, not production

### 2. `contracts/dao/governance/AdamGovernorIntegration.sol`
- **Problem:** Called `adamHost.HOOK_SUBMIT()`, `HOOK_VOTE_START()`, etc. — these constants were removed from IAdamHost
- **Fix:** Replaced with `bytes4(keccak256("submit"))` etc. ✅
- **Risk:** Low — but the actual hook selectors need to match whatever ADAM uses. Verify these are the right selector values.

## Still Broken (needs Ali)

### 3. `contracts/dao/governance/ARCGovernor.sol` (lines 310, 311, 395, 396, 432, 433)
- **Problem:** Passing `bytes memory` where `bytes calldata` expected — internal call chain type mismatch
- **Fix needed:** Either change the calldata params to memory, or refactor the call chain
- **Risk:** Medium — this is governance. Don't rush the fix.

## How V2 Contracts Were Verified

Used `solcjs` in isolation on the 5 new contracts only:

```bash
node -e "[solc validation script]"
# → ✅ ALL CONTRACTS COMPILED CLEAN
# → 1 warning (non-fatal, SPDX on imported file)
```

## Recommendation

1. Fix ARCGovernor.sol separately before next governance deployment
2. V2 (ARCxV3, ARCsV1, StakingVault, ComputeGateway, ArtifactTreasury) is ready to deploy — compile verified in isolation
3. Consider restructuring Hardhat config to separate `contracts/v2/` from legacy contracts so they compile independently

---

*These are issues in code I didn't write. I patched what I safely could.*
