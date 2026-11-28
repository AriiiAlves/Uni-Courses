#set document(title: "Resolução - Listas 6 a 10 - SME0123")
#set page(
	paper: "a4",
	margin: (x: 1.8cm, y: 1.8cm),
	footer: context [
		#set text(size: 8pt)
		#h(1fr) #counter(page).display("1")
	],
)
#set text(size: 10pt, lang: "pt", font: "New Computer Modern")
#set par(justify: true, leading: 0.6em)
#show table: it => block(breakable: false, it)
// Vírgula decimal sem espaço extra dentro das equações
#show math.equation: it => {
	show ",": math.class("normal", ",")
	it
}
#show heading.where(level: 1): it => {
	pagebreak(weak: true)
	block(above: 1.4em, below: 0.8em)[
		#set text(size: 12pt, weight: "bold")
		#it.body
		#v(-0.3em)
		#line(length: 100%, stroke: 0.8pt)
	]
}
#show heading.where(level: 2): it => block(above: 1.3em, below: 0.6em)[
	#set text(size: 10.5pt, weight: "bold")
	#it.body
]

// Caixa de resposta final
#let resp(l: none, body) = block(
	width: 100%,
	inset: (x: 8pt, y: 6pt),
	radius: 3pt,
	fill: rgb("#eef3fb"),
	stroke: (left: 2pt + rgb("#3b6fb6")),
	breakable: false,
)[#if l != none [*(#l)* ]*Resposta:* #body]

// Observação
#let obs(body) = block(
	width: 100%,
	inset: (x: 8pt, y: 5pt),
	radius: 3pt,
	fill: rgb("#fbf6e9"),
	stroke: (left: 2pt + rgb("#c9a227")),
)[#text(size: 9pt)[*Obs.:* #body]]

// Item (a), (b), ...
#let item(l) = [*(#l)*]

// Boxplot horizontal: valores em escala [lo, hi] com largura w
#let bplot(nome, mn, q1, md, q3, mx, lo, hi, w: 11cm, out: ()) = {
	let x(v) = (v - lo) / (hi - lo) * w
	grid(
		columns: (2.6cm, w),
		align: (right + horizon, left),
		column-gutter: 6pt,
		text(size: 8.5pt, nome),
		box(width: w, height: 0.9cm, {
			place(dx: x(mn), dy: 0.45cm, line(length: x(q1) - x(mn), stroke: 0.7pt))
			place(dx: x(q3), dy: 0.45cm, line(length: x(mx) - x(q3), stroke: 0.7pt))
			place(dx: x(mn), dy: 0.25cm, line(length: 0.4cm, angle: 90deg, stroke: 0.7pt))
			place(dx: x(mx), dy: 0.25cm, line(length: 0.4cm, angle: 90deg, stroke: 0.7pt))
			place(dx: x(q1), dy: 0.1cm, rect(width: x(q3) - x(q1), height: 0.7cm, fill: rgb("#dbe6f6"), stroke: 0.7pt))
			place(dx: x(md), dy: 0.1cm, line(length: 0.7cm, angle: 90deg, stroke: 1.4pt))
			for o in out {
				place(dx: x(o) - 2pt, dy: 0.45cm - 2pt, circle(radius: 2pt, stroke: 0.7pt))
			}
		}),
	)
}

// Eixo para os boxplots
#let eixo(lo, hi, passo, w: 11cm, fmt: v => str(v)) = {
	let x(v) = (v - lo) / (hi - lo) * w
	let n = int(calc.round((hi - lo) / passo))
	grid(
		columns: (2.6cm, w),
		column-gutter: 6pt,
		[],
		box(width: w, height: 0.7cm, {
			place(dy: 0cm, line(length: w, stroke: 0.5pt))
			for i in range(n + 1) {
				let v = lo + i * passo
				place(dx: x(v), dy: 0cm, line(length: 0.15cm, angle: 90deg, stroke: 0.5pt))
				place(dx: x(v) - 0.5cm, dy: 0.2cm, box(width: 1cm, align(center, text(size: 7.5pt, fmt(v)))))
			}
		}),
	)
}

// Histograma simples: rótulos das classes e frequências
#let hist(rotulos, freqs, altura: 3.2cm, larg: 1.1cm) = {
	let m = calc.max(..freqs)
	align(center, grid(
		columns: freqs.len() * (larg,),
		align: center + bottom,
		row-gutter: 3pt,
		..freqs.map(f => text(size: 7.5pt, str(f))),
		..freqs.map(f => rect(width: larg, height: f / m * altura, fill: rgb("#dbe6f6"), stroke: 0.6pt)),
		..rotulos.map(r => text(size: 7.5pt, r)),
	))
}

#align(center)[
	#text(size: 13pt, weight: "bold")[RESOLUÇÃO -- LISTAS 6 A 10] \
	#text(size: 10pt)[Estatística SME0123 -- passo a passo]
]

#v(0.3em)
#text(size: 9pt)[
	*Convenções.* $z_alpha$ é o quantil tal que $P(Z > z_alpha) = alpha$; $t_(alpha; nu)$ análogo; $chi^2_(nu; alpha)$ é o quantil com área $alpha$ *à direita*. Variância amostral sempre com $n - 1$. Quartis: $Q_1$ = mediana da metade inferior e $Q_3$ = mediana da metade superior dos dados ordenados (excluindo a mediana quando $n$ é ímpar). Resultados finais com duas casas decimais.

	*Roteiro dos testes:* (1) hipóteses; (2) estatística e sua distribuição sob $H_0$; (3) região crítica; (4) valor observado e valor-p; (5) conclusão no contexto.
]

#outline(depth: 1, title: none)

= Lista 6 -- Estatística Descritiva

Fórmulas usadas:

$ overline(x) = (sum x_i)/n, quad s^2 = (sum (x_i - overline(x))^2)/(n-1) = (sum x_i^2 - n overline(x)^2)/(n-1), quad "AIQ" = Q_3 - Q_1 $

Limites para outliers no boxplot: $Q_1 - 1,5 "AIQ"$ e $Q_3 + 1,5 "AIQ"$.

== Exercício 1 -- Tempo de secagem da tinta

#item("a") Contando os valores:

#resp[$n = 15$.]

#item("b") *Ordenando:*

#align(center)[2,5 #h(4pt) 2,8 #h(4pt) 2,8 #h(4pt) 2,9 #h(4pt) 3,0 #h(4pt) 3,3 #h(4pt) 3,4 #h(4pt) *3,6* #h(4pt) 3,7 #h(4pt) 4,0 #h(4pt) 4,4 #h(4pt) 4,8 #h(4pt) 4,8 #h(4pt) 5,2 #h(4pt) 5,6]

*Média:* $sum x_i = 56,8 arrow.r overline(x) = (56,8)/15 = 3,79$.

*Mediana:* $n = 15$ ímpar $arrow.r$ posição $(n+1)\/2 = 8$: $"Md" = 3,6$.

*Quartis:* metade inferior (7 primeiros) $arrow.r Q_1 = 4^"o" = 2,9$; metade superior (7 últimos) $arrow.r Q_3 = 12^"o" = 4,8$.

*Variância:* $sum x_i^2 = 228,28$

$ s^2 = (228,28 - 15 dot (3,7867)^2)/14 = (13,197)/14 = 0,943, quad s = sqrt(0","943) = 0,97 $

#resp[$overline(x) = 3,79$ h; $"Md" = 3,6$; $s^2 = 0,94$; $s = 0,97$; $Q_1 = 2,9$; $Q_3 = 4,8$.]

#item("c") Ramo = parte inteira, folha = décimo:

#align(center)[
	#table(
		columns: 2,
		stroke: (x, y) => if x == 0 { (right: 0.6pt) },
		inset: (x: 6pt, y: 3pt),
		align: (right, left),
		[2], [5 8 8 9],
		[3], [0 3 4 6 7],
		[4], [0 4 8 8],
		[5], [2 6],
	)
]

#resp[Os tempos se concentram entre 2,5 e 4 horas, com cauda um pouco mais longa à direita (leve assimetria positiva: $overline(x) = 3,79 > "Md" = 3,6$). Não há valores atípicos.]

== Exercício 2 -- Resistência da borracha

#obs[O enunciado cita $45 degree$C no texto e $40 degree$C nos dados; tratamos como a temperatura "alta".]

#item("a") *Dados ordenados* ($n = 12$, par $arrow.r$ mediana = média do 6#super[o] e 7#super[o]; cada metade tem 6 valores):

- $20 degree$C: 2,02 2,03 2,03 2,05 2,07 2,09 | 2,11 2,14 2,14 2,18 2,21 2,22
- $45 degree$C: 1,99 2,01 2,03 2,05 2,08 2,15 | 2,29 2,37 2,42 2,42 2,49 2,52

*20 °C:* $sum x = 25,29$, $sum x^2 = 53,3539$

$ overline(x) = (25,29)/12 = 2,1075, quad s^2 = (53,3539 - 12 dot (2,1075)^2)/11 = (0,05523)/11 = 0,00502, quad s = 0,0709 $

$ "Md" = (2,09 + 2,11)/2 = 2,10, quad Q_1 = (2,03 + 2,05)/2 = 2,04, quad Q_3 = (2,14 + 2,18)/2 = 2,16 $

*45 °C:* $sum x = 26,82$, $sum x^2 = 60,3968$

$ overline(x) = (26,82)/12 = 2,235, quad s^2 = (60,3968 - 12 dot (2,235)^2)/11 = (0,4541)/11 = 0,0413, quad s = 0,2032 $

$ "Md" = (2,15 + 2,29)/2 = 2,22, quad Q_1 = (2,03 + 2,05)/2 = 2,04, quad Q_3 = (2,42 + 2,42)/2 = 2,42 $

#resp[
	#table(
		columns: 7,
		inset: 4pt,
		align: center,
		[], [$overline(x)$], [Md], [$s^2$], [$s$], [$Q_1$], [$Q_3$],
		[20 °C], [2,11], [2,10], [0,0050], [0,07], [2,04], [2,16],
		[45 °C], [2,24], [2,22], [0,0413], [0,20], [2,04], [2,42],
	)
]

#item("b") Outliers? 20 °C: $"AIQ" = 0,12$, limites $[1,86 ; 2,34]$; 45 °C: $"AIQ" = 0,38$, limites $[1,47 ; 2,99]$. Nenhum valor fora $arrow.r$ bigodes vão até mín. e máx.

