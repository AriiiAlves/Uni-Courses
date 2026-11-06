// ╔══════════════════════════════════════════════════════════════════════╗
// ║      academi-notes-gr - Professional Template for Academic Writing  ║
// ║       Designed for University of Granada Students & Researchers      ║
// ║                                                                      ║
// ║   Repository: https://github.com/Miguevrgo/Typst-template-ugr       ║
// ║   License: MIT                                                       ║
// ╚══════════════════════════════════════════════════════════════════════╝

#import "@preview/fontawesome:0.5.0": *

/// Default color scheme - customize by modifying the `colors` variable
/// - primary: Used for Highlight1 boxes and main titles (Orange)
/// - secondary: Used for Highlight2 boxes and mathematical statements (Blue)
/// - accent: Used for examples and highlights (Green)
/// - text: Main text color (Dark gray)
/// - code-bg: Code block background (Light gray)
/// - example-bg: Example environment background (Light blue)
#let colors = (
  primary: rgb("#403AED"), // Orange
  secondary: rgb("#3498DB"), // Blue
  accent: rgb("#2ECC71"), // Green
  text: rgb("#2C3E50"), // Dark gray
  code-bg: rgb("#dfdeff"), // Light gray
  example-bg: rgb("#dfdeff"), // Light blue
)

// Language support for common terms
#let language-translations = (
  es: (
    "proposition": "Proposición",
    "corollary": "Corolario",
    "lemma": "Lema",
    "remark": "Observación",
    "example": "Ejemplo",
    "table-of-contents": "Índice",
  ),
  en: (
    "proposition": "Proposition",
    "corollary": "Corollary",
    "lemma": "Lemma",
    "remark": "Remark",
    "example": "Example",
    "table-of-contents": "Table of Contents",
  ),
)

#let get-translation(key, lang: "es") = {
  let dictionary = language-translations.at(lang, default: language-translations.es)
  dictionary.at(key, default: key)
}

// Translation map available for consumers; internal helpers must use it directly.
// Generic color-box for mathematical environments
#let color-box(title: "", color: black, body) = {
  block(
    width: 100%,
    stroke: 0.5pt + color,
    radius: 3pt,
    clip: true,
    below: 1.5em,
    breakable: false, // keep the title bar together with its content
  )[
    #block(
      fill: color.lighten(10%),
      width: 100%,
      inset: 8pt,
      below: 0pt,
    )[#text(fill: white, weight: "bold")[#title]]
    #block(
      fill: color.lighten(90%),
      width: 100%,
      inset: 12pt,
    )[#body]
  ]
}

// Mathematical environments
#let Highlight1(title, body) = color-box(
  title: title,
  color: colors.primary,
  body,
)

#let Highlight2(title, body) = color-box(
  title: title,
  color: colors.secondary,
  body,
)

#let proposicion(title, body) = color-box(
  title: "Proposición: " + title,
  color: colors.secondary,
  body,
)

#let proposition(title, body) = color-box(
  title: "Proposition: " + title,
  color: colors.secondary,
  body,
)

#let corolario(title, body) = color-box(
  title: "Corolario: " + title,
  color: colors.secondary,
  body,
)

#let corollary(title, body) = color-box(
  title: "Corollary: " + title,
  color: colors.secondary,
  body,
)

#let lema(title, body) = color-box(
  title: "Lema: " + title,
  color: colors.secondary,
  body,
)

#let lemma(title, body) = color-box(
  title: "Lemma: " + title,
  color: colors.secondary,
  body,
)

#let ejemplo(title, body) = color-box(
  title: "Ejemplo: " + title,
  color: colors.accent,
  body,
)

// Example environment with QED symbol
#let example(body) = block(
  fill: colors.example-bg,
  stroke: (left: 4pt + colors.secondary.lighten(30%)),
  inset: (x: 12pt, y: 12pt),
  radius: 4pt,
  width: 100%,
  below: 1em,
)[
  #text(fill: colors.secondary.darken(10%), weight: "bold", style: "italic")[Example.]\
  #body
  #h(1fr) $square$ // QED symbol
]

