#import "../lib.typ": *
#import "@preview/cetz:0.3.4": canvas, draw

// Helpers for the redrawn figures
#let fig-stroke = 0.8pt + colors.text
#let accent-stroke = 0.9pt + colors.primary
#let fill-soft = colors.primary.lighten(85%)
// oblique projection for pseudo-3D drawings: x goes to the lower left
#let p3(x, y, z) = (y - 0.55 * x, z - 0.4 * x)

= Integrais múltiplas

== Integrais iteradas

Sejam $a <= x <= b$ ($x in [a, b]$), $c <= y <= d$ ($y in [c, d]$) e $f(x, y)$ contínua ou com saltos finitos.

+ Fixando $y$ e variando $x$, obtemos a *área* de uma fatia:
  $ F(y) = integral_a^b f(x, y) dif x $
  ($F$ é a antiderivada com $y$ fixo: área sob $f$ ao longo de $x$.)
+ Deslocando essa fatia em $y$, somamos as áreas e obtemos o *volume*:
  $ integral_c^d F(y) dif y = integral_c^d [integral_a^b f(x, y) dif x] dif y $
  Se os limites em $x$ dependem de $y$, ao deslocar em $y$ a integral $integral dif y$ considera essa variação.

#figure(
  canvas(length: 1cm, {
    import draw: *
    let s = fig-stroke
    line(p3(0, 0, 0), p3(4.2, 0, 0), mark: (end: "stealth"), stroke: s)
    line(p3(0, 0, 0), p3(0, 4.6, 0), mark: (end: "stealth"), stroke: s)
    line(p3(0, 0, 0), p3(0, 0, 3.2), mark: (end: "stealth"), stroke: s)
    content(p3(4.5, 0, 0), $x$)
    content(p3(0, 4.9, 0), $y$)
    content(p3(0, 0, 3.45), $f(x, y)$)
    // base rectangle [a,b] x [c,d]
    let (a, b, c, d) = (0.8, 3.2, 0.8, 3.8)
    line(p3(a, c, 0), p3(b, c, 0), p3(b, d, 0), p3(a, d, 0), close: true,
      stroke: (paint: gray, dash: "dashed"))
    let h(x, y) = 1.6 + 0.35 * calc.sin(y * 1.7) + 0.25 * calc.cos(x * 1.3)
    // top surface edges
    let edge(pts) = line(..pts, stroke: accent-stroke)
    edge(range(0, 21).map(k => { let y = c + (d - c) * k / 20; p3(a, y, h(a, y)) }))
    edge(range(0, 21).map(k => { let y = c + (d - c) * k / 20; p3(b, y, h(b, y)) }))
    edge(range(0, 21).map(k => { let x = a + (b - a) * k / 20; p3(x, c, h(x, c)) }))
    edge(range(0, 21).map(k => { let x = a + (b - a) * k / 20; p3(x, d, h(x, d)) }))
    // vertical edges
    for (x, y) in ((a, c), (b, c), (b, d), (a, d)) {
      line(p3(x, y, 0), p3(x, y, h(x, y)), stroke: (paint: gray, thickness: 0.5pt))
    }
    // slice at y0
    let y0 = 2.4
    let top = range(0, 21).map(k => { let x = a + (b - a) * k / 20; p3(x, y0, h(x, y0)) })
    line(p3(a, y0, 0), ..top, p3(b, y0, 0), close: true,
      fill: colors.primary.lighten(70%), stroke: accent-stroke)
    content(p3(b, y0, 0), text(fill: colors.primary)[$F(y)$], anchor: "north-west")
    line(p3(a, 0, 0), p3(a, c, 0), stroke: (paint: gray, dash: "dotted"))
    line(p3(b, 0, 0), p3(b, c, 0), stroke: (paint: gray, dash: "dotted"))
    content(p3(a, 0, 0), $a$, anchor: "south-east")
    content(p3(b, 0, 0), $b$, anchor: "south-east")
    content(p3(0, c, 0), $c$, anchor: "south")
    content(p3(0, d, 0), $d$, anchor: "south")
  }),
  caption: [A fatia em $y$ tem área $F(y)$; somando as fatias de $c$ a $d$, temos o volume.],
)

#Highlight1("Integrais iteradas")[
  Integrais iteradas calculam *volume*! Em particular, $integral.double 1 dif x dif y$ calcula a *área* da região (área $times$ altura 1).
]

== Regiões não retangulares

As funções que limitam a região simplesmente viram os limites de integração, pois eles variam conforme nos deslocamos.

