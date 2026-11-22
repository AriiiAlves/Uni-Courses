#import "../lib.typ": *
#import "@preview/diverential:0.3.0": *

= Probabilidade básica

#Highlight1("União de eventos")[
	$ P(A union B) = P(A) + P(B) - P(A inter B) $
]

#Highlight1("Mutuamente Exclusivo")[
	A, B mutuamente exclusivos:

	$ P(A inter B)=0 $
]

#Highlight1("Probabilidade condicional")[
	Probabilidade de A dado que ocorreu B:

	$ P(A|B)=P(A inter B)/P(B) arrow.l.r.double P(A inter B) = P(A|B)P(B) $
]

#Highlight1("Independência")[
	$ P(A|B)=P(A) arrow.r P(A inter B) = P(A)P(B) $
]

#Highlight2("AND/OR")[
	$ P(A" e "b) arrow.r P(A inter B) $
	$ P(A" ou "b) arrow.r P(A union B) $
]

#Highlight2("Espaço amostral")[
	Se há apenas A, B e C em $Omega$, então:

	$ P(A) + P(B) + P(C) = 1 $
]


#Highlight2("Probabilidade total")[
	$ P(A) = P(A inter B) + P(A inter overline(B)) $
	$ P(A) = P(A | B)P(B) + P(A | overline(B))P(overline(B)) $
	$ P(A) = P(A inter B inter C) + P(A inter overline(B) inter C) + P(A inter B inter overline(C)) + P(A inter overline(B) inter overline(C)) $
]

#Highlight2("Complemento")[
	$ P(A) = 1 - P(overline(A)) $
	$ P(overline(A) | B) = 1 - P(A | B) $

]

#Highlight2("Bayes (Troca)")[
	Se $union_(k=0)^N A_i = Omega$, então:
	$ P(A_i|B) = (P(B|A_i)P(A_i))/(sum P(B|A_i)P(A_i)) $

	(São intersecções: $P(A_i inter B)$
]

O segredo para trabalhar com exercícios de probabilidade é, primeiro, extrair $P(A)$, $P(A|B)$, $P(A inter B)$, montar as proposições, e trabalhar com as propriedades.

= Funções de probabilidade

#Highlight1("Variável aleatória")[
		Variável aleatória é uma função $X(omega)$ que associa a cada elemento $omega in Omega$ um número real $x = x(omega)$.


		$ Omega={S,S,S,N,N} arrow.r X(omega) = {1,1,1,0,0} $

		Ela pode ser discreta ou contínua (tempo de vida de objeto, em horas).

		#example()[	

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

#Highlight1("Função massa de probabilidade ou f.m.p. (discreta)")[
	Associa a cada variável aleatória discreta um valor.

	$ p_x (x_i) = P(X(w_i)) $

	Deve satisfazer:

	+ $p_x(x_i)>0$ para todo $x_i$
	+ $sum p_x(x_i) = 1$
]

#Highlight1("Função densidade de probabilidade ou f.d.p. (contínua)")[
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

#Highlight1("Função distribuição acumulada")[
	Caso discreto:

	$ F_x (x) = P(X <= x) = sum_(x_i<= x) p_x (x_i) $

	Caso contínuo (é a primitiva):

	$ F_x (x) = P(X <= x) = integral_(- infinity)^(x) f_x (t) d t $

	Consequência imediata:

	$ P(a < X < b) = integral_a^b f_x (x) d x = F_x (b) - F_x (a) $
]

#Highlight1("Esperança Matemática/Valor médio")[
	Seja $X$ uma variável aleatória. No caso discreto:
	
	$ mu = E(X) = sum x p_x (x) $

	($p_x (x)$ virá das distribuições). Caso contínuo:

	$ mu = E(X) = integral_(- infinity)^(+ infinity) x f_x (x) d x $

	Propriedades:

	+ Se $X=a$ (constante), então $E(X)=E(a)=a$
	+ $E(E(X))=E(X)$
	+ $E(a X plus.minus b Y) = a E(X) plus.minus b E(Y)$
]