#bplot([20 °C], 2.02, 2.04, 2.10, 2.16, 2.22, 1.95, 2.55)
#bplot([45 °C], 1.99, 2.04, 2.22, 2.42, 2.52, 1.95, 2.55)
#eixo(1.95, 2.55, 0.1, fmt: v => str(calc.round(v, digits: 2)).replace(".", ","))

#resp(l: "c")[Sim: a mediana sobe de 2,10 para 2,22 MPa e $Q_3$ de 2,16 para 2,42; a temperatura mais alta tende a dar maior resistência (embora os mínimos sejam parecidos).]

#resp(l: "d")[A *forma/dispersão* da distribuição: a 45 °C a caixa é muito maior e a distribuição fica assimétrica (metade superior bem mais espalhada).]

#resp(l: "e")[Sim: a variabilidade aumenta bastante -- $s$ passa de 0,07 para 0,20 e o AIQ de 0,12 para 0,38.]

== Exercício 3 -- Fumo e tempo para dormir

#item("a") *Fumantes* ($n = 12$): $sum x = 524,4 arrow.r overline(x)_F = 43,70$ min.

*Não-fumantes* ($n = 15$): $sum x = 454,8 arrow.r overline(x)_(N F) = 30,32$ min.

#item("b") Fumantes: $sum x^2 = 26068,32$

$ s_F^2 = (26068,32 - 12 dot (43,7)^2)/11 = (3152,04)/11 = 286,55, quad s_F = 16,93 $

Não-fumantes: $sum x^2 = 14500,82$

$ s_(N F)^2 = (14500,82 - 15 dot (30,32)^2)/14 = (711,28)/14 = 50,81, quad s_(N F) = 7,13 $

#resp[$overline(x)_F = 43,70$, $s_F = 16,93$; $overline(x)_(N F) = 30,32$, $s_(N F) = 7,13$ (minutos).]

#item("c") Gráfico de pontos (cada ponto = uma pessoa):

#let dots(nome, vals, lo, hi, w: 11cm) = {
	let x(v) = (v - lo) / (hi - lo) * w
	grid(
		columns: (2.6cm, w),
		align: (right + horizon, left),
		column-gutter: 6pt,
		text(size: 8.5pt, nome),
		box(width: w, height: 0.5cm, {
			for v in vals {
				place(dx: x(v) - 2.5pt, dy: 0.25cm - 2.5pt, circle(radius: 2.5pt, fill: rgb("#3b6fb6").transparentize(40%), stroke: none))
			}
		}),
	)
}
#dots([Fumantes], (69.3, 56.0, 22.1, 47.6, 53.2, 48.1, 52.7, 34.4, 60.2, 43.8, 23.2, 13.8), 10, 70)
#dots([Não-fumantes], (28.6, 25.1, 26.4, 34.9, 29.8, 28.4, 38.5, 30.2, 30.6, 31.8, 41.6, 21.1, 36.0, 37.9, 13.9), 10, 70)
#eixo(10, 70, 10)

#resp(l: "d")[Fumantes levam, em média, cerca de 13 minutos a mais para dormir ($43,7$ vs $30,3$) e têm variabilidade muito maior ($s$ 16,9 vs 7,1): os não-fumantes estão concentrados entre 20 e 42 min, enquanto os fumantes se espalham de 14 a 69 min.]

== Exercício 4 -- Vida útil de bombas de combustível

#item("a") Ramo = dígito antes da vírgula, folha = décimo:

#align(center)[
	#table(
		columns: 3,
		stroke: (x, y) => if x == 0 { (right: 0.6pt) },
		inset: (x: 6pt, y: 3pt),
		align: (right, left, right),
		[0], [2 2 2 3 3 4 5 7], [(8)],
		[1], [0 2 3 5 5 8], [(6)],
		[2], [0 3 5], [(3)],
		[3], [0 3], [(2)],
		[4], [0 5 7], [(3)],
		[5], [0 5 6 9], [(4)],
		[6], [0 0 0 5], [(4)],
	)
]

#resp[Muitas bombas falham cedo (menos de 2 anos: 14 de 30), há um "vale" entre 2 e 4 anos e um segundo grupo entre 4 e 6,5 anos: a distribuição é assimétrica à direita e sugere bimodalidade.]

#item("b") $f_i^* = f_i \/ 30$:

#align(center)[
	#table(
		columns: 8,
		inset: 4pt,
		align: center,
		[Classe (anos)], [0 ⊢ 1], [1 ⊢ 2], [2 ⊢ 3], [3 ⊢ 4], [4 ⊢ 5], [5 ⊢ 6], [6 ⊢ 7],
		[$f_i$], [8], [6], [3], [2], [3], [4], [4],
		[$f_i^*$], [0,267], [0,200], [0,100], [0,067], [0,100], [0,133], [0,133],
	)
]

#item("c") $sum x_i = 83,9$, $sum x_i^2 = 378,51$, $n = 30$:

$ overline(x) = (83,9)/30 = 2,80, quad "Amplitude" = 6,5 - 0,2 = 6,3 $

$ s^2 = (378,51 - 30 dot (2,7967)^2)/29 = (143,87)/29 = 4,96, quad s = 2,23 $

#resp[$overline(x) = 2,80$ anos; amplitude $= 6,3$ anos; $s = 2,23$ anos.]

== Exercício 5 -- Transformações nos dados

Se $y_i = a x_i + b$: $overline(y) = a overline(x) + b$, $"Md"_y = a "Md"_x + b$ (a ordem se preserva para $a > 0$) e $s_y = |a| s_x$ (somar constante não muda a dispersão).

#item("a") $a = 2, b = 0$: #resp[Média, mediana e desvio padrão ficam multiplicados por 2.]

#item("b") $a = 1, b = 10$: #resp[Média e mediana aumentam 10; o desvio padrão não muda.]

#item("c") $a = 1, b = -overline(x)$: #resp[Média passa a ser 0; mediana vira $"Md" - overline(x)$; desvio padrão não muda.]

#item("d") $y_i = (x_i - overline(x))\/s$, ou seja, $a = 1\/s$, $b = -overline(x)\/s$: #resp[Média 0, desvio padrão 1 (padronização); mediana vira $("Md" - overline(x))\/s$.]

== Exercício 6 -- Distribuição de frequências

#align(center)[
	#table(
		columns: 11,
		inset: 4pt,
		align: center,
		[$x_i$], [$-4$], [$-3$], [$-2$], [$-1$], [0], [1], [2], [3], [4], [*Total*],
		[$f_i$], [60], [120], [180], [200], [240], [190], [160], [90], [30], [1270],
		[$x_i f_i$], [$-240$], [$-360$], [$-360$], [$-200$], [0], [190], [320], [270], [120], [$-260$],
		[$x_i^2 f_i$], [960], [1080], [720], [200], [0], [190], [640], [810], [480], [5080],
		[$F_"acum"$], [60], [180], [360], [560], [800], [990], [1150], [1240], [1270], [],
	)
]

*Média:* $overline(x) = (sum x_i f_i)/n = (-260)/1270 = -0,205$.

*Mediana:* $n = 1270$ par $arrow.r$ média das posições 635 e 636. Pela frequência acumulada, as posições 561 a 800 valem 0 $arrow.r "Md" = 0$.

*Variância:*

$ s^2 = (sum x_i^2 f_i - n overline(x)^2)/(n-1) = (5080 - 260^2\/1270)/1269 = (5080 - 53,23)/1269 = 3,96 $

#resp[$overline(x) = -0,20$; $"Md" = 0$; $s^2 = 3,96$; $s = 1,99$.]

== Exercício 7 -- Casas por quarteirão

#item("a") Amplitude $= 97 - 2 = 95$; com 5 intervalos, largura $approx 95\/5 = 19 arrow.r$ usamos 20 (classes $[0,20), [20,40), dots$):

#align(center)[
	#table(
		columns: 6,
		inset: 4pt,
		align: center,
		[Classe], [0 ⊢ 20], [20 ⊢ 40], [40 ⊢ 60], [60 ⊢ 80], [80 ⊢ 100],
		[$f_i$], [12], [15], [9], [9], [5],
		[$f_i^*$], [0,24], [0,30], [0,18], [0,18], [0,10],
	)
]

#hist(("0⊢20", "20⊢40", "40⊢60", "60⊢80", "80⊢100"), (12, 15, 9, 9, 5), larg: 1.5cm)

#item("b") $sum x_i = 2021$, $n = 50$:

$ overline(x) = 2021/50 = 40,42, quad "Md" = (x_((25)) + x_((26)))/2 = (30 + 32)/2 = 31 $

$ s^2 = (sum (x_i - overline(x))^2)/49 = (33320,18)/49 = 680,00, quad s = 26,08 $

#resp[Tendência central: $overline(x) = 40,42$ casas (ou $"Md" = 31$, mais adequada pois a distribuição é assimétrica à direita). Dispersão: $s = 26,08$ casas.]

== Exercício 8 -- Boxplot do encolhimento

*Velocidade baixa* (ordenado): 72,42 72,48 72,55 72,58 72,58 | 72,62 72,68 72,84 72,92 73,07

$ "Md" = (72,58 + 72,62)/2 = 72,60, quad Q_1 = 72,55, quad Q_3 = 72,84, quad "AIQ" = 0,29 $

Limites: $72,55 - 1,5(0,29) = 72,12$ e $72,84 + 1,5(0,29) = 73,28$ $arrow.r$ sem outliers.

*Velocidade alta* (ordenado): 71,48 71,50 71,52 71,55 71,56 | 71,62 71,68 71,70 71,71 71,74

$ "Md" = (71,56 + 71,62)/2 = 71,59, quad Q_1 = 71,52, quad Q_3 = 71,70, quad "AIQ" = 0,18 $

Limites: $71,25$ e $71,97$ $arrow.r$ sem outliers.

#bplot([Baixa], 72.42, 72.55, 72.60, 72.84, 73.07, 71.4, 73.2)
#bplot([Alta], 71.48, 71.52, 71.59, 71.70, 71.74, 71.4, 73.2)
#eixo(71.4, 73.2, 0.2, fmt: v => str(calc.round(v, digits: 1)).replace(".", ","))

#resp[Todos os valores com velocidade alta são menores que todos com velocidade baixa: aumentar a velocidade de injeção *reduz o encolhimento* (≈ 1 unidade) e também a variabilidade (AIQ 0,18 vs 0,29). Com velocidade baixa há assimetria à direita (cauda superior mais longa).]

== Exercício 9 -- Dados agrupados

