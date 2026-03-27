# CSS Foundations Path (Roadmap-first)

Purpose: prvo nauciti ciste CSS osnove po roadmap logici, pa zatim ubrzati kroz MILOS.

## 1) Zasto ovako

Ako razumes CSS fundamentals:

- lakse razumes svaki layout engine
- lakse debugujes i bez AI asistencije
- brze usvajas Flex/Grid/CQ i sve posle toga

## 2) Redosled ucenja (canonical)

1. Introduction + CSS Basics
- inline vs internal vs external CSS
- cascade order (source order)
- property/value, selector, declaration, comments
2. Syntax Basics
- simple selectors: element, class, id, universal, grouping
- combinators: descendant, child, adjacent sibling, general sibling
- attribute selectors
3. Text + Colors + Background
- font-family/style/weight/size/shorthand
- line-height, letter/word spacing, align, decoration, transform, text-shadow
- colors: named, hex, rgb/hsl, alpha channels
- background: color/image/gradient/position/attachment
- opacity
4. Box Model + Units
- content/padding/border/margin/outline
- width/height constraints
- box-shadow
- units: px/rem/em/%/vw/vh
- functions: min/max/clamp/calc
5. Display + Positioning
- display: block/inline/inline-block/none/visibility
- position: static/relative/absolute/fixed/sticky
- absolute vs relative
- z-index i stacking context
6. Pseudo selectors
- pseudo-classes: hover/focus-visible/first-child/nth-child
- pseudo-elements: before/after
7. Layouting Techniques
- flow layout
- flexbox
- grid
- kratko: float/multicol legacy awareness
8. Responsive Fundamentals
- media queries
- container queries
- responsive typography
9. CSS Variables + CSS Functions
- custom properties (`var()`)
- calc/min/max/clamp patterns
10. Best Practices
- accessibility
- performance
- maintainability discipline
11. Methodologies (overview)
- BEM
- Sass/PostCSS
- CSS Modules
- CSS-in-JS (kada i zasto)

## 3) Mapiranje na trenutni Academy classroom sadrzaj

Postojece:

- `/classroom/lesson/syntax` -> 1, 2
- `/classroom/lesson/basics` -> 4
- `/classroom/lesson/appearance` -> 3
- `/classroom/lesson/positioning` -> 5
- `/classroom/lesson/flex-flow` -> 7 (flex)
- `/classroom/lesson/grid-matrix` -> 7 (grid)
- `/classroom/lesson/responsive` -> 8
- `/classroom/lesson/variables` -> 9
- `/classroom/lesson/cascade` -> 1 (cascade/specificity/layers)

Dodati (predlog):

- `/classroom/lesson/display-visibility` (display + visibility)
- `/classroom/lesson/pseudo` (pseudo-class/element fundamentals)
- `/classroom/lesson/best-practices` (a11y/perf)
- `/classroom/lesson/methodologies` (BEM/Modules/CSS-in-JS overview)
- `/classroom/lesson/motion` (transforms/transitions/animations)

## 4) Pravilo primene u Academy

Dok ucis fundamentals:

- lekcija objasnjava cisti CSS koncept
- sandbox pokazuje koncept izolovano
- tek na kraju lekcije: "Milos bridge" (kako isti koncept izgleda u MILOS-u)

Ovo drzi putanju cistom: CSS prvo, framework posle.

## 5) Definition of done za "CSS basics complete"

1. Svaka sekcija 1-10 ima bar jednu gotovu lekciju.
2. Svaka lekcija ima challenge i expected outcome.
3. Svaka lekcija ima minimum 2 MDN reference.
4. Ucenik moze samostalno da objasni:
- cascade + specificity
- box model + units
- display/position/z-index
- flex vs grid
- media vs container queries
