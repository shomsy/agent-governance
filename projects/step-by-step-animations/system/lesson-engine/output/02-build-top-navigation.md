<!-- Generated from the source-only lesson package. -->

# 02 · Kako se pravi top navigation bar

Koraci po korak gradiš prvi navbar iz reference: logo levo, linkovi u sredini i CTA dugme desno. Druga dva rasporeda iz iste slike ostaju kao domaći zadatak.

## Goal

- Šta gradimo u ovoj lekciji

U ovoj lekciji gradimo samo prvi raspored iz reference: logo levo, linkovi u sredini i plavo Contact dugme desno.

## Steps

1. Start: Empty App Shell - Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje tri varijante, ali u ovoj lekciji gradimo samo prvu.

2. HTML: Topbar Shell - Dodajemo `<header class="topbar">` kao glavni wrapper buduće navigacije.

3. CSS: .app-shell / outline - Dodajemo tanak helper outline za `.app-shell` i zadržavamo ga kroz celu lekciju, sve do završnog shell rezimea.

4. CSS: .app-shell / padding - Dodajemo padding oko cele scene da navbar dobije vazduh i ne stoji zalepljen za ivice preview-a.

5. CSS: .app-shell / background - Svetla pozadina približava preview referentnoj slici i daje kontrast tamnom navbaru.

6. CSS: .app-shell / min-height - Puna visina drži celu scenu stabilnom tokom lekcije.

7. CSS: .topbar / outline - Dodajemo tanak pomoćni outline da footprint celog navbara ostane vidljiv kroz ceo tok. Skidamo ga tek u završnom rezime koraku za `.topbar`.

8. CSS: .topbar / padding - Navbar dobija unutrašnji spacing, pa odmah izgleda kao realna UI traka.

9. CSS: .topbar / background - Dodajemo tamnu pozadinu, ali outline namerno ostaje do završnog rezimea za `.topbar`.

10. CSS: .topbar / border - Tanka ivica pomaže da navbar bude čitljiv i na svetloj pozadini.

11. CSS: .topbar / box-shadow - Shadow odvaja navbar od pozadine i približava ga referentnoj slici.

12. CSS: .topbar / display - Flex uvodi horizontalni raspored elemenata.

13. CSS: .topbar / align-items - Vertikalno centriramo sve delove navigacije.

14. CSS: .topbar / justify-content - Glavne zone dobijaju početno razdvajanje levo i desno.

15. HTML: Logo Link - Dodajemo logo kao klikabilni `.topbar-logo` element na levom kraju navigacije.

16. CSS: .topbar-logo / outline - Dodajemo tanak outline za logo i držimo ga do završnog rezime koraka za `.topbar-logo`.

17. CSS: .topbar-logo / color - Boju loga postavljamo rano da odmah ima jasan kontrast na tamnoj traci.

18. CSS: .topbar-logo / font-size - Malo povećavamo logo da se odvoji od običnih linkova.

19. CSS: .topbar-logo / font-weight - Težina fonta daje logo signalu identitet.

20. CSS: .topbar-logo / letter-spacing - Blagi spacing pojačava moderni, branded osećaj.

21. CSS: .topbar-logo / text-decoration - Uklanjamo underline da logo izgleda kao deo UI-ja, ne kao sirov link.

22. HTML: Navigation Links - Dodajemo `<nav class="topbar-links">` sa linkovima Services, Projects i About. I grupa linkova i sami linkovi dobijaju helper outline koji ostaje do završnog rezimea za navigaciju.

23. CSS: .topbar-links / outline - Dodajemo tanak helper outline za centralnu navigacionu zonu i držimo ga do završnog rezime koraka za link sekciju.

24. CSS: .topbar-links / display - Linkove slažemo u jedan red.

25. CSS: .topbar-links / gap - Gap daje istu vrstu razmaka kao na referentnoj slici.

26. CSS: .topbar-links / margin-left - Navigacija se odvaja od loga i kreće ka sredini.

27. CSS: .topbar-links / margin-right - Desni auto margin pomaže da grupa linkova ostane vizuelno centrirana.

28. CSS: .topbar-links a / outline - Svaki navigacioni link dobija svoj tanak outline i zadržava ga do završnog rezimea za navigaciju.

29. CSS: .topbar-links a / color - Boja linkova prati logo i pravi konzistentan kontrast.

30. CSS: .topbar-links a / font-size - Linkovi dobijaju čitljivu, ali nenametljivu veličinu.

31. CSS: .topbar-links a / text-decoration - Čistimo default underline da linkovi izgledaju kao deo dizajna.

32. CSS: .topbar-links a / transition - Mala tranzicija omekšava hover promenu.

33. CSS: .topbar-links a:hover / color - Hover ton blago menja boju, bez agresivnog skakanja.

34. HTML: Contact CTA - Dodajemo završni `.topbar-cta` link sa tekstom Contact. Dugme takođe dobija svoj helper outline koji ostaje do njegovog završnog rezimea.

35. CSS: .topbar-cta / outline - Dodajemo tanak pomoćni outline za CTA i držimo ga do završnog rezime koraka za dugme.

36. CSS: .topbar-cta / display - CTA prebacujemo u inline-flex da padding i centriranje rade kao na pravom dugmetu.

37. CSS: .topbar-cta / align-items - Tekst dugmeta centriramo po visini.

38. CSS: .topbar-cta / padding - Padding daje CTA dugmetu njegov pravi footprint.

39. CSS: .topbar-cta / border-radius - Pil oblik odmah približava dugme referentnom primeru.

40. CSS: .topbar-cta / background - Dodajemo završnu boju CTA dugmeta, ali outline i dalje ostaje do rezime koraka za `.topbar-cta`.

41. CSS: .topbar-cta / color - Beli tekst pravi čist kontrast preko plave pozadine.

42. CSS: .topbar-cta / text-decoration - Uklanjamo underline da CTA izgleda kao pravo dugme.

43. CSS: .topbar-cta / box-shadow - Shadow pojačava prisustvo CTA dugmeta i zatvara vizuelni match sa ciljem.

44. Rezime: .topbar - Završni rezime za `.topbar`: sada kada vidimo kompletan block CSS, uklanjamo helper outline sa glavnog wrapper-a.

45. Rezime: .topbar-logo - Rezimiramo `.topbar-logo` i uklanjamo njegov helper outline tek sada, kada je sav CSS za logo već jasan i kompletan.

46. Rezime: .topbar-links - Rezimiramo navigacionu celinu i uklanjamo helper outline i sa wrapper-a i sa pojedinačnih linkova.

47. Rezime: .topbar-cta - Rezime za CTA dugme: helper outline više nije potreban, jer završni stil već jasno govori šta je element i kako izgleda.

48. Rezime: .app-shell - Završni shell rezime: tek sada uklanjamo helper outline sa `.app-shell`, jer je cela navigaciona lekcija kompletna i okvir više nije potreban.

49. Done: Top Navigation - Prvi navbar iz reference je gotov. Druga dva rasporeda iz goal slike ostaju kao domaći zadatak.

## Homework

- Drugu varijantu iz reference napravi kao samostalnu lekciju ili kao vlastitu vežbu: linkovi levo, CTA u sredini, logo desno.

- Treću varijantu iz reference napravi kao drugu vežbu: logo levo, a kompletna navigaciona grupa i CTA dugme desno.
