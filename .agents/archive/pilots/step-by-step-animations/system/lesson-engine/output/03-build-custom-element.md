<!-- Generated from the source-only lesson package. -->

# 03 · Web Components 1/2 · Light DOM custom element

Prva Web Components lekcija prvo gradi vidljivi host i prvi render koji korisnik vidi kao vizuelnu fazu, a tek onda u logičkoj fazi kroz light DOM objašnjava registraciju i atribute, bez shadow DOM sloja.

## Goal

- Šta gradimo u ovoj lekciji

Prva faza je visual composition: prvo gradimo vidljivi host i prvi render, a druga faza uvodi registraciju i atribute kroz light DOM.

## Steps

1. Start: Empty App Shell - Počinjemo od praznog `.app-shell` prostora. Ova prva Web Components lekcija objašnjava custom element osnove bez shadow DOM-a.

2. HTML: my-first-component Host - Dodajemo `<my-first-component>` host sa `title` i `cta-label` atributima. Browser ga za sada vidi samo kao nepoznati custom tag koji čeka registraciju.

3. JS: Class Extends HTMLElement - Otvaramo `class MyFirstComponent extends HTMLElement` i time zadajemo ponašanje budućem custom elementu.

4. JS: connectedCallback - Dodajemo `connectedCallback()`, jer je to najjednostavniji lifecycle hook za prvi render čim element uđe u DOM.

5. JS: Čitamo title Atribut - U lifecycle metodi čitamo `title` atribut sa host elementa. Time host HTML postaje spoljašnji API komponente.

6. JS: Čitamo cta-label Atribut - Na isti način čitamo i `cta-label`, kako bi i tekst CTA dugmeta dolazio iz host HTML-a.

7. JS: Renderujemo Light DOM Markup - Kroz `this.innerHTML` ubacujemo card markup direktno u host element. To je najdirektniji put da vidiš kako custom element može da generiše sopstveni light DOM.

8. JS: Registrujemo my-first-component - Pre registracije proveravamo `customElements.get('my-first-component')`, pa tek onda unutar guarda pozivamo `customElements.define(...)`. Od tog trenutka browser zna kako da upgrade-uje svaki `<my-first-component>` u stvarnu komponentu.

9. CSS: .app-shell / outline - Dodajemo helper outline za `.app-shell` i zadržavamo ga do završnog shell rezimea.

10. CSS: .app-shell / padding - Padding daje komponenti prostor da se vidi kao zaseban teaching target.

11. CSS: .app-shell / display - Grid je dovoljan da centriramo jedan card use case.

12. CSS: .app-shell / place-items - Centar čuva fokus na komponenti koju gradimo.

13. CSS: .app-shell / min-height - Puna visina stabilizuje preview scenu.

14. CSS: .app-shell / background - Svetla pozadina daje kontrast tamnom callout card-u.

15. CSS: my-first-component / outline - Dodajemo helper outline za host element i držimo ga do završnog host rezimea.

16. CSS: my-first-component / display - Host pretvaramo u block da dobije pravi footprint.

17. CSS: my-first-component / width - Širinu zaključavamo rano da card kasnije uleti u stabilan okvir.

18. CSS: my-first-component .card / outline - Kada komponenta renderuje light DOM markup, glavni `.card` dobija helper outline do završnog card rezimea.

19. CSS: my-first-component .card / display - Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.

20. CSS: my-first-component .card / gap - Gap odvaja badge, naslov, opis i CTA.

21. CSS: my-first-component .card / padding - Padding pravi card footprint unutar host elementa.

22. CSS: my-first-component .card / border-radius - Zaobljenje daje card-u mekšu siluetu.

23. CSS: my-first-component .card / border - Tanka border linija odvaja card od pozadine.

24. CSS: my-first-component .card / background - Tamna pozadina zatvara glavni vizuelni blok.

25. CSS: my-first-component .card / box-shadow - Shadow daje card-u dubinu i separaciju.

26. CSS: my-first-component .eyebrow / outline - Badge dobija helper outline i zadržava ga do eyebrow rezimea.

27. CSS: my-first-component .eyebrow / display - Badge ostaje kompaktan i prati svoj sadržaj.

28. CSS: my-first-component .eyebrow / padding - Padding daje badge-u njegov pill footprint.

29. CSS: my-first-component .eyebrow / border-radius - Veliki radius zatvara badge u kapsulu.

30. CSS: my-first-component .eyebrow / background - Blaga pozadina daje badge-u površinu bez agresivnosti.

31. CSS: my-first-component .eyebrow / color - Accent boja badge signalizira kategoriju.

32. CSS: my-first-component .eyebrow / font-size - Badge ostaje mali i sekundaran.

33. CSS: my-first-component .eyebrow / font-weight - Jača težina fonta čini labelu jasnom.

34. CSS: my-first-component .title / font-size - Naslov dobija dominantnu veličinu unutar card-a.

35. CSS: my-first-component .title / font-weight - Pojačavamo naslov da odmah nosi hijerarhiju.

36. CSS: my-first-component .summary / margin - Brišemo default paragraf margin da spacing bude pod kontrolom.

37. CSS: my-first-component .summary / color - Opis dobija prigušenu, ali čitljivu boju.

38. CSS: my-first-component .summary / line-height - Veći line-height otvara tekst za lakše čitanje.

39. CSS: my-first-component .cta / outline - CTA dobija helper outline i zadržava ga do završnog CTA rezimea.

40. CSS: my-first-component .cta / padding - Padding daje dugmetu njegovu klik zonu.

41. CSS: my-first-component .cta / border - Uklanjamo podrazumevanu border liniju dugmeta.

42. CSS: my-first-component .cta / border-radius - Pil oblik čini CTA konzistentnim sa badge oblikom.

43. CSS: my-first-component .cta / background - Gradijent daje CTA-u energiju i fokus.

44. CSS: my-first-component .cta / color - Beli tekst pravi jasan kontrast preko dugmeta.

45. CSS: my-first-component .cta / font-weight - Jači font zatvara CTA kao jasan action element.

46. Rezime: .card - Rezimiramo glavni `.card` blok i uklanjamo njegov helper outline tek sada, kada su host, render i glavni vizuelni sloj zajedno jasni.

47. Rezime: .eyebrow - Rezimiramo eyebrow badge i tek sada uklanjamo njegov helper outline, jer je cela tekstualna hijerarhija card-a završena.

48. Rezime: .cta - Rezime za CTA dugme: helper outline više nije potreban, jer završni stil i render već jasno pokazuju njegovu ulogu.

49. Rezime: my-first-component host - Završni host rezime: uklanjamo host outline tek sada, kada su i atribut API i render flow potpuno jasni.

50. Rezime: .app-shell - Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela uvodna custom element lekcija kompletna.

51. Done: Light DOM Custom Element - Prva Web Components lekcija je gotova. Sad razumeš host tag, registraciju, atribute, render kroz light DOM i tek onda stilizaciju nad stvarnim renderovanim DOM-om. Sledeći prirodan korak je shadow DOM lekcija.