#figure(
  grid(
    columns: 2,
    gutter: 2.5em,
    canvas(length: 1cm, {
      import draw: *
      line((-0.2, 0), (4.2, 0), mark: (end: "stealth"), stroke: fig-stroke)
      line((0, -0.2), (0, 3), mark: (end: "stealth"), stroke: fig-stroke)
      content((4.35, 0), $x$, anchor: "west")
      content((0, 3.15), $y$, anchor: "south")
      let g1(x) = 0.5 + 0.25 * calc.sin(x * 2)
      let g2(x) = 2.1 + 0.35 * calc.sin(x * 1.5 + 1)
      let xs = range(0, 21).map(k => 0.6 + 2.8 * k / 20)
      line(..xs.map(x => (x, g1(x))), ..xs.rev().map(x => (x, g2(x))), close: true,
        fill: fill-soft, stroke: none)
      line(..xs.map(x => (x, g1(x))), stroke: accent-stroke)
      line(..xs.map(x => (x, g2(x))), stroke: accent-stroke)
      line((0.6, 0), (0.6, g2(0.6)), stroke: (paint: gray, dash: "dashed"))
      line((3.4, 0), (3.4, g2(3.4)), stroke: (paint: gray, dash: "dashed"))
      content((0.6, -0.25), $a$, anchor: "north")
      content((3.4, -0.25), $b$, anchor: "north")
      content((3.5, g2(3.4)), $g_2(x)$, anchor: "west")
      content((3.5, g1(3.4)), $g_1(x)$, anchor: "west")
    }),
    canvas(length: 1cm, {
      import draw: *
      line((-0.2, 0), (3.6, 0), mark: (end: "stealth"), stroke: fig-stroke)
      line((0, -0.2), (0, 3.6), mark: (end: "stealth"), stroke: fig-stroke)
      content((3.75, 0), $x$, anchor: "west")
      content((0, 3.75), $y$, anchor: "south")
      let h1(y) = 1.0 + 0.25 * calc.sin(y * 2)
      let h2(y) = 2.6 + 0.35 * calc.sin(y * 1.5)
      let ys = range(0, 21).map(k => 0.6 + 2.6 * k / 20)
      line(..ys.map(y => (h1(y), y)), ..ys.rev().map(y => (h2(y), y)), close: true,
        fill: fill-soft, stroke: none)
      line(..ys.map(y => (h1(y), y)), stroke: accent-stroke)
      line(..ys.map(y => (h2(y), y)), stroke: accent-stroke)
      line((0, 0.6), (h2(0.6), 0.6), stroke: (paint: gray, dash: "dashed"))
      line((0, 3.2), (h2(3.2), 3.2), stroke: (paint: gray, dash: "dashed"))
      content((-0.2, 0.6), $c$, anchor: "east")
      content((-0.2, 3.2), $d$, anchor: "east")
      content((h2(1.9) + 0.12, 1.9), $h_2(y)$, anchor: "west")
      content((h1(1.9) - 0.12, 1.9), $h_1(y)$, anchor: "east")
    }),
  ),
  caption: [Caso 1 (esquerda): $y$ entre duas funções de $x$. Caso 2 (direita): $x$ entre duas funções de $y$.],
)

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  Highlight1("Caso 1: " + $y(x)$ + ", " + $x in [a, b]$)[
    $g_1(x) <= y <= g_2(x)$
    $ integral_a^b integral_(g_1(x))^(g_2(x)) f(x, y) dif y dif x $
  ],
  Highlight1("Caso 2: " + $x(y)$ + ", " + $y in [c, d]$)[
    $h_1(y) <= x <= h_2(y)$
    $ integral_c^d integral_(h_1(y))^(h_2(y)) f(x, y) dif x dif y $
  ],
)

- Uma $integral.double$ com os 4 limites sendo funções *não existe*: a integral mais externa sempre é um intervalo de constantes. Se não, sobrariam variáveis que não podem ser integradas.
- *Obs.:* integrais internas não podem ter limites com variáveis que já foram integradas.

#Highlight2("Teorema de Fubini")[
  Se $f(x, y)$ for contínua e a região de integração $R = [a, b] times [c, d]$ for um retângulo, a ordem de integração não importa:
  $ integral.double_R f(x, y) dif A = integral_a^b integral_c^d f(x, y) dif y dif x = integral_c^d integral_a^b f(x, y) dif x dif y $
]

== Mudança de variáveis

O objetivo é *simplificar a região de integração*.

#figure(
  canvas(length: 1cm, {
    import draw: *
    // uv plane
    line((-0.2, 0), (3, 0), mark: (end: "stealth"), stroke: fig-stroke)
    line((0, -0.2), (0, 2.4), mark: (end: "stealth"), stroke: fig-stroke)
    content((3.15, 0), $u$, anchor: "west")
    content((0, 2.55), $v$, anchor: "south")
    rect((0.4, 0.4), (2.4, 1.4), fill: fill-soft, stroke: accent-stroke)
    content((1.4, 0.9), $S$)
    content((1.4, -0.5), text(size: 9pt)[região $S$])
    // map arrow
    line((3.6, 1.2), (5.2, 1.2), mark: (end: "stealth"), stroke: fig-stroke)
    content((4.4, 1.5), $T(u, v)$, anchor: "south")
    // xy plane
    line((5.8, 0), (9, 0), mark: (end: "stealth"), stroke: fig-stroke)
    line((6, -0.2), (6, 2.8), mark: (end: "stealth"), stroke: fig-stroke)
    content((9.15, 0), $x$, anchor: "west")
    content((6, 2.95), $y$, anchor: "south")
    let lo = range(0, 21).map(k => { let t = k / 20; (6.4 + 2.2 * t, 0.35 + 1.2 * t * t) })
    let hi = range(0, 21).map(k => { let t = k / 20; (6.4 + 2.2 * t, 1.2 + 1.3 * t * t) }).rev()
    line(..lo, ..hi, close: true, fill: fill-soft, stroke: accent-stroke)
    content((7.6, 1.15), $R$)
    content((7.5, -0.5), text(size: 9pt)[região $R$])
  }),
  caption: [Uma região simples $S$ no plano $u v$ é levada por $T$ na região $R$ do plano $x y$.],
)

#Highlight2("Teorema da mudança de variáveis")[
  Seja $f: D subset RR^2 -> RR$ contínua e $phi: B -> D$ de classe $C^1$ e injetora. Então
  $ "Área"(phi(B_(i j))) = |J| "área"(B_(i j)) $
  Ao passar da imagem para o domínio, o *jacobiano* faz o ajuste de escala (ex.: em polares, um intervalo que antes ia de 0 a 1 agora vai de 0 a $2 pi$).
]

#Highlight1("Jacobiano")[
  Para $phi(u, v) = (x(u, v), y(u, v))$:
  $ J(phi) = mat(delim: "|", (partial x)/(partial u), (partial y)/(partial u), dots.c; (partial x)/(partial v), (partial y)/(partial v), dots.c; dots.v, dots.v, dots.down) $
]

