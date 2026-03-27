# HotelSync Engineering Interview Task

Zdravo,

Pošto je ova pozicija fokusirana na API integracije između različitih sistema, pripremili smo tehnički zadatak koji simulira tipične situacije sa kojima se susrećemo u svakodnevnom radu.

Cilj ovog zadatka nije da proverimo koliko brzo možeš napisati kod, već da vidimo:

- kako razmišljaš o integracijama između sistema
- kako pristupaš mapiranju podataka
- kako rešavaš edge-case scenarije
- kako organizuješ integracionu logiku i strukturu koda

Drugim rečima - ovo je mini simulacija realnog posla.

## Napomena o AI alatima

Svesni smo da su danas alati poput ChatGPT, Claude ili Copilot normalan deo developerskog workflow-a. Nemamo problem sa tim da ih koristiš.

Zbog toga je zadatak malo obimniji i uključuje više komponenti koje zahtevaju logiku i razumevanje integracija, a ne samo pisanje koda. U praksi, većina integracionih projekata izgleda vrlo slično ovome.

Drugim rečima - deo koda AI može pomoći da napiše, ali strukturu, odluke i logiku sistema moraš osmisliti sam.

## Važna napomena

Ne očekujemo savršeno niti potpuno production-ready rešenje.

Slobodno se fokusiraj na delove zadatka koje smatraš ključnim za jednu stabilnu integraciju. Ako proceniš da bi implementacija celog zadatka zahtevala više vremena nego što trenutno možeš da izdvojiš, potpuno je u redu da implementiraš samo najvažnije komponente.

Za sve delove koje nisi stigao da implementiraš, zamolićemo te da u README fajlu detaljno opišeš kako bi ih dizajnirao i implementirao u realnom sistemu.

Na taj način možemo razumeti kako razmišljaš o problemu, čak i ako nisi imao vremena da napišeš sav kod.

Mnogo nam je važnije da vidimo način razmišljanja i strukturu rešenja nego količinu napisanog koda.

Rok za slanje rešenja je: 15.03.2026

Rešenje možeš poslati kao:

- GitHub repo
- ili ZIP arhivu sa kodom
- uz kratko uputstvo kako pokrenuti projekat

U nastavku ovog maila nalazi se tehnički zadatak.

Hvala na vremenu i trudu.

Pozdrav,  
HotelSync Engineering Team

## Zadatak

### Tehnologije i ograničenja

Zadatak mora biti urađen koristeći:

- PHP (proceduralni pristup)
- MySQL
- `mysqli` konekciju (`PDO` nije dozvoljen)

Nije dozvoljeno koristiti:

- Laravel
- Symfony
- CodeIgniter
- bilo koji framework koji apstrahuje HTTP ili database layer

Dozvoljeno je koristiti:

- `cURL`
- `mysqli`
- minimalne utility biblioteke ako imaju smisla

### API dokumentacija

Za sve operacije koristi se HotelSync API:

- https://documenter.getpostman.com/view/41568417/2sAYX5MNgD

Testni token je:

- `775580f2b13be0215b5aee08a17c7aa892ece321`

Testni objekat mozete kreirati putem:

- https://app.otasync.me/register

U dokumentaciji ćeš pronaći:

- autentikaciju
- sobe
- rate planove
- rezervacije
- strukturu payload-a

### Scenario

Potrebno je napraviti mali integracioni servis između:

- HotelSync API-ja
- i eksternog sistema koji ćemo nazvati BridgeOne

BridgeOne koristi lokalnu bazu za mapiranja i evidenciju rezervacija.

Integracija treba da:

- uradi autentikaciju prema HotelSync API-ju
- preuzme sobe
- preuzme rate planove
- mapira ih u lokalnu bazu
- preuzme rezervacije
- mapira rezervacije u lokalni model
- obradi izmene rezervacija
- obradi otkazivanje rezervacija
- generiše račun za rezervaciju
- obradi webhook događaje

## Task 1 - Authentication i Catalog Sync

Napraviti CLI skriptu:

```bash
php sync_catalog.php
```

Skripta treba da:

- uradi login prema HotelSync API-ju
- preuzme sve sobe
- preuzme sve rate planove
- upiše ih u lokalnu bazu
- ažurira postojeće zapise ako su promenjeni

Za svaku sobu generisati:

```text
HS-{ROOM_ID}-{slug_room_name}
```

Za svaki rate plan generisati:

```text
RP-{RATE_PLAN_ID}-{meal_plan}
```

## Task 2 - Reservation Import

Napraviti skriptu:

```bash
php sync_reservations.php --from=2026-01-01 --to=2026-01-31
```

Skripta treba da:

- preuzme rezervacije iz API-ja
- upiše ih u bazu
- mapira sobe
- mapira rate planove
- upiše sve povezane zapise

Napomena:

Jedna rezervacija može imati više soba i više rate planova.

Primer:

```text
Reservation
 ├─ Room A (x1)
 ├─ Room B (x2)
 ├─ RatePlan Standard
 └─ RatePlan Breakfast
```

Za svaku rezervaciju generisati:

```text
lock_id = LOCK-{reservation_id}-{arrival_date}
```

## Task 3 - Reservation Update / Cancel

Napraviti skriptu:

```bash
php update_reservation.php --reservation_id=XXXX
```

Skripta treba da:

- preuzme rezervaciju iz API-ja
- proveri da li postoji lokalno
- uporedi payload hash
- ako postoji promena, ažurira podatke
- zabeleži promenu u audit log tabeli

Ako je rezervacija otkazana:

- rezervacija ostaje u bazi
- ali se beleži događaj u audit log

## Task 4 - Invoice Creation

Napraviti skriptu:

```bash
php generate_invoice.php --reservation_id=XXXX
```

Skripta treba da:

- generiše invoice payload
- upiše ga u `invoice_queue` tabelu

Invoice mora sadržati:

- `invoice_number`
- `reservation_id`
- `guest_name`
- `arrival_date`
- `departure_date`
- `line items`
- `total_amount`
- `currency`

Numeracija računa mora biti:

```text
HS-INV-YYYY-000001
```

Potrebno je obezbediti da dve paralelne fakture ne dobiju isti broj.

Ako slanje fakture ne uspe:

- retry do 5 puta
- nakon toga status `failed`

## Task 5 - Webhook Endpoint

Napraviti endpoint:

```text
POST /webhooks/otasync.php
```

Endpoint treba da:

- primi webhook event
- validira payload
- izračuna payload hash
- sačuva event u bazu
- proveri da li je event već obrađen
- ažurira rezervaciju u bazi

Webhook treba da podrži:

- nova rezervacija
- izmena rezervacije
- otkazivanje rezervacije

Ako isti webhook stigne više puta, sistem ne sme napraviti duple zapise.

## Logging

Potrebno je implementirati log fajl koji beleži:

- timestamp
- tip događaja
- opis
- ID rezervacije ili eksterni ID ako postoji