#Highlight1("Variância")[
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

#Highlight1("Distr. Uniforme Discreta")[
	A variável X assume cada um de seus valores com igual probabilidade.

	$ p_x (x) = cases(
		1/k", "x in {x_1,...,x_k},
		0", caso contrário",
	) $

	Notação: $X ~ U_d (k)$
]

#Highlight1("Distr. de Bernoulli")[
	A variável X assume apenas dois valores:

	$ cases(1", se sucesso", 0", se fracasso") $

	$ p_x (x) = cases(p^x (1-p)^(1-x)", "x in {0,1}, 0", caso contrário") $

	Notação: $X ~ B e r (p)$

	$ mu = p $
	$ sigma^2 = p(1-p) $
]

#Highlight1("Distr. Binominal")[
	Considere *M eventos de Bernoulli independentes*, todos com a *mesma probabilidade de sucesso $p$*.

	$ p_x (x) = cases(binom(M,x)p^x (1-p)^(M-x)", "x in {0,1,...,M), 0", caso contrário") $

	(Obs: diferente de Bernoulli, usa-se $x in {0,1,...,M}$ na potência!)

	Notação: $X ~ B i n (M, p)$

	$ mu = M p $
	$ sigma^2 = M p(1-p) $

	#example[
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

#Highlight1("Distr. Geométrica")[
		Considere uma sequência de eventos de Bernoulli independentes, todos com a *mesma probabilidade de sucesso $p$*. Seja a variável X o número de fracassos anteriores ao primeiro sucesso.

		$ p_x (x) = cases(p(1-p)^x", "x in {0,1,...},0", caso contrário") $

	Notação: $X ~ G e o (p)$

	$ mu = (1-p)/p $
	$ sigma^2 = (1-p)/p^2 $

	#example[
		Um pesquisador está realizando experimentos químicos independentes e sabe que a probabilidade de que cada experimento apresente uma reação positiva é 0.3. Qual a probabilidade de que menos de 3 reações negativas ocorram antes da primeira positiva?

		+ $p_x (X <= 2) = sum_(x=0)^(2) 0.3(1-0.3)^x = 0.66 = 66%$
	]
]

#Highlight1("Distr. Binomial Negativa")[
	Considere eventos de Bernoulli independentes, todos com a mesma probabilidade de sucesso $p$. Seja a variável X como o número de fracassos anteirores ao r-ésimo sucesso.

	$ p_x (x) = cases(
		binom(x+r-1,r-1)p^r (1-p)^x", "x  in {0,1,...},
		0", caso contrário"
	) $

	Notação: $X ~ B N(r,p)$

	$ mu = r((1-p)/p) $
	$ sigma^2 = r((1-p)/p^2) $

	#example[
		Em uma série do campeonato, o time que ganhar 4 em 7 jogos será o vencedor. Se a probabilidade do time A ganhar de B é 55% e A e B se enfrentarão em uma série de 7 jogos, qual a probabilidade de que A vença a série em 6 jogos?
		
		+ r-ésimo sucesso: 4
		+ Fracassos: 2 em 6 jogos.
		+ $p_x(2) = binom(2+4-1,4-1)0.55^4(1-0.55)^2 = 0.18 = 18%$
	]
]


#Highlight1("Distr. Hipergeométrica")[
	Considere um conjunto de $n$ objetos dos quais $m$ são do tipo I e $n-m$ são do tipo II (complementos). Para um sorteio de $r<n$ objetos, feito ao acaso e sem reposição, defina X como o número de objetos do tipo I selecionados.

	$ p_x (x) = (binom(m,x)binom(n-m,r-x))/binom(n,r) $

	$ max{0,r-(n-m)}<=x<=min{r,m} $
	
	Notação: $x ~ H g e o (m,n,r)$

	$ mu = r m/n $
	$ sigma^2 = (r m(n-m)(n-r))/(n^2(n-1)) $

	#example[
		Considere que em um lote de 20 peças existam 4 defeituosas. Selecionando 5 dessas peças, sem reposição, qual a probabilidade de escolher 2 defeituosas?
		
		+ $m=4 arrow.r n=16$
		+ $r=5$
		+ $p_x (2) = (binom(4,2)binom(16-4,5-2))/binom(16,5) = 0.3 = 30%$
	]
]