Usamos o *ponto médio* $x_i$ de cada classe como representante:

#align(center)[
	#table(
		columns: 6,
		inset: 4pt,
		align: center,
		[Classe], [$x_i$], [$f_i$], [$F_"acum"$], [$x_i f_i$], [$x_i^2 f_i$],
		[$-10$ ⊢ 0], [$-5$], [3], [3], [$-15$], [75],
		[0 ⊢ 10], [5], [8], [11], [40], [200],
		[10 ⊢ 20], [15], [12], [23], [180], [2700],
		[20 ⊢ 30], [25], [16], [39], [400], [10000],
		[30 ⊢ 40], [35], [9], [48], [315], [11025],
		[40 ⊢ 50], [45], [4], [52], [180], [8100],
		[50 ⊢ 60], [55], [2], [54], [110], [6050],
		[*Total*], [], [54], [], [1210], [38150],
	)
]

*Média:* $overline(x) = 1210\/54 = 22,41$.

*Mediana* (interpolação na classe que contém a posição $n\/2 = 27$, que é 20 ⊢ 30):

$ "Md" = l_i + (n\/2 - F_"ant")/f_"Md" dot h = 20 + (27 - 23)/16 dot 10 = 22,5 $

*Variância:*

$ s^2 = (38150 - 1210^2\/54)/53 = (38150 - 27112,96)/53 = (11037,04)/53 = 208,25 $

#resp[$overline(x) approx 22,41$; $"Md" approx 22,50$; $s^2 approx 208,25$ ($s approx 14,43$).]

#hist(("−10⊢0", "0⊢10", "10⊢20", "20⊢30", "30⊢40", "40⊢50", "50⊢60"), (3, 8, 12, 16, 9, 4, 2))

== Exercício 10 -- Demonstrações

Fatos usados: $sum_(i=1)^n x_i = n overline(x)$; com frequências, $sum_(i=1)^k f_i = n$ e $sum_(i=1)^k f_i x_i = n overline(x)$; $f_i^* = f_i\/n$.

#item("a")
$ sum_(i=1)^n (x_i - overline(x)) = sum x_i - n overline(x) = n overline(x) - n overline(x) = 0 quad square $

#item("b") Expandindo o quadrado:
$ sum (x_i - overline(x))^2 = sum x_i^2 - 2 overline(x) sum x_i + n overline(x)^2 = sum x_i^2 - 2 n overline(x)^2 + n overline(x)^2 = sum x_i^2 - n overline(x)^2 quad square $

#item("c") Mesmo raciocínio, ponderando por $f_i$:
$ sum f_i (x_i - overline(x))^2 = sum f_i x_i^2 - 2 overline(x) sum f_i x_i + overline(x)^2 sum f_i = sum f_i x_i^2 - 2 n overline(x)^2 + n overline(x)^2 = sum f_i x_i^2 - n overline(x)^2 quad square $

#item("d") Dividindo (c) por $n$ e usando $f_i^* = f_i\/n$:
$ sum f_i^* (x_i - overline(x))^2 = 1/n sum f_i x_i^2 - overline(x)^2 = sum f_i^* x_i^2 - overline(x)^2 quad square $

= Lista 7 -- Estimação Pontual

Ferramentas:

- *Viés:* $B(hat(theta)) = E(hat(theta)) - theta$; não viciado se $E(hat(theta)) = theta$.
- *EQM:* $"EQM"(hat(theta)) = "Var"(hat(theta)) + B(hat(theta))^2$. *Consistente* se $"EQM" arrow.r 0$ quando $n arrow.r infinity$.
- *EMV:* (1) $cal(L)(theta) = product f(x_i; theta)$; (2) $cal(l) = ln cal(L)$; (3) $cal(l)'(theta) = 0$; (4) conferir $cal(l)''(theta) < 0$.
- *Método dos momentos:* igualar $E(X^k) = 1/n sum X_i^k$ e resolver para $theta$.

== Exercício 1 -- Estimadores para a Binomial

$X ~ "Bin"(n, p)$: $E(X) = n p$.

#item("a") Linearidade da esperança:

$ E(hat(p)_1) = E(X/n) = (n p)/n = p $

#resp[$hat(p)_1$ é não viciado.]

#item("b")

$ E(hat(p)_2) = (E(X) + sqrt(n)\/2)/(n + sqrt(n)) = (n p + sqrt(n)\/2)/(n + sqrt(n)) $

Isso é igual a $p$ só se $n p + sqrt(n)\/2 = n p + sqrt(n) p <==> p = 1\/2$. Viés:

$ B(hat(p)_2) = (n p + sqrt(n)\/2 - n p - sqrt(n) p)/(n + sqrt(n)) = (sqrt(n)(1\/2 - p))/(n + sqrt(n)) = (1\/2 - p)/(sqrt(n) + 1) $

#resp[$hat(p)_2$ é viciado (exceto no caso particular $p = 1\/2$).]

#item("c") Dividindo numerador e denominador por $n$:

$ E(hat(p)_2) = (p + 1\/(2 sqrt(n)))/(1 + 1\/sqrt(n)) arrow.r_(n arrow.r infinity) (p + 0)/(1 + 0) = p $

#resp[O viés $(1\/2 - p)\/(sqrt(n) + 1) arrow.r 0$: $hat(p)_2$ é *assintoticamente* não viciado.]

== Exercício 2 -- $overline(X)$ na Poisson

$X_i ~ "Poisson"(theta) arrow.r E(X_i) = theta$.

$ E(overline(X)) = 1/n sum_(i=1)^n E(X_i) = 1/n dot n theta = theta $

#resp[$overline(X)$ é não viciado para $theta$.]

== Exercício 3 -- Estimadores ponderados

Seja $V = "Var"(hat(mu)_2)$, então $"Var"(hat(mu)_1) = V\/3$; $E(hat(mu)_1) = E(hat(mu)_2) = mu$; independentes.

#item("i") *Viés* -- todos são combinações com pesos que somam 1:

$ E(hat(mu)_3) = (mu + mu)/2 = mu, quad E(hat(mu)_4) = (4 mu + mu)/5 = mu, quad E(hat(mu)_5) = mu $

#resp[Os três são não viesados.]

#item("ii") Como são todos não viesados, *mais eficiente = menor variância*. $"Var"(a hat(mu)_1 + b hat(mu)_2) = a^2 V\/3 + b^2 V$:

$ "Var"(hat(mu)_3) = 1/4 (V/3 + V) = V/3 approx 0,333 V $
$ "Var"(hat(mu)_4) = 16/25 dot V/3 + 1/25 V = (16 V + 3 V)/75 = (19 V)/75 approx 0,253 V $
$ "Var"(hat(mu)_5) = V/3 approx 0,333 V $

#resp[Em ordem crescente de eficiência: $hat(mu)_3$ e $hat(mu)_5$ (empatados, $V\/3$) $<$ $hat(mu)_4$ ($19V\/75$). O $hat(mu)_4$ é o melhor porque dá mais peso ao estimador mais preciso.]

== Exercício 4 -- Método dos momentos, $f(x; theta) = theta x^(theta - 1)$

*1º momento populacional:*

$ E(X) = integral_0^1 x dot theta x^(theta-1) d x = theta integral_0^1 x^theta d x = theta/(theta+1) $

*Igualar ao momento amostral:*

$ theta/(theta+1) = overline(X) arrow.r.double theta = overline(X) theta + overline(X) arrow.r.double theta(1 - overline(X)) = overline(X) $

#resp[$tilde(theta) = overline(X)/(1 - overline(X))$.]

== Exercício 5 -- EMV de $mu$ na $N(mu, 1)$

$ cal(L)(mu) = product_(i=1)^n 1/sqrt(2 pi) e^(-(x_i - mu)^2\/2) = (2 pi)^(-n\/2) exp(-1/2 sum (x_i - mu)^2) $

$ cal(l)(mu) = -n/2 ln(2 pi) - 1/2 sum (x_i - mu)^2 $

$ cal(l)'(mu) = sum (x_i - mu) = 0 arrow.r.double sum x_i = n mu, quad cal(l)''(mu) = -n < 0 $

#resp[$hat(mu) = overline(X)$.]

== Exercício 6 -- EMV de $lambda$ na Poisson

$ cal(L)(lambda) = product (e^(-lambda) lambda^(y_i))/(y_i !) = (e^(-n lambda) lambda^(sum y_i))/(product y_i !) $

$ cal(l)(lambda) = -n lambda + (sum y_i) ln lambda - ln(product y_i !) $

$ cal(l)'(lambda) = -n + (sum y_i)/lambda = 0, quad cal(l)''(lambda) = -(sum y_i)/lambda^2 < 0 $

#resp[$hat(lambda) = overline(Y)$.]

== Exercício 7 -- Weibull

#item("a")

$ cal(L)(alpha, beta) = product_(i=1)^n alpha beta x_i^(beta - 1) e^(-alpha x_i^beta) = alpha^n beta^n (product_(i=1)^n x_i)^(beta - 1) exp(-alpha sum_(i=1)^n x_i^beta) $

#item("b") Log-verossimilhança:

$ cal(l) = n ln alpha + n ln beta + (beta - 1) sum ln x_i - alpha sum x_i^beta $

Derivadas parciais (lembrando $partial x^beta \/ partial beta = x^beta ln x$):

$ (partial cal(l))/(partial alpha) = n/alpha - sum x_i^beta = 0 $
$ (partial cal(l))/(partial beta) = n/beta + sum ln x_i - alpha sum x_i^beta ln x_i = 0 $

#resp[
	Da primeira, $hat(alpha) = n \/ sum x_i^(hat(beta))$; substituindo na segunda, $hat(beta)$ resolve (numericamente)
	$ n/beta + sum ln x_i - n (sum x_i^beta ln x_i)/(sum x_i^beta) = 0 $
]

== Exercício 8 -- Bernoulli com uma observação $x = 1$

$ cal(L)(p) = p^x (1-p)^(1-x) = p^1 (1-p)^0 = p, quad p in [0, 1] $

$cal(L)(p) = p$ é *estritamente crescente* em $[0,1]$ (derivada $= 1 > 0$, nunca zera). Logo o máximo não está num ponto crítico, e sim na *fronteira*: $p = 1$.

#resp[$hat(p) = 1$ (a derivada não serve aqui; o máximo está no extremo do espaço paramétrico).]

== Exercício 9 -- EMV na $U(-alpha, alpha)$

$f(x) = 1\/(2 alpha)$ se $-alpha < x < alpha$:

