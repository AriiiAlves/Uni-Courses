#set document(title: "Resolução - Super Lista de Revisão para a P2 - SME0123")
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
#show heading.where(level: 1): it => block(above: 1.4em, below: 0.7em)[
	#set text(size: 11pt, weight: "bold")
	#it.body
	#v(-0.3em)
	#line(length: 100%, stroke: 0.6pt)
]
#show heading.where(level: 2): it => block(above: 1.2em, below: 0.6em)[
	#set text(size: 10.5pt, weight: "bold")
	#it.body
]

// Caixa de resposta final
#let resp(body) = block(
	width: 100%,
	inset: (x: 8pt, y: 6pt),
	radius: 3pt,
	fill: rgb("#eef3fb"),
	stroke: (left: 2pt + rgb("#3b6fb6")),
	breakable: false,
)[*Resposta:* #body]

// Item (a), (b), ...
#let item(l) = [*(#l)*]

#align(center)[
	#text(size: 13pt, weight: "bold")[RESOLUÇÃO -- SUPER LISTA DE REVISÃO PARA A P2] \
	#text(size: 10pt)[Estatística SME0123 -- passo a passo]
]

#v(0.3em)
#text(size: 9pt)[
	Convenções: $z_alpha$ é o quantil tal que $P(Z > z_alpha) = alpha$; $t_(alpha; nu)$ e $chi^2_(nu; alpha)$ análogos (cauda superior). Resultados finais com duas casas decimais.
]

= I. Estimação Pontual

== Exercício 1 -- EMV de $beta$ em $f(x; beta) = (beta + 1) x^beta$, $0 < x < 1$

#item("a") *Verossimilhança.* Produto das densidades (amostra independente):

$ cal(L)(beta) = product_(i=1)^n (beta+1) x_i^beta = (beta+1)^n product_(i=1)^n x_i^beta $

*Log-verossimilhança.*

$ cal(l)(beta) = n ln(beta+1) + beta sum_(i=1)^n ln x_i $

*Derivar e igualar a zero.*

$ (d cal(l))/(d beta) = n/(beta+1) + sum ln x_i = 0 arrow.r.double beta + 1 = -n/(sum ln x_i) $

*Segunda ordem.*

$ (d^2 cal(l))/(d beta^2) = -n/(beta+1)^2 < 0 quad forall beta arrow.r "é máximo" $

#resp[$ hat(beta) = -1 - n/(sum_(i=1)^n ln x_i) $]

#item("b") Com $n = 6$:

#align(center)[
	#table(
		columns: 7,
		inset: 4pt,
		align: center,
		[$x_i$], [0,30], [0,80], [0,27], [0,35], [0,62], [0,55],
		[$ln x_i$], [$-1,2040$], [$-0,2231$], [$-1,3093$], [$-1,0498$], [$-0,4780$], [$-0,5978$],
	)
]

$ sum ln x_i = -4,8621 arrow.r.double hat(beta) = -1 - 6/(-4,8621) = -1 + 1,2340 $

#resp[$hat(beta) = 0,23$]

#item("c") *Propriedade da invariância:* se $hat(beta)$ é EMV de $beta$, então $g(hat(beta))$ é EMV de $g(beta)$. Com $g(beta) = (beta+1)/(beta+2)$:

$ hat(E(X)) = (hat(beta)+1)/(hat(beta)+2) = (1,2340)/(2,2340) $

#resp[$hat(E(X)) = 0,55$ (invariância do EMV).]

== Exercício 2 -- Comparação de $T_1, T_2, T_3$

Usaremos: $E(X_i) = mu$, $"Var"(X_i) = sigma^2$, independência, e $"EQM"(T) = "Var"(T) + "viés"(T)^2$.

#item("a") *Esperança e viés* ($"viés" = E(T) - mu$):

