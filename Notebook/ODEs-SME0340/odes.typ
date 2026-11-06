#import "../lib.typ": *
#import "@preview/cetz:0.3.4": canvas, draw

// Small helpers for the redrawn figures
#let fig-stroke = 0.8pt + colors.text
#let accent-stroke = 0.9pt + colors.primary

= Introdução

- $(dif y)/(dif x) + y = 8x - 7$, onde $y$ é a *variável dependente* e $x$ a *variável independente*.
- *Ordem da EDO* = ordem da maior derivada.
- Notação de derivada: $y^((n)) = (dif^n y)/(dif t^n)$.

#Highlight1("EDO linear")[
  Uma EDO de ordem $n$ é linear se pode ser escrita como
  $ F(t, y, ..., y^((n))) = a_0(t) y^((n)) + a_1(t) y^((n-1)) + dots.c + a_n (t) y - g(t) $
  Se aparecer $y^2$, $ln|y|$, $sin(y)$, etc., a EDO *não é linear*.
]

== Problema de Valor Inicial (PVI)

$ cases(y' = f(t, y), y(t_0) = y_0) $

#Highlight2("Teorema de Peano")[
  Se $f$ é contínua $forall (t_0, y_0) in RR^2$, existe *pelo menos uma* solução.
]

#Highlight2("Teorema de Existência e Unicidade (T.E.U.)")[
  Se $f(t, y)$ e $(partial f)/(partial y)(t, y)$ forem contínuas no intervalo, então o PVI *tem solução única*.

  Cuidado: o T.E.U. só vale em PVIs.
]

Pelo T.E.U., as funções solução *não se interseccionam*:

#figure(
  canvas(length: 1cm, {
    import draw: *
    line((0, -0.2), (0, 2.6), mark: (end: "stealth"), stroke: fig-stroke)
    line((-0.2, 0), (6.2, 0), mark: (end: "stealth"), stroke: fig-stroke)
    for k in range(4) {
      let y0 = 0.45 + k * 0.55
      let pts = range(0, 61).map(i => {
        let x = i / 10
        (x, y0 + 0.18 * calc.sin(x * 1.6 + k * 0.4))
      })
      line(..pts, stroke: accent-stroke)
    }
    content((6.3, 2.2), [T.E.U.], anchor: "west")
  }),
  caption: [Soluções distintas de um PVI nunca se cruzam.],
)

= EDOs de 1ª ordem

== EDOs separáveis

#Highlight1("EDO separável")[
  Se $f(t, y) = h(t) g(y)$, a EDO $y' = h(t) g(y)$ é separável.
]

+ *Soluções constantes:* se $y(t) = c$ anula $g$ (isto é, $g(c) = 0$), então $y(t) = c$ é solução constante.
+ *Soluções não constantes:* considerando $y' = g(y) h(t)$ e sendo $y(t)$ solução, segue da definição de diferencial que
  $ dif y = y'(t) dif t quad arrow.r.double quad dif y / g(y) = h(t) dif t $
  Esse é o *método de separação de variáveis*. Depois, integra!

== EDOs lineares de 1ª ordem

#Highlight1("Forma padrão")[
  $ y' + a(t) y = b(t) $
]

+ Calcula a função auxiliar (*fator integrante*):
  $ mu(t) = e^(integral a(t) dif t) $
+ Multiplica a equação por $mu(t)$:
  $ underbrace(y' e^(integral a(t) dif t) + a(t) y e^(integral a(t) dif t), dif/(dif t) (y e^(integral a(t) dif t))) = b(t) e^(integral a(t) dif t) $
+ Integra dos dois lados (pelo T.F.C.):
  $ integral dif/(dif t) (y e^(integral a(t) dif t)) dif t = integral b(t) e^(integral a(t) dif t) dif t $

#Highlight1("Solução")[
  $ y mu(t) = integral b(t) e^(integral a(t) dif t) dif t + C $
  Não esquecer da constante $C$!
]

== EDOs não lineares de 1ª ordem

=== Equação de Bernoulli

#Highlight1("Forma geral")[
  $ y' + a(t) y = b(t) y^n $
  ($n > 1$: não linear)
]

Transformamos em algo linear:

+ Divide por $y^n$: $quad y' y^(-n) + a(t) y^(1-n) = b(t)$
+ Substitui $z = y^(1-n)$, logo $z' = (1-n) y^(-n) y'$, ou seja, $display(z'/(1-n) = y^(-n) y')$.
+ Substitui na original e resolve como se fosse linear de 1ª ordem:
  $ z'/(1-n) + a(t) z = b(t) $
  É linear! (Ao achar $z$, acha $y$.)

=== Equação de Riccati

#Highlight1("Forma geral")[
  $ y' + a(t) y + b(t) y^2 = f(t) $
  (Se $f(t) = 0$, é Bernoulli.)
]

Tomamos $y_1(t)$ uma solução conhecida e fazemos
$ y = y_1 + 1/z quad arrow.r.double quad y' = y'_1 - z'/z^2, quad y^2 = y_1^2 + (2 y_1)/z + 1/z^2 $

