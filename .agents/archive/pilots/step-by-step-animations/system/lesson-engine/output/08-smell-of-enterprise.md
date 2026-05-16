<!-- Generated from the source-only lesson package. -->

# 08 · UI Pricing Card — SaaS Pricing Table

Gradimo `ui-pricing-card` u dve faze: prvo zatvaramo kompletan vizuelni shell sa HTML, template i CSS slojem kao vizuelnu fazu, a tek onda uključujemo tier varijante, popular highlight, yearly/monthly billing toggle, CTA dugme sa urgency countdown timerom i feature matrix slotove kao logičku fazu.

## Goal

- Cilj: SaaS Pricing Card Widget

Prvo gradimo vizuelnu pricing karticu, a tek onda na nju primenjujemo tier varijante, toggle i countdown urgency ponašanje.

## Steps

1. Start: Empty App Shell - Počinjemo od praznog `.app-shell`. SaaS pricing kartica živi u neutralnom host okruženju.

2. HTML: ui-pricing-card Host - Dodajemo `<ui-pricing-card>` sa `tier="pro"`, `price-monthly="29"` i `price-yearly="290"`. Tag odmah kaže šta widget radi.

3. HTML: popular Boolean Attribute - Dodajemo `popular` atribut. Njegova prisutnost znači da je ova kartica istaknuta — nema vrednosti, samo postoji ili ne postoji.

4. HTML: cta-label Attribute - Dodajemo `cta-label="Start free trial"`. CTA tekst je deo javnog contract-a, ne hardkodovan u shadow DOM-u.

5. HTML: Named Slot — badge - Dodajemo `<span slot="badge">⭐ Most Popular</span>`. Parent kontroliše badge sadržaj.

6. HTML: Named Slot — features - Dodajemo `<ul slot="features">` sa pet feature stavki. Feature matrix je javna powierzchina.

7. Teaching Moment: SaaS Pricing Contract - Widget ima šest atributa: `tier`, `price-monthly`, `price-yearly`, `billing`, `popular`, `cta-label`. Ima dva named slota: `badge` i `features`. Emituje jedan namespaced event: `ui-pricing-card:subscribe`. Urgency timer je interni lifecycle detalj.

8. Template JS: Shadow DOM struktura - U `ui-pricing-card.template.js` definišemo `templateHtml`: card sa badge, tier-name, price-block (currency/amount/period), billing-toggle sa knob switch-em, feature-list slot, CTA dugme i urgency timer zona.

9. Template JS: Eksportujemo template element - Kreiramo `uiPricingCardTemplate`, dodajemo `<link>` ka shadow CSS fajlu i ubrizgavamo `${templateHtml}`.

10. JS: Uvozimo template modul - Behavior fajl uvozi `uiPricingCardTemplate` iz template modula.

11. JS: normalizeTextValue() helper - Dodajemo `normalizeTextValue()` za tekst normalizaciju sa fallback-om.

12. JS: allowedTiers Set - Zaključavamo dozvoljene tier vrednosti: `starter`, `pro`, `enterprise`.

13. JS: normalizeTierValue() helper - Nepoznat tier automatski pada na `starter`.

14. JS: parsePriceValue() helper - Dodajemo `parsePriceValue()` koji parira cenu u broj i vraća 0 za nevalidan ulaz.

15. JS: formatTimeRemaining() helper - Dodajemo `formatTimeRemaining()` koji formatira sekunde u `HH:MM:SS` string za urgency timer.

16. JS: tierDisplayName mapa - Dodajemo mapu tier → display name. UI labela ne sme da bude isti string kao API vrednost.

17. JS: UiPricingCard extends HTMLElement - Klasa nosi domain-driven ime konzistentno sa tagom.

18. JS: observedAttributes — svih šest - Komponenta prati `tier`, `price-monthly`, `price-yearly`, `billing`, `popular` i `cta-label`.

19. JS: constructor otvara shadow root - Konstruktor samo priprema instancu: shadow root, bind-ove i nulte reference.

20. JS: constructor pre-binduje handlere - Vezujemo `handleCtaClick` i `handleToggleClick` jednom pri kreiranju instance.