$ cal(L)(alpha) = cases((2 alpha)^(-n) & "se" alpha >= max|x_i|, 0 & "caso contrário") $

Atenção: o suporte depende de $alpha$, então não derivamos. Para $alpha >= max|x_i|$, $cal(L)$ é *decrescente* em $alpha$ $arrow.r$ o máximo é o menor $alpha$ permitido.

#resp[$hat(alpha) = max_i |X_i|$.]

== Exercício 10 -- EMV de $beta$ em $f(x) = (beta + 1) x^beta$

#item("a")

$ cal(l)(beta) = n ln(beta + 1) + beta sum ln x_i, quad cal(l)'(beta) = n/(beta+1) + sum ln x_i = 0, quad cal(l)'' = -n/(beta+1)^2 < 0 $

#resp[$hat(beta) = -1 - n/(sum_(i=1)^n ln x_i)$.]

#item("b") $ln$ de 0,3; 0,8; 0,27; 0,35; 0,62; 0,55:

$ sum ln x_i = -1,2040 - 0,2231 - 1,3093 - 1,0498 - 0,4780 - 0,5978 = -4,8621 $

$ hat(beta) = -1 - 6/(-4,8621) = -1 + 1,2340 $

#resp[$hat(beta) = 0,23$.]

== Exercício 11 -- Distribuição geométrica

#item("a") O número de repetições até o 1º sucesso: $P(N = n) = (1-p)^(n-1) p$, $n = 1, 2, dots$

$ cal(L)(p) = product_(i=1)^k (1-p)^(n_i - 1) p = p^k (1-p)^(sum n_i - k) $

$ cal(l)(p) = k ln p + (sum n_i - k) ln(1-p) $

$ cal(l)'(p) = k/p - (sum n_i - k)/(1-p) = 0 arrow.r.double k(1-p) = p(sum n_i - k) arrow.r.double k = p sum n_i $

$cal(l)''(p) = -k\/p^2 - (sum n_i - k)\/(1-p)^2 < 0$.

#resp[$hat(p) = k / (sum_(i=1)^k n_i) = 1\/overline(n)$.]

#item("b") Para $k$ grande usamos as propriedades assintóticas do EMV: é aproximadamente não viciado e $"Var"(hat(p)) approx 1\/(k I(p))$, onde $I(p) = -E[partial^2 ln f \/ partial p^2]$ é a informação de Fisher de uma observação.

$ ln f = ln p + (N - 1) ln(1-p) arrow.r (partial^2 ln f)/(partial p^2) = -1/p^2 - (N - 1)/(1-p)^2 $

Como $E(N) = 1\/p$, $E(N - 1) = (1-p)\/p$:

$ I(p) = 1/p^2 + (1-p)/(p(1-p)^2) = 1/p^2 + 1/(p(1-p)) = 1/(p^2(1-p)) $

#resp[$E(hat(p)) approx p$ e $"Var"(hat(p)) approx (p^2(1-p))/k$.]

== Exercício 12 -- EMV de $lambda$ na Gama ($r$ conhecido)

$ cal(L)(lambda) = product (lambda (lambda x_i)^(r-1) e^(-lambda x_i))/(Gamma(r)) = (lambda^(n r) (product x_i)^(r-1) e^(-lambda sum x_i))/(Gamma(r)^n) $

$ cal(l)(lambda) = n r ln lambda + (r - 1) sum ln x_i - lambda sum x_i - n ln Gamma(r) $

$ cal(l)'(lambda) = (n r)/lambda - sum x_i = 0, quad cal(l)''(lambda) = -(n r)/lambda^2 < 0 $

#resp[$hat(lambda) = (n r)/(sum x_i) = r/overline(X)$.]

== Exercício 13 -- $hat(theta) = 2 overline(X)$ na $U(0, theta)$

#item("a") $E(hat(theta)) = 2 E(overline(X)) = 2 dot theta/2$. #resp[$E(hat(theta)) = theta$ (não viciado).]

#item("b") Não viciado $arrow.r$ EQM = variância:

$ "Var"(hat(theta)) = 4 "Var"(overline(X)) = 4 dot ("Var"(X))/n = 4 dot theta^2/(12 n) $

#resp[$"EQM"(hat(theta)) = theta^2/(3n)$.]

#resp(l: "c")[Sim: $"EQM"(hat(theta)) = theta^2\/(3n) arrow.r 0$ quando $n arrow.r infinity$.]

== Exercício 14 -- IC para $mu$ (lâmpadas)

Idêntico ao Ex. 1 da Lista 8 (resolvido lá). #resp[(a) $"IC"_(96%)(mu) = [765,03 ; 794,97]$ h. (b) $n = 68$.]

== Exercício 15 -- IC para proporção de defeituosos

Idêntico ao Ex. 2 da Lista 8. #resp[(a) $[0,017 ; 0,143]$. (b) $n = 160$.]

== Exercício 16 -- Foguetes

Idêntico ao Ex. 3 da Lista 8. #resp[$"IC"_(95%)(p) = [0,74 ; 0,96]$; não há evidência conclusiva de que o novo sistema seja melhor.]

= Lista 8 -- Estimação por Intervalos

Fórmulas ($gamma = 1 - alpha$ = coeficiente de confiança):

- Média, $sigma$ conhecido: $overline(x) plus.minus z_(alpha\/2) sigma/sqrt(n)$; tamanho: $n = (z_(alpha\/2) sigma \/ epsilon)^2$.
- Média, $sigma$ desconhecido (pop. normal): $overline(x) plus.minus t_(alpha\/2; n-1) s/sqrt(n)$.
- Proporção: $hat(p) plus.minus z_(alpha\/2) sqrt(hat(p)(1-hat(p))\/n)$ (otimista) ou $hat(p) plus.minus z_(alpha\/2) sqrt(1\/(4n))$ (conservador); tamanho: $n = (z_(alpha\/2)\/epsilon)^2 p(1-p)$, com $p(1-p) <= 1\/4$.

Quantis usados: $gamma = 0,80 arrow.r 1,28$; $0,85 arrow.r 1,44$; $0,88 arrow.r 1,555$; $0,90 arrow.r 1,645$; $0,94 arrow.r 1,88$; $0,95 arrow.r 1,96$; $0,96 arrow.r 2,05$; $0,98 arrow.r 2,33$.

== Exercício 1 -- Lâmpadas ($sigma = 40$)

$X$ = vida útil, $X ~ N(mu; 40^2)$; $sigma$ conhecido $arrow.r$ usa $Z$. $n = 30$, $overline(x) = 780$, $gamma = 0,96 arrow.r z_(0,02) = 2,05$.

$ epsilon = 2,05 dot 40/sqrt(30) = 2,05 dot 7,303 = 14,97 arrow.r "IC" = [780 - 14,97 ; 780 + 14,97] $

*Tamanho* para erro $epsilon = 10$:

$ n = ((2,05 dot 40)/10)^2 = 8,2^2 = 67,24 arrow.r n = 68 $

#resp[$"IC"_(96%)(mu) = [765,03 ; 794,97]$ h; $n = 68$ lâmpadas.]

== Exercício 2 -- Proporção de defeituosos

$hat(p) = 8\/100 = 0,08$; $gamma = 0,98 arrow.r z_(0,01) = 2,33$.

$ epsilon = 2,33 sqrt((0,08 dot 0,92)/100) = 2,33 dot 0,02713 = 0,0632 $

*Tamanho* para $epsilon = 0,05$, usando a estimativa $hat(p) = 0,08$ como valor de $p$:

$ n = ((2,33)/(0,05))^2 dot 0,08 dot 0,92 = 2171,56 dot 0,0736 = 159,8 arrow.r 160 $

#resp[$"IC"_(98%)(p) = [0,017 ; 0,143]$; $n = 160$. (Com a abordagem conservadora $p(1-p) = 1\/4$ seria $n = 543$.)]

== Exercício 3 -- Foguetes

$hat(p) = 34\/40 = 0,85$; $z_(0,025) = 1,96$.

$ epsilon = 1,96 sqrt((0,85 dot 0,15)/40) = 1,96 dot 0,05646 = 0,1107 $

#resp[$"IC"_(95%)(p) = [0,739 ; 0,961]$. Como $0,8$ (sistema atual) está *dentro* do intervalo, não há evidência suficiente de que o novo sistema seja melhor.]

== Exercício 4 -- Alturas ($sigma$ desconhecido)

$n = 50$, $overline(x) = 174,5$, $s = 6,9$ (amostral) $arrow.r$ $T = (overline(X) - mu)/(S\/sqrt(n)) ~ t_49$; $gamma = 0,98 arrow.r t_(0,01;49) = 2,405$.

$ epsilon = 2,405 dot (6,9)/sqrt(50) = 2,405 dot 0,9758 = 2,35 $

#resp[$"IC"_(98%)(mu) = [172,15 ; 176,85]$ cm. Com 98% de confiança, o erro ao estimar $mu$ por 174,5 é no máximo 2,35 cm.]

== Exercício 5 -- Tempo de reação ($sigma = 2$)

#obs[O enunciado diz "vinte pacientes", mas lista 19 valores; usamos os 19 valores dados ($n = 19$).]

$sum x_i = 89,1 arrow.r overline(x) = (89,1)/19 = 4,689$; $z_(0,025) = 1,96$.

$ epsilon = 1,96 dot 2/sqrt(19) = 1,96 dot 0,4588 = 0,899 $

#resp[$"IC"_(95%)(mu) = [3,79 ; 5,59]$ minutos.]

== Exercício 6 -- Vários níveis de confiança

$n = 25$, $sigma = sqrt(16) = 4$, $overline(x) = 8$, $sigma\/sqrt(n) = 4\/5 = 0,8$; $epsilon = z_(alpha\/2) dot 0,8$:

#align(center)[
	#table(
		columns: 4,
		inset: 4pt,
		align: center,
		[$gamma$], [$z_(alpha\/2)$], [$epsilon$], [IC],
		[80%], [1,28], [1,02], [$[6,98 ; 9,02]$],
		[85%], [1,44], [1,15], [$[6,85 ; 9,15]$],
		[90%], [1,645], [1,32], [$[6,68 ; 9,32]$],
		[95%], [1,96], [1,57], [$[6,43 ; 9,57]$],
	)
]

#resp[Quanto maior a confiança, maior o quantil $z$ e *mais largo* o intervalo: ganha-se confiança perdendo precisão (com $n$ fixo).]

== Exercício 7 -- Amplitude vs. tamanho da amostra

