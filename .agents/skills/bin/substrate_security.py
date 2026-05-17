#!/usr/bin/env python3
# substrate_security.py — Security Controls for Execution Substrate
#
# Provides reusable security primitives imported by execution-substrate.py:
# 1. NonceRegistry         — Prevents token replay attacks
# 2. RevocationRegistry    — Tracks revoked tokens and delegation-chain revocation
# 3. AuditChain            — Immutable hash chain of execution manifests
# 4. EnvironmentSanitizer  — Cleans environment before subprocess execution
# 5. PathGuard             — Symlink and path traversal protection
# 6. IntegritySeal         — Integrity seals on manifests

import os
import sys
import json
import time
import hashlib
import fnmatch


class NonceRegistry:
    """In-memory and file-backed registry that tracks used nonces to prevent token replay."""

    def __init__(self, target_dir="."):
        self.target_dir = os.path.normpath(target_dir)
        self.registry_path = os.path.join(
            self.target_dir, ".agents/management/evidence/security/nonce-registry.jsonl"
        )
        os.makedirs(os.path.dirname(self.registry_path), exist_ok=True)
        self._nonces = {}  # nonce -> {token_id, registered_at, expires_at}
        self._load()

    def _load(self):
        """Load existing nonces from the file-backed store."""
        if os.path.exists(self.registry_path):
            with open(self.registry_path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    entry = json.loads(line)
                    self._nonces[entry["nonce"]] = {
                        "token_id": entry["token_id"],
                        "registered_at": entry["registered_at"],
                        "expires_at": entry["expires_at"],
                    }

    def _persist(self):
        """Write the full in-memory registry to the JSONL file."""
        with open(self.registry_path, "w", encoding="utf-8") as f:
            for nonce, info in self._nonces.items():
                entry = {
                    "nonce": nonce,
                    "token_id": info["token_id"],
                    "registered_at": info["registered_at"],
                    "expires_at": info["expires_at"],
                }
                f.write(json.dumps(entry) + "\n")

    def register_nonce(self, nonce, token_id, expires_at):
        """Register a nonce with its owning token_id and an absolute expiration timestamp.

        Args:
            nonce: Unique string nonce value.
            token_id: Identifier of the token this nonce belongs to.
            expires_at: Absolute Unix timestamp when the nonce expires.

        Returns:
            True if the nonce was newly registered, False if it already existed.
        """
        if nonce in self._nonces:
            return False
        self._nonces[nonce] = {
            "token_id": token_id,
            "registered_at": time.time(),
            "expires_at": expires_at,
        }
        self._persist()
        return True

    def is_nonce_valid(self, nonce):
        """Return True if the nonce exists and has not yet expired."""
        if nonce not in self._nonces:
            return False
        entry = self._nonces[nonce]
        return time.time() <= entry["expires_at"]

    def cleanup_expired(self):
        """Remove all expired nonces from the registry and persist the result."""
        now = time.time()
        self._nonces = {
            n: info for n, info in self._nonces.items() if info["expires_at"] > now
        }
        self._persist()


class RevocationRegistry:
    """File-backed registry that tracks revoked tokens and propagates revocation through delegation chains."""

    def __init__(self, target_dir="."):
        self.target_dir = os.path.normpath(target_dir)
        self.registry_path = os.path.join(
            self.target_dir, ".agents/management/evidence/security/revocation-registry.jsonl"
        )
        os.makedirs(os.path.dirname(self.registry_path), exist_ok=True)
        self._revoked = {}  # token_id -> {revoked_at, reason, chain_revoked}
        self._load()

    def _load(self):
        """Load existing revocations from the JSONL file."""
        if os.path.exists(self.registry_path):
            with open(self.registry_path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    entry = json.loads(line)
                    self._revoked[entry["token_id"]] = {
                        "revoked_at": entry["revoked_at"],
                        "reason": entry["reason"],
                        "chain_revoked": list(entry.get("chain_revoked", [])),
                    }

    def _persist(self):
        """Write the full in-memory revocation set to the JSONL file."""
        with open(self.registry_path, "w", encoding="utf-8") as f:
            for token_id, info in self._revoked.items():
                entry = {
                    "token_id": token_id,
                    "revoked_at": info["revoked_at"],
                    "reason": info["reason"],
                    "chain_revoked": info["chain_revoked"],
                }
                f.write(json.dumps(entry) + "\n")

    def revoke_token(self, token_id, reason):
        """Revoke a single token.

        Args:
            token_id: The token identifier to revoke.
            reason: Human-readable reason for revocation.

        Returns:
            True if the token was newly revoked, False if already revoked.
        """
        if token_id in self._revoked:
            return False
        self._revoked[token_id] = {
            "revoked_at": time.time(),
            "reason": reason,
            "chain_revoked": [],
        }
        self._persist()
        return True

    def is_revoked(self, token_id):
        """Return True if the token has been revoked."""
        return token_id in self._revoked

    def revoke_chain(self, token_id, authority_lineage):
        """Revoke a token and all of its descendants in the delegation chain.

        Args:
            token_id: The root token to revoke.
            authority_lineage: A list of descendant token_ids that derive from this token.

        Returns:
            A list of all token_ids that were revoked (including the root).
        """
        revoked_ids = []

        # Revoke the root token
        if token_id not in self._revoked:
            self._revoked[token_id] = {
                "revoked_at": time.time(),
                "reason": "chain_revocation",
                "chain_revoked": [],
            }
            revoked_ids.append(token_id)

        # Revoke all descendants
        now = time.time()
        chain_revoked = []
        for child_id in authority_lineage:
            if child_id not in self._revoked:
                self._revoked[child_id] = {
                    "revoked_at": now,
                    "reason": "chain_revocation (parent: {})".format(token_id),
                    "chain_revoked": [],
                }
            chain_revoked.append(child_id)
            revoked_ids.append(child_id)

        # Record the chain on the root entry
        self._revoked[token_id]["chain_revoked"] = chain_revoked
        self._persist()
        return revoked_ids


class AuditChain:
    """Immutable append-only hash chain of execution manifests for tamper-evident auditing."""

    def __init__(self, target_dir="."):
        self.target_dir = os.path.normpath(target_dir)
        self.chain_path = os.path.join(
            self.target_dir, ".agents/management/evidence/security/audit-chain.jsonl"
        )
        os.makedirs(os.path.dirname(self.chain_path), exist_ok=True)
        self._entries = []  # list of dicts in chain order
        self._load()

    def _load(self):
        """Load existing chain entries from the JSONL file."""
        if os.path.exists(self.chain_path):
            with open(self.chain_path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    self._entries.append(json.loads(line))

    def _persist(self):
        """Write the full chain to the JSONL file."""
        with open(self.chain_path, "w", encoding="utf-8") as f:
            for entry in self._entries:
                f.write(json.dumps(entry) + "\n")

    def get_latest_chain_hash(self):
        """Return the head hash of the chain, or None if the chain is empty."""
        if not self._entries:
            return None
        return self._entries[-1]["chain_hash"]

    def append_entry(self, manifest_data):
        """Append a new entry to the hash chain.

        The chain_hash is computed as SHA256(prev_chain_hash + json.dumps(manifest_data)).

        Args:
            manifest_data: Dict of manifest data to hash into the chain.

        Returns:
            The newly created entry dict.
        """
        prev_hash = self.get_latest_chain_hash() or ""
        manifest_json = json.dumps(manifest_data, sort_keys=True)
        chain_hash_input = prev_hash + manifest_json
        chain_hash = hashlib.sha256(chain_hash_input.encode("utf-8")).hexdigest()

        entry_hash = hashlib.sha256(manifest_json.encode("utf-8")).hexdigest()

        entry = {
            "chain_position": len(self._entries),
            "manifest_data": manifest_data,
            "entry_hash": entry_hash,
            "chain_hash": chain_hash,
            "timestamp": time.time(),
        }
        self._entries.append(entry)
        self._persist()
        return entry

    def verify_chain(self):
        """Verify the integrity of the entire hash chain.

        Returns:
            Tuple of (valid: bool, first_broken_index: int or None).
            If valid is True, first_broken_index is None.
        """
        prev_hash = ""
        for idx, entry in enumerate(self._entries):
            manifest_data = entry.get("manifest_data", {})
            manifest_json = json.dumps(manifest_data, sort_keys=True)

            # Verify the entry's own hash
            expected_entry_hash = hashlib.sha256(manifest_json.encode("utf-8")).hexdigest()
            if entry["entry_hash"] != expected_entry_hash:
                return False, idx

            # Verify the chain linkage
            expected_chain_hash = hashlib.sha256(
                (prev_hash + manifest_json).encode("utf-8")
            ).hexdigest()
            if entry["chain_hash"] != expected_chain_hash:
                return False, idx

            prev_hash = entry["chain_hash"]

        return True, None


class EnvironmentSanitizer:
    """Cleans the environment dictionary before subprocess execution.

    Removes sensitive variables matching blocklist patterns and enforces
    a deterministic locale.
    """

    # Patterns that indicate sensitive environment variables
    BLOCKLIST_PATTERNS = [
        "AWS_*",
        "GOOGLE_*",
        "*_SECRET",
        "*_KEY",
        "*_TOKEN",
        "*_PASSWORD",
        "*_CREDENTIAL",
    ]

    # Variables explicitly allowed even if they might match a pattern
    WHITELIST = {"PATH", "HOME", "USER", "LANG", "LC_ALL", "SHELL", "TERM", "TMPDIR"}

    def sanitize_env(self, env_dict):
        """Return a cleaned copy of the environment dictionary.

        Removes variables matching blocklist patterns (unless whitelisted),
        sets LANG=LC_ALL=C.UTF-8 for determinism, and injects
        SUBSTRATE_SANITIZED=true.

        Args:
            env_dict: The source environment dictionary (e.g., os.environ.copy()).

        Returns:
            A new cleaned dictionary.
        """
        cleaned = {}

        for key, value in env_dict.items():
            if key in self.WHITELIST:
                cleaned[key] = value
                continue

            if self._is_blocked(key):
                continue

            cleaned[key] = value

        # Enforce deterministic locale
        cleaned["LANG"] = "C.UTF-8"
        cleaned["LC_ALL"] = "C.UTF-8"

        # Mark that sanitization was applied
        cleaned["SUBSTRATE_SANITIZED"] = "true"

        return cleaned

    def _is_blocked(self, key):
        """Check if a variable name matches any blocklist pattern."""
        for pattern in self.BLOCKLIST_PATTERNS:
            if fnmatch.fnmatch(key, pattern):
                return True
        return False


class PathGuard:
    """Symlink resolution and path traversal protection for subprocess file access."""

    def __init__(self, target_dir="."):
        self.target_dir = os.path.normpath(target_dir)

    def resolve_and_validate(self, path, root_dir):
        """Resolve symlinks and verify the resulting path is under root_dir.

        Args:
            path: The path to validate (may contain symlinks or relative components).
            root_dir: The root directory that the resolved path must stay within.

        Returns:
            The resolved absolute path string.

        Raises:
            ValueError: If the resolved path escapes root_dir.
        """
        resolved = os.path.realpath(path)
        root_resolved = os.path.realpath(root_dir)

        # Ensure the resolved path starts with the root directory
        if not resolved.startswith(root_resolved + os.sep) and resolved != root_resolved:
            raise ValueError(
                "Path traversal detected: '{}' resolves to '{}' "
                "which is outside the allowed root '{}'".format(path, resolved, root_resolved)
            )

        return resolved

    def is_path_safe(self, path, root_dir):
        """Return True if the resolved path is safely within root_dir.

        Args:
            path: The path to check.
            root_dir: The root directory boundary.

        Returns:
            True if the path is safe, False otherwise.
        """
        try:
            self.resolve_and_validate(path, root_dir)
            return True
        except ValueError:
            return False

    def detect_symlinks(self, state_dict):
        """Find symlink creations in a state diff.

        Scans the keys of state_dict (file paths) and identifies any that
        are currently symlinks on disk. Paths are resolved relative to
        target_dir.

        Args:
            state_dict: Dict mapping relative paths to hashes (e.g., from scan_files_state).

        Returns:
            List of paths that are symlinks.
        """
        symlinks = []
        for rel_path in state_dict:
            abs_path = os.path.join(self.target_dir, rel_path)
            if os.path.islink(abs_path):
                symlinks.append(rel_path)
        return symlinks


class IntegritySeal:
    """Creates and verifies SHA-256 integrity seals on manifest dictionaries."""

    @staticmethod
    def seal_manifest(manifest_dict):
        """Add an integrity_seal field to a copy of the manifest.

        The seal is computed over the JSON serialization of the manifest
        *without* the integrity_seal field itself.

        Args:
            manifest_dict: The manifest dictionary to seal.

        Returns:
            A new dict with the 'integrity_seal' field added.
        """
        # Work on a copy without the seal field
        sealable = {k: v for k, v in manifest_dict.items() if k != "integrity_seal"}
        canonical_json = json.dumps(sealable, sort_keys=True)
        seal = hashlib.sha256(canonical_json.encode("utf-8")).hexdigest()

        sealed = dict(manifest_dict)
        sealed["integrity_seal"] = seal
        sealed["sealed_at"] = time.time()
        return sealed

    @staticmethod
    def verify_seal(manifest_dict):
        """Verify that the integrity_seal on a manifest is valid.

        Args:
            manifest_dict: A sealed manifest dict containing 'integrity_seal'.

        Returns:
            True if the seal matches, False otherwise or if no seal is present.
        """
        if "integrity_seal" not in manifest_dict:
            return False

        stored_seal = manifest_dict["integrity_seal"]
        # Re-compute seal without the seal field and without sealed_at
        sealable = {
            k: v
            for k, v in manifest_dict.items()
            if k not in ("integrity_seal", "sealed_at")
        }
        canonical_json = json.dumps(sealable, sort_keys=True)
        computed_seal = hashlib.sha256(canonical_json.encode("utf-8")).hexdigest()

        return computed_seal == stored_seal

    @staticmethod
    def create_seal_timestamp():
        """Return the current Unix timestamp for sealing purposes."""
        return time.time()
