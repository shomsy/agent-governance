<!-- Generated from the source-only lesson package. -->

# 06 · Modular Web Components (IDE View)

Ova lekcija demonstrira novi IDE mode playera. Prvo ostaje vidljiv stvarni UI rezultat komponente kao vizuelna faza, a tek onda koristimo file browser i automatsko prebacivanje fokusa kao logičku fazu da raspodelimo fajlove i ponašanje.

## Goal

- Cilj: IDE Iskustvo

U ovoj lekciji prvo čuvamo vidljiv rezultat komponente, a tek onda IDE layout koristi fajlove da razdvoji odgovornosti.

## Steps

1. Start: Empty App Shell - Počinjemo od praznog `.app-shell` prostora. Goal slika iznad pokazuje istu komponentu, ali sada je cilj da očistimo način na koji njeni stilovi žive pored JavaScript logike.

2. HTML: My First Component Host - Dodajemo `<my-first-component>` host sa `title` i `cta-label` atributima. Host API ostaje isti; menja se samo način na koji komponenta organizuje sopstveni CSS.

3. HTML: Named Slot Content - U host ubacujemo `<span slot="eyebrow">Vanilla JS</span>`. Light DOM sadržaj ostaje isti i u ovoj čistijoj verziji komponente.

4. HTML: Default Slot Text - Dodajemo opisni tekst kao default slot sadržaj. Čišćenje stila ne menja slot logiku; menja samo gde CSS živi.

5. JS: Template Sada Čuva Samo Markup - Kreiramo `document.createElement('template')`, ali ovoga puta template više nije zadužen i za stilove. Čuvamo ga samo za shadow DOM markup.

6. Now Let's Clean The Mess - Ovde pravimo glavni refactor: CSS više ne guramo u `<style>` unutar `template.innerHTML`, niti ga držimo kao veliki inline string u JavaScript fajlu. Prebacujemo ga u poseban `shadow-dom-style.css` koji komponenta kasnije samo usvoji.

7. JS: Uvozimo shadow-dom-style.css kao tekst - Dodajemo `import shadowDomStyleCssText from './shadow-dom-style.css?raw';`, pa JavaScript više ne nosi same CSS linije nego samo učitava gotov stylesheet source.

8. JS: Kreiramo CSSStyleSheet - Dodajemo `new CSSStyleSheet()` i otvaramo poseban objekat koji će čuvati CSS komponente van same klase.

9. JS: replaceSync Prima Uvezeni CSS - Kroz `myFirstComponentStyles.replaceSync(shadowDomStyleCssText)` punimo constructed stylesheet tekstom koji stiže iz posebnog CSS fajla. JavaScript više ne nosi stil pravila u sebi.

10. JS: Template Markup Bez <style> - Sada otvaramo `template.innerHTML = \`` i ubacujemo samo card markup. Nema više embedded `<style>` bloka u template string-u.

11. JS: Dodajemo Shadow DOM Markup - U template ubacujemo card wrapper, named slot za eyebrow, semantički `h2` naslov, paragraf sa default slotom, CTA dugme i `part` atribute za kasniji escape hatch.

12. JS: Class Extends HTMLElement - Otvaramo `class MyFirstComponent extends HTMLElement`. Time browseru kažemo da naš custom element ima sopstveno ponašanje.

13. JS: constructor + attachShadow - U konstruktoru pozivamo `super()` i odmah otvaramo `const shadowRoot = this.attachShadow({ mode: 'open' })` da komponenta dobije sopstveni shadow root.

14. JS: Kloniramo Template - Dodajemo `appendChild(myFirstComponentTemplate.content.cloneNode(true))`, pa svaka instanca komponente dobija isti početni shadow DOM skeleton.

15. JS: Shadow Root Usvaja Stylesheet - Dodajemo `shadowRoot.adoptedStyleSheets = [myFirstComponentStyles]`, pa shadow root dobija stil bez ubacivanja `<style>` taga u template.

