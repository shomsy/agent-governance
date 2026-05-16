<!-- Generated from the source-only lesson package. -->

# 01 · Kako se pravi moderan sidebar

Koraci po korak gradiš sidebar od osnove do gotove navigacije. Svaki korak uključuje kod, savete i vizuelni prikaz.

## Steps

1. Start: Empty App Shell - Počinjemo od praznog `.app-shell` prostora. Sidebar tek dodajemo kao prvi pravi element.

2. HTML: Sidebar Shell - Ubacujemo osnovni `<aside class="sidebar">` blok kao koren cele komponente.

3. CSS: .app-shell / outline - Dodajemo tanak helper outline za `.app-shell` i zadržavamo ga kroz celu lekciju, sve do završnog shell rezimea.

4. CSS: .sidebar / outline - Dodajemo tanak helper outline da footprint sidebara ostane jasan kroz ceo lesson tok. Skidamo ga tek u završnom rezime koraku za `.sidebar`.

5. CSS: .sidebar / width - Kad granica postoji, zaključavamo širinu sidebara da dobije jasan footprint.

6. CSS: .sidebar / min-height - Dajemo sidebaru punu visinu da box postane čitljiv i bez sadržaja.

7. CSS: .sidebar / border-right - Tanka desna linija odvaja sidebar od ostatka layouta.

8. CSS: .sidebar / background - Dodajemo tamnu pozadinu da sidebar dobije svoj vizuelni identitet, ali outline namerno ostaje do rezime koraka za `.sidebar`.

9. CSS: .sidebar / color - Osnovnu boju teksta postavljamo rano da nasledi ceo sadržaj.

10. HTML: Brand Wrapper - Dodajemo `.sidebar-brand` kao zonu za logo i naziv proizvoda. Svi brand elementi zadržavaju svoje outline helpere do završnog brand rezimea.

11. CSS: .sidebar-brand / outline - Dodajemo tanak helper outline za `.sidebar-brand` i držimo ga do završnog rezime koraka za brand celinu.

12. CSS: .sidebar-brand / padding - Unutrašnji padding daje brand zoni vazduh.

13. CSS: .sidebar-brand / margin-bottom - Odvajamo brand blok od navigacije ispod njega.

14. CSS: .sidebar-brand / display - Prebacujemo brand zonu u flex da logo i tekst mogu da stoje u istom redu.

15. CSS: .sidebar-brand / align-items - Vertikalno poravnanje centrira logo i tekst.

16. CSS: .sidebar-brand / gap - Gap određuje koliko prostora stoji između logotipa i teksta.

17. HTML: Logo Element - Ubacujemo `.logo` element sa slovom `A` kao placeholder identitetom.

18. CSS: .logo / outline - Dodajemo tanak helper outline za `.logo` i držimo ga do završnog brand rezimea.

19. CSS: .logo / width - Prvo zaključavamo širinu logotipa.

20. CSS: .logo / height - Visina prati širinu da bismo dobili kvadratnu osnovu.

21. CSS: .logo / display - Grid nam daje lak centar za jedan znak ili ikonu.

22. CSS: .logo / place-items - Centriramo sadržaj logotipa u oba smera.

23. CSS: .logo / border-radius - Blago zaobljenje daje moderniji osećaj.

24. CSS: .logo / font-weight - Pojačavamo slovo da liči na pravi brand znak.

25. CSS: .logo / background - Gradijent dodaje energiju i daje logotipu fokus. Outline namerno ostaje do brand rezimea.

26. CSS: .logo / color - Bela boja daje čist kontrast preko gradijenta.

27. CSS: .logo / box-shadow - Shadow dodaje depth i čini logo prisutnijim.

28. HTML: Brand Copy - Dodajemo `.brand-copy` sa naslovom i podnaslovom pored logotipa. I on zadržava svoj outline do završnog brand rezimea.

29. CSS: .brand-copy / outline - Dodajemo tanak helper outline za tekstualni brand blok i držimo ga do završnog brand rezimea.

30. CSS: .brand-copy strong / display - Naslov pretvaramo u blok da zauzme svoj red.

31. CSS: .brand-copy strong / font-size - Naslov dobija čitljiviju veličinu.

32. CSS: .brand-copy span / display - Podnaslov spuštamo u novi red.

33. CSS: .brand-copy span / margin-top - Mali razmak odvaja podnaslov od naslova.

34. CSS: .brand-copy span / font-size - Podnaslov pravimo suptilnijim od naslova.

35. CSS: .brand-copy span / color - Muted boja pravi jasnu tekstualnu hijerarhiju.

36. HTML: Nav Wrapper - Ubacujemo `<nav class="nav-list">` kao kontejner za buduće linkove. Navigacioni outline helperi ostaju aktivni sve do završnog navigation rezimea.

37. CSS: .nav-list / outline - Dodajemo tanak helper outline za praznu nav zonu i držimo ga do završnog navigation rezimea.

38. CSS: .nav-list / padding - Dodajemo privremeni helper padding da prazna nav zona dobije visinu pre prvog linka. I njega držimo do završnog navigation rezimea.

39. CSS: .nav-list / display - Navigaciju slažemo u grid da spacing bude čist.

