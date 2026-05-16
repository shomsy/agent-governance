<!-- Generated from the source-only lesson package. -->

# 04 · Web Components 2/2 · Shadow DOM my first component

Druga Web Components lekcija prvo sastavlja vidljivi card shell kroz host, template i slotove kao vizuelnu fazu, a tek onda dodaje shadow DOM behavior, render lifecycle, cleanup i sigurniju registraciju kao logičku fazu.

## Goal

- Šta gradimo u ovoj lekciji

Prvo završavamo vidljivi card shell, a onda kroz shadow DOM, slotove i lifecycle uvodimo behavior i polish.

## Steps

1. Start: Empty App Shell - Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje finalni Web Component koji tek treba da oživi kroz HTML, CSS i vanilla JavaScript.

2. HTML: My First Component Host - Dodajemo `<my-first-component>` host sa `title` i `cta-label` atributima. Još nije registrovan, ali browser već vidi custom tag i njegov sirovi sadržaj.

3. HTML: Named Slot Content - U host ubacujemo `<span slot="eyebrow">Vanilla JS</span>`. To je light DOM sadržaj koji će kasnije upasti u named slot unutar shadow DOM-a.

4. HTML: Default Slot Text - Dodajemo opisni tekst kao default slot sadržaj. Pre registracije komponente vidiš ga kao običan sadržaj custom taga; posle registracije odlazi u `<slot>` unutar template-a.

5. JS: Kreiramo Template - Počinjemo sa `document.createElement('template')`. Template nam daje inertan komad DOM-a koji možemo bezbedno da kloniramo u svakoj instanci komponente.

6. JS: Otvaramo Template String - Dodajemo `template.innerHTML = \`` i od tog trenutka gradimo ceo shadow DOM sadržaj iz jednog kontrolisanog izvora.

7. JS: Dodajemo Shadow DOM Markup - Sada ubacujemo unutrašnji markup: card wrapper, named slot za eyebrow, semantički `h2` naslov, paragraf sa default slotom, CTA dugme i `part` atribute za kasniji escape hatch.

8. JS: Class Extends HTMLElement - Otvaramo `class MyFirstComponent extends HTMLElement`. Time browseru kažemo da naš custom element ima sopstveno ponašanje.

9. JS: constructor + attachShadow - U konstruktoru pozivamo `super()` i odmah otvaramo `const shadowRoot = this.attachShadow({ mode: 'open' })` da komponenta dobije sopstveni shadow root.

10. JS: Kloniramo Template - Dodajemo `appendChild(myFirstComponentTemplate.content.cloneNode(true))`, pa svaka instanca komponente dobija isti početni shadow DOM skeleton.

11. JS: Keširamo Title Element - U konstruktoru čuvamo referencu na `.title` element, da ga kasnije ne tražimo iznova pri svakom renderu.

12. JS: Keširamo CTA Element - Na isti način čuvamo referencu na `.cta`, jer će tekst dugmeta stizati iz atributa host elementa.

13. JS: Bindujemo CTA Handler - U konstruktoru vezujemo `this.handleClick = this.handleClick.bind(this)`, da isti handler može bezbedno da se koristi i za add i za remove listener.

14. JS: Uvodimo render() - Dodajemo `render()` metodu kao jedno mesto gde atributi host elementa prelaze u konkretan UI tekst unutar shadow DOM-a.

15. JS: render() Popunjava Title - U `render()` čitamo `title` atribut i upisujemo ga u `.title` element. Time host atribut postaje stvaran UI sadržaj u komponenti.

16. JS: render() Popunjava CTA - Na isti način `cta-label` atribut pretvaramo u tekst CTA dugmeta.

17. JS: connectedCallback Lifecycle - Dodajemo `connectedCallback()` kao mesto gde komponenta obavlja prvi render i povezuje runtime ponašanje.

18. JS: connectedCallback Pokreće Prvi Render - U `connectedCallback()` pozivamo `this.render()`, pa komponenta dobija sadržaj čim uđe u DOM.

19. JS: connectedCallback Vezuje Click Listener - U istom lifecycle koraku vezujemo click listener na CTA dugme, pa komponenta više ne samo prikazuje UI nego i emituje akciju.

20. JS: disconnectedCallback Cleanup - Dodajemo `disconnectedCallback()` i skidamo CTA listener kada komponenta izađe iz DOM-a.

21. JS: observedAttributes - Dodajemo `static observedAttributes = ['title', 'cta-label']`, pa browser zna koje promene atributa treba da javi komponenti.

22. JS: attributeChangedCallback - Dodajemo `attributeChangedCallback()` sa guard-om za `isConnected`, pa render radimo samo kada komponenta zaista živi u DOM-u.