16. JS: Keširamo Title Element - U konstruktoru čuvamo referencu na `.title` element, da ga kasnije ne tražimo iznova pri svakom renderu.

17. JS: Keširamo CTA Element - Na isti način čuvamo referencu na `.cta`, jer će tekst dugmeta stizati iz atributa host elementa.

18. JS: Bindujemo CTA Handler - U konstruktoru vezujemo `this.handleClick = this.handleClick.bind(this)`, da isti handler može bezbedno da se koristi i za add i za remove listener.

19. JS: Uvodimo render() - Dodajemo `render()` metodu kao jedno mesto gde atributi host elementa prelaze u konkretan UI tekst unutar shadow DOM-a.

20. JS: render() Popunjava Title - U `render()` čitamo `title` atribut i upisujemo ga u `.title` element. Time host atribut postaje stvaran UI sadržaj u komponenti.

21. JS: render() Popunjava CTA - Na isti način `cta-label` atribut pretvaramo u tekst CTA dugmeta.

22. JS: connectedCallback Lifecycle - Dodajemo `connectedCallback()` kao mesto gde komponenta obavlja prvi render i povezuje runtime ponašanje.

23. JS: connectedCallback Pokreće Prvi Render - U `connectedCallback()` pozivamo `this.render()`, pa komponenta dobija sadržaj čim uđe u DOM.

24. JS: connectedCallback Vezuje Click Listener - U istom lifecycle koraku vezujemo click listener na CTA dugme, pa komponenta više ne samo prikazuje UI nego i emituje akciju.

25. JS: disconnectedCallback Cleanup - Dodajemo `disconnectedCallback()` i skidamo CTA listener kada komponenta izađe iz DOM-a.

26. JS: observedAttributes - Dodajemo `static observedAttributes = ['title', 'cta-label']`, pa browser zna koje promene atributa treba da javi komponenti.

27. JS: attributeChangedCallback - Dodajemo `attributeChangedCallback()` sa guard-om za `isConnected`, pa render radimo samo kada komponenta zaista živi u DOM-u.

28. JS: CTA Emituje component-action - Dodajemo `handleClick()` i iz njega emitujemo `CustomEvent('component-action', ...)`, pa komponenta dobija jasan izlazni signal.

29. JS: Čuvamo se duplog define-a - Pre registracije proveravamo `customElements.get('my-first-component')`, da isti custom element ne pokušamo da definišemo dva puta.

30. JS: Registrujemo Custom Element - Unutar guard-a pozivamo `customElements.define('my-first-component', MyFirstComponent)`. Od ovog trenutka browser zna kako da upgrade-uje `<my-first-component>` u pravu komponentu i preview dobija render bez style taga u template-u.

31. CSS: .app-shell / outline - Dodajemo tanak helper outline za `.app-shell` i zadržavamo ga kroz celu lekciju, sve do završnog shell rezimea.

32. CSS: .app-shell / padding - Dodajemo padding da komponenta dobije vazduh čim se pojavi u preview-u.

33. CSS: .app-shell / display - Grid je jednostavan način da centralno postavimo jedan teaching target.

34. CSS: .app-shell / place-items - Centar zadržava fokus korisnika na jednoj komponenti.

35. CSS: .app-shell / min-height - Puna visina drži scenu stabilnom kroz celu lekciju.

36. CSS: .app-shell / background - Svetla pozadina daje kontrast tamnoj komponenti koju gradimo.

37. CSS: my-first-component / outline - Dodajemo tanak helper outline za host element i držimo ga do završnog host rezimea.

38. CSS: my-first-component / display - Host pretvaramo u block da zauzme svoj red i dobije realan footprint.

39. CSS: my-first-component / width - Širinu zaključavamo rano da card skeleton ne šeta po sceni.

40. CSS: my-first-component / --callout-surface - Spolja uvodimo surface token koji adopted stylesheet kasnije povlači kroz `var(...)`.

41. CSS: my-first-component / --callout-surface-alt - Dodajemo i drugi surface ton da unutrašnji gradijent ne zavisi od hardkodovanog fallback-a.