#figure(
  canvas(length: 1cm, {
    import draw: *
    line((-0.2, 0), (2.6, 0), mark: (end: "stealth"), stroke: fig-stroke)
    line((0, -0.2), (0, 2.6), mark: (end: "stealth"), stroke: fig-stroke)
    content((2.75, 0), $r$, anchor: "west")
    content((0, 2.75), $theta$, anchor: "south")
    rect((0, 0), (1.6, 2), fill: fill-soft, stroke: accent-stroke)
    content((-0.15, 2), $2 pi$, anchor: "east")
    content((1.6, -0.25), $1$, anchor: "north")
    bezier((3, 1.4), (5.2, 1.4), (4.1, 2.1), stroke: fig-stroke, mark: (end: "stealth"))
    content((4.1, 2.05), $phi(r, theta)$, anchor: "south")
    line((5.6, 1), (8.4, 1), mark: (end: "stealth"), stroke: fig-stroke)
    line((7, -0.4), (7, 2.4), mark: (end: "stealth"), stroke: fig-stroke)
    circle((7, 1), radius: 1, fill: fill-soft, stroke: accent-stroke)
    content((8.55, 1), $x$, anchor: "west")
    content((7, 2.55), $y$, anchor: "south")
  }),
  caption: [Coordenadas polares: o retângulo $[0, 1] times [0, 2 pi]$ vira o disco unitário.],
)

#example[
  *Polares:* $x(r, theta) = r cos theta$, $y(r, theta) = r sin theta$.
]

- *Em Cálculo II:* com $x = g(u)$,
  $ integral_a^b f(x) dif x = integral_c^d f(g(u)) g'(u) dif u $
  Esse $g'(u)$ era o jacobiano!

#Highlight2("Mudança de variáveis em Cálculo III")[
  $ integral.double_D f(x, y) dif x dif y = integral.double_R f(phi(u, v)) |J(phi)| dif u dif v $
  A região de integração em $R$ tem que ser ajustada.
]

Achar o jacobiano é fácil quando você tem a função:
- *Elipse:* $x = a r cos theta$, $y = b r sin theta arrow.r.double |J(phi)| = r a b$
- *Círculo:* $|J(phi)| = r$

*Roteiro:* 1) identificar o sólido; 2) montar a integral; 3) decidir a mudança de variável.

#Highlight1("Coordenadas cilíndricas e esféricas")[
  - *Cilíndricas:* $phi(r, theta, z) = (r cos theta, r sin theta, z)$, com $|J(phi)| = r$, logo $dif V = r dif r dif theta dif z$.
  - *Esféricas:* $phi(rho, theta, phi) = (rho sin phi cos theta, rho sin phi sin theta, rho cos phi)$, com $|J| = rho^2 sin phi$. Aqui $theta$ varia no plano $x y$ e $phi$ é o ângulo com o eixo $z$ (altura).
]

#figure(
  grid(
    columns: 2,
    gutter: 3em,
    canvas(length: 1cm, {
      import draw: *
      let s = fig-stroke
      line(p3(0, 0, 0), p3(3, 0, 0), mark: (end: "stealth"), stroke: s)
      line(p3(0, 0, 0), p3(0, 3, 0), mark: (end: "stealth"), stroke: s)
      line(p3(0, 0, 0), p3(0, 0, 3), mark: (end: "stealth"), stroke: s)
      content(p3(3.3, 0, 0), $x$)
      content(p3(0, 3.3, 0), $y$)
      content(p3(0, 0, 3.3), $z$)
      let (px, py, pz) = (1.6, 1.8, 1.8)
      line(p3(0, 0, 0), p3(px, py, 0), stroke: accent-stroke)
      line(p3(px, py, 0), p3(px, py, pz), stroke: accent-stroke)
      line(p3(0, 0, pz), p3(px, py, pz), stroke: (paint: gray, dash: "dashed"))
      circle(p3(px, py, pz), radius: 0.07, fill: colors.primary, stroke: none)
      content((p3(px, py, 0).at(0) - 0.6, p3(px, py, 0).at(1) + 0.05), $r$)
      content((p3(px, py, pz / 2).at(0) + 0.25, p3(px, py, pz / 2).at(1)), $z$)
      content((0.55, -0.15), $theta$)
    }),
    canvas(length: 1cm, {
      import draw: *
      let s = fig-stroke
      line(p3(0, 0, 0), p3(3, 0, 0), mark: (end: "stealth"), stroke: s)
      line(p3(0, 0, 0), p3(0, 3, 0), mark: (end: "stealth"), stroke: s)
      line(p3(0, 0, 0), p3(0, 0, 3), mark: (end: "stealth"), stroke: s)
      content(p3(3.3, 0, 0), $x$)
      content(p3(0, 3.3, 0), $y$)
      content(p3(0, 0, 3.3), $z$)
      let (px, py, pz) = (1.4, 1.8, 2.2)
      line(p3(0, 0, 0), p3(px, py, pz), stroke: accent-stroke, mark: (end: "stealth"))
      line(p3(px, py, pz), p3(px, py, 0), stroke: (paint: gray, dash: "dashed"))
      line(p3(0, 0, 0), p3(px, py, 0), stroke: (paint: gray, dash: "dashed"))
      content((p3(px, py, pz).at(0) - 0.55, p3(px, py, pz).at(1) - 0.4), $rho$)
      content((0.22, 0.75), $phi$)
      content((0.55, -0.2), $theta$)
    }),
  ),
  caption: [Coordenadas cilíndricas (esquerda) e esféricas (direita).],
)

== Integral de volume e integral tripla

#Highlight1("Volume")[
  $ V(B) = integral_B 1 dif V $
  Com $dif x dif y$, é a *área*; com $dif x dif y dif z$, é o *volume*.
]

- $integral.triple_D 1 dif x dif y dif z$ calcula o volume (visto antes).
- $integral.triple_D f(x, y, z) dif x dif y dif z$: aplicação no *cálculo de massa*, quando a densidade muda em função de $x, y, z$ (dada por $f(x, y, z)$).

#example[
  Um disco mais denso na borda e menos denso no centro: $f(x, y, z) = sqrt(x^2 + y^2)$ (constante em $z$).
]

= Aplicações de integrais duplas e triplas

== Centro de massa

O *centro de massa* é o ponto onde poderíamos concentrar toda a massa do sistema *sem alterar o momento*: o ponto único que gera o mesmo torque que todos os outros pontos juntos.

$ M x_"cm" = sum m_i x_i quad arrow.r quad overline(x) = (sum m_i x_i)/M quad (M = "massa total") $