$sigma = 9$, $gamma = 0,90 arrow.r z = 1,645$. Amplitude $= 2 z sigma\/sqrt(n)$:

$ n = 30: 2 dot 1,645 dot 9/sqrt(30) = 5,41 quad quad n = 50: 4,19 quad quad n = 100: 2,96 $

#resp[A amplitude cai com $sqrt(n)$: aumentar a amostra estreita o intervalo (para dividir a amplitude por 2 é preciso quadruplicar $n$).]

== Exercício 8 -- Hora-aula

$n = 100$, $overline(x) = 2,50$, $sigma = 1,10$, $z = 1,96$:

$ epsilon = 1,96 dot (1,10)/10 = 0,2156 $

#resp[$"IC"_(95%)(mu) = [2,28 ; 2,72]$ reais.]

== Exercício 9 -- Eleitores (otimista e conservador)

$hat(p) = 0,35$, $n = 50$, $gamma = 0,94 arrow.r z_(0,03) = 1,88$.

*Otimista:* $epsilon = 1,88 sqrt((0,35 dot 0,65)/50) = 1,88 dot 0,0675 = 0,127$.

*Conservador:* $epsilon = 1,88 sqrt(1/200) = 1,88 dot 0,0707 = 0,133$.

#resp[Otimista: $[0,223 ; 0,477]$. Conservador: $[0,217 ; 0,483]$.]

== Exercício 10 -- Colesterol

#item("a") $sigma^2 = 64 arrow.r sigma = 8$; $n = 46$; $overline(x) = 120$; $gamma = 0,88 arrow.r alpha\/2 = 0,06 arrow.r z_(0,06) = 1,555$.

$ epsilon = 1,555 dot 8/sqrt(46) = 1,555 dot 1,1795 = 1,83 $

#resp[$"IC"_(88%)(mu) = [118,17 ; 121,83]$ mg/mL.]

#item("b") Amplitude $= 2 z_(alpha\/2) sigma \/ sqrt(n)$; $sigma$ não está sob controle. #resp[Diminuir o coeficiente de confiança (menor $z$) ou aumentar o tamanho da amostra $n$.]

== Exercício 11 -- Recuperando a média

#item("a") O IC é simétrico em torno de $overline(x)$:

$ overline(x) = (35,21 + 35,99)/2 $

#resp[$overline(x) = 35,60$.] (Confere: $epsilon = 0,39 = 1,96 dot 2\/sqrt(100)$.)

#item("b") $z_(0,05) = 1,645 arrow.r epsilon = 1,645 dot 2\/10 = 0,329$.

#resp[$"IC"_(90%)(mu) = [35,27 ; 35,93]$.]

== Exercício 12 -- Sabonete Bom Cheiro

Com probabilidade 0,90: $z_(0,05) = 1,645$.

#item("a") Sem informação $arrow.r p(1-p) = 1\/4$: $n = (1,645\/0,05)^2 dot 0,25 = 270,6$. #resp[$n = 271$.]

#item("b") $p >= 0,8 arrow.r$ o máximo de $p(1-p)$ na faixa é em $p = 0,8$: $0,16$. $n = 1082,41 dot 0,16 = 173,2$. #resp[$n = 174$.]

#item("c") $epsilon = 1,645 sqrt(1/(4 dot 81)) = (1,645)/18$. #resp[$epsilon = 0,091$.]

#item("d") $P(|hat(p) - p| <= 0,08) = P(|Z| <= 0,08 dot 18) = P(|Z| <= 1,44) = 2(0,9251) - 1$. #resp[$approx 0,85$.]

== Exercício 13 -- Tamanho de amostra com amostra piloto

#item("a") Probabilidade 0,80 $arrow.r z_(0,10) = 1,28$; $epsilon = 0,01$; piloto: $hat(p) = 0,60$.

$ n = ((1,28)/(0,01))^2 dot 0,6 dot 0,4 = 16384 dot 0,24 = 3932,2 $

#resp[$n = 3933$. (Abordagem conservadora, $p(1-p) = 1\/4$: $n = 4096$.)]

#item("b") $hat(p) = 0,55$, $n = 3933$, $z = 1,96$:

$ epsilon = 1,96 sqrt((0,55 dot 0,45)/3933) = 1,96 dot 0,00793 = 0,0155 $

#resp[$"IC"_(95%)(p) = [0,534 ; 0,566]$.]

== Exercício 14 -- Candidato A

$hat(p) = 208\/400 = 0,52$; $z = 1,96$:

$ epsilon = 1,96 sqrt((0,52 dot 0,48)/400) = 1,96 dot 0,02498 = 0,049 $

#resp[$"IC"_(95%)(p) = [0,471 ; 0,569]$. Como contém valores abaixo de 0,5, não dá para garantir que A tenha maioria.]

= Lista 9 -- Testes de Hipóteses

Estatísticas usadas:

#align(center)[
	#table(
		columns: 3,
		inset: 5pt,
		align: (left, center, left),
		[*Situação*], [*Estatística*], [*Distribuição sob $H_0$*],
		[$mu$, $sigma$ conhecido (ou $n$ grande)], [$Z = (overline(X) - mu_0)/(sigma\/sqrt(n))$], [$N(0;1)$],
		[$mu$, $sigma$ desconhecido], [$T = (overline(X) - mu_0)/(S\/sqrt(n))$], [$t_(n-1)$],
		[$p$], [$Z = (hat(p) - p_0)/sqrt(p_0(1-p_0)\/n)$], [$approx N(0;1)$],
		[$sigma^2$], [$Q = ((n-1)S^2)/sigma_0^2$], [$chi^2_(n-1)$],
		[Pareado], [$T = overline(D)/(S_D\/sqrt(n))$], [$t_(n-1)$],
		[2 médias, var. iguais], [$T = (overline(X)_1 - overline(X)_2)/(S_p sqrt(1\/n_1 + 1\/n_2))$], [$t_(n_1+n_2-2)$],
		[2 médias, var. diferentes], [$T = (overline(X)_1 - overline(X)_2)/sqrt(S_1^2\/n_1 + S_2^2\/n_2)$], [$t_nu$ (Welch)],
	)
]

Erro tipo I: rejeitar $H_0$ verdadeira ($P = alpha$). Erro tipo II: não rejeitar $H_0$ falsa ($P = beta$). Poder $= 1 - beta$.

== Exercício 1 -- Escolha de $H_0$ e tipos de erro

Regra: $H_0$ deve ser a hipótese cuja *rejeição indevida* (erro tipo I, controlado por $alpha$) é o erro mais grave.

#item("a") Radar.

#resp[$H_0$: *está começando um ataque*. Erro I: concluir "interferência" quando é um ataque (não reagir -- muito grave). Erro II: tratar uma interferência como ataque (alarme falso).]

#item("b") Júri.

#resp[$H_0$: *o acusado é inocente*. Erro I: condenar um inocente. Erro II: absolver um culpado.]

#item("c") Vacina.

#resp[$H_0$: *a vacina não é eficaz*. Erro I: lançar no mercado uma vacina ineficaz. Erro II: deixar de lançar uma vacina eficaz.]

== Exercício 2 -- Moeda

$p$ = probabilidade de coroa. $H_0: p = 1\/2$ (honesta) vs $H_1: p != 1\/2$. Regra: rejeita $H_0$ se saírem 3 coroas em 3 lançamentos.

*Erro I:* rejeitar com a moeda honesta:

$ alpha = P(3 "coroas" | p = 1\/2) = (1/2)^3 = 1/8 $

*Erro II* com $p = 2\/3$: não rejeitar (sair menos de 3 coroas):

$ beta = 1 - P(3 "coroas" | p = 2\/3) = 1 - (2/3)^3 = 1 - 8/27 = 19/27 $

#resp[$alpha = 0,125$; $beta approx 0,704$.]

== Exercício 3 -- Lâmpadas ($mu = 800$?)

*1.* $H_0: mu = 800$ vs $H_1: mu != 800$.

*2.* $Z = (overline(X) - 800)/(40\/sqrt(30)) ~ N(0;1)$; $sigma\/sqrt(n) = 7,303$.

*3.* $z_"obs" = (788 - 800)/(7,303) = -1,64$.

*4.* Valor-p (bilateral) $= 2 P(Z < -1,64) = 2(0,0502) = 0,100$.

#resp[Valor-p $= 0,10 > 0,05$: não rejeita $H_0$. Não há evidência de que a vida média difira de 800 h.]

== Exercício 4 -- Pipoca

*1.* $H_0: mu = 5,5$ vs $H_1: mu < 5,5$.

*2.* $n = 64$ grande $arrow.r$ $Z = (overline(X) - 5,5)/(S\/sqrt(n)) approx N(0;1)$; $s\/sqrt(n) = 0,24\/8 = 0,03$.

*3.* $R_c = {z < -1,645}$.

*4.* $z_"obs" = (5,23 - 5,5)/(0,03) = -9,0 in R_c$; valor-p $approx 0$.

#resp[Rejeita $H_0$: o peso médio é menor que 5,5 oz.]

== Exercício 5 -- Altura das calouras

*1.* $H_0: mu = 162,5$ vs $H_1: mu != 162,5$ ("houve mudança").

*2.* $Z = (overline(X) - 162,5)/(6,9\/sqrt(50))$; $sigma\/sqrt(n) = 0,9758$.

*3.* $z_"obs" = (165,2 - 162,5)/(0,9758) = 2,77$.

*4.* Valor-p $= 2 P(Z > 2,77) = 2(0,0028) = 0,0057$.

#resp[Valor-p $approx 0,006$ (muito pequeno): rejeita $H_0$. Há evidência de que a altura média mudou (aumentou).]

== Exercício 6 -- Sódio no cereal

*1.* $H_0: mu = 220$ vs $H_1: mu > 220$.

*2.* $sigma$ desconhecido, $n = 20$ $arrow.r$ $T = (overline(X) - 220)/(S\/sqrt(20)) ~ t_19$ (supondo população normal).

*3.* $R_c = {t > t_(0,05;19) = 1,729}$.

*4.* $s\/sqrt(n) = 24,5\/sqrt(20) = 5,478$; $t_"obs" = (244 - 220)/(5,478) = 4,38 in R_c$; valor-p $approx 0,0002$.

#resp[Rejeita $H_0$: o teor médio de sódio é maior que 220 mg.]

== Exercício 7 -- Nicotina