42. CSS: my-first-component / --callout-border - Border token služi da spolja theme-ujemo ivicu komponente.

43. CSS: my-first-component / --callout-accent - Accent token će obojiti badge i CTA unutar komponente.

44. CSS: my-first-component / --callout-accent-strong - Jači accent ton služi za dublji kraj CTA gradijenta.

45. CSS: my-first-component / --callout-text - Text token daje konzistentnu boju celom Web Component sadržaju.

46. CSS: my-first-component / --callout-muted - Muted token služi sekundarnom tekstu unutar komponente.

47. CSS: my-first-component / --callout-shadow - Shadow token prebacuje i dubinu komponente u spoljašnji theme sloj.

48. Shadow CSS: :host / font-family - Počinje constructed stylesheet: host dobija isti font stack kao i ostatak scene.

49. Shadow CSS: :host / color - Host odmah koristi spoljašnji text token, pa vidiš kako custom property prolazi kroz granicu shadow DOM-a.

50. Shadow CSS: .card / outline - Dodajemo helper outline za glavni card blok i držimo ga do završnog card rezimea.

51. Shadow CSS: .card / display - Card raspored uvodimo grid-om jer imamo vertikalnu stack strukturu.

52. Shadow CSS: .card / gap - Gap odvaja badge, naslov, opis i CTA.

53. Shadow CSS: .card / padding - Padding pravi pravi card footprint unutar komponente.

54. Shadow CSS: .card / border-radius - Zaobljenje daje modernu card siluetu.

55. Shadow CSS: .card / border - Ivica koristi host token, pa spoljašnji CSS zaista utiče na unutrašnji card.

56. Shadow CSS: .card / background - Tamna pozadina sada čita oba surface tokena direktno sa host elementa.

57. Shadow CSS: .card / box-shadow - Shadow sada takođe čita spoljašnji token, pa i dubina komponente postaje deo API-ja.

58. Shadow CSS: .eyebrow / outline - Dodajemo helper outline za eyebrow badge i držimo ga do završnog eyebrow rezimea.

59. Shadow CSS: .eyebrow / display - Badge ostaje kompakatan i prirodno prati svoj sadržaj.

60. Shadow CSS: .eyebrow / align-items - Vertikalno centriramo sadržaj badge-a da kapsula izgleda urednije.

61. Shadow CSS: .eyebrow / justify-content - Tekst badge-a ostaje simetrično centriran i kada se sadržaj menja.

62. Shadow CSS: .eyebrow / width - Badge širinu vežemo isključivo za sadržaj, ne za širinu roditelja.

63. Shadow CSS: .eyebrow / padding - Padding daje badge-u jasan pill footprint.

64. Shadow CSS: .eyebrow / border-radius - Veliki radius zatvara badge u kapsulu.

65. Shadow CSS: .eyebrow / background - Poluprovidna pozadina pravi nežan badge signal.

66. Shadow CSS: .eyebrow / color - Boju badge-a takođe vežemo za host accent token.

67. Shadow CSS: .eyebrow / font-size - Manji font čini badge sekundarnim, ali čitljivim.

68. Shadow CSS: .eyebrow / font-weight - Težina fonta čini badge labelu kompaktnom i jasnom.

69. Shadow CSS: .eyebrow / letter-spacing - Mali tracking daje badge-u uredniji, label-like karakter.

70. Shadow CSS: .eyebrow / text-transform - Uppercase zatvara eyebrow kao jasnu oznaku kategorije.

71. Shadow CSS: .title / display - Naslovu dajemo sopstveni red da ne deli liniju sa drugim delovima.

72. Shadow CSS: .title / margin - Pošto koristimo semantički `h2`, prvo gasimo podrazumevani margin.

73. Shadow CSS: .title / font-size - Naslov dobija responzivniju veličinu, bližu finalnom polished utisku.

74. Shadow CSS: .title / line-height - Kraći line-height drži naslov zategnutim i čitljivim.

75. Shadow CSS: .title / font-weight - Pojačavamo naslov da odmah nosi hijerarhiju.