#Highlight1("Distr. Poisson")[
	Muito usada quando se deseja contar o número de eventos de certo tipo que ocorrem em um certo período de tempo ou superfície/volume. Utiliza-se o parâmetro $lambda>0$ (média).

	$ p_x (x) = cases(
		(e^(-lambda)lambda^x)/x!", "x in {0,1,...},
		0", caso contrário"
	) $

	Notação: $X ~ P o i(lambda)$

	$ mu = lambda $
	$ sigma^2 = lambda $

	#example[
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

#Highlight1("Distr. Uniforme")[
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

#Highlight1("Distr. Exponencial")[
	Uma variável aleatória contínua X tem distribuição exponencial com parâmetro $lambda>0$ (média) se:

	$ f_x (x) = cases(
		1/lambda e^(-x/lambda)", "x>=0,
		0", caso contrário"
	) $

	Notação: $X ~ E x p(lambda)$

	$ mu = lambda $
	$ sigma^2 = lambda^2 $
]

#Highlight1("Distr. Normal/Gaussiana")[
	Uma variaǘel aleatória contínua X tem distribuição normal com $mu$ (média) e $sigma^2$ (variância) se:

	$ f_x (x) = 1/sqrt(2 pi sigma^2) e^(-1/(2sigma^2) (x-mu)^2) $
	$ -infinity < x < infinity $

	Notação: $X ~ N(mu, sigma^2)$

	Propriedades: 

	+ A distribuição é simétrica em relação à média. $f_x (mu-x) = f_x (mu +x)$.
	+ A $f.d.a$ é uma integral sem solução analítica. Calculam-se as probabilidades com auxílio de tabela.

	#Highlight1("Distr. Normal-padrão")[
		Se $X ~ N(mu, sigma^2)$, então a variável aleatória Z;

		$ Z = (X-E(X))/sqrt(V a r(X))= (X-mu)/sigma $

		Terá distribuição normal com *média 0 e variância 1*, $Z = N(0,1)$.
	]

	#Highlight1("Aprox. da binomial pela normal")[
		Se $X ~ B i n(M,p)$, sabe-se que:

		$ E(X)=mu=M p $
		$ V a r(X) = sigma^2 = M p(1-p) $

		Seja $Y ~ N(mu, sigma^2)$, com os valores anteriores. Assim, aproxima-se a binomial pela normal.

		$ X ~ B i n(M,p) approx N(mu,sigma^2) $

		A aproximação é boa quando $M p (1-p) >= 3$.
	]
	
	#Highlight1("Teorema do limite central")[
		À medida que o tamanho da amostra (n) aumenta, a distribuição da média amostral aproxima-se de uma distribuição normal, independentemente da forma da distribuição original da população.

		- A média da distribuição amostral é igual à media da população original.
		- O desvio padrão é dado por $sigma/sqrt(n)$

		#example[
			Amostra com n=25 de população com $N(80,25)$. ($sigma = 5$)

			Amostra com n=36 de população com $N(75,9)$. ($sigma = 3$)

			Qual a probabilidade da média amostral em n=25 exceder a média amostral em n=26 por no mínimo 3.4 mas no máximo 5.9. 

			Média da diferença:

			$ mu_triangle = 80-75=5 $

			Desvio da diferença (soma das variâncias):

			$ sigma^2_triangle = sigma_1^2/n_1 + sigma_2^2/n_2 = 1.1 $

			Assim, a distribuição da diferença das médias é $N(5,1.1)$.
		]
	]
]