Dados: 27, 24, 21, 25, 26, 22 $arrow.r overline(x) = 145\/6 = 24,17$. $sigma^2 = 4,86 arrow.r sigma\/sqrt(n) = sqrt(4","86\/6) = 0,9$.

*1.* A afirmação ($mu <= 23$) fica em $H_0$: $H_0: mu = 23$ vs $H_1: mu > 23$.

*2.* $Z = (overline(X) - 23)/(0,9) ~ N(0;1)$.

*3.* $alpha = 0,10 arrow.r R_c = {z > 1,28}$.

*4.* $z_"obs" = (24,17 - 23)/(0,9) = 1,30 in R_c$; valor-p $= P(Z > 1,30) = 0,097 < 0,10$.

#resp[Rejeita $H_0$ a 10%: não se pode aceitar a afirmação do fabricante (por pouco -- a 5% não rejeitaríamos).]

== Exercício 8 -- Consumo _per capita_

$X ~ N(mu; 2^2)$, $n = 25$, $overline(x) = 180\/25 = 7,2$, $sigma\/sqrt(n) = 0,4$.

#item("a") *1.* $H_0: mu = 8$ vs $H_1: mu < 8$.
*2.* $Z = (overline(X) - 8)/(0,4)$.
*3.* $R_c = {z < -1,645} <==> overline(x) < 8 - 1,645(0,4) = 7,342$.
*4.* $z_"obs" = (7,2 - 8)/(0,4) = -2,00 in R_c$; valor-p $= P(Z < -2) = 0,023$.

#resp[Rejeita $H_0$: a diretoria deve *retirar* o produto.]

#item("b") $beta = P("não rejeitar" | mu = 7,8) = P(overline(X) >= 7,342 | mu = 7,8) = P(Z >= (7,342 - 7,8)/(0,4)) = P(Z >= -1,145)$.

#resp[$beta approx 0,874$ (poder $approx 0,126$).]

#item("c") $alpha = 0,01 arrow.r R_c = {z < -2,33}$; $z_"obs" = -2,00 in.not R_c$. #resp[Não rejeita $H_0$: a decisão *muda* (mantém o produto).]

#item("d") $sigma = 4 arrow.r sigma\/sqrt(n) = 0,8$; $z_"obs" = (7,2 - 8)/(0,8) = -1,00 > -1,645$. #resp[Não rejeita $H_0$ (valor-p $= 0,16$): mantém o produto.]

== Exercício 9 -- Receitas municipais

Dados ($n = 10$): $sum x_i = 13500 arrow.r overline(x) = 1350$; $sum (x_i - overline(x))^2 = 4110650$

$ s^2 = 4110650/9 = 456738,9, quad s = 675,82, quad s/sqrt(10) = 213,71 $

*1.* $H_0: mu = 1229$ vs $H_1: mu > 1229$.

*2.* $sigma$ desconhecido $arrow.r$ $T = (overline(X) - 1229)/(S\/sqrt(10)) ~ t_9$ (supondo normalidade).

*3.* $R_c = {t > t_(0,05;9) = 1,833}$.

*4.* $t_"obs" = (1350 - 1229)/(213,71) = 0,566 in.not R_c$; valor-p $= 0,29$.

#resp[Não rejeita $H_0$: o teste leva à aceitação de que a média das cidades pequenas é igual à do estado (1229).]

== Exercício 10 -- Precipitação pluviométrica

$sum x_i = 270,4 arrow.r overline(x) = 30,04$; $n = 9$; $sigma\/sqrt(n) = 3,1\/3 = 1,033$.

#item("a") $H_0: mu = 30$ vs $H_1: mu > 30$; $R_c = {z > 1,645} <==> overline(x) > 30 + 1,645(1,033) = 31,70$.

$ z_"obs" = (30,04 - 30)/(1,033) = 0,043, quad "valor-p" = 0,483 $

#resp[Não rejeita $H_0$: não há evidência de que a média seja maior que 30.]

#item("b") $sigma$ desconhecido: $s^2 = 9,94$, $s = 3,15$; $T ~ t_8$, $R_c = {t > 1,86}$:

$ t_"obs" = (30,04 - 30)/(3,153\/3) = 0,042 $

#resp[Mesma conclusão (não rejeita). Muda a estatística ($S$ no lugar de $sigma$) e a distribuição de referência ($t_8$, caudas mais pesadas $arrow.r$ valor crítico maior).]

#item("c") $alpha = 0,01 arrow.r R_c = {z > 2,33}$; $z_"obs" = 0,043$. #resp[Mesma decisão: não rejeita $H_0$ (o valor-p 0,48 é maior que qualquer $alpha$ usual).]

#item("d") Com $mu = 33$, $H_0$ é falsa; erro = não rejeitar (tipo II), com $alpha = 5%$:

$ beta = P(overline(X) <= 31,70 | mu = 33) = P(Z <= (31,70 - 33)/(1,033)) = P(Z <= -1,26) $

#resp[$beta approx 0,104$.]

== Exercício 11 -- Equipamentos conforme especificação

$hat(p) = (200 - 25)\/200 = 0,875$ (proporção conforme).

*1.* $H_0: p = 0,90$ vs $H_1: p < 0,90$.

*2.* $Z = (hat(p) - 0,9)/sqrt(0","9 dot 0","1\/200)$; $sqrt(0","09\/200) = 0,02121$.

*3.* $R_c$: $z < -1,645$ (5%) ou $z < -2,33$ (1%).

*4.* $z_"obs" = (0,875 - 0,9)/(0,02121) = -1,18$; valor-p $= P(Z < -1,18) = 0,119$.

#resp[Não rejeita $H_0$ nem a 5% nem a 1%: os dados não contradizem a afirmação do fabricante.]

== Exercício 12 -- Programa de TV

$hat(p) = 80\/400 = 0,20$.

*1.* $H_0: p = 0,25$ vs $H_1: p < 0,25$.

*2.* $sqrt(0","25 dot 0","75\/400) = 0,02165$; $z_"obs" = (0,20 - 0,25)/(0,02165) = -2,31$.

*3.* $R_c = {z < -1,645}$; valor-p $= P(Z < -2,31) = 0,010$.

#resp[Rejeita $H_0$: menos de 1/4 assiste regularmente $arrow.r$ os produtores devem *modificar* o programa.]

== Exercício 13 -- Bicicleta

$hat(p) = 28\/90 = 0,311$.

*1.* $H_0: p = 0,25$ vs $H_1: p != 0,25$.

*2.* $sqrt(0","25 dot 0","75\/90) = 0,04564$; $z_"obs" = (0,311 - 0,25)/(0,04564) = 1,34$.

*3.* $R_c = {|z| > 1,96}$; valor-p $= 2 P(Z > 1,34) = 0,18$.

#resp[Não rejeita $H_0$: a estimativa de 25% é válida.]

== Exercício 14 -- Radar antimíssil

$hat(p) = 250\/300 = 0,833$.

*1.* A afirmação "não excede 0,8" fica em $H_0$: $H_0: p = 0,8$ vs $H_1: p > 0,8$.

*2.* $sqrt(0","8 dot 0","2\/300) = 0,02309$; $z_"obs" = (0,8333 - 0,8)/(0,02309) = 1,44$.

*3.* $alpha = 0,04 arrow.r R_c = {z > 1,75}$; valor-p $= P(Z > 1,44) = 0,075$.

#resp[Não rejeita $H_0$: aceita-se a afirmação de que o novo sistema não supera 0,8.]

== Exercício 15 -- Pneus A e B (variâncias iguais)

*1.* $H_0: mu_A = mu_B$ vs $H_1: mu_A != mu_B$; $n_A = n_B = 12$.

*2.* Variância combinada:

$ S_p^2 = (11 dot 5100^2 + 11 dot 5900^2)/22 = 30.410.000, quad S_p = 5514,53, quad nu = 22 $

*3.* $R_c = {|t| > t_(0,025;22) = 2,074}$.

*4.* $t_"obs" = (37900 - 39800)/(5514,53 sqrt(2\/12)) = (-1900)/(2251,30) = -0,84$; valor-p $= 0,41$.

#resp[Não rejeita $H_0$: não há diferença significativa no desgaste médio.]

== Exercício 16 -- Ácido sórbico (pareado)

Mesma fatia antes/depois $arrow.r$ amostras dependentes $arrow.r$ teste $t$ pareado. $D_i = "antes" - "depois"$:

#align(center)[
	#table(
		columns: 8,
		inset: 4pt,
		align: center,
		[Fatia], [1], [2], [3], [4], [5], [6], [7],
		[$d_i$], [108], [174], [161], [115], [153], [63], [104],
	)
]

*1.* $H_0: mu_D = 0$ vs $H_1: mu_D != 0$.

*2.* $overline(d) = 878\/7 = 125,43$; $s_D^2 = 9153,71\/6 = 1525,62$; $s_D = 39,06$; $s_D\/sqrt(7) = 14,76$.

*3.* $R_c = {|t| > t_(0,025;6) = 2,447}$.

*4.* $t_"obs" = (125,43)/(14,76) = 8,50 in R_c$; valor-p $approx 0,0001$.

#resp[Rejeita $H_0$: o armazenamento influencia (reduz) a concentração residual de ácido sórbico.]

== Exercício 17 -- Lasanha

$hat(p) = 9\/20 = 0,45$; $n p_0 = 8 >= 5$ e $n(1-p_0) = 12 >= 5$ (aproximação normal razoável).

*1.* $H_0: p = 0,4$ vs $H_1: p != 0,4$.

*2.* $sqrt(0","4 dot 0","6\/20) = 0,1095$; $z_"obs" = (0,45 - 0,40)/(0,1095) = 0,46$.

*3.* $R_c = {|z| > 1,96}$; valor-p $= 2 P(Z > 0,46) = 0,65$.

#resp[Não rejeita $H_0$: os dados são compatíveis com a afirmação de 40%.]

== Exercício 18 -- Função poder (Binomial)

$X$ = nº de sucessos em $n = 10$; $R_c = {0, 1, 2, 8, 9, 10}$; poder $pi(p) = P(X in R_c | p)$.

#item("a") Sob $H_0$ ($p = 0,5$), por simetria $P(X = k) = P(X = 10 - k)$:

$ alpha = 2[P(0) + P(1) + P(2)] = 2 dot (binom(10, 0) + binom(10, 1) + binom(10, 2))/2^10 = 2 dot (1 + 10 + 45)/1024 = 112/1024 $

#resp[$alpha approx 0,109$.]

#item("b") $pi(p) = sum_(k in R_c) binom(10, k) p^k (1-p)^(10-k)$:

#align(center)[
	#table(
		columns: 12,
		inset: 4pt,
		align: center,
		[$p$], [0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7], [0,8], [0,9], [1],
		[$pi(p)$], [1], [0,930], [*0,678*], [0,384], [*0,180*], [0,109], [*0,180*], [0,384], [*0,678*], [0,930], [1],
	)
]

#let curva(pts, xlo, xhi, ylo, yhi, w: 9cm, h: 4cm, xr: (), yr: ()) = {
	let X(v) = (v - xlo) / (xhi - xlo) * w
	let Y(v) = h - (v - ylo) / (yhi - ylo) * h
	align(center, box(width: w + 1cm, height: h + 0.8cm, {
		place(dx: 0.8cm, box(width: w, height: h, {
			place(line(start: (0pt, h), end: (w, h), stroke: 0.5pt))
			place(line(start: (0pt, 0pt), end: (0pt, h), stroke: 0.5pt))
			for i in range(pts.len() - 1) {
				let (a, b) = (pts.at(i), pts.at(i + 1))
				place(line(start: (X(a.at(0)), Y(a.at(1))), end: (X(b.at(0)), Y(b.at(1))), stroke: 1pt + rgb("#3b6fb6")))
			}
			for p in pts {
				place(dx: X(p.at(0)) - 1.8pt, dy: Y(p.at(1)) - 1.8pt, circle(radius: 1.8pt, fill: rgb("#3b6fb6"), stroke: none))
			}
			for (v, r) in xr {
				place(dx: X(v) - 0.5cm, dy: h + 0.1cm, box(width: 1cm, align(center, text(size: 7pt, r))))
			}
			for (v, r) in yr {
				place(dx: -0.8cm, dy: Y(v) - 0.15cm, box(width: 0.7cm, align(right, text(size: 7pt, r))))
				place(dx: 0pt, dy: Y(v), line(length: w, stroke: (paint: luma(200), thickness: 0.4pt, dash: "dotted")))
			}
		}))
	}))
}

#curva(
	((0, 1), (0.1, 0.9298), (0.2, 0.6779), (0.3, 0.3844), (0.4, 0.1796), (0.5, 0.1094), (0.6, 0.1796), (0.7, 0.3844), (0.8, 0.6779), (0.9, 0.9298), (1, 1)),
	0, 1, 0, 1,
	xr: ((0, "0"), (0.2, "0,2"), (0.4, "0,4"), (0.5, "0,5"), (0.6, "0,6"), (0.8, "0,8"), (1, "1")),
	yr: ((0, "0"), (0.5, "0,5"), (1, "1")),
)

#item("c") Em $p = 0,5$ ($H_0$ verdadeira), o poder coincide com a probabilidade de rejeitar $H_0$ verdadeira. #resp[$pi(0,5) = alpha approx 0,109$.]

== Exercício 19 -- Função poder (Normal)

$X ~ N(mu, 400) arrow.r sigma = 20$; $n = 25 arrow.r sigma\/sqrt(n) = 4$. $H_0: mu = 200$ vs $H_1: mu > 200$.

#item("a") $R_c = {overline(x) > 200 + 1,645 dot 4} $. #resp[$R_c = {overline(x) > 206,58}$.]

#item("b") $pi(mu) = P(overline(X) > 206,58 | mu) = P(Z > (206,58 - mu)/4)$:

#align(center)[
	#table(
		columns: 8,
		inset: 4pt,
		align: center,
		[$mu$], [195], [200], [204], [206,58], [210], [215], [220],
		[$pi(mu)$], [0,002], [0,050], [0,259], [0,500], [0,804], [0,982], [0,9996],
	)
]

#curva(
	((195, 0.0019), (200, 0.05), (204, 0.2595), (206.58, 0.5), (210, 0.8037), (215, 0.9824), (220, 0.9996)),
	195, 220, 0, 1,
	xr: ((195, "195"), (200, "200"), (206.58, "206,6"), (210, "210"), (215, "215"), (220, "220")),
	yr: ((0, "0"), (0.5, "0,5"), (1, "1")),
)

#item("c") $pi(mu) > 0,5 <==> (206,58 - mu)\/4 < 0 <==> mu > 206,58$. #resp[Para $mu > 206,58$.]

== Exercício 20 -- Variância da produção

*1.* $H_0: sigma^2 = 300$ vs $H_1: sigma^2 != 300$.

*2.* $Q = ((n-1) S^2)/sigma_0^2 ~ chi^2_23$ sob $H_0$ ($n = 24$).

*3.* $alpha = 0,20$ (bilateral, 0,10 em cada cauda): $chi^2_(23;0,90) = 14,85$ e $chi^2_(23;0,10) = 32,01$. $R_c = {q < 14,85 "ou" q > 32,01}$.

*4.* $q_"obs" = (23 dot 400)/300 = 30,67 in.not R_c$; valor-p $approx 0,26$.

#resp[Não rejeita $H_0$: não há razão para acreditar que a variância mudou.]

== Exercício 21 -- Tempo de operação

#resp(l: "a")[A *variância* $sigma^2$ (ou o desvio padrão $sigma$), pois mede quanto os tempos variam de empregado para empregado.]

#item("b") $overline(x) = 1440\/11 = 130,91$; $sum (x_i - overline(x))^2 = 1140,91$:

$ s^2 = (1140,91)/10 = 114,09, quad s = 10,68 $

#resp[$s^2 = 114,09$ s#super[2] ($s = 10,68$ s).]

== Exercício 22 -- Tempo de adaptação (homens vs mulheres)

*Suposições:* amostras aleatórias e independentes; $n = 50$ em cada grupo é grande $arrow.r$ pelo TLC, $overline(X)_H - overline(X)_M$ é aprox. normal e podemos usar $s$ no lugar de $sigma$.

*1.* $H_0: mu_H = mu_M$ vs $H_1: mu_H != mu_M$.

*2.* $Z = (overline(X)_H - overline(X)_M)/sqrt(S_H^2\/n_H + S_M^2\/n_M) approx N(0;1)$:

$ sqrt((0,8^2)/50 + (0,9^2)/50) = sqrt(0","0128 + 0","0162) = 0,1703 $

*3.* $z_"obs" = (3,2 - 3,7)/(0,1703) = -2,94$; $R_c = {|z| > 1,96}$; valor-p $= 0,003$.

#resp[Rejeita $H_0$: as mulheres levam, em média, mais tempo para se adaptar. IC 95% para $mu_H - mu_M$: $-0,5 plus.minus 1,96(0,1703) = [-0,83 ; -0,17]$ anos.]

== Exercício 23 -- Gasto médio em duas filiais

$sigma = 20$ (conhecido, igual nas duas), $n_1 = n_2 = 50$.

*1.* $H_0: mu_1 = mu_2$ vs $H_1: mu_1 != mu_2$.

*2.* $sigma sqrt(1\/n_1 + 1\/n_2) = 20 sqrt(2\/50) = 20 dot 0,2 = 4$.

*3.* $z_"obs" = (62 - 71)/4 = -2,25$; $R_c = {|z| > 1,96}$; valor-p $= 0,024$.

*4.* Rejeita $H_0$ $arrow.r$ IC para a diferença:

$ (overline(x)_1 - overline(x)_2) plus.minus 1,96 dot 4 = -9 plus.minus 7,84 $

#resp[Não é possível afirmar que os gastos médios sejam iguais (valor-p $= 0,024$). $"IC"_(95%)(mu_1 - mu_2) = [-16,84 ; -1,16]$.]

== Exercício 24 -- Salário inicial: liberais vs administradores

*Estatísticas:* L ($n = 7$): $overline(x) = 69,1\/7 = 9,87$, $s_X^2 = 5,919$. A.E. ($n = 8$): $overline(y) = 73,8\/8 = 9,23$, $s_Y^2 = 0,788$.

A razão das variâncias é $5,919\/0,788 approx 7,5$ (muito diferentes) $arrow.r$ usamos o teste de *Welch*.

*1.* $H_0: mu_L = mu_(A E)$ vs $H_1: mu_L != mu_(A E)$.

*2.* $s_X^2\/n_X = 0,8456$, $s_Y^2\/n_Y = 0,0985$:

$ t_"obs" = (9,871 - 9,225)/sqrt(0","8456 + 0","0985) = (0,646)/(0,9716) = 0,665 $

$ nu = (0,9441)^2/((0,8456)^2\/6 + (0,0985)^2\/7) = (0,8913)/(0,1206) = 7,39 approx 7 $

*3.* $R_c = {|t| > t_(0,025;7) = 2,365}$; valor-p $approx 0,53$.

#resp[Não rejeita $H_0$: não há evidência de que a opção profissional influencie o salário inicial médio. (O teste com variâncias iguais dá $t = 0,70$, valor-p $= 0,49$ -- mesma conclusão.)]

= Lista 10 -- Testes Qui-Quadrado

*Aderência:* $Q = sum_(i=1)^s (O_i - E_i)^2/E_i ~ chi^2_(s - 1 - k)$, com $E_i = n p_i$ ($p_i$ sob $H_0$), $s$ = nº de classes, $k$ = nº de parâmetros *estimados* dos dados.

*Independência / homogeneidade:* $E_(i j) = ("total linha"_i times "total coluna"_j)\/n$; $Q = sum_(i,j) (O_(i j) - E_(i j))^2/E_(i j) ~ chi^2_((r-1)(c-1))$.

Condição: $E_i >= 5$ (agregar classes se necessário). Rejeita $H_0$ se $Q > chi^2_(nu; alpha)$.

== Exercício 1 -- Sexo dos bebês

#item("a") $X = 1$ se menina. #resp[$H_0$: $X ~ "Bernoulli"(0,55)$ (ou $p = 0,55$); $H_1$: $p != 0,55$.]

#item("b") $n = 25$; esperados: $25(0,55) = 13,75$ meninas e $25(0,45) = 11,25$ meninos.

#align(center)[
	#table(
		columns: 4,
		inset: 4pt,
		align: center,
		[], [Menina], [Menino], [Total],
		[$O_i$], [13], [12], [25],
		[$E_i$], [13,75], [11,25], [25],
		[$(O_i - E_i)^2\/E_i$], [0,041], [0,050], [$Q = 0,091$],
	)
]

$nu = 2 - 1 = 1$; $chi^2_(1;0,05) = 3,84$; valor-p $= 0,76$.