21. JS: constructor priprema interne reference - Nulujemo DOM reference, binding flagove, timer ID i urgency preostalo vreme.

22. JS: connectedCallback — lifecycle ulaz - Connected lifecycle je glavni ulaz kada pricing kartica uđe u DOM.

23. JS: connectedCallback poziva setupTemplateOnce - Montiramo template u shadow root jednom.

24. JS: connectedCallback poziva cacheDom - Keširamo pet DOM referenci.

25. JS: connectedCallback sinhronizuje atribute - Pozivamo `syncFromAttributes()` za inicijalni render pass.

26. JS: connectedCallback zakačuje evente - Vezujemo CTA i toggle click listenere.

27. JS: connectedCallback pokreće urgency timer - Pozivamo `startUrgencyTimer()` koji pokreće interval sa countdown-om od 1h.

28. JS: disconnectedCallback — čisti sve - Na izlazu iz DOM-a skidamo evente i zaustavljamo urgency timer.

29. JS: precizan attributeChangedCallback - Potpis prima `name`, `oldValue` i `newValue` za granularni update.

30. JS: guard za iste vrednosti i disconnected stanje - Odmah izlazimo ako se vrednost nije promenila ili widget nije u DOM-u.

31. JS: switch — precizan update po atributu - Tier menja labelu, price/billing/yearly menjaju prikazanu cenu i toggle, cta-label menja dugme.

32. JS: tier getter - Getter vraća normalizovani tier sa fallback-om na `starter`.

33. JS: tier setter - Setter normalizuje i piše nazad u atribut.

34. JS: priceMonthly getter - Getter parsira mesečnu cenu u bezbedan broj.

35. JS: priceYearly getter - Getter parsira godišnju cenu na isti način.

36. JS: billing getter - Getter vraća `monthly` ili `yearly` — samo dve opcije.

37. JS: billing setter - Setter piše normalizovani billing nazad u atribut.

38. JS: popular getter - Boolean getter čita hasAttribute.

39. JS: ctaLabel getter - Getter vraća normalizovan CTA tekst sa fallback-om.

40. JS: setupTemplateOnce() - Template mount za reusable kloniranje.

41. JS: guard sprečava dupliranje - Kloniramo template samo ako shadow root nema dece.

42. JS: cacheDom — samo kešira reference - Querijemo šest internih elemenata i čuvamo na instanci.

43. JS: cacheDom kešira .tier-name - Tier name span čuvamo za updateTierName.

44. JS: cacheDom kešira .price-amount - Price amount element čuvamo za dinamičko menjanje cene.

45. JS: cacheDom kešira .price-period - Price period span čuvamo za dinamičko menjanje tekstualne labele (/mo ili /yr).

46. JS: cacheDom kešira .cta - CTA dugme čuvamo za tekst i event binding.

47. JS: cacheDom kešira .toggle-switch - Toggle switch čuvamo za aria-checked i event.

48. JS: cacheDom kešira .urgency-text - Urgency text element čuvamo za timer update.

49. JS: syncFromAttributes() - Centralna one-time inicijalizacija DOM-a iz atributa.

50. JS: sync poziva četiri update metode - Pozivamo `updateTierName()`, `updatePrice()`, `updateToggleState()` i `updateCtaLabel()`.

51. JS: updateTierName() - Piše display name tiera u naslov. `pro` → `Pro`.

52. JS: updatePrice() - Čita `billing` da odluči monthly ili yearly cenu i piše broj u DOM.

53. JS: updateCtaLabel() - Piše CTA tekst i postavlja aria-label sa tier kontekstom.

54. JS: updateToggleState() - Ažurira `aria-checked` na toggle switch-u prema billing stanju.

55. JS: startUrgencyTimer() - Pokreće setInterval koji svake sekunde smanjuje urgencyRemaining i ažurira prikaz.

56. JS: stopUrgencyTimer() - Čisti interval i postavlja ID na null.

57. JS: updateUrgencyDisplay() - Formatira preostalo vreme u `HH:MM:SS` i piše u urgency-text element.

