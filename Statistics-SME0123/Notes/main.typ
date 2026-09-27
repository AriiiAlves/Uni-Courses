#import "./lib.typ": *
#import "@preview/diverential:0.3.0": *

#show: project.with(
	title: "Notas de Estatística",
	author: "Ariel Alves da Silva",
	academic-year: "Academic year 2026",
	orcid: "https://orcid.org/xxxx-xxxx-xxxx-xxxx", // Your number
	github: "https://github.com/AriiiAlves",
)

= Probabilidade básica

#definition("União de eventos")[
	$ P(A union B) = P(A) + P(B) - P(A inter B) $
]

#definition("Mutuamente Exclusivo")[
	A, B mutuamente exclusivos:

	$ P(A inter B)=0 $
]

#definition("Probabilidade condicional")[
	Probabilidade de A dado que ocorreu B:

	$ P(A|B)=P(A inter B)/P(B) arrow.l.r.double P(A inter B) = P(A|B)P(B) $
]

#definition("Independência")[
	$ P(A|B)=P(A) arrow.r P(A inter B) = P(A)P(B) $
]

#theorem("AND/OR")[
	$ P(A" e "b) arrow.r P(A inter B) $
	$ P(A" ou "b) arrow.r P(A union B) $
]

#theorem("Espaço amostral")[
	Se há apenas A, B e C em $Omega$, então:

	$ P(A) + P(B) + P(C) = 1 $
]


#theorem("Probabilidade total")[
	$ P(A) = P(A inter B) + P(A inter overline(B)) $
	$ P(A) = P(A | B)P(B) + P(A | overline(B))P(overline(B)) $
	$ P(A) = P(A inter B inter C) + P(A inter overline(B) inter C) + P(A inter B inter overline(C)) + P(A inter overline(B) inter overline(C)) $
]

#theorem("Complemento")[
	$ P(A) = 1 - P(overline(A)) $
	$ P(overline(A) | B) = 1 - P(A | B) $

]

#theorem("Bayes (Troca)")[
	Se $union_(k=0)^N A_i = Omega$, então:
	$ P(A_i|B) = (P(B|A_i)P(A_i))/(sum P(B|A_i)P(A_i)) $

	(São intersecções: $P(A_i inter B)$
]

O segredo para trabalhar com exercícios de probabilidade é, primeiro, extrair $P(A)$, $P(A|B)$, $P(A inter B)$, montar as proposições, e trabalhar com as propriedades.

= Funções de probabilidade

#definition("Variável aleatória")[
		Variável aleatória é uma função $X(omega)$ que associa a cada elemento $omega in Omega$ um número real $x = x(omega)$.


		$ Omega={S,S,S,N,N} arrow.r X(omega) = {1,1,1,0,0} $

		Ela pode ser discreta ou contínua (tempo de vida de objeto, em horas).

		#proof()[	

			Ex: Duas pessoas jogam 3 moedas cada. Qual a probabilidade de obter o mesmo número de caras? (k)

			$ X(Omega) = cases(
				k=0 arrow.r 1" poss." arrow.r k = 1/8,
				k=1 arrow.r 3" poss." arrow.r k = 3/8,
				k=2 arrow.r 3" poss." arrow.r k = 3/8,
				k=3 arrow.r 1" poss." arrow.r k = 1/8,
			) $

			Total: 8 possibilidades

			$ P(A=B) = P(k_a=0 inter k_b=0) + P(k_a=1 inter k_b=1) + \ + P(k_a=2 inter k_b=2) + P(k_a=3 inter k_b=3) $
			
			A e B são independentes, logo: $P(A inter B) = P(A)P(B)$

			$ P(A=B) = (1/8)^2 + (3/8)^2 + (3/8)^2 + (1/8)^2 $
		]
]

#definition("Função massa de probabilidade ou f.m.p. (discreta)")[
	Associa a cada variável aleatória discreta um valor.

	$ p_x (x_i) = P(X(w_i)) $

	Deve satisfazer:

	+ $p_x(x_i)>0$ para todo $x_i$
	+ $sum p_x(x_i) = 1$
]