#Highlight1("Distribuição de Weibull")[
	Uma variável aleatória X tem distribuição de Weibull se, para $lambda > 0$ (média):

	$ f_x (x,alpha, beta) = cases(
		alpha beta x^(beta-1) e^(-alpha x^beta)", se "x>=0,
		0", caso contrário"
	) $

	Para $beta=1$, a distribuição se reduz à distribuição exponencial.

	$ mu = alpha^(-1/beta) dot Gamma(1+1/beta) $
	$ sigma^2 = alpha^(-2/beta) {Gamma(1 + 2/beta) - [Gamma(1 + 1/beta)]^2} $

	Onde:
	
	$ Gamma(n) = integral_0^infinity t^(n-1) e^(-t) d t $
	$ Gamma(n) = (n-1)!, n in NN^* $

	Em particular:

	$ Gamma(3/2) = sqrt(pi)/2 $
	
	A função de confiabilidade (sobrevivência) é:

	$ P(T>t) = e^(-alpha x^beta) $
]

== Notas adicionais

#Highlight2("Expansão de termo na esperança")[
	Se $C(X) = (X+5)^2$ é o custo da função, então $E(C(X))=E(X^2+10X+25)=E(X^2)+10E(X)+25$
]

#Highlight2("Tabela de distribuição normal padrão")[
	+ A tabela fornece apenas áreas superiores ao ponto $P(Z>=z)$. Assim, se queremos $P(Z<2)$, devemos utilizar $1-P(Z>=2)$.
	+ Para usar a tabela, deve-se padronizar a variável aleatória X: 

	$ Z = (X-mu)/sigma $
]

#Highlight2("Z-score em Machine Learning")[
	O Z score é útil para otimizar modelos de machine-learning.

	$ Z = (X-mu)/sigma $

	+ Eliminação de diferenças de escala: Se uma featura varia entre 0 e 1 e outra entre 0 e 100.000, o gráfico de erro forma um "vale oval e comprimido". O algoritmo perde muito tempo até encontrar o mínimo. Com dados padronizados, as diferenças de escala somem, e o gráfico fica equilibrado (esférico), agilizando o GD. Isso impede que sinais de alta amplitude dominem o aprendizado do modelo.
	+ Detecção de outliers: Valores com $|Z| > 3$ são anomalias que se desviam drasticamente da média da população original, e podem ser identificados.
]

#Highlight2("Nota de exercício de distr. normal")[
	Um protocolo de roteamento distribui pacotes de dados de modo que o tempo de latência siga uma distribuição Normal com desvio-padrão de 10 ms. O administrador precisa garantir que apenas 10% dos pacotes tenham latência inferior a 500 ms.
	
	Qual deve ser o tempo médio configurado no sistema?

	+ $sigma = 10 "ms"$
	+ Na tabela, não se pode consultar simplesmente $f_x (Z) = 0.1$, pois a tabela dá $f_x (X>=500)$. Assim, temos que buscar$f_x (X<=500) = 1 - f_x (X>=500)$: 

	$ 1-f_x (Z) = 0.1 arrow.r f_x (Z) = 0.9 arrow.r Z = -1.28 $
	
	+ $Z = (X-mu)/sigma arrow.r -1.28 = (500-mu)/10 arrow.r mu = 512.8$
]


#Highlight2("Nota de exercício de distr. normal - Acúmulo de média/variância")[
	Um servidor em nuvem suporta até 500 GB de memória RAM para instâncias virtuais. O consumo de cada instância é Normal, com média 70 GB e variância 100 GB².

Qual é a probabilidade aproximada de 7 instâncias independentes ultrapassarem, em conjunto, o limite de 500 GB?

	+ Nova média: $7 dot 70 "GB" = 490 "GB"$
	+ Nova variância: $7 dot 100 "GB"^2 arrow.r sigma = sqrt(700) = 26.48 "GB" $
	+ $Z = (500-490)/26.48 = 0.378$	
	+ $f_x (X>=500) = P(Z>=0.378) = 0.3527$
]

= Variáveis Aleatórias Bidimensionais