58. JS: bindEvents() - Event wiring ostaje u sopstvenoj responsibility metodi.

59. JS: bindEvents kači CTA listener - Guard sprečava dvostruki binding. CTA click emituje subscribe event.

60. JS: bindEvents kači toggle listener - Toggle click menja billing atribut. Guard sprečava dvostruki binding.

61. JS: unbindEvents() - Cleanup metoda za oba listenera.

62. JS: unbindEvents skida CTA listener - Proveri flag pre skidanja — izbjagava grešku na disconnect bez prethodnog bind-a.

63. JS: unbindEvents skida toggle listener - Isti pattern: flag check, remove, reset.

64. JS: handleCtaClick() - CTA handler emituje namespaced event.

65. JS: ui-pricing-card:subscribe event - Emitujemo `ui-pricing-card:subscribe` sa `{tier, price, billing, ctaLabel, source}` detail-om.

66. JS: handleToggleClick() — billing toggle - Klik na toggle menja billing sa monthly na yearly (ili obrnuto). Setter upisuje atribut → attributeChangedCallback → updatePrice + updateToggleState.

67. JS: guard pre registracije - Proveravamo da li je element već registrovan.

68. JS: registrujemo ui-pricing-card - `customElements.define("ui-pricing-card", UiPricingCard)` — pricing kartica je spremna.

69. CSS: .app-shell / outline - Dodajemo tanak helper outline za `.app-shell` i držimo ga do završnog shell rezimea.

70. CSS: .app-shell / padding - Padding drži scenu urednom.

71. CSS: .app-shell / display - Grid pravi jedinstven host za pricing card.

72. CSS: .app-shell / place-items - Centar drži fokus na jednom pricing card-u.

73. CSS: .app-shell / min-height - Puna visina drži tamnu pozadinu stabilnom.

74. CSS: .app-shell / background - Tamna pozadina naglašava SaaS pricing card.

75. CSS: ui-pricing-card / outline - Dodajemo host helper outline i držimo ga do završnog rezimea.

76. CSS: ui-pricing-card / display - Block display pravi stabilan footprint.

77. CSS: ui-pricing-card / width - Širina pricing card-a ostaje ograničena i predvidiva.

78. CSS: ui-pricing-card / position - Relative za popular state i buduće overlay-e.

79. CSS: ui-pricing-card / --pricing-surface - Surface token vodi pozadinu card-a.

80. CSS: ui-pricing-card / --pricing-surface-alt - Alternativna površina zatvara gradijent.

81. CSS: ui-pricing-card / --pricing-border - Border token drži ivice nežnim.

82. CSS: ui-pricing-card / --pricing-accent - Accent token vodi CTA, badge i tier boju.

83. CSS: ui-pricing-card / --pricing-accent-strong - Jači accent zatvara CTA gradijent.

84. CSS: ui-pricing-card / --pricing-text - Text token čuva kontrast.

85. CSS: ui-pricing-card / --pricing-muted - Muted token pokriva sekundarne labele.

86. CSS: ui-pricing-card / --pricing-shadow - Shadow je javni token, ne interni magic number.

87. CSS: ui-pricing-card / --pricing-popular-glow - Popular glow token priprema highlight efekat za istaknutu karticu.

88. CSS: ui-pricing-card[tier="starter"] / --pricing-accent - Starter tier dobija ljubičasti accent.

89. CSS: ui-pricing-card[tier="starter"] / --pricing-accent-strong - Jači ljubičasti ton za CTA gradijent.

90. CSS: ui-pricing-card[tier="pro"] / --pricing-accent - Pro tier koristi default sky blue accent.

91. CSS: ui-pricing-card[tier="pro"] / --pricing-accent-strong - Jači blue ton za pro CTA.

92. CSS: ui-pricing-card[tier="enterprise"] / --pricing-accent - Enterprise tier dobija amber accent.

93. CSS: ui-pricing-card[tier="enterprise"] / --pricing-accent-strong - Jači amber ton za enterprise CTA.

94. CSS: ui-pricing-card[popular] / box-shadow - Popular kartica dobija glow efekat.

