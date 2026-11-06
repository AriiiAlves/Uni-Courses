#import "./lib.typ": *

#show: project.with(
	title: "Notas de Aula",
	author: "Ariel Alves da Silva",
	academic-year: "Academic year 2026",
	orcid: "https://orcid.org/xxxx-xxxx-xxxx-xxxx", // Your number
	github: "https://github.com/AriiiAlves",
)

// Subjects are level-1 headings; each subject's own headings are pushed
// one level down via `heading(offset: ...)`, so the note files stay untouched.
// Heading numbering is defined in lib.typ.

// Adds a subject chapter and includes its notes one heading level below it.
// `lang` is the default syntax highlighting for that subject's untagged code.
#let subject(name, lang: none, ..files) = {
  heading(level: 1, name)
  set heading(offset: 1)
  set raw(lang: lang) if lang != none
  for f in files.pos() { f }
}

#subject("Arquitetura e Organização de Computadores (SCC0902)", lang: "riscv",
  include "Arq-Org-SCC0902/arq-org.typ",
)

#subject("Matemática Discreta (SMA0180)",
  include "Discrete-Math-SMA0180/discrete-math.typ",
)

#subject("Introdução à Ciência da Computação II (SCC0201)", lang: "c",
  include "ICC2-SCC0201/icc2.typ",
  [
    #heading(level: 2)[Lista 2 - Complexidade]
    #set heading(offset: 2)
    #include "ICC2-SCC0201/lista2-complexidade.typ"
  ],
)

#subject("Equações Diferenciais Ordinárias (SME0340)",
  include "ODEs-SME0340/odes.typ",
)

// TODO: iot.typ is written in Markdown syntax (`* item`, `**bold**`, LaTeX math)
// and does not compile as Typst yet. Uncomment once it is converted.
// #subject("Internet das Coisas (SSC0952)", lang: "cpp",
//   include "IoT-SSC0952/iot.typ",
// )

#subject("Estatística (SME0123)",
  include "Statistics-SME0123/statistics.typ",
)