#definition("Função densidade de probabilidade ou f.d.p. (contínua)")[
	Associa a cada variável aleatória um valor.

	$ f_x (x_i) = P(X(w_i)) $

	Deve satisfazer:

	+ $f_x(x) >=0$ para todo $x in R_x$
	+ $integral_(- infinity)^(+ infinity) f_x (x)d x = 1$
	+ $P(a < X < b) = integral_a^b f_x (x) d x$

	Propriedades:

	- $P(x > a) = P(x >= a) = integral_a^(+ infinity) f_x (x) d x$
	- $P(x >= a) = 1 - P(X < a)$
]

#definition("Função distribuição acumulada")[
	Caso discreto:

	$ F_x (x) = P(X <= x) = sum_(x_i<= x) p_x (x_i) $

	Caso contínuo (é a primitiva):

	$ F_x (x) = P(X <= x) = integral_(- infinity)^(x) f_x (t) d t $

	Consequência imediata:

	$ P(a < X < b) = integral_a^b f_x (x) d x = F_x (b) - F_x (a) $
]

#definition("Esperança Matemática/Valor médio")[
	Seja $X$ uma variável aleatória. No caso discreto:
	
	$ mu = E(X) = sum x p_x (x) $

	($p_x (x)$ virá das distribuições). Caso contínuo:

	$ mu = E(X) = integral_(- infinity)^(+ infinity) x f_x (x) d x $

	Propriedades:

	+ Se $X=a$ (constante), então $E(X)=E(a)=a$
	+ $E(E(X))=E(X)$
	+ $E(a X plus.minus b Y) = a E(X) plus.minus b E(Y)$
]

#definition("Variância")[
	$ sigma^2 = "Var"(X) = E((X - E(X))^2) \ sigma^2 = E(X^2)-[E(X)]^2 $

	Obs: $E(X^2) = sum x^2 p_x (x)" ou "integral_(-infinity)^(+infinity) x^2 f_x (x) d x$

	Propriedades:
	+ Se $X = a$ (constante), então $"Var"(X) = "Var"(a) = 0$
	+ $"Var"(X plus.minus a) = "Var"(X)$
	+ Se X e Y são independentes: $"Var"(a X plus.minus b Y) = a^2 "Var"(X) + b^2 "Var"(Y)$

	A raiz quadrada da variância é o desvio padrão.
]

= Distribuições

== Distribuições Discretas

#definition("Distr. Uniforme Discreta")[
	A variável X assume cada um de seus valores com igual probabilidade.

	$ p_x (x) = cases(
		1/k", "x in {x_1,...,x_k},
		0", caso contrário",
	) $

	Notação: $X ~ U_d (k)$
]

#definition("Distr. de Bernoulli")[
	A variável X assume apenas dois valores:

	$ cases(1", se sucesso", 0", se fracasso") $

	$ p_x (x) = cases(p^x (1-p)^(1-x)", "x in {0,1}, 0", caso contrário") $

	Notação: $X ~ B e r (p)$

	$ mu = p $
	$ sigma^2 = p(1-p) $
]

#definition("Distr. Binominal")[
	Considere *M eventos de Bernoulli independentes*, todos com a *mesma probabilidade de sucesso $p$*.

	$ p_x (x) = cases(binom(M,x)p^x (1-p)^(M-x)", "x in {0,1,...,M), 0", caso contrário") $

	(Obs: diferente de Bernoulli, usa-se $x in {0,1,...,M}$ na potência!)

	Notação: $X ~ B i n (M, p)$

	$ mu = M p $
	$ sigma^2 = M p(1-p) $

	#proof[
		O fabricante indica que a taxa de equipamentos em perfeito estado é 97%.

		a) Seleciona-se ao acaso 20 destes itens. Qual a probabilidade de que haja *pelo menos um* item defeituoso nesses 20?
		
		+ Probabilidade de ter defeito: $1-0.97=0.03$
		+ Pelo menos um: $p_x (X>=1) = 1 - p(X=0)$
		+ $p_x (0) = 1 - binom(20,0)(0.03)^0 (1-0.03)^(20-0) = 1 - 0.54 = 0.46 = 46%$

		b) Selecionando-se aleatoriamente 20 itens em cada um de 10 carregamentos, qual a probabilidade de que haja 3 carregamentos com pelo menos um item defeituoso?
		
		+ Agora que temos a probabilidade de um único caregamento, *aplica-se distribuição binomial novamente com o novo $p$*.
		+ $p_x (3) = binom(10,3)(0.46)^3 (1-0.46)^(10-3) = 0.16 = 16%$
	]
]