23. JS: CTA Emituje component-action - Dodajemo `handleClick()` i iz njega emitujemo `CustomEvent('component-action', ...)`, pa komponenta dobija jasan izlazni signal.

24. JS: Čuvamo se duplog define-a - Pre registracije proveravamo `customElements.get('my-first-component')`, da isti custom element ne pokušamo da definišemo dva puta.

25. JS: Registrujemo Custom Element - Unutar guard-a pozivamo `customElements.define('my-first-component', MyFirstComponent)`. Od ovog trenutka browser zna kako da upgrade-uje `<my-first-component>` u pravu komponentu i preview dobija prvi stvarni, još uvek sirovi render.

26. CSS: .app-shell / outline - Dodajemo tanak helper outline za `.app-shell` i zadržavamo ga kroz celu lekciju, sve do završnog shell rezimea.

27. CSS: .app-shell / padding - Dodajemo padding da komponenta dobije vazduh čim se pojavi u preview-u.

28. CSS: .app-shell / display - Grid je jednostavan način da centralno postavimo jedan teaching target.

29. CSS: .app-shell / place-items - Centar zadržava fokus korisnika na jednoj komponenti.

30. CSS: .app-shell / min-height - Puna visina drži scenu stabilnom kroz celu lekciju.

31. CSS: .app-shell / background - Svetla pozadina daje kontrast tamnoj komponenti koju gradimo.

32. CSS: my-first-component / outline - Dodajemo tanak helper outline za host element i držimo ga do završnog host rezimea.

33. CSS: my-first-component / display - Host pretvaramo u block da zauzme svoj red i dobije realan footprint.

34. CSS: my-first-component / width - Širinu zaključavamo rano da card skeleton ne šeta po sceni.

35. CSS: my-first-component / --callout-surface - Spolja uvodimo surface token koji shadow DOM kasnije povlači kroz `var(...)`.

36. CSS: my-first-component / --callout-surface-alt - Dodajemo i drugi surface ton da unutrašnji gradijent ne zavisi od hardkodovanog fallback-a.

37. CSS: my-first-component / --callout-border - Border token služi da spolja theme-ujemo ivicu komponente.

38. CSS: my-first-component / --callout-accent - Accent token će obojiti badge i CTA unutar shadow DOM-a.

39. CSS: my-first-component / --callout-accent-strong - Jači accent ton služi za dublji kraj CTA gradijenta.

40. CSS: my-first-component / --callout-text - Text token daje konzistentnu boju celom Web Component sadržaju.

41. CSS: my-first-component / --callout-muted - Muted token služi sekundarnom tekstu unutar komponente.

42. CSS: my-first-component / --callout-shadow - Shadow token prebacuje i dubinu komponente u spoljašnji theme sloj.

43. JS: template / :host / font-family - Počinje unutrašnji template CSS: host dobija isti font stack kao i ostatak scene.

44. JS: template / :host / color - Host odmah koristi spoljašnji text token, pa vidiš kako custom property prolazi kroz granicu shadow DOM-a.

45. JS: template / .card / outline - Dodajemo helper outline za glavni card blok i držimo ga do završnog card rezimea.

46. JS: template / .card / display - Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.

47. JS: template / .card / gap - Gap odvaja badge, naslov, opis i CTA.

48. JS: template / .card / padding - Padding pravi pravi card footprint unutar shadow DOM-a.

49. JS: template / .card / border-radius - Zaobljenje daje modernu card siluetu.

50. JS: template / .card / border - Ivica koristi host token, pa spoljašnji CSS zaista utiče na unutrašnji card.

51. JS: template / .card / background - Tamna pozadina sada čita oba surface tokena direktno sa host elementa.

52. JS: template / .card / box-shadow - Shadow sada takođe čita spoljašnji token, pa i dubina komponente postaje deo API-ja.

53. JS: template / .eyebrow / outline - Dodajemo helper outline za eyebrow badge i držimo ga do završnog eyebrow rezimea.

54. JS: template / .eyebrow / display - Badge ostaje kompakatan i prirodno prati svoj sadržaj.

55. JS: template / .eyebrow / align-items - Vertikalno centriramo sadržaj badge-a da kapsula izgleda urednije.

56. JS: template / .eyebrow / justify-content - Tekst badge-a ostaje simetrično centriran i kada se sadržaj menja.

57. JS: template / .eyebrow / width - Badge širinu vežemo isključivo za sadržaj, ne za širinu roditelja.

58. JS: template / .eyebrow / padding - Padding daje badge-u jasan pill footprint.

59. JS: template / .eyebrow / border-radius - Veliki radius zatvara badge u kapsulu.