#Highlight1("Lâmina com densidade " + $rho(x, y)$)[
  - *Massa:* $display(M = integral_D rho(x, y) dif x dif y)$
  - *Densidade média:* $display((integral_D rho(x, y) dif V)/(integral_D dif V))$ ($rho/A$ ou $rho/V$)
  - *Momentos:* $display(M_x = integral_D x rho(x, y) dif A)$, $quad display(M_y = integral_D y rho(x, y) dif A)$
  - *Centro de massa:*
    $ overline(x) = M_x/M = (integral_D x rho(x, y) dif A)/(integral_D rho(x, y) dif A), quad overline(y) = M_y/M $
]

Obs.: aqui $M_x$ é o momento ponderado por $x$. Muitos livros chamam esse mesmo momento de $M_y$ (momento em relação ao eixo $y$).

== Momento de inércia

$ I_D = sum m_i d_i^2 quad (m_i -> rho dif A) $

#Highlight1("Momentos de inércia")[
  $ I_x = integral_D y^2 rho(x, y) dif A, quad I_y = integral_D x^2 rho(x, y) dif A, quad I_z = I_x + I_y quad (d^2 = x^2 + y^2) $
  ($I_x$: a distância ao eixo $x$ é $d = y$; $I_y$: $d = x$.)
]

= Curvas e integrais de linha

== Parametrização de curvas

Parametrizações permitem usar as ferramentas do Cálculo; representam trajetórias.

#Highlight1("Curva parametrizada")[
  $ gamma: [a, b] -> RR^2 (RR^3), quad gamma(t) = (x(t), y(t)) quad "ou" quad gamma(t) = (x(t), y(t), z(t)) $
]

- *Traço* de $gamma$: $gamma([a, b])$.
- *Reta tangente* a $gamma$ em $t_0$: $X(lambda) = gamma(t_0) + lambda gamma'(t_0)$.
- *Curva regular:* $gamma'(t) != arrow(0) space forall t in [a, b]$. Se não, há pontos sem reta tangente.
- *Curva fechada:* $gamma(a) = gamma(b)$.

#Highlight1("Comprimento de arco")[
  $ integral_gamma dif s = integral_a^b norm(gamma'(t)) dif t $
  Vem de $sum "lados" = sum norm(gamma'(t)) Delta t$ (T.V.M.). Obs.: para a poligonal aproximar o comprimento, todos os vértices dela devem estar na curva.
]

== Integral de linha de campo escalar

#Highlight1("Integral de linha de campo escalar")[
  $ integral_gamma f dif s = integral_a^b f(gamma(t)) norm(gamma'(t)) dif t $
  - $f(gamma(t))$: função aplicada nos pontos da curva.
  - $norm(gamma'(t))$: fator de correção que ajusta o comprimento do arco.
  Obs.: só funciona sobre curvas unidimensionais.
]

Ela é a *área da "cortina"* abaixo de $f(x, y)$ quando andamos sobre a curva (a integral simples $integral f dif x$ é o caso em que a curva é o eixo $x$).

#figure(
  canvas(length: 1cm, {
    import draw: *
    let s = fig-stroke
    line(p3(0, 0, 0), p3(3.6, 0, 0), mark: (end: "stealth"), stroke: s)
    line(p3(0, 0, 0), p3(0, 4.4, 0), mark: (end: "stealth"), stroke: s)
    line(p3(0, 0, 0), p3(0, 0, 2.8), mark: (end: "stealth"), stroke: s)
    content(p3(3.9, 0, 0), $x$)
    content(p3(0, 4.7, 0), $y$)
    content(p3(0, 0, 3.05), $f$)
    let ts = range(0, 31).map(k => k / 30)
    let cx(t) = 2.6 - 2.0 * t
    let cy(t) = 0.6 + 3.2 * t + 0.4 * calc.sin(t * 6)
    let fz(t) = 1.2 + 0.5 * calc.sin(t * 5)
    line(..ts.map(t => p3(cx(t), cy(t), 0)), ..ts.rev().map(t => p3(cx(t), cy(t), fz(t))), close: true,
      fill: colors.primary.lighten(75%), stroke: none)
    for t in ts.filter(t => calc.rem(int(t * 30), 3) == 0) {
      line(p3(cx(t), cy(t), 0), p3(cx(t), cy(t), fz(t)), stroke: (paint: colors.primary.lighten(30%), thickness: 0.4pt))
    }
    line(..ts.map(t => p3(cx(t), cy(t), 0)), stroke: 1.1pt + colors.text)
    line(..ts.map(t => p3(cx(t), cy(t), fz(t))), stroke: accent-stroke)
    content(p3(cx(1), cy(1) + 0.3, 0), $gamma(t)$, anchor: "west")
    content(p3(cx(1), cy(1), fz(1) + 0.2), $f(gamma(t))$, anchor: "south")
  }),
  caption: [A integral de linha de $f$ é a área da cortina entre a curva $gamma$ e o gráfico de $f$.],
)

== Integral de linha de campos vetoriais (I.L.C.V.)

*Campo vetorial*, ex.: $arrow(F)(x, y) = (-y, x)$. Fornece um *vetor aplicado* em cada ponto $(x_0, y_0)$ da trajetória.

A I.L.C.V. é o *trabalho* $W = arrow(F) dot arrow(d)$: fazemos o produto escalar do vetor aplicado em cada ponto da trajetória com um *vetor unitário na direção tangente* à curva, $arrow(T) = gamma'(t)\/norm(gamma'(t))$ (isso dá $norm(arrow(F)) cos theta$, pois $chevron.l u, v chevron.r = norm(u) norm(v) cos theta$):

