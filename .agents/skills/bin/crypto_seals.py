#!/usr/bin/env python3
# crypto_seals.py — V1.0.0 HMAC-Based Integrity Seals for Execution Substrate
#
# Gap 2: Replace unkeyed SHA-256 with keyed HMAC signatures.
#
# Provides keyed cryptographic integrity seals for manifests and audit chains:
# 1. HMACKeyManager    — Manages HMAC-SHA256 secret keys (generate / load / save)
# 2. HMACSeal          — HMAC-SHA256 integrity seals on manifest dictionaries
# 3. HMACAuditChain    — HMAC-protected append-only audit chain
# 4. AsymmetricSeal    — Optional ed25519 signatures with HMAC fallback
# 5. SealMigration     — Migrate old SHA-256 seals to HMAC seals
#
# CLI:
#   python3 crypto_seals.py key generate
#   python3 crypto_seals.py key show
#   python3 crypto_seals.py seal <manifest_path>
#   python3 crypto_seals.py verify <manifest_path>
#   python3 crypto_seals.py migrate
#   python3 crypto_seals.py status

import os
import sys
import json
import time
import hmac
import hashlib
import secrets
import stat
import warnings

# ---------------------------------------------------------------------------
# Default paths
# ---------------------------------------------------------------------------

DEFAULT_KEY_PATH = ".agents/management/evidence/security/hmac-key.bin"
DEFAULT_AUDIT_CHAIN_PATH = ".agents/management/evidence/security/hmac-audit-chain.jsonl"
DEFAULT_TARGET_DIR = "."


# ---------------------------------------------------------------------------
# 1. HMACKeyManager
# ---------------------------------------------------------------------------

class HMACKeyManager:
    """Manages HMAC-SHA256 secret keys for integrity seals.

    Keys are 256-bit (32-byte) random values generated via
    ``secrets.token_bytes(32)`` and stored on disk with mode 0o600.
    """

    def __init__(self, key_path=None, target_dir=DEFAULT_TARGET_DIR):
        self.target_dir = os.path.normpath(target_dir)
        if key_path is None:
            key_path = DEFAULT_KEY_PATH
        # Resolve relative paths against target_dir
        if not os.path.isabs(key_path):
            key_path = os.path.join(self.target_dir, key_path)
        self.key_path = key_path
        self._key = None

    def generate_key(self):
        """Generate a random 256-bit key and return it as bytes."""
        return secrets.token_bytes(32)

    def load_key(self, path=None):
        """Load a key from a file.

        Args:
            path: Optional file path override. Defaults to the instance key_path.

        Returns:
            The key as raw bytes.

        Raises:
            FileNotFoundError: If the key file does not exist.
        """
        load_path = path or self.key_path
        if not os.path.isabs(load_path):
            load_path = os.path.join(self.target_dir, load_path)

        if not os.path.exists(load_path):
            raise FileNotFoundError(
                f"HMAC key file not found: {load_path}. "
                "Generate a key first with: python3 crypto_seals.py key generate"
            )

        with open(load_path, "rb") as f:
            self._key = f.read()
        return self._key

    def save_key(self, key, path=None):
        """Save a key to a file with restricted permissions (0o600).

        Args:
            key: The key as bytes.
            path: Optional file path override.

        Returns:
            The path the key was saved to.
        """
        save_path = path or self.key_path
        if not os.path.isabs(save_path):
            save_path = os.path.join(self.target_dir, save_path)

        os.makedirs(os.path.dirname(save_path), exist_ok=True)

        # Create with restrictive permissions using low-level os.open
        fd = os.open(save_path, os.O_CREAT | os.O_WRONLY | os.O_TRUNC, 0o600)
        try:
            os.write(fd, key)
        finally:
            os.close(fd)

        # Double-check permissions (umask may have interfered)
        os.chmod(save_path, stat.S_IRUSR | stat.S_IWUSR)

        self._key = key
        return save_path

    def get_key(self):
        """Return the current key, loading or generating one as needed.

        Returns:
            The key as bytes.
        """
        if self._key is not None:
            return self._key

        if os.path.exists(self.key_path):
            return self.load_key()

        # No key exists — generate and persist one
        new_key = self.generate_key()
        self.save_key(new_key)
        self._key = new_key
        return self._key