Sejam X e Y duas variáveis aleatórias. Quando há interesse na variação conjunta de X e Y, estudamos (X,Y) como uma variável aleatória bidimensional.

#Highlight1("Variável aleatória bidimensional discreta")[
	A variável aleatória bidimensional discreta (X, Y) tem f.m.p. conjunta definida por:

	$ p_(x,y) = P(X=x, Y=y) $

	Ela é utilizada quando há interesse na variação conjunta de X e Y.

	Propriedades:

	+ $ p_(x,y) (x,y) >= 0$	
	+ $ sum_(x_i)sum_(y_i) p_(x,y) (x_i,y_i) = 1$

	#example[
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

#Highlight1("Distribuições Marginais")[
	Para uma variável aleatória bidimensional, a probabilidade marginal de X é dada por:

	$ p_x (x) = sum_(y_i) p_(x,y) (x,y) $

	E a probabilidade marginal de y é:

	$ p_y (y) = sum_(x) p_(x,y) (x,y) $
]

#Highlight1("Variável aleatória bidimensional contínua")[
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

#Highlight1("Densidades Marginais")[
	Seja (X,Y) a variável aleatória contínua bidimensional com f.d.p. conjunta $f_(x,y) (x,y)$. A f.d.p. marginal de X é dada por:

	$ f_x (x) = integral f_(x,y) d y $

	E a f.d.p. marginal de Y é:

	$ f_y(y) = integral f_(x,y) (x,y) d x $
]

#Highlight1("Independência Probabilística")[
	Duas variáveis aleatórias X e Y são independentes se a f.m.p. (ou f.d.p.) conjunta de (X,Y) for fatorável no produto das f.m.p. (ou f.d.p.) marginais de de X e Y:

	$ p_(x,y) (x,y) = p_x (x) dot p_y (y) $
	$ f_(x,y) (x,y) = f_x (x) dot f_y (y) $
]

#Highlight1("Esperança")[
	$ E(h(X,Y)) = sum_x_i sum_y_i h(x,y) p_(x,y) (x,y) $

	Ou

	$ E(h(X,Y)) = integral integral h(x,y) f_(x,y) d y d x $

]

#Highlight1("Covariância")[
	$ sigma_(X Y) = C o v(X,Y) = E((X-mu_x)(Y-mu_y)) = E(X Y) - E(X)E(Y) = E(X Y) - mu_x mu_y $

	E a correlação entre X e Y por:

	$ rho_(x,y) = (C o v(X,Y))/(sqrt(V a r(X))sqrt(V a r(Y))) = sigma_(x y)/(sigma_x sigma_y) $
]

#Highlight1("Independência e correlação")[
	Se X e Y são duas variáveis aleatórias independentes, então a correlação entre X e Y é nula. A volta não vale.
]

#Highlight1("Variância de X e Y")[
	Propriedades:

	+ $V a r(X + Y) = V a r(X) + V a r(Y) + 2 C o v(X,Y)$
	+ $V a r(X - Y) = V a r(X) + V a r(Y) - 2 C o v(X,Y)$
	+ $V a r(a X plus.minus b Y) = a^2 V a r(X) + b^2 V a r(Y) plus.minus 2 a b C o v(X,Y)$
	+ Se X,Y independentes: $C o v(X,Y) = 0$
]

#Highlight1("Combinação linear de variáveis aleatórias normais independentes")[
	Sejam $X_1, X_2, ..., X_n$ n variáveis aleatórias independentes tais que $X_i ~ N(mu, sigma^2)$.
	
	Considere $Y = sum_(i=1)^n X_i$. Temos que:

	$ E(Y) = E(sum_(i=1)^n X_i) = sum_(i=1)^n E(X_i) = sum_(i=1)^n mu = n mu $

	e

	$ V a r(Y) = V a r(sum_(i=1)^n X_i) = sum_(i=1)^n V a r(X_i) = sum_(i=1)^n sigma^2 = n sigma^2 $

	Padronizando:

	$ (Y - E(Y))/sqrt(V a r(Y)) = (Y - n mu)/(mu sqrt(n)) ~ N(0,1) $
]