$ W = chevron.l arrow(F)(gamma(t)), (gamma'(t))/norm(gamma'(t)) chevron.r dot underbrace(norm(gamma'(t)) dif t, dif s) $

#Highlight1("Trabalho (I.L.C.V.)")[
  $ W = integral_gamma arrow(F) dot dif arrow(r) = integral_gamma arrow(F) dot arrow(T) dif s = integral_a^b arrow(F)(gamma(t)) dot gamma'(t) dif t $
  Notação: $display(integral_gamma arrow(F) dot dif arrow(r) = integral_gamma P dif x + Q dif y + R dif z)$ (o produto escalar entre $arrow(F)$ e $gamma'$ já foi feito).
]

== Campos conservativos

Um campo é *conservativo* quando $arrow(F)$ possui uma primitiva: a integral só depende do início e do fim.

#Highlight2("Campo conservativo: condições equivalentes")[
  + $exists space phi: RR^3 -> RR$ (função escalar, chamada *função potencial*) com
    $ nabla phi = ((partial phi)/(partial x), (partial phi)/(partial y), (partial phi)/(partial z)) = arrow(F)(x, y, z) $
  + $integral_gamma arrow(F) dot dif arrow(r)$ não depende de $gamma(t)$, só de $gamma(a)$ (início) e $gamma(b)$ (fim):
    $ integral_gamma arrow(F) dot dif arrow(r) = phi(gamma(b)) - phi(gamma(a)) $
  + $integral.cont_gamma arrow(F) dot dif arrow(r) = 0$ sobre *qualquer* curva fechada.
]

#example[
  *Demonstração de (2).* Pela regra da cadeia, $dif/(dif t) phi(gamma(t)) = nabla phi(gamma(t)) dot gamma'(t) = chevron.l nabla phi, gamma' chevron.r$ (a derivada de $phi(x, y, z)$ é o gradiente). Logo:
  $ integral_gamma arrow(F) dot dif arrow(r) = integral_a^b chevron.l arrow(F), gamma' chevron.r dif t = integral_a^b chevron.l nabla phi, gamma' chevron.r dif t = integral_a^b dif/(dif t) phi(gamma(t)) dif t = phi(gamma(b)) - phi(gamma(a)) $
  pelo T.F.C.
]

== Rotacional

#Highlight1("Rotacional")[
  Para $arrow(F)(x, y, z) = (P(x, y, z), Q(x, y, z), R(x, y, z))$:
  $ "rot" arrow(F) = mat(delim: "|", hat(i), hat(j), hat(k); partial/(partial x), partial/(partial y), partial/(partial z); P, Q, R) = ((partial R)/(partial y) - (partial Q)/(partial z)) hat(i) + ((partial P)/(partial z) - (partial R)/(partial x)) hat(j) + ((partial Q)/(partial x) - (partial P)/(partial y)) hat(k) $
]

Mede a *tendência de rotacionar em torno do ponto*, e não se a trajetória é reta ou circular:
- $arrow(F) = (0, x)$ (trajetórias retas) $arrow.r "rot" arrow(F) = 1 hat(k)$
- $arrow(F) = (-y, x)$ (trajetórias circulares) $arrow.r "rot" arrow(F) = 2 hat(k)$

Se $arrow(F)$ é conservativo, $arrow(F) = (P, Q, R) = ((partial phi)/(partial x), (partial phi)/(partial y), (partial phi)/(partial z))$ e
$ "rot" arrow(F) = (partial/(partial y)((partial phi)/(partial z)) - partial/(partial z)((partial phi)/(partial y))) hat(i) + (dots.c) hat(j) + (dots.c) hat(k) = arrow(0) $
pelo *Teorema de Schwarz*, $partial/(partial x)((partial f)/(partial y)) = partial/(partial y)((partial f)/(partial x))$ (vale para $f$ de classe $C^2$).

#Highlight2("Conservativo implica rotacional nulo")[
  Se $arrow(F)$ é conservativo, então $"rot" arrow(F) = arrow(0)$. *A volta não vale* necessariamente.
]

*Intuição para verificar se é conservativo:* $"rot" arrow(F) = arrow(0)$? Sim: calcule $phi$ (potencial). Não: não é conservativo (não gaste tempo tentando achar $phi$).

#Highlight1("Como achar " + $phi$)[
  Queremos $arrow(F) = (P, Q) = ((partial phi)/(partial x), (partial phi)/(partial y))$:
  - integrando $P$ em $x$: $phi = f(x, y) + g(y)$ (o "$C$" depende de $y$);
  - integrando $Q$ em $y$: $phi = f(x, y) + h(x)$.
  Comparamos as duas integrais para ver se existe um potencial compatível com ambas.
]

== Teorema de Green

Podemos alternar entre olhar a *borda* e olhar o *interior* da curva fechada. Green só vale em $RR^2$.

#Highlight2("Teorema de Green")[
  Seja $arrow(F): D subset RR^2 -> RR^2$, $arrow(F) = (P, Q)$ de classe $C^1$, e $D$ fechado, limitado, com fronteira $partial D$ formada por um número finito de curvas fechadas, simples, regulares por partes, *disjuntas* (não se cruzam) e *orientadas positivamente*. Então
  $ integral.cont_(partial D) P dif x + Q dif y = integral.double_D underbrace(((partial Q)/(partial x) - (partial P)/(partial y)), "rotacional (2D)") dif x dif y $
  ou, equivalentemente,
  $ integral.cont_(partial D) arrow(F) dot dif arrow(r) = integral.double_D "rot" arrow(F) dot hat(k) dif A $
]

*Orientação positiva:* ao percorrer a borda, a região fica *à esquerda*. Se tomarmos o sentido contrário, colocamos um sinal de $-$. Ex.: com a borda dividida em $gamma_1, ..., gamma_4$ e $gamma_3, gamma_4$ percorridas ao contrário,
$ integral_(partial D) P dif x = integral_(gamma_1) P dif x + integral_(gamma_2) P dif x - integral_(gamma_3) P dif x - integral_(gamma_4) P dif x $