$ E(T_1) = 1/n dot n mu = mu arrow.r "viés" = 0 $
$ E(T_2) = 1/2 (mu + mu) = mu arrow.r "viés" = 0 $
$ E(T_3) = (n mu)/(n+1) arrow.r "viés" = (n mu)/(n+1) - mu = -mu/(n+1) $

#resp[$T_1$ e $T_2$ são não viesados; $T_3$ é viesado (viés $-mu\/(n+1)$, que $arrow.r 0$: assintoticamente não viesado).]

#item("b") *Variância* (independência $arrow.r$ variância da soma = soma das variâncias; $"Var"(a X) = a^2 "Var"(X)$):

$ "Var"(T_1) = 1/n^2 dot n sigma^2 = sigma^2/n $
$ "Var"(T_2) = 1/4 dot 2 sigma^2 = sigma^2/2 $
$ "Var"(T_3) = 1/(n+1)^2 dot n sigma^2 = (n sigma^2)/(n+1)^2 $

*EQM:*

$ "EQM"(T_1) = sigma^2/n, quad "EQM"(T_2) = sigma^2/2, quad "EQM"(T_3) = (n sigma^2)/(n+1)^2 + mu^2/(n+1)^2 = (n sigma^2 + mu^2)/(n+1)^2 $

#item("c") *Consistência:* basta $"EQM"(T) arrow.r 0$ quando $n arrow.r infinity$.

- $"EQM"(T_1) = sigma^2\/n arrow.r 0$ #sym.checkmark
- $"EQM"(T_2) = sigma^2\/2$ não depende de $n$ #sym.crossmark
- $"EQM"(T_3) approx sigma^2\/n + mu^2\/n^2 arrow.r 0$ #sym.checkmark

#resp[$T_1$ e $T_3$ são consistentes; $T_2$ não (só usa 2 observações, a variância não diminui).]

#item("d") *$T_1$ vs $T_2$* (ambos não viesados $arrow.r$ compara variância):

$ sigma^2/n < sigma^2/2 <==> n > 2 $

Logo $T_1$ é mais eficiente que $T_2$.

*$T_1$ vs $T_3$ pelo EQM:*

$ (n sigma^2 + mu^2)/(n+1)^2 < sigma^2/n <==> n^2 sigma^2 + n mu^2 < sigma^2 (n+1)^2 <==> n mu^2 < sigma^2 (2n+1) $

#resp[$T_1$ é mais eficiente que $T_2$ ($n > 2$). $"EQM"(T_3) < "EQM"(T_1)$ quando $mu^2 < (sigma^2 (2n+1))/n$ (ou seja, $mu$ pequeno perto de $sigma$).]

= II. Estimação por Intervalos

== Exercício 3 -- IC para $mu$ com $sigma$ conhecido

#item("a") $X$ = vida útil de uma lâmpada (horas), $X ~ N(mu; 40^2)$. Parâmetro: $mu$ (vida média). Como $sigma = 40$ é *conhecido*, a quantidade pivotal é

$ Z = (overline(X) - mu)/(sigma \/ sqrt(n)) ~ N(0;1) $

por isso usamos $z$ (o $t$ só aparece quando $sigma$ é estimado por $S$).

#item("b") $1 - alpha = 0,96 arrow.r alpha\/2 = 0,02 arrow.r z_(0,02) = 2,05$.

$ "Erro" = z_(0,02) sigma/sqrt(n) = 2,05 dot 40/sqrt(30) = 2,05 dot 7,303 = 14,97 $

$ "IC"_(96%)(mu) = [780 - 14,97 ; 780 + 14,97] $

#resp[$"IC"_(96%)(mu) = [765,03 ; 794,97] approx [765 ; 795]$ horas.]

#item("c") Queremos erro $epsilon = 10$:

$ epsilon = z_(alpha\/2) sigma/sqrt(n) arrow.r.double n = ((z_(alpha\/2) sigma)/epsilon)^2 = ((2,05 dot 40)/10)^2 = 8,2^2 = 67,24 $

#resp[$n = 68$ lâmpadas (sempre arredondar *para cima*).]