#definition("Distr. Geométrica")[
		Considere uma sequência de eventos de Bernoulli independentes, todos com a *mesma probabilidade de sucesso $p$*. Seja a variável X o número de fracassos anteriores ao primeiro sucesso.

		$ p_x (x) = cases(p(1-p)^x", "x in {0,1,...},0", caso contrário") $

	Notação: $X ~ G e o (p)$

	$ mu = (1-p)/p $
	$ sigma^2 = (1-p)/p^2 $

	#proof[
		Um pesquisador está realizando experimentos químicos independentes e sabe que a probabilidade de que cada experimento apresente uma reação positiva é 0.3. Qual a probabilidade de que menos de 3 reações negativas ocorram antes da primeira positiva?

		+ $p_x (X <= 2) = sum_(x=0)^(2) 0.3(1-0.3)^x = 0.66 = 66%$
	]
]

#definition("Distr. Binomial Negativa")[
	Considere eventos de Bernoulli independentes, todos com a mesma probabilidade de sucesso $p$. Seja a variável X como o número de fracassos anteirores ao r-ésimo sucesso.

	$ p_x (x) = cases(
		binom(x+r-1,r-1)p^r (1-p)^x", "x  in {0,1,...},
		0", caso contrário"
	) $

	Notação: $X ~ B N(r,p)$

	$ mu = r((1-p)/p) $
	$ sigma^2 = r((1-p)/p^2) $

	#proof[
		Em uma série do campeonato, o time que ganhar 4 em 7 jogos será o vencedor. Se a probabilidade do time A ganhar de B é 55% e A e B se enfrentarão em uma série de 7 jogos, qual a probabilidade de que A vença a série em 6 jogos?
		
		+ r-ésimo sucesso: 4
		+ Fracassos: 2 em 6 jogos.
		+ $p_x(2) = binom(2+4-1,4-1)0.55^4(1-0.55)^2 = 0.18 = 18%$
	]
]


#definition("Distr. Hipergeométrica")[
	Considere um conjunto de $n$ objetos dos quais $m$ são do tipo I e $n-m$ são do tipo II (complementos). Para um sorteio de $r<n$ objetos, feito ao acaso e sem reposição, defina X como o número de objetos do tipo I selecionados.

	$ p_x (x) = (binom(m,x)binom(n-m,r-x))/binom(n,r) $

	$ max{0,r-(n-m)}<=x<=min{r,m} $
	
	Notação: $x ~ H g e o (m,n,r)$

	$ mu = r m/n $
	$ sigma^2 = (r m(n-m)(n-r))/(n^2(n-1)) $

	#proof[
		Considere que em um lote de 20 peças existam 4 defeituosas. Selecionando 5 dessas peças, sem reposição, qual a probabilidade de escolher 2 defeituosas?
		
		+ $m=4 arrow.r n=16$
		+ $r=5$
		+ $p_x (2) = (binom(4,2)binom(16-4,5-2))/binom(16,5) = 0.3 = 30%$
	]
]