76. Shadow CSS: .summary / margin - Brišemo podrazumevani paragraf margin da spacing kontrolišemo iz card gap-a.

77. Shadow CSS: .summary / color - Opis dobija muted token, pa i sekundarni tekst postaje deo spoljašnjeg theme API-ja.

78. Shadow CSS: .summary / line-height - Line-height otvara tekst i čini ga lakšim za čitanje.

79. Shadow CSS: .cta / outline - Dodajemo helper outline za CTA i držimo ga do završnog CTA rezimea.

80. Shadow CSS: .cta / justify-self - CTA ostaje uz levu ivicu card sadržaja umesto da se rasteže.

81. Shadow CSS: .cta / appearance - Gasimo browser-native izgled dugmeta da komponenta zadrži konzistentan cross-browser izgled.

82. Shadow CSS: .cta / padding - Padding daje dugmetu njegovu klik zonu.

83. Shadow CSS: .cta / border - Uklanjamo podrazumevanu border liniju dugmeta.

84. Shadow CSS: .cta / border-radius - Pil radius drži CTA vizuelno bliskim badge logici.

85. Shadow CSS: .cta / background - CTA sada koristi i jači accent token za dublji, kontrolisan gradijent.

86. Shadow CSS: .cta / color - Beli tekst drži jasan kontrast preko gradijenta.

87. Shadow CSS: .cta / font - Dugme preuzima isti font vocabulary kao i ostatak komponente.

88. Shadow CSS: .cta / font-weight - Težina fonta zatvara CTA kao jasan action element.

89. Shadow CSS: .cta / cursor - Kursor eksplicitno potvrđuje interaktivnost CTA dugmeta.

90. Shadow CSS: .cta / transition - Dodajemo finu tranziciju da hover i focus states ne deluju grubo.

91. Shadow CSS: .cta / box-shadow - Mali shadow pojačava CTA kao završni action sloj.

92. Shadow CSS: .cta:hover / filter - Hover blago podiže svetlinu CTA dugmeta bez agresivne promene boje.

93. Shadow CSS: .cta:hover / transform - Minimalni lift daje osećaj da dugme odgovara na hover.

94. Shadow CSS: .cta:active / transform - Na active vraćamo dugme nazad, da klik ima malu fizičku povratnu informaciju.

95. Shadow CSS: .cta:focus-visible / outline - Focus-visible dodaje jasan tastaturski focus ring bez oslanjanja na browser default.

96. Shadow CSS: .cta:focus-visible / outline-offset - Offset odvaja focus ring od same pil ivice dugmeta.

97. Rezime: .card u shadow-dom-style.css - Rezimiramo glavni card blok i tek sada uklanjamo njegov helper outline, jer su struktura, stil iz posebnog CSS fajla i način usvajanja stylesheet-a potpuno jasni.

98. Rezime: .eyebrow u shadow-dom-style.css - Rezimiramo eyebrow badge i uklanjamo njegov helper outline tek sada, kada slot projekcija i badge stil rade zajedno iz izdvojenog CSS fajla.

99. Rezime: .cta u shadow-dom-style.css - Rezime za CTA dugme: helper outline više nije potreban, jer završni stil iz posebnog CSS fajla, event i hover/focus ponašanje već jasno pokazuju njegovu ulogu.

100. Rezime: my-first-component host - Završni host rezime: spoljašnji outline host elementa više nije potreban, jer su API atributi, theme tokeni i adopted stylesheet tok sada jasni.

101. Rezime: .app-shell - Tek sada uklanjamo helper outline sa `.app-shell`, jer je cela cleanup lekcija kompletna i okvir više nije potreban.

102. Done: Clean My First Component with adoptedStyleSheets - Lekcija je završena: ista komponenta sada ima čistiji raspored odgovornosti. Host HTML ostaje mali, template čuva samo markup, `shadow-dom-style.css` čuva CSS, a klasa samo uvozi tekst, usvaja stylesheet i vodi lifecycle ponašanje.