== Exercício 4 -- IC para $mu$ com $sigma$ desconhecido

#item("a") Só temos o desvio-padrão *amostral* $s = 6,9$; ao trocar $sigma$ por $S$ ganhamos uma fonte extra de variabilidade, e

$ T = (overline(X) - mu)/(S\/sqrt(n)) ~ t_(n-1) $

#item("b") $n = 50$, g.l. $= 49$, $1-alpha = 0,98 arrow.r t_(0,01;49) = 2,405$.

$ "Erro" = t_(0,01;49) s/sqrt(n) = 2,405 dot (6,9)/sqrt(50) = 2,405 dot 0,9758 = 2,35 $

$ "IC"_(98%)(mu) = [174,5 - 2,35 ; 174,5 + 2,35] $

#resp[$"IC"_(98%)(mu) = [172,15 ; 176,85]$ cm.]

#item("c") O tamanho do erro é a semi-amplitude do IC.

#resp[Com 98% de confiança, o erro ao estimar $mu$ por $174,5$ é no máximo $approx 2,35$ cm.]

== Exercício 5 -- IC para proporção (otimista e conservador)

#item("a") $X_i = 1$ se o eleitor $i$ vota em José João, $0$ caso contrário; $X_i ~ "Bernoulli"(p)$. Estimador: $hat(p) = overline(X) = 1/n sum X_i$; aqui $hat(p) = 0,35$, $n = 50$.

#item("b") $1-alpha = 0,94 arrow.r alpha\/2 = 0,03 arrow.r z_(0,03) = 1,88$.

*Otimista* (usa $hat(p)$ na variância):

$ epsilon = z sqrt((hat(p)(1-hat(p)))/n) = 1,88 sqrt((0,35 dot 0,65)/50) = 1,88 dot 0,0675 = 0,127 $

*Conservador* (usa $p(1-p) <= 1\/4$, o pior caso):

$ epsilon = z sqrt(1/(4n)) = 1,88 sqrt(1/200) = 1,88 dot 0,0707 = 0,133 $

#resp[Otimista: $[0,223 ; 0,477]$. Conservador: $[0,217 ; 0,483]$.]

#item("c") Amplitudes: $2 dot 0,127 = 0,254$ (otimista) e $2 dot 0,133 = 0,266$ (conservador).

#resp[O conservador é mais largo porque substitui $hat(p)(1-hat(p)) = 0,2275$ pelo máximo possível $1\/4 = 0,25$.]

== Exercício 6 -- Tamanho de amostra para proporção

Fórmula do erro: $epsilon = z_(alpha\/2) sqrt((p(1-p))/n) arrow.r.double n = (z_(alpha\/2)/epsilon)^2 p(1-p)$. Com probabilidade 0,90: $z_(0,05) = 1,645$.

#item("a") Sem informação sobre $p$ $arrow.r$ pior caso $p(1-p) = 1\/4$:

$ n = ((1,645)/(0,05))^2 dot 1/4 = 1082,41 dot 0,25 = 270,6 $

#resp[$n = 271$.]

#item("b") Se $p >= 0,8$, o maior valor de $p(1-p)$ nessa faixa ocorre em $p = 0,8$ ($p(1-p)$ decresce para $p > 0,5$): $0,8 dot 0,2 = 0,16$.

$ n = 1082,41 dot 0,16 = 173,2 $

#resp[$n = 174$.]

#item("c") $n = 81$, conservador:

$ epsilon = 1,645 sqrt(1/(4 dot 81)) = (1,645)/18 = 0,0914 $

#resp[$epsilon approx 0,09$.]

#item("d") Queremos $P(|hat(p) - p| <= 0,08)$ com $n = 81$ (conservador):

$ P(|Z| <= (0,08)/sqrt(1\/(4 dot 81))) = P(|Z| <= 0,08 dot 18) = P(|Z| <= 1,44) = 2 Phi(1,44) - 1 = 2(0,9251) - 1 $