#definition("Distr. Poisson")[
	Muito usada quando se deseja contar o número de eventos de certo tipo que ocorrem em um certo período de tempo ou superfície/volume. Utiliza-se o parâmetro $lambda>0$ (média).

	$ p_x (x) = cases(
		(e^(-lambda)lambda^x)/x!", "x in {0,1,...},
		0", caso contrário"
	) $

	Notação: $X ~ P o i(lambda)$

	$ mu = lambda $
	$ sigma^2 = lambda $

	#proof[
		Uma central telefônica recebe, em média, cinco chamadas p/min. Supondo que a distribuição Poisson seja adequada nessa situação, obtenha a probabilidade de que a central telefônica receba no máximo duas chamadas durante um intervalo de um minuto.
		+ $lambda = 5$
		+ $p_x(X <= 2) = sum_(x=0)^(2) (e^(-5) dot 5^x)/x! = 0.12 = 12%$
	]

	Obsevações

	+ Se $X_1,...,X_n$ são variáveis aleatórias indepentes e $X_i ~ P o i(lambda_i)$, então $ Y = X_1 + ... + X_n ~ P o i (lambda_1+...+lambda_n) $
	+ Se $X ~ B i n(M, p)$, com $M >> p$, pode-se aproximar para Poisson com $lambda = M p$
	+ $E(x) = V a r(x) = lambda$
]

== Distribuições Contínuas

#definition("Distr. Uniforme")[
	Uma variável aleatória contínua X tem distribuição uniforme no intervalo $[alpha, beta],a,b in RR$ se:

	$ f_x (x) = cases(
		1/(beta-alpha)", "alpha <= x <= beta,
		0", caso contrário"
	) $

	Obs: Área = $(beta-alpha) dot 1/(beta-alpha)=1$
	
	Notação: $X ~U(alpha,beta)$

	$ mu = (alpha+beta)/2 $
	$ sigma^2 = (beta-alpha)^2/12 $
]

#definition("Distr. Exponencial")[
	Uma variável aleatória contínua X tem distribuição exponencial com parâmetro $lambda>0$ (média) se:

	$ f_x (x) = cases(
		1/lambda e^(-x/lambda)", "x>=0,
		0", caso contrário"
	) $

	Notação: $X ~ E x p(lambda)$

	$ mu = lambda $
	$ sigma^2 = lambda^2 $
]

#definition("Distr. Normal/Gaussiana")[
	Uma variaǘel aleatória contínua X tem distribuição normal com $mu$ (média) e $sigma^2$ (variância) se:

	$ f_x (x) = 1/sqrt(2 pi sigma^2) e^(-1/(2sigma^2) (x-mu)^2) $
	$ -infinity < x < infinity $

	Notação: $X ~ N(mu, sigma^2)$

	Propriedades: 

	+ A distribuição é simétrica em relação à média. $f_x (mu-x) = f_x (mu +x)$.
	+ A $f.d.a$ é uma integral sem solução analítica. Calculam-se as probabilidades com auxílio de tabela.

	#definition("Distr. Normal-padrão")[
		Se $X ~ N(mu, sigma^2)$, então a variável aleatória Z;

		$ Z = (X-E(X))/sqrt(V a r(X))= (X-mu)/sigma $

		Terá distribuição normal com *média 0 e variância 1*, $Z = N(0,1)$.
	]

	#definition("Aprox. da binomial pela normal")[
		Se $X ~ B i n(M,p)$, sabe-se que:

		$ E(X)=mu=M p $
		$ V a r(X) = sigma^2 = M p(1-p) $

		Seja $Y ~ N(mu, sigma^2)$, com os valores anteriores. Assim, aproxima-se a binomial pela normal.

		$ X ~ B i n(M,p) approx N(mu,sigma^2) $

		A aproximação é boa quando $M p (1-p) >= 3$.
	]
]

== Notas adicionais

#theorem("Expansão de termo na esperança")[
	Se $C(X) = (X+5)^2$ é o custo da função, então $E(C(X))=E(X^2+10X+25)=E(X^2)+10E(X)+25$
]

#theorem("Tabela de distribuição normal padrão")[
	+ A tabela fornece apenas áreas superiores ao ponto $P(Z>=z)$. Assim, se queremos $P(Z<2)$, devemos utilizar $1-P(Z>=2)$.
	+ Para usar a tabela, deve-se padronizar a variável aleatória X: 

	$ Z = (X-mu)/sigma $
]

