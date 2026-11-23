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

// Primeira parte feita por mim. Segunda parte feita pelo Claude
#subject("Arquitetura e Organização de Computadores (SCC0902)", lang: "riscv",
  include "Arq-Org-SCC0902/arq-org.typ",
)

// Feito por mim
#subject("Matemática Discreta (SMA0180)",
  include "Discrete-Math-SMA0180/discrete-math.typ",
)

// Claude refatorou e completou resumo.
#subject("Introdução à Ciência da Computação II (SCC0201)", lang: "c",
  include "ICC-II-SCC0201/icc2.typ",
  [
    #heading(level: 2)[Lista 2 - Complexidade]
    #set heading(offset: 2)
    #include "ICC-II-SCC0201/lista2-complexidade.typ"
  ],
)

// Claude transcreveu meu resumo do caderno
#subject("Cálculo III (SMA0355)",
  include "Calculus-III- SMA0355/calculus3.typ",
)

// Claude transcreveu meu resumo do caderno
#subject("Equações Diferenciais Ordinárias (SME0340)",
  include "ODEs-SME0340/odes.typ",
)

// Feito pelo Claude
#subject("Recuperação de Informação (SCC0282)", lang: "python",
  include "Info-Rec-SCC0282/info-rec.typ",
)

// Feito por mim
#subject("Estatística (SME0123)",
  include "Statistics-SME0123/statistics.typ",
)