#resp[Não rejeita $H_0$: o modelo Bernoulli com $p = 0,55$ é adequado. (Equivale ao teste $Z$ para proporção: $z = -0,30$, $z^2 = 0,091$.)]

== Exercício 2 -- Ajustes de máquinas, $"Bin"(4; 0,01)$

$H_0$: nº de ajustes diários $~ "Bin"(4; 0,01)$; $H_1$: não segue. $n = 22$ dias.

$P(X = k) = binom(4, k) (0,01)^k (0,99)^(4-k)$:

#align(center)[
	#table(
		columns: 6,
		inset: 4pt,
		align: center,
		[$k$], [0], [1], [2], [3], [4],
		[$P(X=k)$], [0,9606], [0,0388], [0,0006], [$approx 0$], [$approx 0$],
		[$E_k = 22 P$], [21,13], [0,85], [0,01], [$approx 0$], [$approx 0$],
		[$O_k$], [13], [6], [2], [1], [0],
	)
]

Agregando $k >= 1$: $O = 9$, $E = 0,87$ -- *ainda menor que 5*. Com $p = 0,01$ e só 22 dias, não há como cumprir $E_i >= 5$; o qui-quadrado não é confiável. Ainda assim:

$ Q = (13 - 21,13)^2/(21,13) + (9 - 0,87)^2/(0,87) = 3,13 + 76,30 = 79,43 >> chi^2_(1;0,04) = 4,22 $

Conferindo com um teste exato: sob $H_0$, $P("dia com" >= 1 "ajuste") = 1 - 0,99^4 = 0,0394$; o nº de dias com ajuste $Y ~ "Bin"(22; 0,0394)$, e $P(Y >= 9) approx 7 times 10^(-8)$.

#resp[Rejeita $H_0$: o modelo $"Bin"(4; 0,01)$ não é adequado -- há muito mais ajustes do que ele prevê.]

== Exercício 3 -- Cabos de aço, Uniforme(0, 5)

#obs[A 2ª faixa aparece como "1 ⊢ 1" no enunciado; é 1 ⊢ 2.]

$H_0$: ponto de ruptura $~ U(0, 5)$; $H_1$: não segue. Sob $H_0$ cada faixa de 1 m tem probabilidade $1\/5$ $arrow.r E_i = 30 dot 1\/5 = 6$.

#align(center)[
	#table(
		columns: 7,
		inset: 4pt,
		align: center,
		[Faixa], [0 ⊢ 1], [1 ⊢ 2], [2 ⊢ 3], [3 ⊢ 4], [4 ⊢ 5], [Total],
		[$O_i$], [7], [6], [4], [6], [7], [30],
		[$E_i$], [6], [6], [6], [6], [6], [30],
		[$(O_i - E_i)^2\/E_i$], [0,167], [0], [0,667], [0], [0,167], [$Q = 1,00$],
	)
]

$nu = 5 - 1 = 4$ (nenhum parâmetro estimado); $chi^2_(4;0,02) = 11,67$; valor-p $= 0,91$.

#resp[Não rejeita $H_0$: o modelo Uniforme Contínuo é adequado.]

== Exercício 4 -- Asma $times$ gripe

$H_0$: asma e gripe são independentes; $H_1$: há associação. Totais: linhas 61 e 89; colunas 69 e 81; $n = 150$.

$ E_(11) = (61 dot 69)/150 = 28,06, quad E_(12) = (61 dot 81)/150 = 32,94, quad E_(21) = (89 dot 69)/150 = 40,94, quad E_(22) = (89 dot 81)/150 = 48,06 $

$ Q = (27 - 28,06)^2/(28,06) + (34 - 32,94)^2/(32,94) + (42 - 40,94)^2/(40,94) + (47 - 48,06)^2/(48,06) = 0,040 + 0,034 + 0,027 + 0,023 = 0,125 $

$nu = (2-1)(2-1) = 1$; $chi^2_(1;0,04) = 4,22$; valor-p $= 0,72$.

#resp[Não rejeita $H_0$: asma e gripe podem ser consideradas independentes.]

== Exercício 5 -- Opinião sobre atendimento (homogeneidade)

$H_0$: a distribuição da opinião é a mesma nas duas cidades; $H_1$: difere. Totais: A = 150, B = 200; Bom 167, Regular 98, Ruim 85; $n = 350$.

#align(center)[
	#table(
		columns: 4,
		inset: 4pt,
		align: center,
		[$E_(i j)$ ($O_(i j)$)], [Bom], [Regular], [Ruim],
		[A], [71,57 (73)], [42,00 (37)], [36,43 (40)],
		[B], [95,43 (94)], [56,00 (61)], [48,57 (45)],
	)
]

$ Q = 0,029 + 0,595 + 0,350 + 0,021 + 0,446 + 0,263 = 1,70 $

$nu = (2-1)(3-1) = 2$; $chi^2_(2;0,05) = 5,99$; valor-p $= 0,43$.

#resp[Não rejeita $H_0$: a opinião é a mesma nas duas cidades.]

== Exercício 6 -- Desempenho esportivo por curso

$H_0$: desempenho independe do curso; $H_1$: depende. Totais: Adm 180, Eco 150; Bom 92, Regular 173, Ruim 65; $n = 330$.

#align(center)[
	#table(
		columns: 4,
		inset: 4pt,
		align: center,
		[$E_(i j)$ ($O_(i j)$)], [Bom], [Regular], [Ruim],
		[Administração], [50,18 (65)], [94,36 (70)], [35,45 (45)],
		[Economia], [41,82 (27)], [78,64 (103)], [29,55 (20)],
	)
]

$ Q = 4,376 + 6,290 + 2,570 + 5,251 + 7,549 + 3,084 = 29,12 $

$nu = (2-1)(3-1) = 2$; $chi^2_(2;0,04) = 6,44$; valor-p $approx 5 times 10^(-7)$.

#resp[Rejeita $H_0$: os cursos não têm o mesmo desempenho (Administração tem mais "Bom" e "Ruim"; Economia concentra-se em "Regular").]

== Exercício 7 -- Acidentes, $"Bin"(5; 0,2)$

$H_0$: nº de dias com acidente $~ "Bin"(5; 0,2)$; $H_1$: não segue. $E_k = 200 dot binom(5, k)(0,2)^k (0,8)^(5-k)$:

#align(center)[
	#table(
		columns: 7,
		inset: 4pt,
		align: center,
		[$k$], [0], [1], [2], [3], [4], [5],
		[$P(X=k)$], [0,3277], [0,4096], [0,2048], [0,0512], [0,0064], [0,0003],
		[$E_k$], [65,54], [81,92], [40,96], [10,24], [1,28], [0,06],
		[$O_k$], [64], [56], [40], [24], [8], [8],
	)
]

$E_4, E_5 < 5$ $arrow.r$ agrupa $k >= 3$: $O = 40$, $E = 11,58$.

#align(center)[
	#table(
		columns: 5,
		inset: 4pt,
		align: center,
		[Classe], [0], [1], [2], [$>= 3$],
		[$(O_i - E_i)^2\/E_i$], [0,04], [8,20], [0,02], [69,71],
	)
]

$Q = 77,97$; $nu = 4 - 1 = 3$ (nenhum parâmetro estimado); $chi^2_(3;0,10) = 6,25$; valor-p $approx 0$.

#resp[Rejeita $H_0$: os dados não aderem à $"Bin"(5; 0,2)$.]

== Exercício 8 -- Reclamações, Uniforme Discreta {0, ..., 5}

$H_0$: $P(X = k) = 1\/6$, $k = 0, dots, 5$; $H_1$: não segue. $E_k = 120\/6 = 20$.

#align(center)[
	#table(
		columns: 8,
		inset: 4pt,
		align: center,
		[$k$], [0], [1], [2], [3], [4], [5], [Total],
		[$O_k$], [8], [32], [28], [24], [16], [12], [120],
		[$(O_k - 20)^2\/20$], [7,2], [7,2], [3,2], [0,8], [0,8], [3,2], [$Q = 22,4$],
	)
]

$nu = 6 - 1 = 5$; $chi^2_(5;0,05) = 11,07$; valor-p $= 0,0004$.

#resp[Rejeita $H_0$: o modelo Uniforme Discreto não é adequado.]

== Exercício 9 -- Notas de Matemática $times$ Física

$H_0$: as notas são independentes; $H_1$: há dependência. Totais: linhas (Mat.) 139, 248, 141; colunas (Fís.) 117, 276, 135; $n = 528$.

#align(center)[
	#table(
		columns: 4,
		inset: 4pt,
		align: center,
		[$E_(i j)$ ($O_(i j)$) / contribuição], [Física Altas], [Física Regulares], [Física Baixas],
		[Mat. Altas], [30,80 (56) / 20,62], [72,66 (71) / 0,04], [35,54 (12) / 15,59],
		[Mat. Regulares], [54,95 (47) / 1,15], [129,64 (163) / 8,59], [63,41 (38) / 10,18],
		[Mat. Baixas], [31,24 (14) / 9,52], [73,70 (42) / 13,64], [36,05 (85) / 66,46],
	)
]

$ Q = 145,78, quad nu = (3-1)(3-1) = 4, quad chi^2_(4;0,02) = 11,67 $

Nível descritivo: $P(chi^2_4 > 145,78) < 0,0001$.

#resp[Rejeita $H_0$ (valor-p $approx 0$): há forte dependência entre as notas -- quem vai bem (mal) em Matemática tende a ir bem (mal) em Física.]

== Exercício 10 -- Ajustes de máquinas, $"Bin"(4; 0,1)$

$H_0$: nº de ajustes $~ "Bin"(4; 0,1)$; $H_1$: não segue.

#align(center)[
	#table(
		columns: 6,
		inset: 4pt,
		align: center,
		[$k$], [0], [1], [2], [3], [4],
		[$P(X=k)$], [0,6561], [0,2916], [0,0486], [0,0036], [0,0001],
		[$E_k = 22 P$], [14,43], [6,42], [1,07], [0,08], [0,00],
		[$O_k$], [13], [6], [2], [1], [0],
	)
]

Para ter $E_i >= 5$, agrupamos $k >= 1$: $O = 9$, $E = 7,57$.

$ Q = (13 - 14,43)^2/(14,43) + (9 - 7,57)^2/(7,57) = 0,142 + 0,272 = 0,41 $

$nu = 2 - 1 = 1$; $chi^2_(1;0,04) = 4,22$; valor-p $= 0,52$.

#resp[Não rejeita $H_0$: o modelo $"Bin"(4; 0,1)$ é adequado.]