#resp[$approx 0,85$.]

== Exercício 7 -- IC para $sigma^2$ e $sigma$

#item("a") Queremos medir quanto os tempos *variam* entre empregados $arrow.r$ parâmetro: *variância* $sigma^2$ (ou desvio-padrão $sigma$).

$ overline(x) = 1440/11 = 130,91 $
$ sum (x_i - overline(x))^2 = 1140,91 arrow.r s^2 = (1140,91)/10 = 114,09, quad s = 10,68 $

#resp[Variância; estimativa pontual $s^2 = 114,09$ ($s = 10,68$ s).]

#item("b") Quantidade pivotal (população normal):

$ Q = ((n-1) S^2)/sigma^2 ~ chi^2_(n-1) = chi^2_10 $

Quantis com $alpha = 0,05$: $chi^2_(10;0,975) = 3,247$ (inferior) e $chi^2_(10;0,025) = 20,483$ (superior).

$ P(3,247 <= (10 S^2)/sigma^2 <= 20,483) = 0,95 arrow.r.double P((10 S^2)/(20,483) <= sigma^2 <= (10 S^2)/(3,247)) = 0,95 $

Os quantis "invertem" porque $sigma^2$ está no *denominador* de $Q$: ao isolar $sigma^2$, inverte-se a desigualdade, e o quantil maior gera o limite inferior.

$ "IC"_(95%)(sigma^2) = [(1140,91)/(20,483) ; (1140,91)/(3,247)] $

#resp[$"IC"_(95%)(sigma^2) = [55,70 ; 351,37]$.]

#item("c") Raiz é monótona crescente $arrow.r$ tira a raiz dos extremos:

#resp[$"IC"_(95%)(sigma) = [sqrt("55,70") ; sqrt("351,37")] = [7,46 ; 18,74]$ s.]

= III. Testes de Hipóteses (uma amostra)

== Exercício 8 -- Teste unilateral para $mu$ com $sigma$ conhecido

$X$ = consumo mensal _per capita_, $X ~ N(mu; 2^2)$, $n = 25$, $overline(x) = 180\/25 = 7,2$, $sigma\/sqrt(n) = 2\/5 = 0,4$.

#item("a") *1. Hipóteses* (retira se $mu < 8$):

$ H_0: mu = 8 quad "vs" quad H_1: mu < 8 $

*2. Estatística:* $Z = (overline(X) - 8)/(0,4) ~ N(0;1)$ sob $H_0$.

*3. Região crítica* ($alpha = 0,05$, unilateral à esquerda): $R_c = {z < -1,645}$, ou $overline(x) < 8 - 1,645 dot 0,4 = 7,342$.

*4. Valor observado:* $z_"obs" = (7,2 - 8)/(0,4) = -2,00 in R_c$.

*5. Valor-p:* $P(Z < -2,00) = 0,0228$.

#resp[Rejeita $H_0$ (valor-p $= 0,023 < 0,05$): há evidência de $mu < 8$, a diretoria deve *retirar* o produto.]

#item("b") Erro tipo II: não rejeitar $H_0$ quando $mu = 7,8$.

$ beta = P(overline(X) >= 7,342 | mu = 7,8) = P(Z >= (7,342 - 7,8)/(0,4)) = P(Z >= -1,145) = 0,874 $

#resp[$beta approx 0,874$; poder $= 1 - beta approx 0,126$.]

#item("c") Com $alpha = 0,01$: $z_c = -2,33$. Como $z_"obs" = -2,00 > -2,33$, não cai em $R_c$ (equivalente: valor-p $0,023 > 0,01$).

#resp[Não rejeita $H_0$: a decisão *muda* (mantém o produto).]

#item("d") $sigma = 4 arrow.r sigma\/sqrt(n) = 0,8$:

$ z_"obs" = (7,2 - 8)/(0,8) = -1,00 > -1,645, quad "valor-p" = P(Z < -1) = 0,159 $