95. CSS: ui-pricing-card[popular] / transform - Blagi scale ističe popularnu opciju.

96. CSS: ui-pricing-card[popular] / z-index - Z-index drži popularnu karticu iznad susednih u grid-u.

97. Teaching Moment: Tier + Popular + Billing Contract - Host CSS je definisao token contract, tier accent varijante i popular state highlight. Shadow CSS sada stilizuje card internals: badge, cenu, toggle switch, feature listu, CTA i urgency timer. Toggle vizuelni efekat dolazi iz `:host([billing="yearly"])` selectora — CSS automatski reaguje na atribut.

98. Shadow CSS: :host / display - Shadow host potvrđuje block model iznutra.

99. Shadow CSS: :host / font-family - Font stack je interni shadow contract.

100. Shadow CSS: :host / color - Boja čita spoljašnji text token.

101. Shadow CSS: .card / outline - Dodajemo helper outline za card blok.

102. Shadow CSS: .card / display - Card koristi grid za vertikalni stack svih zona.

103. Shadow CSS: .card / gap - Gap odvaja badge, tier, cenu, toggle, feature listu i CTA.

104. Shadow CSS: .card / padding - Padding pravi pravi card footprint.

105. Shadow CSS: .card / border-radius - Zaobljenje daje modernu siluetu.

106. Shadow CSS: .card / border - Border čita host token.

107. Shadow CSS: .card / background - Card pozadina čita host surface tokene.

108. Shadow CSS: .card / box-shadow - Shadow dolazi iz host contract-a.

109. Shadow CSS: .card / text-align - Card sadržaj se centrira.

110. Shadow CSS: .popular-badge / outline - Dodajemo helper outline za popular badge.

111. Shadow CSS: .popular-badge / display - Badge je sakriveno po defaultu.

112. Shadow CSS: .popular-badge / padding - Padding pravi pill footprint.

113. Shadow CSS: .popular-badge / border-radius - Veliki radius pravi kapsulu.

114. Shadow CSS: .popular-badge / background - Badge pozadina čita tier accent tokene.

115. Shadow CSS: .popular-badge / color - Beli tekst drži kontrast.

116. Shadow CSS: .popular-badge / font-size - Mali font čini badge kompaktnim.

117. Shadow CSS: .popular-badge / font-weight - Bold drži badge labelu čitkom.

118. Shadow CSS: .popular-badge / letter-spacing - Tracking drži badge urednim.

119. Shadow CSS: .popular-badge / text-transform - Uppercase za badge kategorijsku labelu.

120. Shadow CSS: .popular-badge / width - Širina samo za sadržaj.

121. Shadow CSS: .popular-badge / justify-self - Centriramo badge horizontalno.

122. Shadow CSS: :host([popular]) .popular-badge / display - Kada je popular atribut prisutan, badge postaje vidljiv.

123. Shadow CSS: ::slotted([slot="badge"]) / font - Slotovani badge sadržaj nasleđuje font.

124. Shadow CSS: .tier-name / margin - Brišemo podrazumevani heading margin.

125. Shadow CSS: .tier-name / font-size - Tier ime dobija kompaktnu veličinu.

126. Shadow CSS: .tier-name / font-weight - Bold drži tier ime jasnim.

127. Shadow CSS: .tier-name / text-transform - Uppercase pojačava hijerarhiju.

128. Shadow CSS: .tier-name / letter-spacing - Tracking za tier labelu.

129. Shadow CSS: .tier-name / color - Tier ime čita accent token — menja se sa tier variantom.

130. Shadow CSS: .price-block / outline - Dodajemo helper outline za price blok.

131. Shadow CSS: .price-block / display - Flex pravi horizontalni raspored valuta/iznos/period.

132. Shadow CSS: .price-block / align-items - Baseline poravnavanje drži $ i /mo uz velik iznos.

133. Shadow CSS: .price-block / justify-content - Centriramo cenu horizontalno.

134. Shadow CSS: .price-block / gap - Minimalni gap između delova cene.

135. Shadow CSS: .price-currency / font-size - Valuta dobija manji ali jasno vidljiv font.