#theorem("Z-score em Machine Learning")[
	O Z score é útil para otimizar modelos de machine-learning.

	$ Z = (X-mu)/sigma $

	+ Eliminação de diferenças de escala: Se uma featura varia entre 0 e 1 e outra entre 0 e 100.000, o gráfico de erro forma um "vale oval e comprimido". O algoritmo perde muito tempo até encontrar o mínimo. Com dados padronizados, as diferenças de escala somem, e o gráfico fica equilibrado (esférico), agilizando o GD. Isso impede que sinais de alta amplitude dominem o aprendizado do modelo.
	+ Detecção de outliers: Valores com $|Z| > 3$ são anomalias que se desviam drasticamente da média da população original, e podem ser identificados.
]

#theorem("Nota de exercício de distr. normal")[
	Um protocolo de roteamento distribui pacotes de dados de modo que o tempo de latência siga uma distribuição Normal com desvio-padrão de 10 ms. O administrador precisa garantir que apenas 10% dos pacotes tenham latência inferior a 500 ms.
	
	Qual deve ser o tempo médio configurado no sistema?

	+ $sigma = 10 "ms"$
	+ Na tabela, não se pode consultar simplesmente $f_x (Z) = 0.1$, pois a tabela dá $f_x (X>=500)$. Assim, temos que buscar$f_x (X<=500) = 1 - f_x (X>=500)$: 

	$ 1-f_x (Z) = 0.1 arrow.r f_x (Z) = 0.9 arrow.r Z = -1.28 $
	
	+ $Z = (X-mu)/sigma arrow.r -1.28 = (500-mu)/10 arrow.r mu = 512.8$
]


#theorem("Nota de exercício de distr. normal - Acúmulo de média/variância")[
	Um servidor em nuvem suporta até 500 GB de memória RAM para instâncias virtuais. O consumo de cada instância é Normal, com média 70 GB e variância 100 GB².

Qual é a probabilidade aproximada de 7 instâncias independentes ultrapassarem, em conjunto, o limite de 500 GB?

	+ Nova média: $7 dot 70 "GB" = 490 "GB"$
	+ Nova variância: $7 dot 100 "GB"^2 arrow.r sigma = sqrt(700) = 26.48 "GB" $
	+ $Z = (500-490)/26.48 = 0.378$	
	+ $f_x (X>=500) = P(Z>=0.378) = 0.3527$
]

= Variáveis Aleatórias Bidimensionais

Sejam X e Y duas variáveis aleatórias. Quando há interesse na variação conjunta de X e Y, estudamos (X,Y) como uma variável aleatória bidimensional.

#definition("Variável aleatória bidimensional discreta")[
	A variável aleatória bidimensional discreta (X, Y) tem f.m.p. conjunta definida por:

	$ p_(x,y) = P(X=x, Y=y) $

	Ela é utilizada quando há interesse na variação conjunta de X e Y.

	Propriedades:

	+ $ p_(x,y) (x,y) >= 0$	
	+ $ sum_(x_i)sum_(y_i) p_(x,y) (x_i,y_i) = 1$

	#proof[
		$ X = cases(
			1", se a peça passa no 1 teste",
			0", se a peça falha no 1 teste"
		) $

		$ Y = cases(
			1", se a peça passa no 2 teste",
			0", se a peça falha no 2 teste"
		) $
		
		#set align(center)
		#table(
			columns: (auto, auto, auto),
			inset:10pt,
			align:horizon,
			table.header([$p_(x,y) (x,y)$],table.cell(colspan: 2)[*Y*]),
			[X], [0], [1],
			[0], [0.1], [0.2],
			[1], [0.2], [0.5]
		)
		#set align(left)
	]
]

#definition("Distribuições Marginais")[
	Para uma variável aleatória bidimensional, a probabilidade marginal de X é dada por:

	$ p_x (x) = sum_(y_i) p_(x,y) (x,y) $

	E a probabilidade marginal de y é:

	$ p_y (y) = sum_(x) p_(x,y) (x,y) $
]