#figure(
  grid(
    columns: 2,
    gutter: 3em,
    canvas(length: 1cm, {
      import draw: *
      let pts = range(0, 41).map(k => {
        let t = k / 40 * 2 * calc.pi
        let r = 1.3 + 0.25 * calc.sin(3 * t)
        (r * calc.cos(t), r * calc.sin(t))
      })
      line(..pts, close: true, fill: fill-soft, stroke: accent-stroke)
      for k in (0, 13, 26) {
        line(pts.at(k), pts.at(k + 2), stroke: accent-stroke, mark: (end: "stealth"))
      }
      content((0, 0), $D$)
      content((1.6, 1.2), $partial D$)
    }),
    canvas(length: 1cm, {
      import draw: *
      circle((0, 0), radius: 1.5, fill: fill-soft, stroke: accent-stroke)
      circle((0, 0), radius: 0.55, fill: white, stroke: accent-stroke)
      arc((1.5, 0), start: 0deg, stop: 50deg, radius: 1.5, stroke: accent-stroke, mark: (end: "stealth"))
      arc((-0.55, 0), start: 180deg, stop: 130deg, radius: 0.55, stroke: accent-stroke, mark: (end: "stealth"))
      content((0, 1.0), $D$)
    }),
  ),
  caption: [Orientação positiva: a região fica sempre à esquerda. Com um buraco, a curva interna é percorrida no sentido horário.],
)

*E para curvas não fechadas?* Fechamos a curva $gamma$ com uma curva auxiliar $alpha$ (ex.: um segmento) e descontamos $alpha$ depois:
$ integral_gamma arrow(F) dot dif arrow(r) = plus.minus integral.double_D "rot" arrow(F) dot hat(k) dif A - integral_alpha arrow(F) dot dif arrow(r) $
(sinal $+$ se $gamma union alpha$ estiver orientada positivamente, $-$ se estiver ao contrário.)

=== E se $"rot" arrow(F) = 0$?

- *Sem singularidade dentro da curva fechada:* o campo é conservativo ali e $integral.cont arrow(F) dot dif arrow(r) = 0$ pelo teorema de Green.
- *Com singularidade dentro da curva:* usar Green diretamente está errado, pois um ponto da região não faz parte do domínio. Ex.: $arrow(F) = (1\/x, 1\/y)$.

Isolamos a singularidade com uma curva fechada $alpha$, com orientação oposta (para fora da região):
$ integral_(gamma union alpha) arrow(F) dot dif arrow(r) = integral.double_D underbrace("rot" arrow(F), 0) dot hat(k) dif A = 0 quad arrow.r.double quad integral_gamma arrow(F) dot dif arrow(r) = -integral_alpha arrow(F) dot dif arrow(r) $

#figure(
  canvas(length: 1cm, {
    import draw: *
    line((-2.2, 0), (2.4, 0), mark: (end: "stealth"), stroke: fig-stroke)
    line((0, -2), (0, 2.2), mark: (end: "stealth"), stroke: fig-stroke)
    let pts = range(0, 41).map(k => {
      let t = k / 40 * 2 * calc.pi
      let r = 1.55 + 0.2 * calc.cos(2 * t)
      (r * calc.cos(t), r * calc.sin(t))
    })
    line(..pts, close: true, fill: fill-soft, stroke: accent-stroke)
    line(pts.at(4), pts.at(6), stroke: accent-stroke, mark: (end: "stealth"))
    circle((0, 0), radius: 0.45, fill: white, stroke: (paint: colors.secondary, thickness: 0.9pt))
    arc((0.45, 0), start: 0deg, stop: -60deg, radius: 0.45, stroke: (paint: colors.secondary, thickness: 0.9pt), mark: (end: "stealth"))
    circle((0, 0), radius: 0.06, fill: black)
    content((1.75, 1.05), text(fill: colors.primary)[$gamma$])
    content((0.6, 0.45), text(fill: colors.secondary)[$alpha$])
  }),
  caption: [A singularidade na origem fica isolada pela curva $alpha$ (orientação oposta a $gamma$).],
)

== Domínios simplesmente conexos

#Highlight1("Simplesmente conexo (" + $RR^2$ + ")")[
  $D subset RR^2$ é simplesmente conexo se toda curva fechada em $D$ pode ser contraída a um ponto de $D$. Ex.: $RR^2 without {(0, 0)}$ *não* é simplesmente conexo.
]

#Highlight2("Rotacional nulo + simplesmente conexo implica conservativo")[
  Se $arrow(F): D subset RR^2 -> RR^2$ é um campo vetorial, $D$ é simplesmente conexo e $"rot" arrow(F) = 0$, então $arrow(F)$ é conservativo: $display(integral_gamma arrow(F)(gamma) dot gamma' dif t = phi_2 - phi_1)$.

  Obs.: se existe função potencial, o campo é conservativo *somente no domínio da função*.
]

#example[
  *Campo $dif theta$:* $arrow(F)(x, y) = (-y/(x^2 + y^2), x/(x^2 + y^2)) arrow.r phi(x, y) = arctan(y/x) = theta$.

  A integral $integral_gamma arrow(F) dot dif arrow(r)$ é a variação de $theta$ ao longo de $gamma$. Como o domínio exclui a origem, uma volta em torno dela dá $2 pi$, e não 0.
]

= Superfícies e integrais de superfície

== Superfícies parametrizadas em $RR^3$

#Highlight1("Superfície parametrizada")[
  $ X: D subset RR^2 -> RR^3, quad X(u, v) = (x(u, v), y(u, v), z(u, v)) $
]

#figure(
  canvas(length: 1cm, {
    import draw: *
    line((-0.2, 0), (2.8, 0), mark: (end: "stealth"), stroke: fig-stroke)
    line((0, -0.2), (0, 2.4), mark: (end: "stealth"), stroke: fig-stroke)
    content((2.95, 0), $u$, anchor: "west")
    content((0, 2.55), $v$, anchor: "south")
    let blob = range(0, 41).map(k => {
      let t = k / 40 * 2 * calc.pi
      (1.3 + (0.9 + 0.15 * calc.sin(3 * t)) * calc.cos(t), 1.1 + (0.75 + 0.1 * calc.cos(2 * t)) * calc.sin(t))
    })
    line(..blob, close: true, fill: fill-soft, stroke: accent-stroke)
    content((1.3, 1.1), $D$)
    bezier((3.3, 1.3), (5.3, 1.3), (4.3, 2), stroke: fig-stroke, mark: (end: "stealth"))
    content((4.3, 1.95), $X$, anchor: "south")
    let o = (6.3, 0.2)
    line(o, (o.at(0) + 3, o.at(1)), mark: (end: "stealth"), stroke: fig-stroke)
    line(o, (o.at(0), o.at(1) + 2.8), mark: (end: "stealth"), stroke: fig-stroke)
    line(o, (o.at(0) - 0.9, o.at(1) - 0.8), mark: (end: "stealth"), stroke: fig-stroke)
    let surf = range(0, 41).map(k => {
      let t = k / 40 * 2 * calc.pi
      (7.8 + 1.15 * calc.cos(t) + 0.1 * calc.cos(3 * t), 1.6 + 0.5 * calc.sin(t) + 0.08 * calc.sin(2 * t))
    })
    line(..surf, close: true, fill: colors.primary.lighten(70%), stroke: accent-stroke)
    line((7.8, 1.6), (8.1, 2.6), stroke: (paint: colors.secondary, thickness: 1pt), mark: (end: "stealth"))
    content((8.25, 2.65), text(fill: colors.secondary)[$arrow(n)$], anchor: "west")
    content((9.1, 1.0), $S = X(D)$, anchor: "west")
  }),
  caption: [A parametrização $X$ leva a região $D$ do plano $u v$ na superfície $S$.],
)