Substituindo na original, obtemos:
$ z' = underbrace([a(t) + 2 b(t) y_1], h(t)) z + b(t) $

- Riccati se transforma em uma EDO linear de 1ª ordem.
- Ao aplicar Riccati, $f(t)$ zera.

= Aplicações

== Problemas de crescimento / decaimento

Seja $N = N(t)$ a lei que descreve a evolução de um fenômeno em $Delta t$, e a taxa de variação seja proporcional à quantidade presente:

$ (dif N)/(dif t) = k N quad arrow.r quad N(t) = C e^(k t) $

($k$: constante de proporcionalidade.)

== Lei do resfriamento / aquecimento de Newton

A taxa de variação da temperatura no tempo é proporcional à diferença de temperatura entre o corpo e o meio:

$ (dif T)/(dif t) = k (T_"corpo" - T_"ambiente") quad arrow.r quad T(t) = C e^(k t) + T_m $

($T_"ambiente" = T_m$ considerado constante.)

== Diluição

A taxa de variação da quantidade de sal no tanque é igual à taxa que entra menos a taxa que sai:

#align(center, table(
  columns: 3,
  stroke: none,
  align: center,
  [$alpha$ l/min, $b$ kg/l], [$Q(t)$], [$beta$ l/min],
  [_entrada_], [_sal no tanque_], [_saída_],
))

$ (dif Q)/(dif t) = alpha b - C(t) beta $

onde $C(t)$ é a concentração no tanque:

$ (dif Q)/(dif t) = alpha b - underbrace((Q(t))/(V_0 + alpha t - beta t), "concentração (kg/l) no tanque") beta $

= EDOs de 2ª ordem

#Highlight1("Homogênea e não homogênea")[
  - $x'' + a(t) x' + b(t) x = 0 quad arrow.r$ EDO *homogênea* (H)
  - $x'' + a(t) x' + b(t) x = f(t) quad arrow.r$ EDO *não homogênea* (NH)
]

== EDOs de 2ª ordem homogêneas

#Highlight2("T.E.U. para PVI")[
  $ cases(x'' + a(t) x' + b(t) x = f(t), x(t_0) = alpha, x'(t_0) = beta) $
  Se $a, b, f$ são contínuas, então o PVI possui *solução única*.
]

#Highlight2("Princípio da superposição")[
  Se $x_1, x_2$ são soluções da EDO (H) de 2ª ordem, então a combinação linear
  $ phi(t) = C_1 x_1(t) + C_2 x_2(t) $
  também é solução de H.

  Obs.: ${x_1(t), x_2(t)}$ é a base das soluções da EDO.
]

#Highlight1("Wronskiano")[
  Verifica se $x_1, x_2$ são L.I. (para formar base):
  $ W(x_1, x_2)(t) = mat(delim: "|", x_1(t), x_2(t); x'_1(t), x'_2(t)) $
  - $W != 0$: L.I.
  - $W = 0$: L.D.
]

#Highlight2("Teorema de Abel")[
  $ W(x_1, x_2)(t) = C e^(-integral a(t) dif t) $
  Não depende de $t$, só de $x_1, x_2$.
  - Evita ter que achar soluções para saber se a base é L.I.
  - $a(t)$ é o coeficiente de $x'$ (o coeficiente do 2º maior).
  - Para determinar $C$, calculamos $W$ no ponto $t_0$.
]

== EDOs (H, 2ª ordem) com coeficientes constantes

$ x'' + a x' + b x = 0 $

Ao aplicar $x(t) = e^(lambda t)$ (solução genérica), obtemos a *equação característica*:

#Highlight1("Equação característica")[
  $ lambda^2 + a lambda + b = 0 $
  Achando $lambda$, achamos $x_1$ e $x_2$.
]

- *Caso $Delta > 0$:* $W != 0$ ($lambda_1 != lambda_2$).
  $ x_H (t) = C_1 e^(lambda_1 t) + C_2 e^(lambda_2 t) $
- *Caso $Delta = 0$:* $lambda_1 = lambda_2$, então $W = 0$. Usamos
  $ x_1(t) = e^(lambda t), quad x_2(t) = t e^(lambda t) $
  pois $W(x_1, x_2)(t) != 0$ (é solução e é L.I.!). Para multiplicidade 3, $x_3 = t^2 e^(lambda t)$.

  Por soma e produto: $lambda + lambda = -a/1 quad arrow.r.double quad lambda = -a/2$.
- *Caso $Delta < 0$:* se $lambda = alpha plus.minus i beta$ ($beta != 0$),
  $ x_1(t) = e^(alpha t) cos(beta t), quad x_2(t) = e^(alpha t) sin(beta t) $

Obs.: o $plus.minus$ não importa (usa-se $e^((alpha + i beta) t)$ como solução e a identidade de Euler $e^(i theta) = cos theta + i sin theta$, $theta in RR$).
$ W(x_1, x_2) = beta e^(2 alpha t) != 0 $

== Teorema de Abel (ordem $n$)