// Main template function
#let project(
  title: "",
  author: "",
  academic-year: "Curso 2025-2026",
  orcid: none,
  github: none,
  logo: image("./assets/USP-Logo.jpg", width: 40%),
  lang: "es",
  heading-color: colors.primary,
  body,
) = {
  set document(author: author, title: title)

  // Page setup
  set page(
    paper: "a4",
    margin: 2cm,
    header: context {
      if counter(page).get().first() > 1 {
        grid(
          columns: (1fr, 1fr),
          align(left)[#smallcaps(title)], align(right)[#counter(page).display()],
        )
        line(length: 100%, stroke: 0.5pt + gray)
      }
    },
  )

  // Text setup
  set par(justify: true, leading: 1.2em)

  // ── Code styling ─────────────────────────────────────────────────────
  // GitHub Light syntax colors (see assets/github-light.tmTheme).
  // Highlighting needs a language: tag the code (```c, ```python, ...) or set a
  // default for untagged code with `#set raw(lang: "c")`.
  set raw(
    theme: "./assets/github-light.tmTheme",
    syntaxes: "./assets/riscv.sublime-syntax", // adds ```riscv
  )
  show raw: set text(font: ("DejaVu Sans Mono", "Fira Mono"))

  let code-bg = rgb("#e4e6e9") // solid light gray
  let code-border = rgb("#bcc4cc")
  let code-text = rgb("#1f2328")
  let code-label = rgb("#6e7781")

  // Multi-line code block: gray card, syntax colors, language label.
  show raw.where(block: true): it => {
    set par(justify: false, leading: 0.65em)
    block(
      fill: code-bg,
      stroke: 0.5pt + code-border,
      inset: (x: 12pt, y: 10pt),
      radius: 6pt,
      width: 100%,
      breakable: true,
    )[
      #if it.lang != none and it.lang != "" and it.lang != "text" {
        place(top + right, dx: 6pt, dy: -6pt)[
          #text(size: 0.7em, fill: code-label, font: "DejaVu Sans")[#it.lang]
        ]
      }
      #set text(fill: code-text, size: 0.85em)
      #it
    ]
  }

  // Inline code: Notion-like gray pill with black text.
  show raw.where(block: false): it => box(
    fill: rgb("#dcdbd7"), // solid Notion-like gray (no transparency, renders in every PDF viewer)
    inset: (x: 3pt),
    outset: (y: 3pt),
    radius: 3pt,
  )[#text(fill: code-text, size: 0.92em)[#it]]

  // Heading numbering: level 1 (subject) unnumbered, level 2 -> "1.",
  // level 3 -> "1.1.", deeper levels unnumbered. Restarts in each subject.
  set heading(numbering: (..nums) => {
    let vals = nums.pos()
    if vals.len() >= 2 and vals.len() <= 3 {
      vals.slice(1).map(str).join(".") + "."
    } else {
      none
    }
  })

  // Level 1 headings - Chapter style
  // Level 1 headings:
  //  - unnumbered ones (e.g. the table of contents) keep a simple title style;
  //  - numbered ones (subjects) get a full chapter page, like a book.
  show heading.where(level: 1): it => {
    if it.numbering == none {
      pagebreak(weak: true)
      v(2em)
      text(size: 20pt, weight: "bold", fill: heading-color)[#it.body]
      v(1em)
      line(length: 100%, stroke: 1pt + heading-color)
      v(1em)
      return
    }

    // "Name (CODE)" -> title "Name" + subtitle "CODE"
    let title = it.body
    let code = none
    if it.body.has("text") {
      let m = it.body.text.match(regex("^(.*?)\s*\(([^()]+)\)$"))
      if m != none {
        title = m.captures.at(0)
        code = m.captures.at(1)
      }
    }

    page(header: none, footer: none, fill: heading-color.lighten(25%), context {
      let n = counter(heading).get().first()
      set par(justify: false, leading: 0.55em)
      align(center + horizon, stack(
        spacing: 0pt,
        text(size: 10pt, tracking: 4pt, weight: "bold", fill: white.transparentize(30%))[CAPÍTULO],
        v(1.6em),
        text(size: 80pt, weight: "bold", fill: rgb("#ffd166"))[#n], // warm gold, complementary to purple
        v(1.2em),
        block(width: 80%, text(size: 28pt, weight: "bold", fill: white)[#title]),
        v(1.4em),
        line(length: 3cm, stroke: 1.5pt + rgb("#ffd166")),
        if code != none { v(1em) },
        if code != none {
          text(size: 12pt, tracking: 2pt, fill: white.transparentize(25%))[#smallcaps(code)]
        },
      ))
    })
  }

  // Level 2 headings - Section style
  show heading.where(level: 2): it => {
    v(1.5em)
    text(size: 14pt, weight: "bold", fill: heading-color)[#it]
    v(0.75em)
  }

  // Level 3 headings - Subsection style
  show heading.where(level: 3): it => {
    v(1em)
    text(size: 12pt, weight: "bold", fill: heading-color.lighten(20%))[#it]
    v(0.5em)
  }

  // --- TITLE PAGE ---
  align(center + horizon)[
    #block(stroke: (bottom: 2pt + heading-color), width: 100%, inset: 1em)[
      #text(size: 30pt, weight: "bold", fill: heading-color)[#title]
    ]

    #v(3em)

    // Logo
    #if logo != none {
      logo
    }

    #v(3em)

    // Author
    #text(size: 16pt)[#author]
    #v(0.5em)

    // Author links
    #grid(
      columns: (auto, auto),
      gutter: 1em,
      if orcid != none {
        link(orcid)[#text(fill: rgb("#A6CE39"), size: 1.2em)[#image("./assets/orcid.svg", width: 2.7em)]]
      },
      if github != none {
        link(github)[#text(fill: black, size: 3.2em)[#image("./assets/github.png", width: 1.0em)]]
      },
    )

    #v(2em)

    // Academic year
    #text(size: 14pt, weight: "bold", fill: colors.text.lighten(30%))[#academic-year]
  ]

  // Table of Contents
  heading(level: 1, numbering: none)[#get-translation("table-of-contents", lang: lang)]
  {
    // chapters stand out in the table of contents
    show outline.entry.where(level: 1): it => block(above: 1.4em)[
      #text(weight: "bold", fill: heading-color)[#it]
    ]
    outline(title: none, indent: auto)
  }

  // Document body
  body
}