136. Shadow CSS: .price-currency / font-weight - Bold za valutu.

137. Shadow CSS: .price-currency / color - Valuta čita muted token.

138. Shadow CSS: .price-amount / font-size - Velika veličina dominira karticom.

139. Shadow CSS: .price-amount / font-weight - Extra bold naglašava cenu.

140. Shadow CSS: .price-amount / line-height - Line-height drži broj zategnutim.

141. Shadow CSS: .price-amount / transition - Tranzicija omogućava future animaciju pri promeni.

142. Shadow CSS: .price-period / font-size - Period je sekundaran.

143. Shadow CSS: .price-period / color - Period čita muted token.

144. Shadow CSS: .price-period / font-weight - Medium weight za period.

145. Shadow CSS: .billing-toggle / outline - Dodajemo helper outline za billing toggle.

146. Shadow CSS: .billing-toggle / display - Flex slaže labele i switch horizontalno.

147. Shadow CSS: .billing-toggle / align-items - Centriramo elemente vertikalno.

148. Shadow CSS: .billing-toggle / justify-content - Centriramo ceo toggle.

149. Shadow CSS: .billing-toggle / gap - Gap odvaja labele od switch-a.

150. Shadow CSS: .toggle-label / font-size - Kompaktan font za toggle labele.

151. Shadow CSS: .toggle-label / color - Muted boja za neupadljivost.

152. Shadow CSS: .toggle-label / font-weight - Medium weight za labele.

153. Shadow CSS: .toggle-label / transition - Tranzicija za smooth promenu.

154. Shadow CSS: .toggle-switch / appearance - Gasimo native izgled.

155. Shadow CSS: .toggle-switch / width - Switch širina.

156. Shadow CSS: .toggle-switch / height - Switch visina.

157. Shadow CSS: .toggle-switch / border-radius - Zaobljenje za pill oblik.

158. Shadow CSS: .toggle-switch / border - Uklanjamo border.

159. Shadow CSS: .toggle-switch / background - Neutralna toggle pozadina — menja se na yearly.

160. Shadow CSS: .toggle-switch / cursor - Pointer kursor za klikabilnost.

161. Shadow CSS: .toggle-switch / position - Relative za knob pozicioniranje.

162. Shadow CSS: .toggle-switch / padding - Padding oko knob-a.

163. Shadow CSS: .toggle-switch / transition - Glatki prelaz pozadine.

164. Shadow CSS: .toggle-knob / display - Block za knob.

165. Shadow CSS: .toggle-knob / width - Knob veličina.

166. Shadow CSS: .toggle-knob / height - Visina jednaka širini.

167. Shadow CSS: .toggle-knob / border-radius - Kružni knob.

168. Shadow CSS: .toggle-knob / background - Beli knob.

169. Shadow CSS: .toggle-knob / transition - Glatki prelaz pozicije.

170. Shadow CSS: :host([billing="yearly"]) .toggle-switch / background - Na yearly, switch postaje accent boja.

171. Shadow CSS: :host([billing="yearly"]) .toggle-knob / transform - Knob se pomera desno na yearly.

172. Shadow CSS: .save-badge / font-size - Save badge je mali ali upadljiv.

173. Shadow CSS: .save-badge / background - Zelena pozadina signalizira uštedu.

174. Shadow CSS: .save-badge / color - Zeleni tekst za save signal.

175. Shadow CSS: .save-badge / padding - Mali padding.

176. Shadow CSS: .save-badge / border-radius - Blago zaobljenje.

177. Shadow CSS: .save-badge / font-weight - Bold za isticanje.

178. Shadow CSS: .feature-list / outline - Dodajemo helper outline za feature listu.

179. Shadow CSS: .feature-list / padding - Vertikalni padding za feature zonu.

180. Shadow CSS: ::slotted(ul) / list-style - Brišemo bullet-e.

181. Shadow CSS: ::slotted(ul) / margin - Brišemo default margin.

182. Shadow CSS: ::slotted(ul) / padding - Brišemo default padding.

183. Shadow CSS: ::slotted(ul) / display - Grid za feature listu.

184. Shadow CSS: ::slotted(ul) / gap - Razmak između feature stavki.