#Highlight2("Teorema de Abel para ordem n")[
  Para EDO de ordem $n$ na forma
  $ y^((n)) + p_(n-1) y^((n-1)) + dots.c + p_0(x) y = 0 $
  $ W(x) = C e^(-integral a(x) dif x) $
  onde $a(x)$ é *sempre* $p_(n-1)$ (se for 0, temos $W(x) = C$).
]

- Sem achar as soluções, Abel nos dá a forma final do Wronskiano (comportamento).
- Se $W(0) = 0$, Abel garante que $W(t) = 0$ em todos os pontos (o mesmo para $W(0) != 0$).
- Se $W(t) = C t$, por exemplo, então $t = 0$ é um ponto de descontinuidade (função original: $a(t) = 1/t$).

#example[
  *Uso de Abel para calcular o Wronskiano geral.* Se temos $y'' + e^x y' + (x^2 + 1) y = 0$ e $W(0) = 5$, qual é $W(10)$?

  $ W(x) = C e^(-e^x) quad "(por Abel)" $
  $ W(0) = 5 = C e^(-1) arrow.r C = 5e arrow.r W(x) = 5e dot e^(-e^x) $
  que é o Wronskiano em qualquer ponto.
]

#example[
  *Uso de Abel para achar a 2ª solução.* Se temos
  $ y'' - ((x+2)/x) y' + ((x+2)/x^2) y = 0 $
  e sabemos que $y_1(x) = x$ é solução:

  $ W(x) = C x^2 e^x quad "(por Abel)" quad "e" quad W(x) = y_1 y'_2 - y_2 y'_1 = x y'_2 - y_2 $

  Igualando os dois: $C x^2 e^x = x y'_2 - y_2$.

  Admite-se $C = 1$ (qualquer múltiplo da solução L.I. também é L.I.):
  $ y'_2 - 1/x y_2 = x e^x quad arrow.r "EDO linear de 1ª ordem" $
]

== Resolução de EDOs não homogêneas de 2ª ordem

$ x'' + a(t) x' + b(t) x = f(t) quad "(NH)" $

#Highlight1("Solução geral")[
  $ x(t) = underbrace(x_H (t), C_1 x_1(t) + C_2 x_2(t)) + x_p (t) $
  onde $x_H$ é a solução da EDO (H), sem $f(t)$.
]

Pois, se aplicarmos $[x(t) - x_p (t)]$ na EDO, teremos:
$ underbrace((x''(t) + a(t) x'(t) + b(t) x(t)), f(t)) - underbrace((x''_p(t) + a(t) x'_p(t) + b(t) x_p (t)), f(t)) = 0 $

#Highlight2("Teorema da variação dos parâmetros (achar " + $x_p$ + ")")[
  Seja ${x_1(t), x_2(t)}$ base de soluções da EDO (H) linear de 2ª ordem. Então
  $ x_p (t) = x_1(t) integral (W_1(t) f(t))/(W(x_1, x_2)(t)) dif t + x_2(t) integral (W_2(t) f(t))/(W(x_1, x_2)(t)) dif t $
  onde $W_n (t)$ é o Wronskiano com a coluna $n$ cheia de zeros e o último número $1$:
  $ W_1(t) = mat(delim: "|", 0, x_2(t); 1, x'_2(t)) $
]

- Em $x_p$, não precisa de $C$ (considera-se $C = 0$), pois apenas buscamos uma solução particular.
- Esse teorema se expande para EDOs lineares de ordem $n$.

= EDOs de ordem $n$

#Highlight2("T.E.U. (geral)")[
  Se $p_1, p_2, ..., p_n, f$ são contínuas no intervalo, então o PVI
  $ cases(
    x^((n)) + p_1(t) x^((n-1)) + dots.c + p_(n-1)(t) x' + p_n (t) x = f(t),
    x(t_0) = alpha_0,
    x'(t_0) = alpha_1,
    dots.v,
    x^((n-1))(t_0) = alpha_(n-1),
  ) $
  possui *solução única*! (Ordem $n$: $n$ pontos de definição.)
]

== Números complexos

#Highlight1("Forma polar")[
  $ z = x + i y, quad z = |z| (cos theta + i sin theta) $
]

#figure(
  canvas(length: 1cm, {
    import draw: *
    line((-0.3, 0), (3.6, 0), mark: (end: "stealth"), stroke: fig-stroke)
    line((0, -0.3), (0, 2.6), mark: (end: "stealth"), stroke: fig-stroke)
    content((3.75, 0), $RR$, anchor: "west")
    content((0, 2.75), $i$, anchor: "south")
    line((0, 0), (2.6, 1.8), mark: (end: "stealth"), stroke: accent-stroke)
    line((2.6, 1.8), (2.6, 0), stroke: (paint: gray, dash: "dashed"))
    line((2.6, 1.8), (0, 1.8), stroke: (paint: gray, dash: "dashed"))
    content((2.6, -0.25), $x$, anchor: "north")
    content((-0.15, 1.8), $y$, anchor: "east")
    content((1.2, 1.1), $|z|$, anchor: "south-east")
    arc((0.8, 0), start: 0deg, stop: 34.7deg, radius: 0.8, stroke: fig-stroke)
    content((1.05, 0.28), $theta$)
  }),
  caption: [Representação de $z$ no plano complexo.],
)

