#import "../lib.typ": *

= Ex. 1: menor $n$ com $100 n^2 < 2^n$

Basta testar inteiros, pois a exponencial passa a quadrática e não volta mais:

#align(center, table(
  columns: 4,
  inset: 6pt,
  align: center,
  stroke: 0.5pt + colors.primary,
  table.header([$n$], [$100 n^2$], [$2^n$], []),
  [14], [19 600], [16 384], [#sym.crossmark],
  [15], [22 500], [32 768], [#sym.checkmark],
))

*Resposta:* $n = 15$.

#Highlight1("Solução analítica (função W de Lambert)")[
  $W$ é a inversa de $f(x) = x e^x$: se $x e^x = y$, então $x = W(y)$.

  $ 2^n = 100 n^2 arrow.r.double e^(n ln 2 \/ 2) = 10 n arrow.r.double (-(ln 2)/2 n) e^(-(ln 2)/2 n) = -(ln 2)/20 $
  $ n = -2/(ln 2) W(-(ln 2)/20) approx 14.32 quad "(ramo " W_(-1) ")" $
  O próximo inteiro é $n = 15$.
]

= Ex. 2: "no mínimo $cal(O)(n^2)$"

$cal(O)$ é um limite *superior*, então "no mínimo $cal(O)(n^2)$" não diz nada: qualquer algoritmo, até um de custo constante, é $cal(O)(n^2)$. Para um limite inferior, usa-se $Omega$: "o tempo é $Omega(n^2)$".

= Ex. 3: $2^(n+1) = cal(O)(2^n)$? $2^(2n) = cal(O)(2^n)$?

- $2^(n+1) = 2 dot 2^n <= c dot 2^n$ com $c = 2$. *Sim.*
- $2^(2n) = 4^n$, e $4^n <= c dot 2^n arrow.l.r.double 2^n <= c$, falso para $n$ grande. *Não.*

= Ex. 5: $T(n) = T(n-1) + n$ é $cal(O)(n^2)$

Expandindo a recorrência até a base $T(1) = 1$:
$ T(n) = n + (n - 1) + dots.c + 2 + 1 = sum_(i=1)^n i = (n(n+1))/2 = cal(O)(n^2) $