= Análise Exploratória de Dado

É aplicada em uma amostra.

== Medidas de Posição

#Highlight1("Média")[
	$ overline(x) = (sum_(i=1)^n x_i)/(n) $
]

#Highlight1("Mediana")[
	$ M d = cases(
		x_c", se n ímpar",
		(x_c+x_(c+1))/2", se n par",
	) $
]

#Highlight1("Moda")[
	Valor mais frequente da amostra.
]

== Medidas de Posição

#Highlight1("Quantil")[
	É o valor que provoca uma divisão conveniente nos dados (ordenados). Ex: O quantil de 10% divide os dados de modo que "10% dos menores valores fiquem à esquerda do valor escolhido para o quantil". O quantil de 50% é a mediana.

	- *Quartis* - Dividem os dados em porções de 25%
	- *Decis* - Dividem os dados em porções de 10%
	- *Percentis* - Dividem os dados em porções de 1%
]

== Medidas de Dispersão

é comum usar as medidas corrigidas (n-1 ao invés de n).

#Highlight1("Variância Corrigida")[
	$ s^2 = (sum_(i=1)^n (x_i-overline(x))^2)/(n-1) $
]

#Highlight1("Desvio Padrão Corrigido")[
	$ s = sqrt((sum_(i=1)^n (x_i-overline(x))^2)/(n-1)) $
]

#Highlight1("Amplitude")[
	$ A = x_n - x_1 $
]

#Highlight1("Coeficiente de Variação")[
	$ C V = s/overline(x) $
]

== Assimetria

#Highlight1("Assimetria da Distribuição")[
	- Simétrica: Média = Mediana = Moda
	- Assimétrica à Direita: Moda < Mediana < Média
	- Assimétria à Esquerda: Média < Mediana < Moda
]

== Curtose

#Highlight1("Curtose da Distribuição")[
	- Leptocúrtica $> 0$: Distribuição mais concentrada
	- Mesocúrtica $approx 0$: Achatamento da distribuição normal
	- Platicúrtica $< 0$: Distribuição mais achatada

	#set align(center)
	#image("./images/image-1.png", width: 50%)
	#set align(left)
]

== Medidas de Associação entre Variáveis Quantitativas

#Highlight1("Covariância (amostral)")[
	$ s_(X Y) = (sum_(i=1)^n (x_i-overline(x))(y_i-overline(y)))/(n-1) $
]

#Highlight1("Coeficiente de Correlação Linear (amostral) de Pearson")[
	$ r = (s_(X Y))/sqrt(s^2_X s^2_Y) $

	Propriedade: $-1 <= r <= 1$

	Classificações (apenas indica):
	- $r=1$ - Correlação perfeita e positiva
	- $r=-1$ - Correlação perfeita e negativa
	- $0.7 <= bar(r) <= 1$ - Correlação forte
	- $0.5 <= bar(r) <= 0.69$ - Correlação moderada
	- $0 <= bar(r) <= 0.49$ - Correlação fraca
]