60. JS: template / .eyebrow / background - Poluprovidna pozadina pravi nežan badge signal.

61. JS: template / .eyebrow / color - Boju badge-a takođe vežemo za host accent token.

62. JS: template / .eyebrow / font-size - Manji font čini badge sekundarnim, ali čitljivim.

63. JS: template / .eyebrow / font-weight - Težina fonta čini badge labelu kompaktnom i jasnom.

64. JS: template / .eyebrow / letter-spacing - Mali tracking daje badge-u uredniji, label-like karakter.

65. JS: template / .eyebrow / text-transform - Uppercase zatvara eyebrow kao jasnu oznaku kategorije.

66. JS: template / .title / display - Naslovu dajemo sopstveni red da ne deli liniju sa drugim delovima.

67. JS: template / .title / margin - Pošto prelazimo na semantički `h2`, prvo gasimo podrazumevani margin.

68. JS: template / .title / font-size - Naslov dobija responzivniju veličinu, bližu finalnom polished utisku.

69. JS: template / .title / line-height - Kraći line-height drži naslov zategnutim i čitljivim.

70. JS: template / .title / font-weight - Pojačavamo naslov da odmah nosi hijerarhiju.

71. JS: template / .summary / margin - Brišemo podrazumevani paragraf margin da spacing kontrolišemo iz card gap-a.

72. JS: template / .summary / color - Opis dobija muted token, pa i sekundarni tekst postaje deo spoljašnjeg theme API-ja.

73. JS: template / .summary / line-height - Line-height otvara tekst i čini ga lakšim za čitanje.

74. JS: template / .cta / outline - Dodajemo helper outline za CTA i držimo ga do završnog CTA rezimea.

75. JS: template / .cta / justify-self - CTA ostaje uz levu ivicu card sadržaja umesto da se rasteže.

76. JS: template / .cta / appearance - Gasimo browser-native izgled dugmeta da komponenta zadrži konzistentan cross-browser izgled.

77. JS: template / .cta / padding - Padding daje dugmetu njegovu klik zonu.

78. JS: template / .cta / border - Uklanjamo podrazumevanu border liniju dugmeta.

79. JS: template / .cta / border-radius - Pil radius drži CTA vizuelno bliskim badge logici.

80. JS: template / .cta / background - CTA sada koristi i jači accent token za dublji, kontrolisan gradijent.

81. JS: template / .cta / color - Beli tekst drži jasan kontrast preko gradijenta.

82. JS: template / .cta / font - Dugme preuzima isti font vocabulary kao i ostatak komponente.

83. JS: template / .cta / font-weight - Težina fonta zatvara CTA kao jasan action element.

84. JS: template / .cta / cursor - Kursor eksplicitno potvrđuje interaktivnost CTA dugmeta.

85. JS: template / .cta / transition - Dodajemo finu tranziciju da hover i focus states ne deluju grubo.

86. JS: template / .cta / box-shadow - Mali shadow pojačava CTA kao završni action sloj.

87. JS: template / .cta:hover / filter - Hover blago podiže svetlinu CTA dugmeta bez agresivne promene boje.

88. JS: template / .cta:hover / transform - Minimalni lift daje osećaj da dugme odgovara na hover.

89. JS: template / .cta:active / transform - Na active vraćamo dugme nazad, da klik ima malu fizičku povratnu informaciju.

90. JS: template / .cta:focus-visible / outline - Focus-visible dodaje jasan tastaturski focus ring bez oslanjanja na browser default.

91. JS: template / .cta:focus-visible / outline-offset - Offset odvaja focus ring od same pil ivice dugmeta.

92. Rezime: .card unutar template-a - Rezimiramo glavni card blok i tek sada uklanjamo njegov helper outline, jer je unutrašnja struktura komponente već potpuno jasna.

93. Rezime: .eyebrow unutar template-a - Rezimiramo eyebrow badge i uklanjamo njegov helper outline tek sada, kada slot projekcija i badge stil rade zajedno.

94. Rezime: .cta unutar template-a - Rezime za CTA dugme: helper outline više nije potreban, jer završni stil, event i hover/focus ponašanje već jasno pokazuju njegovu ulogu.

95. Rezime: my-first-component host - Završni host rezime: spoljašnji outline host elementa više nije potreban, jer su API atributi, theme tokeni i safe registration sada jasni.

96. Rezime: .app-shell - Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela Web Components lekcija kompletna i okvir više nije potreban.

97. Done: My First Component Web Component - Lekcija je završena: od praznog shell-a stigli smo do pravog custom elementa sa host atributima, slotovima, shadow DOM-om, render lifecycle-om, cleanup-om, sigurnom registracijom, izlaznim event-om i interaction polish slojem.