40. CSS: .nav-list / gap - Gap održava ravnomeran razmak između stavki.

41. HTML: Nav Items - Dodajemo prve `.nav-item` linkove sa ikonama i labelama. I stavke i ikonice zadržavaju outline helpere do navigation rezimea.

42. CSS: .nav-item / outline - Svaka stavka dobija tanak helper outline i zadržava ga do završnog navigation rezimea.

43. CSS: .nav-item / display - Svaka stavka postaje flex red da ikona i tekst stanu jedan do drugog.

44. CSS: .nav-item / min-height - Klik zona dobija pristojnu visinu.

45. CSS: .nav-item / padding - Padding pravi realnu klik zonu i diše bolje od golog teksta.

46. CSS: .nav-item / align-items - Vertikalno centriramo sadržaj svake stavke.

47. CSS: .nav-item / gap - Gap odvaja ikonu od labele.

48. CSS: .nav-item .icon / outline - Ikonica dobija svoj tanak outline i zadržava ga do završnog navigation rezimea.

49. CSS: .nav-item .icon / width - Ikona dobija fiksnu širinu.

50. CSS: .nav-item .icon / height - Ikona dobija i fiksnu visinu radi konzistentnog kvadrata.

51. CSS: .nav-item .icon / display - Grid olakšava centriranje sadržaja ikone.

52. CSS: .nav-item .icon / place-items - Ikonicu centriramo i horizontalno i vertikalno.

53. CSS: .nav-item .label / font-size - Labela dobija čitljivu veličinu.

54. CSS: .nav-item .label / font-weight - Blago pojačavamo labelu da zadrži hijerarhiju.

55. CSS: .nav-item / border-radius - Zaobljene ivice daju linkovima mekši, UI osećaj. Outline helper i dalje ostaje do rezimea.

56. CSS: .nav-item / margin - Spoljni razmak odvaja stavke od ivice sidebara.

57. CSS: .nav-item.active / background - Aktivna stavka dobija svoju pozadinu, ali helper outline ostaje do navigation rezimea.

58. CSS: .nav-item.active / color - Boju aktivne stavke pojačavamo za bolji kontrast.

59. CSS: .nav-item / transition - Dodajemo glatku tranziciju za hover i active stanje.

60. CSS: .nav-item:hover / background - Hover feedback potvrđuje da je stavka interaktivna.

61. CSS: .sidebar.is-collapsed / width - Collapsed mod sužava sidebar na kompaktnu širinu.

62. HTML: Sidebar Footer - Dodajemo `.sidebar-footer` kao završni informativni blok pri dnu sidebara. Footer takođe dobija svoj outline helper koji ostaje do njegovog završnog rezimea.

63. CSS: .sidebar / display - Sidebar pretvaramo u flex kolonu da footer može da ode na dno.

64. CSS: .sidebar / flex-direction - Kolona omogućava prirodan vertikalni raspored sekcija.

65. CSS: .sidebar-footer / outline - Dodajemo tanak helper outline za footer i držimo ga do završnog footer rezimea.

66. CSS: .sidebar-footer / border - Tanka linija razdvaja footer od pozadine.

67. CSS: .sidebar-footer / background - Blaga pozadina izdvaja footer bez teškog kontrasta.

68. CSS: .sidebar-footer / padding - Footer dobija unutrašnji spacing.

69. CSS: .sidebar-footer / border-radius - Zaobljenje usklađuje footer sa ostatkom UI-ja.

70. CSS: .sidebar-footer / margin-top - Auto margin gura footer na dno kolone.

71. CSS: .sidebar-footer p / margin - Odstupamo paragraf od naslova unutar footera.

72. CSS: .sidebar-footer p / color - Muted ton čini pomoćni tekst nenametljivim.

73. CSS: .sidebar-footer p / line-height - Line-height daje tekstu dovoljno vazduha.

74. CSS: .sidebar.is-collapsed .brand-copy, .sidebar.is-collapsed .nav-item .label / display - U collapsed modu sakrivamo tekstualne labele i brand copy.

75. CSS: .sidebar / min-height - Na manjim ekranima sidebar više ne mora da glumi pun viewport.

76. Rezime: .sidebar - Završni rezime za `.sidebar`: helper outline više nije potreban, jer je sav osnovni CSS za shell već kompletan i jasan.

77. Rezime: Brand Celina - Rezimiramo brand wrapper, logo i brand copy. Tek sada uklanjamo njihove outline helpere jer je ceo brand blok završen.

78. Rezime: Navigation Celina - Rezimiramo nav zonu, stavke i ikonice. Tek sada uklanjamo outline helpere sa cele navigacione celine.

79. Rezime: Footer - Rezimiramo footer blok i uklanjamo njegov helper outline tek sada, kada je ceo footer vizuelno završen.

80. Rezime: .app-shell - Završni shell rezime: tek sada uklanjamo helper outline sa `.app-shell`, jer je cela sidebar lekcija kompletna i okvir više nije potreban.

81. Done: Sidebar - Tutorijal je sada potpuno detaljan: CSS ide kumulativno, property po property, a outline helperi odlaze tek u rezime koracima.