#Highlight1("Coeficiente de Correlação de Spearman")[
	É definido como o coeficiente de correlação de Pearson entre variáveis classificadas em postos.

	Para uma amostra de tamanho $n$, os $n$ dados brutos $X_i,Y_i$ são convertidos em postos $"rg" X_i, "rg" Y_i$ e o coeficiente é dado por:

	$ r_s = rho_("rg"_X, "rg"_Y) = "cov"("rg"_X, "rg"_Y)/(sigma_"rg"_X sigma_"rg"_Y) $

	*Posto* $"rg"_X_i$ consiste em ordenar os valores $X_i$ e obter a posição (a partir de 1) de $X_i$ no conjunto. O mesmo com $"rg"_Y_i$.

	Apenas se todos os postos $n$ forem números inteiros distintos, o coeficiente pode ser calculado usando a fórmula:

	$ r_s = 1 - (6 sum d_i^2)/(n(n^2-1)) $

	Onde $d_i = "rg"(X_i) - "rg"(Y_i)$.

	#example[
		Correlação entre QI de uma pessoa e horas de televisão por semana.

		#set align(center)
		#table(
			columns: 6,
			align: right,
			stroke: 0.5pt + gray,
			fill: (_, y) => if y == 0 { luma(235) },
			table.header(
				[*QI*, $X_i$], [*Horas de TV por semana*, $Y_i$],
				[*posto* $x_i$], [*posto* $y_i$], [$d_i$], [$d_i^2$],
			),
			[86],  [0],  [1],  [1],  [$0$],  [0],
			[97],  [20], [2],  [6],  [$-4$], [16],
			[99],  [28], [3],  [8],  [$-5$], [25],
			[100], [27], [4],  [7],  [$-3$], [9],
			[101], [50], [5],  [10], [$-5$], [25],
			[103], [29], [6],  [9],  [$-3$], [9],
			[106], [7],  [7],  [3],  [$4$],  [16],
			[110], [17], [8],  [5],  [$3$],  [9],
			[112], [6],  [9],  [2],  [$7$],  [49],
			[113], [12], [10], [4],  [$6$],  [36],
		)
		#set align(left)
	]

	Uma correlação de Spearman igual a 1 ocorre quando as duas variáveis comparadas são monotonamente relacionadas, *mesmo se a relação entre elas não for linear*. (X e Y sempre crescem juntos). Para -1, o contrário (X cresce, Y diminui).

	#set align(center)
	#image("images/image-2.png", width: 40%)
	#set align(left)

	
]

= Boxplot

#Highlight1("Boxplot")[
	#set align(center)
	#image("images/image-3.png", width: 70%)
	#set align(left)

	Obs: 
	- $Q 1$ = 25%
	- $Q 2$ = mediana
	- $Q 3$ = 75%
]

= Introdução à Inferência Estatística

Inferência estatística é fazer uma afirmação sobre os parâmetros da população através da amostra.

- $theta$ = Parâmetro desconhecido que queremos estimar (por Métodos de Estimação Pontual)

#Highlight2("Distribuição Amostral da Média")[
	O que ocorre com a distruibuição de $overline(X)$ se aumentamos o tamanho da amostra?

	$ E(overline(X)) = E(X) = mu $

	$ "Var"(overline(X)) = sigma^2/n arrow.r 0 $
]

#Highlight1("Teorema do Limite Central - TLC")[
	Para amostras aleatórias, a distribuição amostral da média aproxima-se , para n grande:

	$ overline("X") ~ N(mu;sigma^2/n) $

	E a padronização:

	$ Z = (overline(X) - E(overline(X)))/sqrt("Var"(overline(X))) = (overline(X)-mu)/(sigma/sqrt(n)) ~ N(0;1) $
]

#Highlight1("Distribuição Amostral da Proporção")[
	Suponha X com distribuição de Bernoulli com média $mu = E(X) = p$ e variância $sigma^2 = "Var"(X) = p(1-p)$.

	Considere também uma amostra aleatória $X = (X_1,X_2,...,X_n)$ da variável aleatória X.

	Temos interesse em avaliar a proporção $hat(p)$ de indivíduos/elementos que possui a característica (sucesso) na amostra:

	$ hat(p) = (sum_(i=1)^n X_i | "Sucesso")/n $ 

	Pelo TCL, $hat(p)$ terá distribuição aproximadamente normal com média e variância dadas, respectivamente, por:

	$ mu = E(hat(p)) = p $
	$ sigma^2 = "Var"(hat(p)) = (p(1-p))/n $

	Ou seja:

	$ hat(p) ~ N(p; (p(1-p)/n)) $

	E a distribuição padronizada:

	$ Z = (hat(p)-E(hat(p)))/sqrt("Var"(hat(p))) = (hat(p)-p)/sqrt((p(1-p))/n) ~ N(0;1) $
]