# ---------------------------------------------------------------------------
# 2. HMACSeal
# ---------------------------------------------------------------------------

class HMACSeal:
    """HMAC-SHA256 integrity seals for manifest dictionaries.

    Unlike the old unkeyed SHA-256 seals, HMAC seals require knowledge
    of the secret key to create or forge a valid seal.
    """

    def __init__(self, key_manager=None, target_dir=DEFAULT_TARGET_DIR):
        self.target_dir = os.path.normpath(target_dir)
        self.key_manager = key_manager or HMACKeyManager(target_dir=target_dir)

    def _get_key(self, key=None):
        """Resolve the key to use (explicit argument or key manager)."""
        if key is not None:
            return key
        return self.key_manager.get_key()

    @staticmethod
    def _canonical_json(manifest_dict):
        """Produce canonical JSON (sorted keys) excluding seal metadata fields."""
        sealable = {
            k: v
            for k, v in manifest_dict.items()
            if k not in ("integrity_seal", "hmac_seal", "sealed_at", "seal_algorithm", "key_id")
        }
        return json.dumps(sealable, sort_keys=True, separators=(",", ":"))

    def seal_manifest(self, manifest_dict, key=None):
        """Create an HMAC-SHA256 seal over a manifest dictionary.

        Args:
            manifest_dict: The manifest to seal.
            key: Optional key bytes override.

        Returns:
            The hex-encoded HMAC-SHA256 digest string.
        """
        actual_key = self._get_key(key)
        msg = self._canonical_json(manifest_dict).encode("utf-8")
        return hmac.new(actual_key, msg, hashlib.sha256).hexdigest()

    def verify_seal(self, manifest_dict, key=None):
        """Verify an HMAC seal on a manifest dictionary.

        Checks both ``hmac_seal`` (new) and ``integrity_seal`` (legacy) fields.

        Args:
            manifest_dict: The sealed manifest dictionary.
            key: Optional key bytes override.

        Returns:
            True if the seal is valid, False otherwise.
        """
        actual_key = self._get_key(key)

        # Prefer the newer hmac_seal field; fall back to integrity_seal
        stored_seal = manifest_dict.get("hmac_seal") or manifest_dict.get("integrity_seal")
        if stored_seal is None:
            return False

        computed_seal = self.seal_manifest(manifest_dict, key=actual_key)
        return hmac.compare_digest(computed_seal, stored_seal)

    def create_seal_entry(self, manifest_dict, key=None):
        """Return a copy of the manifest with seal metadata added.

        Args:
            manifest_dict: The manifest to seal.
            key: Optional key bytes override.

        Returns:
            A new dict with hmac_seal, key_id, sealed_at, and seal_algorithm fields.
        """
        actual_key = self._get_key(key)
        seal = self.seal_manifest(manifest_dict, key=actual_key)

        # Derive a short key_id from the key for identification
        key_id = hashlib.sha256(actual_key).hexdigest()[:12]

        sealed = dict(manifest_dict)
        sealed["hmac_seal"] = seal
        sealed["key_id"] = key_id
        sealed["sealed_at"] = time.time()
        sealed["seal_algorithm"] = "HMAC-SHA256"
        return sealed


# ---------------------------------------------------------------------------
# 3. HMACAuditChain
# ---------------------------------------------------------------------------