- *Vetores tangentes* em um ponto da superfície:
  $ X_u = ((partial x)/(partial u), (partial y)/(partial u), (partial z)/(partial u)) quad ("fixa" v), quad quad X_v = ((partial x)/(partial v), (partial y)/(partial v), (partial z)/(partial v)) quad ("fixa" u) $
- *Superfície regular:* $X_u$ e $X_v$ são L.I., ou seja, $X_u and X_v != arrow(0)$.
- *Plano tangente:* $X = X(u_0, v_0) + lambda X_u + mu X_v$.

#Highlight1("Área de superfície")[
  $ "Área"(S) = integral.double_D norm(X_u and X_v) dif u dif v $
  (cada pedacinho é o paralelogramo de lados $X_u Delta u$ e $X_v Delta v$, de área $norm(X_u and X_v) Delta u Delta v$.)

  Obs. (G.A.): $norm(arrow(u) and arrow(v))^2 = chevron.l u, u chevron.r chevron.l v, v chevron.r - chevron.l u, v chevron.r^2 = norm(u)^2 norm(v)^2 - chevron.l u, v chevron.r^2$.
]

#Highlight1("Integral de superfície de campo escalar")[
  $ integral.double_D delta(x(u, v), y(u, v), z(u, v)) norm(X_u and X_v) dif u dif v $
  (ex.: $delta$ = densidade, $delta: RR^3 -> RR$).
]

== Orientação e fluxo

#Highlight1("Orientação de uma superfície regular")[
  $ arrow(n)(u, v) = (X_u and X_v)/norm(X_u and X_v) quad "(vetor normal unitário)" $
  O vetor normal define a face (o lado) da superfície. $S$ é *orientável* se existe uma escolha contínua de vetores normais em $S$. (A faixa de Möbius não é orientável.)
]

#Highlight1("Fluxo de " + $arrow(F)$ + " através de " + $S$)[
  Para $S$ orientada e $S subset "dom"(arrow(F))$:
  $ integral.double_S arrow(F) dot arrow(n) dif S = integral.double_D chevron.l arrow(F), (X_u and X_v)/norm(X_u and X_v) chevron.r norm(X_u and X_v) dif u dif v $
  $ integral.double_S arrow(F) dot arrow(n) dif S = integral.double_D chevron.l arrow(F)(X(u, v)), X_u and X_v chevron.r dif u dif v $
  (ex.: o líquido que atravessa uma placa.)

  Notação: $display(integral.double_S P dif y and dif z + Q dif z and dif x + R dif x and dif y)$, com $P, Q, R$ multiplicando a 1ª, 2ª e 3ª componentes da normal.
]

== Divergente e Teorema de Gauss

#Highlight1("Divergente")[
  $ "div" arrow(F) = (partial P)/(partial x) + (partial Q)/(partial y) + (partial R)/(partial z) $
  Mede a quantidade de massa que sai da superfície de um bloquinho de volume (é positivo quando sai massa).
]

#Highlight2("Teorema de Gauss (divergência)")[
  Seja $arrow(F): V subset RR^3 -> RR^3$ e $partial V$ uma superfície regular por partes, orientada pela normal *para fora*. Então
  $ integral.triple_V "div" arrow(F) dif V = integral.double_(partial V) arrow(F) dot arrow(n) dif S $
  Olhar só para a casca (o fluxo que atravessa a superfície) equivale a olhar para cada cantinho do volume e ver quanto sai/entra.
]

*E se a superfície não for um sólido fechado (sem tampa)?* Adicionamos a tampa $S_1$, de modo que $partial V = S union S_1$:

#Highlight1("Gauss sem tampa")[
  $ integral.double_S arrow(F) dot arrow(n) dif S = integral.triple_V "div" arrow(F) dif V - integral.double_(S_1) arrow(F) dot arrow(n) dif S_1 $
]

- Em Gauss, $X_u and X_v$ tem que ter orientação positiva (para fora).
- Em Gauss não se aplica $"div" arrow(F)(S)$: é simplesmente $"div" arrow(F)$ nas coordenadas escolhidas. Se fizer mudança de coordenadas, use o jacobiano.

#example[
  *Campo ângulo sólido ($dif Omega$ em $RR^3$):* $arrow(F) = arrow(r)/r^3$, com $arrow(r) = (x, y, z)$ e $r = |arrow(r)| = sqrt(x^2 + y^2 + z^2)$. Domínio: $RR^3 without {(0, 0, 0)}$. É o análogo 3D do campo $dif theta$.
]

== Superfícies com bordo

#Highlight1("Superfície com bordo")[
  + O bordo de $S$ é formado por curvas regulares por partes.
  + As curvas do bordo são percorridas uma única vez.
  + $partial S subset X(partial D)$.
]

- *Esfera:* não tem bordo ($partial S = emptyset$).
- *Cilindro / cubo:* ao colar as partes (faces), as costuras são percorridas 2 vezes, em sentidos opostos, e se cancelam. Só sobram os bordos de verdade.
- *Orientação do bordo:* a orientação coerente entre $S$ e $partial S$ é dada pela *regra da mão direita* ($arrow(n)$ saindo da superfície).

