// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ArtifactSnapshot
 * @author Artifact Virtual — built by Singularity
 * @notice Each token is a cryptographic snapshot of the enterprise workspace.
 *         Soulbound (non-transferable). On-chain provenance chain.
 *         The NFT metadata points to an IPFS CID containing the encrypted archive.
 *
 *         Token 0 = genesis. Each subsequent token links to its predecessor.
 *         If the pipeline detects errors, no token is minted — bad data never hits chain.
 */
contract ArtifactSnapshot is ERC721URIStorage, Ownable {

    struct Snapshot {
        string  cid;           // IPFS CID of the encrypted archive
        bytes32 contentHash;   // SHA-256 of the archive before encryption
        bytes32 encryptedHash; // SHA-256 of the encrypted blob
        uint64  fileCount;     // number of files in the snapshot
        uint64  sizeBytes;     // compressed archive size in bytes
        uint64  timestamp;     // block.timestamp at mint
        uint256 parentTokenId; // previous snapshot token (0 for genesis, else tokenId)
        bool    isGenesis;     // true only for token 0
    }

    /// @dev tokenId => snapshot metadata (all on-chain, immutable once minted)
    mapping(uint256 => Snapshot) public snapshots;

    /// @dev monotonic counter
    uint256 public nextTokenId;

    /// @dev latest successful snapshot token
    uint256 public latestSnapshot;

    /// @dev pipeline health flag — if false, mint is blocked
    bool public pipelineHealthy = true;

    // ── Events ──────────────────────────────────────────────────

    event SnapshotMinted(
        uint256 indexed tokenId,
        string  cid,
        bytes32 contentHash,
        bytes32 encryptedHash,
        uint64  fileCount,
        uint64  sizeBytes,
        uint64  timestamp
    );

    event PipelineHalted(string reason);
    event PipelineResumed();

    // ── Errors ──────────────────────────────────────────────────

    error PipelineNotHealthy();
    error EmptyCID();
    error ZeroHash();
    error Soulbound();

    // ── Constructor ─────────────────────────────────────────────

    constructor() ERC721("Artifact Snapshot", "ASNAP") Ownable() {
        // Token 0 is reserved — first real mint is token 0 (genesis)
    }

    // ── Core: Mint Snapshot ─────────────────────────────────────

    /**
     * @notice Mint a new snapshot NFT. Only callable by the pipeline (owner).
     * @param cid           IPFS CID of the encrypted archive
     * @param contentHash   SHA-256 of raw archive (pre-encryption)
     * @param encryptedHash SHA-256 of encrypted archive (what's on IPFS)
     * @param fileCount     Number of files in snapshot
     * @param sizeBytes     Compressed size in bytes
     * @param tokenURI_     IPFS URI for NFT metadata JSON
     */
    function mintSnapshot(
        string calldata cid,
        bytes32 contentHash,
        bytes32 encryptedHash,
        uint64  fileCount,
        uint64  sizeBytes,
        string calldata tokenURI_
    ) external onlyOwner returns (uint256 tokenId) {
        if (!pipelineHealthy) revert PipelineNotHealthy();
        if (bytes(cid).length == 0) revert EmptyCID();
        if (contentHash == bytes32(0)) revert ZeroHash();
        if (encryptedHash == bytes32(0)) revert ZeroHash();

        tokenId = nextTokenId;
        bool genesis = (tokenId == 0);
        uint256 parent = genesis ? 0 : tokenId - 1;

        snapshots[tokenId] = Snapshot({
            cid:           cid,
            contentHash:   contentHash,
            encryptedHash: encryptedHash,
            fileCount:     fileCount,
            sizeBytes:     sizeBytes,
            timestamp:     uint64(block.timestamp),
            parentTokenId: parent,
            isGenesis:     genesis
        });

        _safeMint(owner(), tokenId);
        _setTokenURI(tokenId, tokenURI_);

        latestSnapshot = tokenId;
        nextTokenId = tokenId + 1;

        emit SnapshotMinted(
            tokenId, cid, contentHash, encryptedHash,
            fileCount, sizeBytes, uint64(block.timestamp)
        );
    }

    // ── Pipeline Control ────────────────────────────────────────

    /// @notice Halt the pipeline — no snapshots can be minted until resumed
    function haltPipeline(string calldata reason) external onlyOwner {
        pipelineHealthy = false;
        emit PipelineHalted(reason);
    }

    /// @notice Resume the pipeline after errors are resolved
    function resumePipeline() external onlyOwner {
        pipelineHealthy = true;
        emit PipelineResumed();
    }

    // ── Soulbound: Block all transfers ──────────────────────────

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override {
        // Allow minting (from == address(0)), block everything else
        if (from != address(0)) revert Soulbound();
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // ── View Helpers ────────────────────────────────────────────

    /// @notice Get full snapshot data for a token
    function getSnapshot(uint256 tokenId) external view returns (Snapshot memory) {
        return snapshots[tokenId];
    }

    /// @notice Get the latest snapshot CID
    function getLatestCID() external view returns (string memory) {
        return snapshots[latestSnapshot].cid;
    }

    /// @notice Verify a snapshot's integrity by comparing hashes
    function verifySnapshot(uint256 tokenId, bytes32 hash) external view returns (bool) {
        return snapshots[tokenId].encryptedHash == hash;
    }

    /// @notice Walk the full provenance chain from latest back to genesis
    function getProvenanceChain(uint256 maxDepth) external view returns (uint256[] memory) {
        uint256 depth = maxDepth > nextTokenId ? nextTokenId : maxDepth;
        uint256[] memory chain = new uint256[](depth);
        uint256 current = latestSnapshot;
        for (uint256 i = 0; i < depth; i++) {
            chain[i] = current;
            if (snapshots[current].isGenesis) {
                // Trim array
                uint256[] memory trimmed = new uint256[](i + 1);
                for (uint256 j = 0; j <= i; j++) trimmed[j] = chain[j];
                return trimmed;
            }
            current = snapshots[current].parentTokenId;
        }
        return chain;
    }
}