#resp[Não rejeita $H_0$: com mais variabilidade, a diferença $7,2$ vs $8$ deixa de ser significativa.]

== Exercício 9 -- Precipitação pluviométrica

$sum x_i = 270,4 arrow.r overline(x) = 30,04$, $n = 9$, $sigma = 3,1 arrow.r sigma\/sqrt(n) = 1,033$.

#item("a") *Hipóteses:* $H_0: mu = 30$ vs $H_1: mu > 30$.

*Estatística:* $Z = (overline(X) - 30)/(3,1\/3) ~ N(0;1)$ sob $H_0$.

*Região crítica* ($alpha = 0,05$): $R_c = {z > 1,645}$, ou $overline(x) > 30 + 1,645 dot 1,033 = 31,70$.

$ z_"obs" = (30,04 - 30)/(1,033) = 0,043, quad "valor-p" = P(Z > 0,043) = 0,483 $

#resp[Não rejeita $H_0$: não há evidência de que a média seja maior que 30.]

#item("b") $sigma$ desconhecido $arrow.r$ estima-se por $s$ e usa-se $t$ com $n - 1 = 8$ g.l.:

$ s^2 = 9,94, quad s = 3,15, quad T = (overline(X) - 30)/(S\/sqrt(n)) ~ t_8 $

$ t_"obs" = (0,044)/(3,153\/3) = 0,042, quad t_(0,05;8) = 1,86, quad "valor-p" = 0,484 $

#resp[Mesma conclusão (não rejeita $H_0$). Muda a estatística ($S$ no lugar de $sigma$) e a referência ($t_8$ no lugar de $N(0;1)$, com caudas mais pesadas).]

#item("c") Conclusão errada com $mu = 33$ (ou seja, $H_1$ verdadeira) = erro tipo II (usando o teste do item (a)):

$ beta = P(overline(X) <= 31,70 | mu = 33) = P(Z <= (31,70 - 33)/(1,033)) = P(Z <= -1,26) $

#resp[$beta approx 0,104$.]

== Exercício 10 -- Teste e IC para proporção

#item("a") $X_i = 1$ se a peça $i$ é defeituosa, $X_i ~ "Bernoulli"(p)$; $sum X_i ~ "Bin"(100, p)$. Pelo TLC, $hat(p) approx N(p; p(1-p)\/n)$.

$ H_0: p = 0,05 quad "vs" quad H_1: p > 0,05 $

#item("b") $hat(p) = 9\/100 = 0,09$. Estatística sob $H_0$:

$ Z = (hat(p) - p_0)/sqrt((p_0(1-p_0))/n) = (0,09 - 0,05)/sqrt((0,05 dot 0,95)/100) = (0,04)/(0,02179) = 1,84 $

$R_c = {z > 1,645}$; $z_"obs" = 1,84 in R_c$; valor-p $= P(Z > 1,84) = 0,033$.

#resp[Rejeita $H_0$ ($0,033 < 0,05$): há evidência de que a proporção de defeituosas é maior que 5%.]

#item("c") IC (otimista), $z_(0,025) = 1,96$:

$ epsilon = 1,96 sqrt((0,09 dot 0,91)/100) = 1,96 dot 0,0286 = 0,056 $

#resp[$"IC"_(95%)(p) = [0,034 ; 0,146]$.]

#item("d") No teste, *supomos $H_0$ verdadeira*, então $p = p_0$ é conhecido e a variância de $hat(p)$ é exatamente $p_0(1-p_0)\/n$. No IC não há hipótese: $p$ é desconhecido, então estimamos a variância com $hat(p)$.

= IV. Comparação de Duas Médias

== Exercício 11 -- Amostras pareadas

#item("a") Cada fatia é medida *duas vezes* (antes e depois): as duas observações vêm da mesma unidade, logo são dependentes. Teste adequado: *$t$ pareado*. Suposição: as diferenças $D_i$ são normais.