== Teorema de Stokes

#Highlight2("Teorema de Stokes")[
  Seja $arrow(F): V subset RR^3 -> RR^3$ um campo vetorial e $S$ uma superfície parametrizada regular por partes, com $S$ e $partial S$ orientadas coerentemente. Então
  $ integral.double_S "rot" arrow(F) dot arrow(n) dif S = integral.cont_(partial S) arrow(F) dot dif arrow(r) quad "(integral do tipo trabalho)" $
]

- $"div"("rot" arrow(F)) = 0$ e $"rot"(nabla f) = arrow(0)$.
- Superfícies diferentes com o mesmo bordo dão o mesmo resultado: basta escolher a superfície mais fácil.
- O sentido de $arrow(n)$ é importante: se $X_u and X_v$ der um $arrow(n)$ contrário à orientação, trabalhe com $-arrow(n)$.

#Highlight1("Simplesmente conexo (" + $RR^3$ + ")")[
  $A subset RR^3$ é simplesmente conexo se:
  + qualquer curva fechada simples pode ser contraída a um ponto em $A$;
  + qualquer curva fechada simples é bordo de uma superfície em $A$.
]

#Highlight2("Rotacional nulo + simplesmente conexo implica conservativo")[
  Se $"dom" arrow(F)$ é simplesmente conexo em $RR^3$ e $"rot" arrow(F) = arrow(0)$, então $arrow(F)$ é conservativo.
]

#example[
  *E se não for simplesmente conexo?* Ex.: $RR^3 without "eixo" z$. Usamos um cilindro que não toca o eixo $z$, com 2 bordos: a curva $gamma$ que queremos e a curva $gamma_1$ (projetada no plano $x y$) percorrida ao contrário:
  $ integral.double_"cilindro" underbrace("rot" arrow(F), 0) dot arrow(n) dif S = integral_(gamma union gamma_1) arrow(F) dot dif arrow(r) = 0 quad arrow.r.double quad integral_gamma arrow(F) dot dif arrow(r) = -integral_(gamma_1) arrow(F) dot dif arrow(r) $
]

== Integral de fluxo no plano

Para uma superfície $X(u, v)$, a integral de fluxo é
$ integral.double_S arrow(F) dot underbrace((X_u and X_v)/norm(X_u and X_v), arrow(n)) underbrace(norm(X_u and X_v) dif u dif v, dif S) = integral.double_S arrow(F)(P, Q, R) dot (X_u and X_v) dif u dif v $

Para uma curva $gamma(t) = (x(t), y(t))$ no plano, o vetor tangente é $(x', y')$ e a normal unitária é perpendicular a ele ($arrow(n) dot gamma' = 0$):
$ arrow(n) = (y', -x')/norm(gamma'(t)) quad arrow.r.double quad integral_gamma arrow(F)(P, Q) dot (y', -x')/norm(gamma'(t)) norm(gamma'(t)) dif t = integral_gamma P dif y - Q dif x $

#Highlight1("Fluxo × trabalho no plano")[
  - *Fluxo* (componente normal): $display(integral_gamma arrow(F) dot arrow(n) dif s = integral_gamma P dif y - Q dif x)$ ($R = 0$)
  - *Trabalho* (componente tangencial): $display(integral_gamma arrow(F) dot dif arrow(r) = integral_gamma P dif x + Q dif y)$
]

#Highlight2("Teorema da divergência no plano (Green para fluxo)")[
  É o Teorema de Gauss com $R = 0$ (em 2D, o volume vira área e $partial V$ vira a curva):
  $ integral.cont_gamma arrow(F) dot arrow(n) dif s = integral.double_D "div" arrow(F) dif A $
]

= Resumão

#align(center, table(
  columns: (1.2fr, 2.1fr, 1.5fr),
  inset: 7pt,
  align: (left, center, left),
  stroke: 0.5pt + colors.primary,
  table.header([*O quê*], [*Fórmula*], [*Lembrar*]),
  [Integral de linha (trabalho)], [$integral_gamma arrow(F)(gamma) dot gamma'(t) dif t$], [Se $"rot" arrow(F) = 0$ e o domínio é simplesmente conexo, use o potencial $phi$],
  [Rotacional], [$mat(delim: "|", hat(i), hat(j), hat(k); partial_x, partial_y, partial_z; P, Q, R)$], [$P$ nunca é derivado em $x$],
  [Divergente], [$(partial P)/(partial x) + (partial Q)/(partial y) + (partial R)/(partial z)$], [Positivo quando sai massa],
  [Green (trabalho, 2D)], [$integral.cont_(partial D) arrow(F) dot dif arrow(r) = integral.double_D "rot" arrow(F) dot hat(k) dif A$], [Só para curvas fechadas; região à esquerda; isole singularidades],
  [Área de superfície], [$integral.double_D norm(X_u and X_v) dif u dif v$], [$dif S = norm(X_u and X_v) dif u dif v$],
  [Superfície, campo escalar], [$integral.double_D delta(X(u, v)) norm(X_u and X_v) dif u dif v$], [$delta: RR^3 -> RR$],
  [Fluxo por superfície], [$integral.double_D arrow(F)(X(u, v)) dot (X_u and X_v) dif u dif v$], [Confira o sentido de $arrow(n)$],
  [Fluxo por curva (2D)], [$integral_gamma P dif y - Q dif x$], [$arrow(n) prop (y', -x')$],
  [Gauss], [$integral.triple_V "div" arrow(F) dif V = integral.double_(partial V) arrow(F) dot arrow(n) dif S$], [Normal para fora; sem tampa: Gauss $-$ tampa],
  [Green para fluxo (2D)], [$integral.cont_gamma arrow(F) dot arrow(n) dif s = integral.double_D "div" arrow(F) dif A$], [Gauss com $R = 0$],
  [Stokes], [$integral.cont_(partial S) arrow(F) dot dif arrow(r) = integral.double_S "rot" arrow(F) dot arrow(n) dif S$], [Regra da mão direita; em 2D é Green],
))