== Radiciação complexa

#Highlight1("2ª fórmula de De Moivre")[
  $ root(n, z) = root(n, |z|) (cos((theta + 2k pi)/n) + i sin((theta + 2k pi)/n)) $
  com $k = 0, 1, 2, ..., n-1$ (são as raízes!).
]

De onde vem a 2ª fórmula de De Moivre? As raízes são os vértices de um *polígono regular* inscrito na circunferência de raio $root(n, |z|)$. Exemplo: $root(3, -1)$.

#figure(
  canvas(length: 1cm, {
    import draw: *
    let r = 1.6
    line((-2.3, 0), (2.4, 0), mark: (end: "stealth"), stroke: fig-stroke)
    line((0, -2.1), (0, 2.2), mark: (end: "stealth"), stroke: fig-stroke)
    content((2.55, 0), $RR$, anchor: "west")
    content((0, 2.35), $i$, anchor: "south")
    circle((0, 0), radius: r, stroke: (paint: gray, dash: "dashed"))
    let pts = (60deg, 180deg, 300deg).map(a => (r * calc.cos(a), r * calc.sin(a)))
    line(..pts, close: true, stroke: accent-stroke)
    for p in pts { circle(p, radius: 0.07, fill: colors.primary, stroke: none) }
    content((-r - 0.1, 0.3), $-1$, anchor: "east")
    content((pts.at(0).at(0) + 0.15, pts.at(0).at(1) + 0.1), $e^(i pi\/3)$, anchor: "south-west")
    content((pts.at(2).at(0) + 0.15, pts.at(2).at(1) - 0.1), $e^(-i pi\/3)$, anchor: "north-west")
  }),
  caption: [As 3 raízes cúbicas de $-1$ formam um triângulo equilátero.],
)

== Método das raízes racionais

- Ache os divisores de $a_n$ (coeficiente do maior grau).
- Ache os divisores de $a_0$ (coeficiente do termo independente).
- Considere positivos e negativos ($plus.minus$).

#Highlight1("Possíveis raízes racionais")[
  $ D(a_0) / D(a_n) $
]

*Raiz única? Dupla?* Se $p'(lambda) = 0$, é dupla; se $p''(lambda) = 0$, é tripla; etc.

== Circuito em série RLC

#figure(
  canvas(length: 1cm, {
    import draw: *
    let s = fig-stroke
    // frame: (0,0) to (5,2.4)
    // left side with source
    line((0, 0), (0, 0.85), stroke: s)
    circle((0, 1.2), radius: 0.35, stroke: s)
    content((0, 1.2), text(size: 8pt)[$E$])
    line((0, 1.55), (0, 2.4), stroke: s)
    content((0.45, 1.55), text(size: 8pt)[$+$])
    content((0.45, 0.85), text(size: 8pt)[$-$])
    content((0.75, 1.2), $E(t)$, anchor: "west")
    // top with inductor (coil bumps)
    line((0, 2.4), (1.4, 2.4), stroke: s)
    for k in range(5) {
      arc((1.4 + k * 0.44, 2.4), start: 180deg, stop: 0deg, radius: 0.22, stroke: s)
    }
    line((3.6, 2.4), (5, 2.4), stroke: s)
    content((2.5, 2.85), $L$)
    // right side with resistor (zigzag)
    line((5, 2.4), (5, 1.75), stroke: s)
    line((5, 1.75), (5.18, 1.65), (4.82, 1.47), (5.18, 1.29), (4.82, 1.11), (5.18, 0.93), (5, 0.85), stroke: s)
    line((5, 0.85), (5, 0), stroke: s)
    content((5.35, 1.3), $R$, anchor: "west")
    // bottom with capacitor
    line((5, 0), (2.62, 0), stroke: s)
    line((2.62, -0.3), (2.62, 0.3), stroke: 1.4pt + colors.text)
    line((2.38, -0.3), (2.38, 0.3), stroke: 1.4pt + colors.text)
    line((2.38, 0), (0, 0), stroke: s)
    content((2.5, -0.55), $C$)
    // current loop arrow
    arc((3.3, 1.25), start: 0deg, stop: 300deg, radius: 0.55, stroke: accent-stroke, mark: (end: "stealth"))
    content((2.75, 1.25), text(fill: colors.primary)[$i$])
  }),
  caption: [Circuito RLC em série alimentado por $E(t)$.],
)

#Highlight2("Lei de Kirchhoff")[
  $ V = V_L + V_R + V_C $
  (a soma das tensões no laço é zero / se conserva).
]

- *Capacitor:* $Q = C V$ (tensão). Como $i = (dif Q)/(dif t)$, temos $dif V = (i dif t)/C$, logo
  $ i = C (dif V)/(dif t) quad "(corrente)" $
- *Indutor:* $phi = L i$ (corrente). Como $V = (dif phi)/(dif t)$ (lei de Faraday),
  $ V = L (dif i)/(dif t) quad "(tensão)" $

Resumo: $Q = C V$, $phi = L i$. Para outras relações, basta derivar.

