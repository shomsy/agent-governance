# MILOS Academy – Corporate Training Feature Plan

Status: Draft v1.0  
Date: 2026-02-22  
Owner: MILOS Academy

## 1. Cilj
Pretvoriti MILOS Academy iz "personal learning" alata u **corporate onboarding/training sistem** za CSS i interno usvajanje standarda.

Fokus nije "još jedan LMS", već:
- brže uvođenje novih ljudi u tim
- merenje napretka po timu
- sprovođenje CSS pravila firme kroz praksu

## 2. Principi
- Keep it simple: zadržati lesson-first UX koji već radi.
- Enterprise-ready: dodati samo funkcije koje kompanije realno traže.
- No feature bloat: bez gamification viška i nepotrebnog LMS kompleksa.
- Policy-driven learning: validator/linter da prati pravila konkretne firme.

## 3. Prioriteti (P0 / P1 / P2)

## P0 – Obavezno za prvi corporate pilot
1. Cohorts + Assignments
- Kreiranje grupa (cohort) po timu/odseku.
- Dodela lekcija po rokovima.
- Manager vidi ko je krenuo, ko je završio, ko je blokiran.

2. Manager Dashboard (osnovni)
- Completion rate po lekciji/timu.
- Prosečan broj pokušaja.
- Najčešći CSS konflikti (npr. cascade/specificity greške).
- Vreme do rešenja zadatka.

3. Reporting Export
- CSV/PDF export po korisniku i cohort-u.
- Evidencija: ko je šta završio i kada.

4. SSO (minimal)
- OIDC/SAML login za enterprise okruženja.
- Osnovna role podela: Learner, Manager, Admin.

5. Multi-tenant osnova
- Tenant izolacija podataka (firma A ne vidi firmu B).
- Tenant-level branding (logo, naziv programa).

## P1 – Diferencijacija proizvoda
1. Company Policy Packs (najvažniji differentiator)
- Linter/validator pravila po firmi:
  - zabrana `!important`
  - naming pravila
  - token disciplina
  - allowed/blocked patterns
- Feedback poruke u simple English (edukativno + operativno).

2. Advanced Dashboard
- Trendovi po nedelji/mesecu.
- Skill gap po timu.
- "Top blockers" tabela sa predlogom sledećih lekcija.

3. Assignment Templates
- Standardizovani onboarding setovi:
  - Frontend Intern Pack
  - Design System Pack
  - CSS Debugging Pack

4. SCIM Provisioning (po potrebi)
- Auto-provisioning korisnika iz identity sistema.

## P2 – Skaliranje i enterprise hardening
1. Audit Trail
- Log promena (ko je menjao policy, assignment, role).

2. Compliance-ready izveštaji
- Periodični automatski izveštaji za L&D/HR.

3. API za integracije
- Integracija sa internim HR/LMS alatima.

4. Multi-language UI (sekundarno)
- Lokalizacija za međunarodne timove.

## 4. Šta NE radimo sada
- Global scoring/gamification sistem.
- Veliki certifikacioni engine.
- AI autopilot koji rešava zadatke umesto korisnika.
- Kompleksan "universal LMS" feature set.

## 5. Predlog rollout plana (30-60-90)

## 0-30 dana
- P0.1 Cohorts + Assignments
- P0.2 Manager Dashboard (MVP)
- P0.3 CSV Export
- Tehnički cilj: prvi pilot tenant spreman

## 31-60 dana
- P0.4 SSO (OIDC/SAML)
- P0.5 Multi-tenant osnova
- P1.1 Company Policy Packs (MVP)
- Poslovni cilj: 1-2 pilot kompanije

## 61-90 dana
- P1.2 Advanced Dashboard
- P1.3 Assignment Templates
- P1.4 SCIM (ako pilot traži)
- Poslovni cilj: pilot -> paid annual contract

## 6. KPI-jevi za corporate vrednost
- Time-to-productivity (novi član do prvog samostalnog task-a).
- Completion rate po cohort-u.
- Median attempts to pass (po lekciji).
- Top 5 CSS konflikata po timu.
- Manager adoption (broj aktivnih menadžera nedeljno).
- Renewal indicator: broj timova koji traže proširenje licenci.

## 7. Predlog pakovanja i monetizacije
- Annual per-seat pricing (B2B).
- Minimum seat threshold po ugovoru (npr. 25+).
- Setup/onboarding paket (jednokratno):
  - tenant setup
  - policy pack setup
  - manager training
- Enterprise add-ons:
  - SCIM
  - custom reporting
  - dedicated support SLA

## 8. Rizici i mitigacija
1. Rizik: previše LMS scope-a
- Mitigacija: držati se P0/P1 prioriteta i product discipline.

2. Rizik: slab enterprise adoption bez SSO
- Mitigacija: SSO staviti u prvih 60 dana.

3. Rizik: "nice UI, no business value"
- Mitigacija: dashboard + exports + assignment workflow kao core.

4. Rizik: prekompleksan validator
- Mitigacija: policy packs postepeno, sa jasnim pravilima i testovima.

## 9. Definition of Done (za corporate-ready MVP)
- Cohorts i assignments rade end-to-end.
- Manager dashboard prikazuje ključne metrike bez ručnih koraka.
- CSV/PDF export radi po tenant-u.
- SSO radi za minimum jednog enterprise identity providera.
- Tenant izolacija potvrđena.
- Linter feedback i challenge validacija stabilni u real-time radu.

---

## Kratak zaključak
Pravac je ispravan: **ne širiti LMS**, već graditi **corporate CSS onboarding platformu** sa jakim validator/debug slojem.  
Najveća vrednost: "policy-driven learning" + manager-level vidljivost rezultata.
