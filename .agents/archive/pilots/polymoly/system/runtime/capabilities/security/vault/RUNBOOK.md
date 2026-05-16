# [HashiCorp Vault](https://www.vaultproject.io/) Init/Unseal/Recovery Runbook

This runbook is for production operators.

```text
     [ YOU ] 
        │ (Secret Key in hand)
        ▼
   [ THE GATE ] (Traefik TLS)
        │
        ▼
╔══════════════════╗ ──> Room open? (API/UI)
║ THE METAL SAFE   ║
╚═══════╦══════════╝
        │
        ▼
[ SECRET BASEMENT ] (vault_data)
```

References:

- <https://developer.hashicorp.com/vault/system/docs/commands/operator/init>
- <https://developer.hashicorp.com/vault/system/docs/commands/operator/unseal>
- <https://developer.hashicorp.com/vault/system/docs/concepts/seal>

## 1) Preconditions

1. Start platform with production overlay:
   `docker compose --project-directory . -f system/adapters/docker/compose.yaml -f system/adapters/docker/compose.prod.yaml up -d vault`
2. Verify Vault API address is set:
   `docker compose exec vault env | grep VAULT_API_ADDR`
3. Verify Vault is sealed:
   `docker compose exec vault vault status`

## 2) First Initialization (one time per storage backend)

1. Run init with shared keys:
   `docker compose exec vault vault operator init -key-shares=5 -key-threshold=3`
2. Store output in secure vault/offline media.
3. Distribute unseal shares to different operators.

Done criteria:

- 5 shares generated, threshold 3.
- Root token escrowed in approved secret store.

**Lemme explain:**
- **Initialization (Buying the Safe):** When you first buy a giant safe, it's locked from the factory and you don't even have the keys yet! Initialization is the very first time you drill the lock and cut 5 physical keys to hand out to your friends.
- **Key Shares & Thresholds:** You give 1 key to 5 different friends. The "Threshold = 3" rule means that at least 3 of those friends must show up together to open the door. If only 1 friend shows up, the door stays locked!

## 3) Unseal Procedure (after restart)

1. Enter unseal key #1:
   `docker compose exec vault vault operator unseal <KEY_1>`
2. Enter unseal key #2:
   `docker compose exec vault vault operator unseal <KEY_2>`
3. Enter unseal key #3:
   `docker compose exec vault vault operator unseal <KEY_3>`
4. Confirm:
   `docker compose exec vault vault status`

Done criteria:

- `Sealed` is `false`.
- UI/API reachable on `https://vault.<domain>`.

**Lemme explain:**
- **Unsealing (Opening for Business):** If the city loses power, the giant safe automatically slams shut and locks itself to protect the gold. When the power comes back, the apps CANNOT get inside. *Unsealing* is the act of calling your 3 friends to come down to the basement, insert their keys, and twist them at the exact same time (like commanders in a nuclear submarine) so the apps can get their passwords again!

## 4) Recovery Checklist

1. Confirm storage mount `vault_data` is attached and readable.
2. Confirm Traefik route `vault.<domain>` resolves correctly.
3. If all unseal shares are lost, execute emergency key rotation/governance process.
4. Record incident timeline, impacted systems, and operator actions.

Done criteria:

- Service restored within target RTO.
- Post-incident notes added to incident tracker.