#item("b") $D_i = "antes"_i - "depois"_i$, $D_i ~ N(mu_D; sigma_D^2)$.

$ H_0: mu_D = 0 quad "vs" quad H_1: mu_D != 0 $

(bilateral: "influencia" não diz a direção.)

#item("c") Diferenças:

#align(center)[
	#table(
		columns: 8,
		inset: 4pt,
		align: center,
		[Fatia], [1], [2], [3], [4], [5], [6], [7],
		[$d_i$], [108], [174], [161], [115], [153], [63], [104],
	)
]

$ overline(d) = 878/7 = 125,43, quad s_D^2 = (sum (d_i - overline(d))^2)/6 = (9153,71)/6 = 1525,62, quad s_D = 39,06 $

$ T = overline(D)/(S_D\/sqrt(n)) ~ t_6, quad t_"obs" = (125,43)/(39,06\/sqrt(7)) = (125,43)/(14,76) = 8,50 $

$t_(0,025;6) = 2,447$; $|t_"obs"| = 8,50 > 2,447$; valor-p $approx 0,0001$.

#resp[Rejeita $H_0$: o armazenamento influencia (diminui) a concentração residual de ácido sórbico.]

== Exercício 12 -- Duas amostras independentes, variâncias iguais

#item("a") $X_1$ = km até desgaste (marca A), $X_1 ~ N(mu_1; sigma^2)$; $X_2$ = km (marca B), $X_2 ~ N(mu_2; sigma^2)$; independentes, $n_1 = n_2 = 12$.

$ H_0: mu_1 = mu_2 quad "vs" quad H_1: mu_1 != mu_2 $

#item("b") Variância combinada:

$ S_p^2 = ((n_1 - 1) s_1^2 + (n_2 - 1) s_2^2)/(n_1 + n_2 - 2) = (11 dot 5100^2 + 11 dot 5900^2)/22 = (5100^2 + 5900^2)/2 $

#resp[$S_p^2 = 30.410.000$, $S_p = 5514,53$, $nu = n_1 + n_2 - 2 = 22$.]

#item("c") Estatística:

$ T = (overline(X)_1 - overline(X)_2)/(S_p sqrt(1\/n_1 + 1\/n_2)) ~ t_22 $

$ t_"obs" = (37900 - 39800)/(5514,53 sqrt(2\/12)) = (-1900)/(2251,30) = -0,84 $

$t_(0,025;22) = 2,074$; $|t_"obs"| = 0,84 < 2,074$; valor-p $= 0,408$.

#resp[Não rejeita $H_0$: não há evidência de diferença no desgaste médio das marcas.]

== Exercício 13 -- Duas amostras independentes, variâncias diferentes (Welch)

#item("a") $X$ = salário inicial (L.), $X ~ N(mu_X; sigma_X^2)$, $n_X = 7$; $Y$ = salário inicial (A.E.), $Y ~ N(mu_Y; sigma_Y^2)$, $n_Y = 8$; independentes, $sigma_X^2 != sigma_Y^2$.

$ H_0: mu_X = mu_Y quad "vs" quad H_1: mu_X != mu_Y $

#item("b") *Médias e variâncias:*

$ overline(x) = (69,1)/7 = 9,87, quad s_X^2 = 5,919 $
$ overline(y) = (73,8)/8 = 9,23, quad s_Y^2 = 0,788 $

*Estatística de Welch:*

$ s_X^2/n_X = 0,8456, quad s_Y^2/n_Y = 0,0985 $

$ T = (overline(X) - overline(Y))/sqrt(S_X^2\/n_X + S_Y^2\/n_Y), quad t_"obs" = (9,871 - 9,225)/sqrt(0","8456 + 0","0985) = (0,646)/(0,9716) = 0,665 $

*Graus de liberdade (Welch-Satterthwaite):*