185. Shadow CSS: ::slotted(ul) / text-align - Feature stavke su levo poravnate.

186. Shadow CSS: ::slotted(ul) / font-size - Kompaktan font za feature listu.

187. Shadow CSS: ::slotted(ul) / color - Feature tekst čita muted token.

188. Shadow CSS: .cta / outline - Dodajemo helper outline za CTA dugme.

189. Shadow CSS: .cta / appearance - Gasimo native button izgled.

190. Shadow CSS: .cta / width - CTA zauzima punu širinu.

191. Shadow CSS: .cta / padding - Padding pravi klik zonu.

192. Shadow CSS: .cta / border - Brišemo border.

193. Shadow CSS: .cta / border-radius - Zaobljeno dugme.

194. Shadow CSS: .cta / background - CTA gradijent čita tier tokene — menja se sa varijantom.

195. Shadow CSS: .cta / color - Beli tekst za kontrast.

196. Shadow CSS: .cta / font - Preuzima font.

197. Shadow CSS: .cta / font-size - Solidna veličina za action.

198. Shadow CSS: .cta / font-weight - Bold za jasnoću.

199. Shadow CSS: .cta / cursor - Kursor potvrđuje interakciju.

200. Shadow CSS: .cta / transition - Tranzicije za glatki response.

201. Shadow CSS: .cta / box-shadow - CTA shadow dodaje dubinu.

202. Shadow CSS: .cta:hover / filter - Na hover blago podižemo svetlinu.

203. Shadow CSS: .cta:hover / transform - Blagi lift na hover.

204. Shadow CSS: .cta:active / transform - Na active vraćamo dugme.

205. Shadow CSS: .cta:focus-visible / outline - Focus ring za tastatursku navigaciju.

206. Shadow CSS: .cta:focus-visible / outline-offset - Offset odvaja ring od dugmeta.

207. Shadow CSS: .urgency / outline - Dodajemo helper outline za urgency timer zonu.

208. Shadow CSS: .urgency / display - Flex slaže ikonu i tekst.

209. Shadow CSS: .urgency / align-items - Centriramo vertikalno.

210. Shadow CSS: .urgency / justify-content - Centriramo horizontalno.

211. Shadow CSS: .urgency / gap - Gap između ikone i teksta.

212. Shadow CSS: .urgency / font-size - Kompaktan font.

213. Shadow CSS: .urgency / color - Narandžasta boja za urgency signal.

214. Shadow CSS: .urgency / font-weight - Semi-bold za urgentnost.

215. Rezime: .card - Uklanjamo card helper outline.

216. Rezime: .popular-badge - Uklanjamo badge helper outline.

217. Rezime: .price-block - Uklanjamo price helper outline.

218. Rezime: .billing-toggle - Uklanjamo billing toggle helper outline.

219. Rezime: .feature-list - Uklanjamo feature list helper outline.

220. Rezime: .cta - Uklanjamo CTA helper outline.

221. Rezime: .urgency - Uklanjamo urgency timer helper outline.

222. Rezime: ui-pricing-card host - Uklanjamo host helper outline.

223. Rezime: .app-shell - Uklanjamo shell helper outline.

224. Done: UI Pricing Card — SaaS Pricing Table - `ui-pricing-card` je završen: `index.html` deklarativno koristi tier/price/popular atribute i feature slot, `ui-pricing-card.template.js` drži shadow strukturu, `ui-pricing-card.js` vodi property API, billing toggle, urgency timer i subscribe event, `style.css` theme-uje host sa tier varijantama, a `ui-pricing-card.shadow.css` drži unutrašnji styling sa toggle animacijom.

## Homework

- Napravi grid od tri kartice (starter/pro/enterprise) sa različitim feature listama i cenama.

- Dodaj `urgency-seconds` atribut umesto hardkodovanih 3600 sekundi za veću fleksibilnost.

- Implementiraj dynamic pricing calc: dodaj `seats` atribut i množji cenu sa brojem mesta.

- Dodaj `discount-code` atribut koji primeni popust i prikaže precrtan originalni iznos.