= Sistemas de EDOs de 1ª ordem

== O que são?

$ cases(
  x'_1 = a_(11)(t) x_1 + a_(12)(t) x_2 + dots.c + a_(1n)(t) x_n + g_1(t),
  dots.v,
  x'_n = a_(n 1)(t) x_1 + a_(n 2)(t) x_2 + dots.c + a_(n n)(t) x_n + g_n (t),
) $

onde $a_(i j)(t)$ e $g_i (t)$ são contínuas em um intervalo $J subset RR$. Na forma matricial:

$ mat(x'_1(t); dots.v; x'_n(t)) = mat(a_(11)(t), dots.c, a_(1n)(t); dots.v, dots.down, dots.v; a_(n 1)(t), dots.c, a_(n n)(t)) mat(x_1(t); dots.v; x_n (t)) + mat(g_1(t); dots.v; g_n (t)) $

#Highlight1("Forma matricial")[
  $ X'(t) = A(t) X(t) + g(t) $
]

#Highlight2("T.E.U.")[
  Se $a_(i j)(t)$ e $g_i (t)$ são contínuas num intervalo $J subset RR$, então, dados $t_0 in J$ e $X_0 in RR^n$, existe uma *única solução* $X(t)$, definida em $J$, do PVI:
  $ X'(t) = A(t) X(t) + g(t), quad X(t_0) = X_0 = mat(x_0^1; dots.v; x_0^n) $
]

- *Sistema homogêneo:* $X' = A X$
- *Sistema não homogêneo:* $X' = A X + g(t)$

#Highlight1("Matriz solução")[
  $X(t)_(n times n)$ é matriz solução do sistema $X' = A(t) X$ se cada coluna de $X(t)$ for uma solução desse sistema.
]

#example[
  $ X(t) = mat(e^t, 0; 0, e^(2t)) $ é solução de $X' = mat(1, 0; 0, 2) X$. Derivando a 1ª coluna:
  $ X'_1(t) = mat(e^t; 0) = mat(1, 0; 0, 2) underbrace(mat(e^t; 0), X_1(t)) $
  (e o mesmo para $X_2$).

  Obs.: chamando as colunas de $X(t)$ de $X_i (t)$, dizemos, por exemplo, que $X'_i (t) = A X_i (t)$.
]

#Highlight1("Matriz fundamental")[
  Matriz solução com $det X(t) != 0 space forall t in J$ (colunas L.I.).
]

#Highlight2("Solução geral")[
  Se $X(t)$ é matriz fundamental de $X' = A(t) X$, então a solução geral é dada por
  $ X(t) = X(t) C, quad C = mat(c_1; dots.v; c_n) in RR^n "(vetor constante)" $
]

#Highlight2("Fórmula de Jacobi-Liouville")[
  $ det X(t) = det X(t_0) e^(integral_(t_0)^t "tr"(A(s)) dif s) $
  ($t_0 = 0$, por exemplo), onde $"tr"(A(s))$ é o traço de $A(s)$ (soma dos elementos da diagonal principal).

  Serve para verificar se é a matriz fundamental: é o teorema de Abel melhorado.
]

== Solucionando sistemas $X' = A X$ (homogêneos)

Basta achar autovalores/autovetores de
$ (A - lambda I) arrow(v) = arrow(0) quad arrow.r quad det(A - lambda I) = 0 $
(descobrir os autovalores pelo *polinômio característico*). Para achar os autovetores, basta substituir $lambda$ em $(A - lambda I) arrow(v) = arrow(0)$.

#Highlight1("Matriz fundamental")[
  $ X(t) = (e^(lambda_1 t) v_1, ..., e^(lambda_n t) v_n) quad arrow.r quad X_H (t) = X(t) arrow(C) $
  ($arrow(C)$: vetor de constantes).
]

=== Autovalores complexos de $A$

Com $lambda = alpha + i beta$ e $v = v_1 + i v_2$:
$ e^(lambda t) v &= e^((alpha + i beta) t) (v_1 + i v_2) = e^(alpha t) (cos(beta t) + i sin(beta t)) (v_1 + i v_2) \
  &= underbrace(e^(alpha t) (v_1 cos(beta t) - v_2 sin(beta t)), X_1 = "Re"(X(t)) "  (solução 1)") + i underbrace(e^(alpha t) (v_1 sin(beta t) + v_2 cos(beta t)), X_2 = "Im"(X(t)) "  (solução 2)") $

Obs.: sim, tem que achar os autovetores depois.

=== Autovalores repetidos

- $m_a (lambda)$: grau de $lambda$ no $p(lambda)$ (multiplicidade algébrica).
- $m_g (lambda)$: nº de autovetores L.I. que $lambda$ gera (multiplicidade geométrica).

Casos:

- $m_g (lambda) = m_a (lambda) arrow.r lambda$ gera exatamente $m_a (lambda)$ autovetores L.I.
- $m_g (lambda) < m_a (lambda) arrow.r lambda$ gera $m_g (lambda)$ autovetores L.I., mas precisamos de $m_a (lambda)$. Temos que buscar os autovetores restantes:

#grid(
  columns: (1fr, 1fr),
  align: horizon,
  $ (A - lambda I) arrow(v)_1 &= arrow(0) \
    (A - lambda I) arrow(v)_2 &= arrow(v)_1 \
    (A - lambda I) arrow(v)_3 &= arrow(v)_2 \
    &dots.v \
    (A - lambda I) arrow(v)_n &= arrow(v)_(n-1) $,
  $ X_1(t) &= e^(lambda t) v_1 \
    X_2(t) &= e^(lambda t) (v_1 t + v_2) \
    X_3(t) &= e^(lambda t) (v_1 t^2/2! + v_2 t + v_3) \
    &dots.v \
    X_n (t) &= e^(lambda t) sum_(i=1)^n t^(n-i)/((n-i)!) v_i $,
)

== Sistemas lineares não homogêneos

$ X' = A(t) X + f(t) $

$ X(t) = underbrace(X(t) C, "matriz fundamental de" X' = A(t) X) + underbrace(X_p (t), "solução particular") $

#Highlight2("Variação dos parâmetros")[
  $ X_p (t) = X(t) integral X^(-1)(t) f(t) dif t $
  ($integral$ = integral elemento a elemento; $X(t)$ é a matriz fundamental obtida do homogêneo).
]

#Highlight1("Adicional: inversa 2×2")[
  Se $M = mat(a, b; c, d)$ e $det M = a d - b c != 0$, então
  $ M^(-1) = 1/(det M) mat(d, -b; -c, a) $
  (diagonal principal troca, diagonal secundária nega).
]

== EDO de ordem $k >= 2$ como sistema

Podemos transformar uma EDO de ordem $n >= 2$ em um sistema de $n$ equações diferenciais de 1ª ordem.