$ nu = (s_X^2\/n_X + s_Y^2\/n_Y)^2/((s_X^2\/n_X)^2/(n_X - 1) + (s_Y^2\/n_Y)^2/(n_Y - 1)) = (0,9441)^2/((0,8456)^2\/6 + (0,0985)^2\/7) = (0,8913)/(0,1206) = 7,39 approx 7 $

(arredonda-se para baixo, o que é conservador.)

#item("c") $t_(0,025;7) = 2,365$; $|t_"obs"| = 0,665 < 2,365$; valor-p $approx 0,53$.

#resp[Não rejeita $H_0$: não há evidência, a 5%, de diferença no salário inicial médio entre liberais e administradores.]

= V. Testes Qui-Quadrado

== Exercício 14 -- Aderência à Binomial(5; 0,2)

#item("a") $H_0$: o número de dias com acidente segue $"Bin"(5; 0,2)$; $H_1$: não segue.

#item("b") $P(X = k) = binom(5, k) dot (0,2)^k dot (0,8)^(5-k)$ e $E_k = 200 dot P(X = k)$:

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

$E_4$ e $E_5$ são menores que 5 $arrow.r$ agrupa as classes $k >= 3$: $O = 24 + 8 + 8 = 40$, $E = 10,24 + 1,28 + 0,06 = 11,58$.

#item("c") $Q = sum (O_i - E_i)^2/E_i$ nas $s = 4$ classes:

#align(center)[
	#table(
		columns: 5,
		inset: 4pt,
		align: center,
		[Classe], [0], [1], [2], [$>= 3$],
		[$O_i$], [64], [56], [40], [40],
		[$E_i$], [65,54], [81,92], [40,96], [11,58],
		[$(O_i - E_i)^2\/E_i$], [0,04], [8,20], [0,02], [69,71],
	)
]

$ Q = 77,97, quad nu = s - 1 = 3 $

$nu = s - 1$ (e não $s - 1 - k$) porque *nenhum parâmetro foi estimado* dos dados: $n = 5$ e $p = 0,2$ foram dados ($k = 0$).

#item("d") $chi^2_(3;0,10) = 6,25$; $Q = 77,97 > 6,25$; valor-p $approx 0$.

#resp[Rejeita $H_0$: os dados não aderem à $"Bin"(5; 0,2)$ (há muito mais semanas com 3 ou mais dias de acidente do que o modelo prevê).]

== Exercício 15 -- Independência (curso $times$ aprovação)

#item("a") Variáveis: $A$ = participou do curso (sim/não); $B$ = aprovado (sim/não).

$H_0$: $A$ e $B$ são independentes; $H_1$: há associação.

Esperadas: $E_(i j) = ("total linha"_i dot "total coluna"_j)/n$. Totais: linhas 50 e 50; colunas 65 e 35; $n = 100$.

$ E_(11) = (50 dot 65)/100 = 32,5, quad E_(12) = (50 dot 35)/100 = 17,5 $

e igual na segunda linha (mesmo total): $E_(21) = 32,5$, $E_(22) = 17,5$.

#item("b") Estatística:

$ Q = (38 - 32,5)^2/(32,5) + (12 - 17,5)^2/(17,5) + (27 - 32,5)^2/(32,5) + (23 - 17,5)^2/(17,5) $
$ = 0,931 + 1,729 + 0,931 + 1,729 = 5,32 $

$nu = (r - 1)(c - 1) = 1 dot 1 = 1$; $chi^2_(1;0,05) = 3,84$; $Q = 5,32 > 3,84$; valor-p $= 0,021$.

#resp[Rejeita $H_0$ a 5%: há associação entre fazer o curso e ser aprovado.]

#item("c") Quem fez o curso foi aprovado em 76% dos casos (38/50) contra 54% (27/50) de quem não fez: a associação é positiva. Porém o estudo é *observacional* (os funcionários não foram sorteados para fazer o curso), então *não* dá para concluir causalidade: pode haver variáveis de confundimento (ex.: funcionários mais motivados procuram o curso e também se preparam mais para a avaliação).