class HMACAuditChain:
    """HMAC-protected append-only audit chain of execution manifests.

    Each entry includes:
      - chain_hash: HMAC-SHA256(prev_chain_hash + canonical_json(manifest))
      - entry_hash: HMAC-SHA256(canonical_json(manifest))

    This prevents both tampering with individual entries and
    reordering / deletion of chain entries.
    """

    def __init__(self, key_manager=None, chain_path=None, target_dir=DEFAULT_TARGET_DIR):
        self.target_dir = os.path.normpath(target_dir)
        self.key_manager = key_manager or HMACKeyManager(target_dir=target_dir)

        if chain_path is None:
            chain_path = DEFAULT_AUDIT_CHAIN_PATH
        if not os.path.isabs(chain_path):
            chain_path = os.path.join(self.target_dir, chain_path)
        self.chain_path = chain_path

        self._entries = []
        self._load()

    def _get_key(self, key=None):
        if key is not None:
            return key
        return self.key_manager.get_key()

    def _load(self):
        """Load chain entries from the JSONL file."""
        if os.path.exists(self.chain_path):
            with open(self.chain_path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    self._entries.append(json.loads(line))

    def _persist(self):
        """Write the full chain to the JSONL file."""
        os.makedirs(os.path.dirname(self.chain_path), exist_ok=True)
        with open(self.chain_path, "w", encoding="utf-8") as f:
            for entry in self._entries:
                f.write(json.dumps(entry) + "\n")

    def get_latest_chain_hash(self):
        """Return the head hash of the chain, or None if empty."""
        if not self._entries:
            return None
        return self._entries[-1]["chain_hash"]

    def append_entry(self, manifest_data, key=None):
        """Append a new HMAC-protected entry to the audit chain.

        Args:
            manifest_data: Dict of manifest data to hash into the chain.
            key: Optional key bytes override.

        Returns:
            The newly created entry dict.
        """
        actual_key = self._get_key(key)
        prev_hash = self.get_latest_chain_hash() or ""
        canonical = json.dumps(manifest_data, sort_keys=True, separators=(",", ":"))

        # Chain hash links to the previous entry
        chain_hmac_input = (prev_hash + canonical).encode("utf-8")
        chain_hash = hmac.new(actual_key, chain_hmac_input, hashlib.sha256).hexdigest()

        # Entry hash protects the manifest data itself
        entry_hash = hmac.new(actual_key, canonical.encode("utf-8"), hashlib.sha256).hexdigest()

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

    def verify_chain(self, key=None):
        """Verify the integrity of the entire HMAC chain.

        Args:
            key: Optional key bytes override.

        Returns:
            Tuple of (valid: bool, first_broken_index: int or None).
        """
        actual_key = self._get_key(key)
        prev_hash = ""

        for idx, entry in enumerate(self._entries):
            manifest_data = entry.get("manifest_data", {})
            canonical = json.dumps(manifest_data, sort_keys=True, separators=(",", ":"))

            # Verify entry hash
            expected_entry_hash = hmac.new(
                actual_key, canonical.encode("utf-8"), hashlib.sha256
            ).hexdigest()
            if entry.get("entry_hash") != expected_entry_hash:
                return False, idx

            # Verify chain linkage
            expected_chain_hash = hmac.new(
                actual_key, (prev_hash + canonical).encode("utf-8"), hashlib.sha256
            ).hexdigest()
            if entry.get("chain_hash") != expected_chain_hash:
                return False, idx

            prev_hash = entry["chain_hash"]

        return True, None

    def __len__(self):
        return len(self._entries)


# ---------------------------------------------------------------------------
# 4. AsymmetricSeal (optional ed25519 with HMAC fallback)
# ---------------------------------------------------------------------------

class AsymmetricSeal:
    """Optional ed25519-style signatures with HMAC-SHA256 fallback.

    When the ``cryptography`` library is available, this class uses
    Ed25519 key pairs for signing and verification. Otherwise all
    operations fall back to HMAC-SHA256 with a clear warning.
    """

    def __init__(self, key_manager=None, target_dir=DEFAULT_TARGET_DIR):
        self.target_dir = os.path.normpath(target_dir)
        self.key_manager = key_manager or HMACKeyManager(target_dir=target_dir)
        self._crypto_available = self._check_crypto()

    @staticmethod
    def _check_crypto():
        """Check if the cryptography library is available."""
        try:
            from cryptography.hazmat.primitives.asymmetric.ed25519 import (
                Ed25519PrivateKey,
                Ed25519PublicKey,
            )
            from cryptography.hazmat.primitives.serialization import (
                Encoding,
                PrivateFormat,
                PublicFormat,
                NoEncryption,
            )
            return True
        except ImportError:
            return False

    def is_asymmetric_available(self):
        """Return True if the cryptography library is available."""
        return self._crypto_available

    def _canonical_json(self, manifest_dict):
        sealable = {
            k: v
            for k, v in manifest_dict.items()
            if k not in ("asymmetric_seal", "hmac_seal", "integrity_seal",
                         "sealed_at", "seal_algorithm", "key_id")
        }
        return json.dumps(sealable, sort_keys=True, separators=(",", ":"))

    def seal_manifest(self, manifest_dict, private_key=None, key=None):
        """Sign a manifest with ed25519, falling back to HMAC-SHA256.

        Args:
            manifest_dict: The manifest to seal.
            private_key: Optional Ed25519 private key bytes (only when crypto available).
            key: Optional HMAC key bytes override (used for fallback).

        Returns:
            Hex-encoded signature (ed25519 or HMAC).
        """
        msg = self._canonical_json(manifest_dict).encode("utf-8")

        if self._crypto_available and private_key is not None:
            from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PrivateKey
            signing_key = Ed25519PrivateKey.from_private_bytes(private_key)
            signature = signing_key.sign(msg)
            return signature.hex()

        # Fallback to HMAC
        if not self._crypto_available:
            warnings.warn(
                "AsymmetricSeal: cryptography library not available, "
                "falling back to HMAC-SHA256. Install 'cryptography' for ed25519 support.",
                RuntimeWarning,
                stacklevel=2,
            )
        actual_key = self.key_manager.get_key() if key is None else key
        return hmac.new(actual_key, msg, hashlib.sha256).hexdigest()

    def verify_seal(self, manifest_dict, signature, public_key=None, key=None):
        """Verify an asymmetric seal, falling back to HMAC.

        Args:
            manifest_dict: The sealed manifest dictionary.
            signature: Hex-encoded signature to verify.
            public_key: Optional Ed25519 public key bytes.
            key: Optional HMAC key bytes override.

        Returns:
            True if the signature is valid, False otherwise.
        """
        msg = self._canonical_json(manifest_dict).encode("utf-8")
        sig_bytes = bytes.fromhex(signature)

        if self._crypto_available and public_key is not None:
            from cryptography.hazmat.primitives.asymmetric.ed25519 import Ed25519PublicKey
            try:
                verify_key = Ed25519PublicKey.from_public_bytes(public_key)
                verify_key.verify(sig_bytes, msg)
                return True
            except Exception:
                return False

        # Fallback to HMAC
        actual_key = self.key_manager.get_key() if key is None else key
        expected = hmac.new(actual_key, msg, hashlib.sha256).hexdigest()
        return hmac.compare_digest(expected, signature)


# ---------------------------------------------------------------------------
# 5. SealMigration
# ---------------------------------------------------------------------------

class SealMigration:
    """Migrate old unkeyed SHA-256 seals to HMAC-SHA256 seals.

    Scans for execution manifest JSON files, removes the old
    ``integrity_seal`` field, and re-seals with HMAC.
    """

    def __init__(self, key_manager=None, target_dir=DEFAULT_TARGET_DIR):
        self.target_dir = os.path.normpath(target_dir)
        self.key_manager = key_manager or HMACKeyManager(target_dir=target_dir)
        self.hmac_seal = HMACSeal(key_manager=self.key_manager, target_dir=target_dir)

    def _find_manifests(self, target_dir=None):
        """Find all execution manifest JSON files."""
        td = target_dir or self.target_dir
        manifests = []

        # Common manifest locations
        search_dirs = [
            os.path.join(td, ".agents/management/evidence/execution"),
            os.path.join(td, ".agents/management/evidence/generated"),
            os.path.join(td, "EVIDENCE/execution"),
        ]

        for search_dir in search_dirs:
            if not os.path.isdir(search_dir):
                continue
            for fname in os.listdir(search_dir):
                if fname.endswith(".json"):
                    manifests.append(os.path.join(search_dir, fname))

        return manifests

    def _is_sealed(self, manifest_data):
        """Check if a manifest has any kind of seal."""
        return bool(
            manifest_data.get("hmac_seal")
            or manifest_data.get("integrity_seal")
        )

    def _is_hmac_sealed(self, manifest_data):
        """Check if a manifest has an HMAC seal specifically."""
        return (
            "hmac_seal" in manifest_data
            and manifest_data.get("seal_algorithm") == "HMAC-SHA256"
        )

    def migrate_old_manifests(self, target_dir=None):
        """Scan execution manifests and re-seal with HMAC.

        Args:
            target_dir: Root directory to search for manifests.

        Returns:
            Dict with keys: migrated, already_hmac, skipped, errors, paths.
        """
        manifests = self._find_manifests(target_dir)
        result = {
            "migrated": 0,
            "already_hmac": 0,
            "skipped": 0,
            "errors": 0,
            "paths": [],
        }

        for manifest_path in manifests:
            try:
                with open(manifest_path, "r", encoding="utf-8") as f:
                    data = json.load(f)

                if not isinstance(data, dict):
                    result["skipped"] += 1
                    result["paths"].append((manifest_path, "not_a_dict"))
                    continue

                if self._is_hmac_sealed(data):
                    result["already_hmac"] += 1
                    result["paths"].append((manifest_path, "already_hmac"))
                    continue

                if not self._is_sealed(data):
                    result["skipped"] += 1
                    result["paths"].append((manifest_path, "not_sealed"))
                    continue

                # Remove old seal fields
                for old_field in ("integrity_seal", "sealed_at", "seal_algorithm"):
                    data.pop(old_field, None)

                # Re-seal with HMAC
                sealed = self.hmac_seal.create_seal_entry(data)

                with open(manifest_path, "w", encoding="utf-8") as f:
                    json.dump(sealed, f, indent=2)

                result["migrated"] += 1
                result["paths"].append((manifest_path, "migrated"))

            except (json.JSONDecodeError, IOError, OSError) as exc:
                result["errors"] += 1
                result["paths"].append((manifest_path, f"error: {exc}"))

        return result

    def verify_migration(self, target_dir=None):
        """Verify all manifests have valid HMAC seals.

        Args:
            target_dir: Root directory to search for manifests.

        Returns:
            Dict with keys: valid, invalid, total.
        """
        manifests = self._find_manifests(target_dir)
        result = {"valid": 0, "invalid": 0, "total": 0}

        for manifest_path in manifests:
            result["total"] += 1
            try:
                with open(manifest_path, "r", encoding="utf-8") as f:
                    data = json.load(f)

                if not isinstance(data, dict):
                    result["invalid"] += 1
                    continue

                if self.hmac_seal.verify_seal(data):
                    result["valid"] += 1
                else:
                    result["invalid"] += 1

            except (json.JSONDecodeError, IOError, OSError):
                result["invalid"] += 1

        return result

    def report_migration_status(self, target_dir=None):
        """Report migration status for all manifests.

        Args:
            target_dir: Root directory to search for manifests.

        Returns:
            A formatted status string.
        """
        migration_result = self.migrate_old_manifests(target_dir)
        verify_result = self.verify_migration(target_dir)

        lines = [
            "=== HMAC Seal Migration Report ===",
            f"  Manifests found:      {verify_result['total']}",
            f"  Already HMAC-sealed:  {migration_result['already_hmac']}",
            f"  Migrated this run:    {migration_result['migrated']}",
            f"  Not sealed (skipped): {migration_result['skipped']}",
            f"  Errors:               {migration_result['errors']}",
            "---",
            f"  Valid HMAC seals:     {verify_result['valid']}",
            f"  Invalid seals:        {verify_result['invalid']}",
            "=== End Report ===",
        ]

        if migration_result["paths"]:
            lines.append("\nDetails:")
            for path, status in migration_result["paths"]:
                lines.append(f"  [{status}] {path}")

        return "\n".join(lines)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def _cli_key_generate():
    """CLI: Generate a new HMAC key."""
    mgr = HMACKeyManager()
    key = mgr.generate_key()
    saved_path = mgr.save_key(key)
    key_id = hashlib.sha256(key).hexdigest()[:12]
    print(f"Generated new HMAC-SHA256 key ({len(key)} bytes)")
    print(f"Saved to: {saved_path}")
    print(f"Key ID:   {key_id}")
    return 0


def _cli_key_show():
    """CLI: Show the current key ID (never the key itself)."""
    mgr = HMACKeyManager()
    try:
        key = mgr.get_key()
        key_id = hashlib.sha256(key).hexdigest()[:12]
        print(f"Key file: {mgr.key_path}")
        print(f"Key ID:   {key_id}")
        print(f"Key size: {len(key)} bytes ({len(key) * 8} bits)")
        return 0
    except FileNotFoundError as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1


def _cli_seal(manifest_path):
    """CLI: Seal a manifest file with HMAC."""
    if not os.path.exists(manifest_path):
        print(f"Error: manifest not found: {manifest_path}", file=sys.stderr)
        return 1

    with open(manifest_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    seal_obj = HMACSeal()
    sealed = seal_obj.create_seal_entry(data)

    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(sealed, f, indent=2)

    print(f"Sealed manifest: {manifest_path}")
    print(f"HMAC seal: {sealed['hmac_seal']}")
    print(f"Key ID:    {sealed['key_id']}")
    return 0


def _cli_verify(manifest_path):
    """CLI: Verify an HMAC seal on a manifest file."""
    if not os.path.exists(manifest_path):
        print(f"Error: manifest not found: {manifest_path}", file=sys.stderr)
        return 1

    with open(manifest_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    seal_obj = HMACSeal()
    valid = seal_obj.verify_seal(data)

    if valid:
        print(f"VALID:   {manifest_path}")
        return 0
    else:
        print(f"INVALID: {manifest_path}")
        return 1


def _cli_migrate():
    """CLI: Migrate all manifests to HMAC seals."""
    migration = SealMigration()
    report = migration.report_migration_status()
    print(report)
    return 0


def _cli_status():
    """CLI: Show overall HMAC seal status."""
    mgr = HMACKeyManager()
    key_exists = os.path.exists(mgr.key_path)

    lines = [
        "=== HMAC Seal Status ===",
        f"Key file exists: {key_exists}",
    ]

    if key_exists:
        key = mgr.get_key()
        key_id = hashlib.sha256(key).hexdigest()[:12]
        lines.append(f"Key ID:          {key_id}")

    # Check audit chain
    chain_path = os.path.join(mgr.target_dir, DEFAULT_AUDIT_CHAIN_PATH) if not os.path.isabs(DEFAULT_AUDIT_CHAIN_PATH) else DEFAULT_AUDIT_CHAIN_PATH
    chain_exists = os.path.exists(chain_path)
    chain_entries = 0
    if chain_exists:
        with open(chain_path, "r", encoding="utf-8") as f:
            chain_entries = sum(1 for line in f if line.strip())
    lines.append(f"HMAC audit chain: {'exists' if chain_exists else 'not created'}")
    if chain_exists:
        lines.append(f"  Entries:         {chain_entries}")

    # Check manifests
    migration = SealMigration()
    verify = migration.verify_migration()
    lines.append(f"Manifests:         {verify['total']} found")
    lines.append(f"  Valid HMAC:      {verify['valid']}")
    lines.append(f"  Invalid:         {verify['invalid']}")

    # Check asymmetric availability
    asym = AsymmetricSeal()
    lines.append(f"Asymmetric (ed25519): {'available' if asym.is_asymmetric_available() else 'not available (HMAC fallback)'}")

    lines.append("=== End Status ===")
    print("\n".join(lines))
    return 0


def main():
    """CLI entry point."""
    if len(sys.argv) < 2:
        print("Usage: python3 crypto_seals.py <command> [args]")
        print()
        print("Commands:")
        print("  key generate          Generate a new HMAC-SHA256 key")
        print("  key show              Show the current key ID")
        print("  seal <manifest_path>  Seal a manifest with HMAC")
        print("  verify <manifest_path> Verify an HMAC seal")
        print("  migrate               Migrate all manifests to HMAC seals")
        print("  status                Show overall HMAC seal status")
        return 1

    command = sys.argv[1]

    if command == "key":
        if len(sys.argv) < 3:
            print("Usage: python3 crypto_seals.py key <generate|show>", file=sys.stderr)
            return 1
        subcommand = sys.argv[2]
        if subcommand == "generate":
            return _cli_key_generate()
        elif subcommand == "show":
            return _cli_key_show()
        else:
            print(f"Unknown key subcommand: {subcommand}", file=sys.stderr)
            return 1

    elif command == "seal":
        if len(sys.argv) < 3:
            print("Usage: python3 crypto_seals.py seal <manifest_path>", file=sys.stderr)
            return 1
        return _cli_seal(sys.argv[2])

    elif command == "verify":
        if len(sys.argv) < 3:
            print("Usage: python3 crypto_seals.py verify <manifest_path>", file=sys.stderr)
            return 1
        return _cli_verify(sys.argv[2])

    elif command == "migrate":
        return _cli_migrate()

    elif command == "status":
        return _cli_status()

    else:
        print(f"Unknown command: {command}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