#Highlight1("Estimação pontual")[
		Para ober um estimador de determinado parâmetro populacional, utilizaremos alguns métodos para obtenção de estimadores:

		- Método de Mínimos Quadrados
		- Método dos Momentos
		- *Método de Máxima Verossimilhança* - O que usaremos.
	]

	#Highlight1("Método de Máxima Verossimilhança")[
			Seja X uma variável aleatória com f.m.p $p_x (x,theta)$ ou f.d.p. $f_x (x,theta)$, em que $theta$ é o parâmetro que queremos estimar tal que $theta in Theta in RR$. Considere:

			- $X = (X_1, X_2,...,X_n)$ - Amostra aleatória
			- $x = (x_1, x_2,...,x_n)$ - Amostra observada ou vetor de observações de X

			OBS:

			- $theta$ pode ser um vetor, $theta = (theta_1, ..., theta_k)$.
			- Iremos considerar casos onde a variável aleatória não depende de $theta$.

			*Definição: Função de Verossimilhança*
			
			A função de verossimilhança $cal(L)(theta, x)$ é definida por:

			$ cal(L)(theta, x) = product_(i=1)^n p_x (x_i, theta) " ou " product_(i=1)^n f_x (x_i, theta) $

			#Highlight2("De onde vem a função")[
				Ela vem de independência. Se $X_1, ..., X_n$ é amostra aleatória, a probabilidade conjunta de observar exatamente aquela amostra é, por definição:

				$ P(X_1=x_1,...,X_n=x_n) = product_(i=1)^n P(X_i=x_i) = product_(i=1)^n p_x (x_i, theta) $
			]

			*Definição: Função Log-verossimilhança*

			A função de log-verossimilhança $cal(l)(theta, x)$ é definida por:

			$ cal(l)(theta, x) = ln (cal(L)(theta, x)) $

			Com ela, o produtório vira soma (mais fácil de derivar).

			OBS: $log = ln$ (em Estatística)

			*Estimador de Máxima Verossimilhança*

			O estimador de máxima verossimilhança (EMV) de $theta$ ($hat(theta)$) é o valor que maximiza a função $cal(L)(theta,x)$.

			Em alguns casos, podemos obter fazendo:

			$ (partial L (theta, x))/(partial theta) = 0 " , " (partial^2 L (theta, x))/(partial theta^2) < 0 $

			Maximizar $cal(L)(theta, x)$ é equivalente a maximizar $cal(l)(theta, x)$.

			#example[

				*Bernoulli* (discreto)

				Vamos estimar a probabilidade $p$.

				$ p_x (x,p) = p^x (1-p)^(1-x)" , " x in {0,1} $

				$ cal(L)(p) = product_(i=1)^n p^x_i (1-p)^(1-x_i) = p^(sum x_i) (1-p)^(n-sum x_i) $

				$ cal(l) = (sum x_i) ln p + (n - sum x_i) ln(1-p) $

				$ (partial cal(l))/(partial p) = (sum x_i)/p - (n - sum x_i)/(1-p) = 0 arrow.r.double hat(p) = (sum x_i)/n = overline(X) $

				*Poisson* (contínuo)

				Vamos estimar o parâmetro $lambda$.

				$ p_x (x, lambda) = (e^(-lambda) lambda^x)/x! $

				$ cal(L)(lambda) = (e^(- n lambda) lambda^(sum x_i))/(product x_i !) $

				$ cal(l)(lambda) = cal(l)(lambda) = -n lambda + (sum x_i) ln lambda - ln (product x_i !) $

				$ (partial cal(l))/(partial lambda) = -n + (sum x_i)/lambda = 0 arrow.r.double hat(lambda) = overline(X) $
			]

			*Propriedade do EMV: Invariância*

			Se $hat(theta)$ é o EMV de $theta$, então $g(hat(theta))$ é o EMV de $g(theta)$

			#example[
				Bernoulli.

				$ hat(p) = overline(X) $

				$ "Var"(X) = p(1-p) = overline(X)(1-overline(X)) $
			]
		]