#definition("Variável aleatória bidimensional contínua")[
	A variável aleatória bidimensional contínua (X,Y) tem f.d.p. conjunta dada por $f_(x,y) (x,y)$ e f.d.a $F_(x,y) (x,y) = P(X <= x, y <= y)$, satisfazendo:

	+ $f_(x,y) (x,y) >= 0$
	+ $integral_(-infinity)^(infinity) integral_(-infinity)^(infinity) f_(x,y) (x,y) d y d x = integral_(-infinity)^(infinity) integral_(-infinity)^(infinity) f_(x,y) (x,y) d x d y = 1$
	+ $F(x,y) (x,y) = P(X <= x, Y <= y) = P(X < x, Y <= y) = P(X<=x, Y<y) = P(X<x,Y<y)$

	Propriedades:

	+ $f_(x,y) (x,y) = dvp(F_(x,y) (x,y), x, y) = dvp(F_(x,y) (x,y), y, x) $
	+ $F_(x,y) (x,y) = integral_(-infinity)^(x) integral_(-infinity)^(y) f_(x,y) (t,w) d w d t$
	+ $P(a <= X <= b, c<= Y <= d) = integral_a^b integral_c^d f_(x,y) (x,y) d y d x$

	Todas as integral são invertíveis por Fubini.
]

#definition("Densidades Marginais")[
	Seja (X,Y) a variável aleatória contínua bidimensional com f.d.p. conjunta $f_(x,y) (x,y)$. A f.d.p. marginal de X é dada por:

	$ f_x (x) = integral f_(x,y) d y $

	E a f.d.p. marginal de Y é:

	$ f_y(y) = integral f_(x,y) (x,y) d x $
]

#definition("Independência Probabilística")[
	Duas variáveis aleatórias X e Y são independentes se a f.m.p. (ou f.d.p.) conjunta de (X,Y) for fatorável no produto das f.m.p. (ou f.d.p.) marginais de de X e Y:

	$ p_(x,y) (x,y) = p_x (x) dot p_y (y) $
	$ f_(x,y) (x,y) = f_x (x) dot f_y (y) $
]

#definition("Esperança")[
	$ E(h(X,Y)) = sum_x_i sum_y_i h(x,y) p_(x,y) (x,y) $

	Ou

	$ E(h(X,Y)) = integral integral h(x,y) f_(x,y) d y d x $

]

#definition("Covariância")[
	$ sigma_(X Y) = C o v(X,Y) = E((X-mu_x)(Y-mu_y)) = E(X Y) - E(X)E(Y) = E(X Y) - mu_x mu_y $

	E a correlação entre X e Y por:

	$ rho_(x,y) = (C o v(X,Y))/(sqrt(V a r(X))sqrt(V a r(Y))) = sigma_(x y)/(sigma_x sigma_y) $
]

#definition("Independência e correlação")[
	Se X e Y são duas variáveis aleatórias independentes, então a correlação entre X e Y é nula. A volta não vale.
]

#definition("Variância de X e Y")[
	Propriedades:

	+ $V a r(X + Y) = V a r(X) + V a r(Y) + 2 C o v(X,Y)$
	+ $V a r(X - Y) = V a r(X) + V a r(Y) - 2 C o v(X,Y)$
	+ $V a r(a X plus.minus b Y) = a^2 V a r(X) + b^2 V a r(Y) plus.minus 2 a b C o v(X,Y)$
	+ Se X,Y independentes: $C o v(X,Y) = 0$
]

#definition("Combinação linear de variáveis aleatórias normais independentes")[
	Sejam $X_1, X_2, ..., X_n$ n variáveis aleatórias independentes tais que $X_i ~ N(mu, sigma^2)$.
	
	Considere $Y = sum_(i=1)^n X_i$. Temos que:

	$ E(Y) = E(sum_(i=1)^n X_i) = sum_(i=1)^n E(X_i) = sum_(i=1)^n mu = n mu $

	e

	$ V a r(Y) = V a r(sum_(i=1)^n X_i) = sum_(i=1)^n V a r(X_i) = sum_(i=1)^n sigma^2 = n sigma^2 $

	Padronizando:

	$ (Y - E(Y))/sqrt(V a r(Y)) = (Y - n mu)/(mu sqrt(n)) ~ N(0,1) $
]