#example[
  $y^((5)) - 2 y^((4)) + 4 y''' - 6 y'' + 7 y' = 0$ (escrito com $y_0 = y$):

  #grid(
    columns: (auto, 1fr),
    gutter: 1.5em,
    align: horizon,
    $ cases(y'_0 = y_1, y'_1 = y_2, y'_2 = y_3, y'_3 = y_4, y'_4 - 2 y_3 + 4 y_2 - 6 y_1 + 7 y_0 = 0) $,
    $ underbrace(mat(y'_0; y'_1; y'_2; y'_3; y'_4), Y') = underbrace(mat(0, 1, 0, 0, 0; 0, 0, 1, 0, 0; 0, 0, 0, 1, 0; 0, 0, 0, 0, 1; -7, 6, -4, 2, 0), A(t)) underbrace(mat(y_0; y_1; y_2; y_3; y_4), Y) $,
  )
]

= Transformada de Laplace

#Highlight1("Definição")[
  $ cal(L){f(t)} = F(s) = integral_0^(+infinity) e^(-s t) f(t) dif t $
  (com $f(t)$ definida para $t >= 0$ e a integral convergindo). $F$ é a transformada da função $f$.
]

Usamos a transformada para trocar uma *equação diferencial* $f(y^((n)), ..., y, t) = 0$ por uma *equação algébrica* $f(s) = 0$ em um domínio diferente. Ao manipular $f(s) = 0$ e aplicar a transformada inversa, temos a resposta $y(t)$.

#figure(
  canvas(length: 1cm, {
    import draw: *
    content((0, 0), $x'' + x' + x = 1$, name: "t")
    content((5.5, 0), $X(s) + dots$, name: "s")
    content((0, 0.75), text(size: 9pt)[domínio $t$])
    content((5.5, 0.75), text(size: 9pt)[domínio $s$])
    bezier((1.2, 0.35), (4.5, 0.35), (2.85, 1.5), stroke: accent-stroke, mark: (end: "stealth"))
    bezier((4.5, -0.35), (1.2, -0.35), (2.85, -1.5), stroke: accent-stroke, mark: (end: "stealth"))
    content((2.85, 1.25), $cal(L)$, anchor: "south")
    content((2.85, -1.25), $cal(L)^(-1)$, anchor: "north")
  }),
  caption: [A transformada leva o problema ao domínio $s$; a inversa traz de volta.],
)

== Transformadas básicas

#align(center, table(
  columns: 2,
  inset: 8pt,
  stroke: 0.5pt + colors.primary,
  align: left,
  [$cal(L){1} = 1/s, quad s > 0$], [$cal(L){e^(k t)} = 1/(s - k), quad s > k$],
  [$cal(L){t^n} = (n!)/s^(n+1), quad s > 0$], [$cal(L){sin(k t)} = k/(s^2 + k^2), quad s > 0$],
  [], [$cal(L){cos(k t)} = s/(s^2 + k^2), quad s > 0$],
))

== Condição para convergência

#Highlight1("Ordem exponencial")[
  $f$ é de ordem exponencial se $exists c in RR, M > 0, T >= 0$ tais que
  $ |f(t)| <= M e^(c t) quad forall t >= T $
  (conseguimos limitar a função por uma exponencial). Ex.: $f(t) = t$, $f(t) = sin(t)$.
]

#Highlight1("Contínua por partes")[
  Uma função é contínua por partes em $I subset RR$ se, em qualquer subintervalo de $I$, há apenas um número finito de descontinuidades e toda descontinuidade é de *primeira espécie* (existem os limites laterais e eles tendem a um número).

  (2ª espécie: um dos lados vai para $plus.minus infinity$.)
]

Se $f(t)$ é de ordem exponencial e contínua por partes, ela converge em Laplace.

== Propriedades

#Highlight2("Teorema (Laplace é linear)")[
  $ cal(L){alpha f(t) + beta g(t)} = alpha cal(L){f(t)} + beta cal(L){g(t)} $
]

#Highlight2("Teorema (deslocamento de domínio)")[
  $ cal(L){e^(c t) f(t)} = F(s - c) quad (s > a + c) $
]

#Highlight2("Teorema (" + $t^n f(t)$ + ")")[
  $ cal(L){t^n f(t)} = (-1)^n F^((n))(s) $
  onde $F^((n))(s)$ é a derivada $display((dif^n)/(dif s^n))$ de $cal(L){f(t)}$.
]

#Highlight2("Fórmula da derivada")[
  Sejam $f, f', ..., f^((n-1))$ contínuas e $f^((n))$ contínua por partes em $[0, A]$. Então
  $ cal(L){f^((n))(t)} = s^n cal(L){f(t)} - sum_(i=1)^n s^(n-i) f^((i-1))(0) $
  Os expoentes de $s$ vão de $s^(n-1)$ a $s^0$ e as derivadas de $f^((0))(0) = f(0)$ a $f^((n-1))(0)$ (contrários).

  Obs.: lembre-se de aplicar no ponto zero.
]

#Highlight2("Fórmula da derivada inversa")[
  $ cal(L)^(-1){dif/(dif s) F(s)} = -t f(t) $
]

== Transformada inversa

Consiste em voltar: $cal(L)^(-1){F(s)}$. Buscar funções elementares no domínio de $s$ (seja manipulando ou fazendo frações parciais).

#Highlight2("Teorema (existência da inversa)")[
  Se $f(t)$ for contínua por partes em $[0, infinity)$ e de ordem exponencial para $t >= T$, então:
  $ lim_(s -> infinity) cal(L){f(t)} = lim_(s -> infinity) F(s) = 0 $
  No infinito, $F(s)$ tem que dar zero.
]

== Função degrau unitário

Permite modelar mudanças bruscas, descontinuidades e forças que ligam/desligam em sistemas dinâmicos descritos por EDOs. Funciona como um "interruptor": $U(t - a)$ liga quando $t = a$ e permanece em $t > a$.

#Highlight1("Degrau unitário")[
  Para $a > 0$:
  $ U(t - a) = cases(0\, quad 0 <= t < a quad "(desligado)", 1\, quad t >= a quad "(ligado)") $
]

#Highlight2("Transformada do degrau")[
  $ cal(L){f(t - a) U(t - a)} = e^(-a s) F(s), quad a > 0 $
  onde $F(s) = cal(L){f(t)}$.
]

== Função delta de Dirac

Permite modelar *forças impulsivas*, que aplicam uma intensidade imensa em um intervalo de tempo praticamente instantâneo. "Impacto".

#grid(
  columns: (auto, 1fr),
  gutter: 1.5em,
  align: horizon,
  canvas(length: 1cm, {
    import draw: *
    line((-0.2, 0), (4, 0), mark: (end: "stealth"), stroke: fig-stroke)
    line((0, -0.2), (0, 2.6), mark: (end: "stealth"), stroke: fig-stroke)
    rect((1.2, 0), (2.8, 1.9), fill: colors.primary.lighten(85%), stroke: accent-stroke)
    content((1.2, -0.3), $t_0 - a$, anchor: "north")
    content((2.8, -0.3), $t_0 + a$, anchor: "north")
    line((1.2, 1.9), (0, 1.9), stroke: (paint: gray, dash: "dashed"))
    content((-0.1, 1.9), $1/(2a)$, anchor: "east")
    content((4.1, 0), $t$, anchor: "west")
  }),
  [
    #Highlight1("Pulso " + $delta_a$)[
      $ delta_a (t - t_0) = cases(
        0\, quad 0 <= t < t_0 - a,
        1/(2a)\, quad t_0 - a <= t < t_0 + a,
        0\, quad t >= t_0 + a,
      ) quad a > 0, space t_0 > 0 $
    ]
  ],
)

$ integral_0^(+infinity) delta_a (t - t_0) dif t = 1, quad lim_(a -> 0) delta_a (t - t_0) = 0, quad lim_(a -> 0) integral_0^(+infinity) delta_a (t - t_0) dif t = 1 $

Vamos definir uma função impulso unitária que funciona como impulso de tamanho 1 em $t = t_0$:

#Highlight1("Delta de Dirac")[
  + $delta(t - t_0) = 0$ se $t != t_0$
  + $display(integral_0^(+infinity) delta(t - t_0) dif t = 1)$

  $ cal(L){delta(t - t_0)} = lim_(a -> 0) cal(L){delta_a (t - t_0)} = e^(-s t_0) $
]

== Convolução (importante)

#Highlight1("Convolução")[
  $ (f * g)(t) = integral_0^t f(tau) g(t - tau) dif tau quad (= integral_0^t f(t - tau) g(tau) dif tau) $
]

#Highlight2("Teorema da convolução")[
  Sejam $f, g$ contínuas por partes em $[0, +infinity)$:
  $ cal(L){(f * g)(t)} = F(s) dot G(s) $
  $ (f * g)(t) = cal(L)^(-1){F(s) dot G(s)} $
  Permite separar funções na transformada inversa!
]

#example[
  $ cases(y'' - 6 y' + 9 y = t^2 e^(3t), y(0) = 2, y'(0) = 6) $

  Aplicando $cal(L)$ dos dois lados e a fórmula da derivada (com $Y = cal(L){y}$):
  $ [s^2 Y - s y(0) - y'(0)] - 6 [s Y - y(0)] + 9 Y = underbrace((2!)/(s-3)^3, "deslocamento de domínio") $

  Organizando:
  $ Y(s) = 2/(s-3)^5 + 2/(s-3) $

  Aplicando $cal(L)^(-1)$: $display(2/(s-3)^5 -> 1/12 e^(3t) t^4)$ ($t^n$ com domínio deslocado em $a = 3$) e $display(2/(s-3) -> 2 e^(3t))$:
  $ y(t) = (t^4 e^(3t))/12 + 2 e^(3t) $

  Sempre que tiver termo elevado a alta potência, vai ser um $t^n$.
]

= Anotações da Lista

== Como resolver $sin() cos()$?

Não resolve: separa.

#Highlight1("Produto de senos e cossenos")[
  $ sin(2t) = 2 sin(t) cos(t) $
  $ sin(A) cos(B) = 1/2 (sin(A - B) + sin(A + B)) $
  $ cos(A) cos(B) = 1/2 (cos(A - B) + cos(A + B)) $
  $ sin(A) sin(B) = 1/2 (cos(A - B) - cos(A + B)) $
]

== Transformadas em cadeia

$ t e^(a t) sin(b t) = F(s - a), quad F = cal(L){t underbrace(sin(b t), G)} = (-1)^1 G'(s) $
$ = (2 (s - a) b)/(((s - a)^2 + b^2)^2) $

== Interruptor ($U$)

$ f(t) = cases(t\, quad 0 <= t < 1, 1\, quad t >= 1) quad arrow.r quad f(t) = t underbrace((1 - U(t - 1)), [0, 1)) + 1 dot underbrace(U(t - 1), [1, infinity)) $

$ f(t) &= t - t U(t - 1) + U(t - 1) quad "(precisamos de" (t - 1)")" \
  &= t - (t - 1 + 1) U(t - 1) + U(t - 1) $

Obs.: se $f(t) = 2$, então $f(t - a) = 2$ (constante).

== Periodicidade

$ cal(L){sin(t) U(t - 2pi)} = cal(L){sin(t - 2pi) U(t - 2pi)} $

$ cos(2t) + cos(2t) U(t - pi) &= cos(2t) + cos(2t + 2pi - 2pi) U(t - pi) \
  &= cos(2t) + cos(2(t - pi)) U(t - pi) quad arrow.r^(cal(L)) quad dots + e^(-pi s) s/(s^2 + 4) $

== Outras anotações

- *Se tem potência, é $t^n$:* $display(4/(s-1)^3 quad arrow.r^(cal(L)^(-1)) quad 2 e^t t^2)$
- *Convolução vale propriedade associativa:* $cal(L){f * g * h} = F dot G dot H$
- *Convolução é comutativa:* $f * g = g * f$
- *Como saber se a transformada é válida?* $display(lim_(s -> infinity) F(s) = 0)$
- *Função periódica:* $f(t) = f(t + T) = f(t + 2T)$
- *Regra da derivada:* $s^n Y - s^(n-1) y(0) - dots$ (começa do zero e continua caindo).
- *Função delta:* $delta(t - a) arrow.r^(cal(L)) e^(-a s)$

=== Frações parciais

- *Termos simples:* $display((x - 1)(x + 2) arrow.r A/(x - 1) + B/(x + 2))$
- *Termo 1 elevado:* $display((x - 1)^2 arrow.r A/(x - 1) + B/(x - 1)^2)$
- *Termo 2 elevado sem raízes reais:* $display((x^2 + 4) arrow.r (A x + B)/(x^2 + 4))$

Obs.:
$ P(s)/(s^2 + 2)^2 = (A s + B)/(s^2 + 2) + (C s + D)/(s^2 + 2)^2 $

#example[
  *Achar frações parciais por substituição* (bem mais fácil!):
  $ (s + 1)/((s - 1)(s + 2)) = A/(s - 1) + B/(s + 2) $
  $ s + 1 = A(s + 2) + B(s - 1) $
  - $s = 1$: $2 = 3A arrow.r A = 2/3$
  - $s = -2$: $-1 = -3B arrow.r B = 1/3$
]
