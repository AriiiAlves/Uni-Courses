#import "./lib.typ": *

#show: project.with(
	title: "Notes on ...",
	author: "Ariel Alves da Silva",
	academic-year: "Academic year 2026",
	orcid: "https://orcid.org/xxxx-xxxx-xxxx-xxxx", // Your number
	github: "https://github.com/AriiiAlves",
)

#set heading(numbering: (..nums) => {
  let vals = nums.pos()
  if vals.len() <= 2 {
    vals.map(str).join(".") + "."
  } else {
    none
  }
})

= Tema 1

Esta es una introducción al tema. Typst ajusta el texto automáticamente.


== Espacios de Probabilidad

#definition("Espacio de Probabilidad")[
  Un espacio de probabilidad es una terna $(Omega, cal(A), P)$ donde:
  - $Omega$: Espacio muestral.
  - $cal(A)$: $sigma$-álgebra de sucesos.
  - $P$: Medida de probabilidad tal que $P(Omega)=1$.
]

#theorem("Teorema Central del Límite")[
  Dadas $X_1, ..., X_n$ v.a. i.i.d con media $mu$ y varianza $sigma^2$:
  $ sqrt(n) (bar(X)_n - mu) / sigma arrow.r N(0,1) $
]

#proof[
  La demostración se basa en la función característica. Sea $phi_X(t)$ la función característica...

  Como vemos, es trivial.
]

#proposition("Name")[
	Content
]

#corollary("Name")[
	Content
]

== Código en Rust
Aquí tienes un ejemplo de código con resaltado automático:

```rust
fn main() {
    let x: Vec<i32> = vec![1, 2, 3];
    println!("El vector es: {:?}", x);
}
```

