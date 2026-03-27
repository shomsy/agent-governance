```md
# Secure, Enterprise-Grade, Production-Ready Node.js + Express Ruleset

Ovaj dokument je skup pravila i standarda za izgradnju bezbednih, skalabilnih i stabilnih Node.js/Express API servisa u production okruženju. Pravila su pisana kao “must/should” standard.

---

## 0) Bazne vrednosti

### MUST
- Aplikacija mora biti bezbedna po default-u, bez “naknadnog krpljenja”.
- Svaka spoljašnja ulazna vrednost je nepoverljiva (request body, query, headers, cookies, JWT claims, webhook payload).
- Najmanja privilegija svuda: DB, tokeni, IAM, mreža, fajl sistem.

### SHOULD
- Preferiraj TypeScript (strogi režim) ili barem strogi ESLint + JSDoc tipovi.
- Jasna granica slojeva: HTTP (transport) ne sme da sadrži poslovnu logiku.

---

## 1) Verzije i dependency higijena

### MUST
- Koristi aktivnu Node.js LTS verziju.
- Lockfile je obavezan (package-lock.json, pnpm-lock.yaml, ili yarn.lock) i mora biti commitovan.
- Zabranjeno je “wildcard” verzionisanje (npr. `*`, `latest`) u produkcionom kodu.
- Redovno pokreći dependency audit (CI) i blokiraj build na kritične ranjivosti, osim ako postoji eksplicitno odobren exception.

### SHOULD
- Uključi Dependabot/Renovate + automatizovane PR-ove.
- Generiši SBOM (npr. CycloneDX) za release.

---

## 2) Struktura projekta i Clean Architecture

### MUST
- HTTP sloj je tanak: routing, validacija, auth guard, mapping DTO ↔ domain, response shaping.
- Poslovna logika ide u application/use-case sloj.
- Infrastruktura (DB, cache, queues, email, third-party API) je iza interfejsa.
- Nema “shared global state” koji preživljava request (osim read-only konfiguracije).

### SHOULD
- Uvedi module boundary: feature-sliced ili vertical-sliced strukturu. Sto je jednako pragmaticnoj DDD arhitekturi.
Zelim da ima DSL imena file-ova i funkcija, intuitivni Fluent API. Lak za ucenje i on boarding.
- Uvedi “composition root” za DI (iako Express nema DI, sastavljanje je obavezno na jednom mestu).
---

## 3) Konfiguracija i tajne

### MUST
- Nema tajni u kodu, git-u, logovima, niti u build artifact-ima.
- Konfiguracija ide kroz environment variables ili secret manager (Vault, AWS/GCP/Azure secrets).
- Validiraj config na startu (schema), fail-fast ako fali obavezan parametar.
- Razdvoji okruženja (dev, staging, prod) bez “if prod then magic”.

### SHOULD
- Rotacija tajni i kratko trajanje tokena gde je moguće.
- Enforce “immutable infrastructure”: isti artifact ide kroz env-ove, menja se samo config.

---

## 4) HTTP server hardening

### MUST
- `helmet` uključen i konfigurisan (CSP gde ima smisla, X-Content-Type-Options, Referrer-Policy, itd).
- CORS je restriktivan: allowlist domena, metoda i header-a. Ne koristi `*` za credentialed requests.
- Rate limiting i brute-force zaštita na login i “skupim” endpoint-ima.
- Body size limiti (JSON, urlencoded), timeouts, i limit concurrency gde je potrebno.
- Trust proxy je eksplicitno podešen ako si iza reverse proxy-ja (inače spoofing IP-a).

### SHOULD
- Implementiraj request timeouts (server i upstream).
- Implementiraj “graceful shutdown” (SIGTERM) i prestanak primanja novih zahteva, pa dovrši aktivne.

---

## 5) Validacija ulaza i output kontrakti

### MUST
- Validiraj svaki ulaz: body, query, params, headers. Odbij nepoznata polja (strip ili error).
- Koristi striktne šeme (Zod, Joi, Yup, Ajv) sa jasnim error formatom.
- Ne veruj JWT claim-ovima bez server-side provere (role/permissions i resursni scope).
- Response mora da prati stabilan ugovor: status kodovi, error shape, pagination.

### SHOULD
- OpenAPI spec (swagger) kao izvor istine.
- Koristi idempotency key za kritične operacije (npr. naplata, kreiranje narudžbine).

---

## 6) AuthN i AuthZ

### MUST
- AuthZ je obavezan po resursu, ne samo po endpoint-u.
- Password storage: samo argon2 ili bcrypt sa modernim parametrima. Nikad plain ili sha1/sha256.
- Session cookies: `HttpOnly`, `Secure`, `SameSite` adekvatno, kratki TTL, rotacija session ID-a posle login-a.
- JWT: kratki access tokeni, refresh tokeni sa rotacijom, revoke mehanizam (ili token versioning).
- MFA gde ima smisla (admin, visoko rizične akcije).

### SHOULD
- Centralizuj permission sistem (RBAC/ABAC) i testiraj ga.
- Audit log za security relevantne događaje (login, failed login, permission denied, password change, token refresh).

---

## 7) Zaštita od uobičajenih napada

### MUST
- SQL/NoSQL injection: samo parametrizovani upiti, nikad string konkatenacija.
- XSS: nikad ne renderuj neprovereni HTML; ako ima templating, sanitizuj.
- CSRF: ako koristiš cookies za auth, CSRF zaštita je obavezna za state-changing rute.
- SSRF: stroga allowlist za outbound HTTP pozive, blokiraj interne IP range-ove, validiraj URL.
- File upload: limit veličine, MIME verifikacija, skladištenje van web root-a, random file name, skeniranje ako je potrebno.

### SHOULD
- Uvedi “security headers” i CSP posebno za aplikacije koje renderuju UI.
- Webhooks: verifikuj signature i replay zaštita (timestamp + nonce).

---

## 8) Error handling, logging, observability

### MUST
- Centralni error middleware sa:
  - mapiranjem grešaka na HTTP kodove
  - standardizovanim error response formatom
  - bez curenja stack trace-a u prod-u
- Structured logging (JSON), sa requestId/correlationId u svakom logu.
- Nikad ne loguj: lozinke, tokene, kompletan card data, secrets, ili nepotrebni PII.

### SHOULD
- Metrics (Prometheus) i tracing (OpenTelemetry) za kritične servise.
- Health endpoints:
  - liveness (proces živ)
  - readiness (spremno, DB/cache connectivity)
- Alerting na: error rate, latency, saturation, DB pool exhaustion, queue lag.

---

## 9) Performanse i stabilnost

### MUST
- DB konekcioni pool konfigurisan, bez “connect per request”.
- Cache koristiš namerno: TTL, invalidacija, i zaštita od stampede-a.
- Ograniči skupe operacije: pagination obavezna, streaming za velike rezultate, limit export-a.
- Timeouts za sve outbound pozive, plus retry sa backoff-om samo gde je bezbedno.

### SHOULD
- Circuit breaker za nestabilne dependency-je.
- Backpressure: queue za heavy jobs, a ne da HTTP request radi sve.

---

## 10) Bezbednost podataka i privatnost

### MUST
- Enkripcija u tranzitu (TLS) svuda, uključujući unutrašnje servise ako je moguće.
- Enkripcija u mirovanju za baze i storage (kada platforma podržava).
- Data minimization: čuvaj samo ono što ti stvarno treba.
- Definiši retention politike i brisanje podataka.

### SHOULD
- Klasifikuj podatke (public, internal, confidential, restricted) i primeni pravila po nivou.
- Pseudonimizacija ili tokenizacija za osetljive identifikatore.

---

## 11) Testovi i kvalitet

### MUST
- Unit testovi za use-case sloj i permission logiku.
- Integration testovi za DB i kritične rute.
- Static checks u CI: lint, typecheck, tests, dependency audit.

### SHOULD
- Contract testovi (OpenAPI) i snapshot testovi za error shape.
- Load test pre release-a za kritične endpointe.

---

## 12) CI/CD, deploy, runtime

### MUST
- Deploy je ponovljiv i determinističan.
- Kontejner ili proces manager mora imati restart policy.
- Graceful shutdown obavezan (SIGTERM) i “drain” konekcija.
- Migracije baze su kontrolisane i logovane, sa rollback strategijom (ili jasno definisanom “forward-only” strategijom).

### SHOULD
- Blue/green ili canary release za rizične promene.
- Feature flags za kontrolu rollout-a.

---

## 13) Minimalni “security checklist” po ruti

Za svaku novu rutu, pre merge-a proveri:

- [ ] AuthN: da li je ruta autentifikovana gde treba?
- [ ] AuthZ: da li proveravaš pravo nad resursom?
- [ ] Validacija ulaza: body/query/params/headers
- [ ] Rate limit: da li je potrebna zaštita?
- [ ] Output: da li response shape i status kodovi imaju smisla?
- [ ] Error handling: da li greške cure u prod?
- [ ] Logging: requestId, bez tajni i PII
- [ ] Test: bar jedan unit ili integration test za kritičnu logiku

---

## 14) Zabranjene prakse

- Hardkodovani secret-i, tokeni, privatni ključevi.
- “Debug” endpoint-i u prod-u.
- `eval`, dinamički require iz user input-a, ili izvršavanje shell komandi sa user input-om.
- Direktan pristup ORM/DB iz controller-a.
- Neograničeno listanje resursa bez paginacije i limita.

---

## 15) Preporučeni osnovni stack (primer)

- Express + helmet + rate limiter
- Zod/Joi/Ajv za validaciju
- pino ili winston za structured logging
- OpenTelemetry za tracing (po potrebi)
- Prisma/TypeORM/Knex (uz parametrizaciju) ili native driver sa prepared statements
- Redis za cache/lock/queue (ili namenski queue sistem)
- Jest/Vitest + supertest za testiranje

---

## 16) “Definition of Done” za production

Feature se smatra gotovim tek kada:

- [ ] Validacija i auth/authz su pokriveni
- [ ] Testovi prolaze i pokrivaju ključne scenarije
- [ ] Observability postoji (logovi, osnovne metrike, health)
- [ ] Dependency audit čist ili postoji dokumentovan exception
- [ ] Dokumentovan API ugovor (OpenAPI ili ekvivalent)
- [ ] Nema curenja osetljivih informacija u response ili logovima

---
```
