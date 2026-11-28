#set document(title: "Super Lista de Revisão para a P2 - SME0123")
#set page(
	paper: "a4",
	margin: (x: 1.6cm, y: 1.8cm),
	columns: 2,
	footer: context [
		#set text(size: 8pt)
		#h(1fr) #counter(page).display("1")
	],
)
#set text(size: 9pt, lang: "pt", font: "New Computer Modern")
#set par(justify: true, leading: 0.55em)
#show table: it => block(breakable: false, it)
#show heading.where(level: 1): it => block(above: 1.1em, below: 0.6em)[
	#set text(size: 9.5pt, weight: "bold")
	#it.body
	#v(-0.3em)
	#line(length: 100%, stroke: 0.5pt)
]

#place(
	top + center,
	scope: "parent",
	float: true,
	block(width: 100%)[
		#set align(center)
		#text(size: 12pt, weight: "bold")[SUPER LISTA DE REVISÃO PARA A P2 - ESTATÍSTICA SME0123]
		#v(-0.4em)
		#text(size: 8.5pt)[
			Um exercício de cada tópico cobrado na P2, extraídos das listas 7 a 10, da aula de exercícios e da 2#super[a] prova anterior (SME0320). \
			Justifique todas as respostas. Use duas casas decimais nos resultados finais, mantendo precisão nos cálculos intermediários.
		]
		#v(0.4em)
	],
)

= I. Estimação Pontual

*Exercício 1* (Meyer 14.4 p.365 -- Lista 7, Ex. 10). Uma variável aleatória $X$ tem f.d.p.

$ f(x; beta) = (beta + 1) x^beta " , " 0 < x < 1. $

(a) Escreva a função de verossimilhança e a log-verossimilhança e calcule o estimador de máxima verossimilhança de $beta$ baseado numa amostra de tamanho $n$. Verifique a condição de segunda ordem.

(b) Calcule a estimativa de MV de $beta$ quando os valores amostrais forem: 0,30; 0,80; 0,27; 0,35; 0,62 e 0,55.

(c) Sabendo que $E(X) = (beta+1)/(beta+2)$, obtenha o EMV de $E(X)$. Que propriedade do EMV você usou?

*Exercício 2* (Aula de exercícios SME0320, Questão 4). Sejam $X_1, ..., X_n$ uma amostra aleatória de uma população com média $mu$ e variância $sigma^2$, com $0 < sigma^2 < infinity$ e $n > 2$. Considere os seguintes estimadores para $mu$:

$ T_1 = overline(X) = (X_1 + ... + X_n)/n $
$ T_2 = (X_1 + X_2)/2 $
$ T_3 = (X_1 + ... + X_n)/(n+1) $

(a) Obtenha a esperança e o viés de cada estimador. Quais são não viesados para $mu$?

(b) Obtenha a variância e o erro quadrático médio (EQM) de cada estimador.

(c) Verifique quais estimadores são consistentes para $mu$. Justifique.

(d) Compare a eficiência de $T_1$ e $T_2$. Compare também $T_1$ e $T_3$ pelo EQM, indicando em que condição $T_3$ apresenta menor EQM.

= II. Estimação por Intervalos

*Exercício 3* (Walpole et al. E.9.4 e 9.8 p.180 -- Lista 8, Ex. 1). Uma indústria elétrica fabrica lâmpadas com vida útil distribuída aproximadamente normal, com desvio-padrão de 40 horas.

(a) Formalize o problema: defina a variável aleatória, sua distribuição e o parâmetro de interesse. Justifique por que se usa o quantil $z$ e não $t$.

(b) Se uma amostra de 30 lâmpadas tem média de vida de 780 horas, determine um intervalo de confiança de 96% para a média populacional de todas as lâmpadas produzidas pela empresa.

(c) Qual deve ser o tamanho da amostra se desejarmos estar 96% confiantes de que nossa média amostral estará dentro das dez horas da média verdadeira?

*Exercício 4* (Walpole et al. E.9.5 p.180 -- Lista 8, Ex. 4). As alturas de uma amostra aleatória de 50 estudantes universitários mostram média de 174,5 centímetros e um desvio-padrão *amostral* de 6,9 centímetros.

(a) Justifique por que aqui a estatística pivotal é $T$ com distribuição t-Student, e não $Z$.

(b) Construa um intervalo de confiança de 98% para a altura média de todos os estudantes.

(c) O que podemos afirmar, com 98% de confiança, sobre o possível tamanho de nosso erro se estimarmos a altura média de todos os estudantes como sendo 174,5 centímetros?

*Exercício 5* (Magalhães e Lima 5 p.235 -- Lista 8, Ex. 9). Numa pesquisa com 50 eleitores, o candidato José João obteve 0,35 da preferência dos eleitores.

(a) Defina a variável aleatória de interesse, sua distribuição e o estimador pontual de $p$.

(b) Construa, para a confiança de 94%, os intervalos *otimista* e *conservador* de confiança para a proporção de votos a serem recebidos pelo candidato, supondo que a eleição fosse nesse momento.

(c) Compare as amplitudes dos dois intervalos e explique de onde vem a diferença.

*Exercício 6* (Magalhães e Lima 29 p.239 -- Lista 8, Ex. 12). Em uma pesquisa de mercado, desejamos estimar a proporção de pessoas que compram o sabonete Bom Cheiro.

(a) Que tamanho de amostra devemos colher para que, com probabilidade 0,90, a proporção amostral não se desvie do verdadeiro valor por mais de 0,05?

(b) Se tivermos a informação adicional de que a aceitação do sabonete é no mínimo 0,8, qual deve ser o tamanho da amostra?

(c) Decidimos colher uma amostra de tamanho 81. Qual o erro máximo que cometemos com probabilidade 0,90?

(d) Para a amostra de tamanho 81, qual a probabilidade de que o erro máximo seja 0,08?

*Exercício 7* (Bussab e Morettin E.16 p.348 -- Lista 9, Ex. 21, adaptado). Numa linha de produção, é muito importante que o tempo gasto numa determinada operação não varie muito de empregado para empregado. Onze empregados apresentaram os tempos abaixo (em segundos) para realizar essa operação:

#align(center)[
	#table(
		columns: 11,
		inset: 3pt,
		align: center,
		stroke: none,
		[125], [135], [115], [120], [150], [130], [125], [145], [125], [140], [130],
	)
]

(a) Que parâmetro estatístico poderia ser usado para avaliar esse fato? Por quê? Qual é a estimativa pontual desse parâmetro?

(b) Supondo que os tempos seguem distribuição Normal, construa um intervalo de confiança de 95% para $sigma^2$. Indique qual é a quantidade pivotal utilizada e por que os quantis aparecem invertidos no intervalo.

(c) Obtenha também o intervalo de 95% para o desvio-padrão $sigma$.

= III. Testes de Hipóteses (uma amostra)

*Exercício 8* (Bussab e Morettin E.6 p.341 -- Lista 9, Ex. 8). Sabe-se que o consumo mensal _per capita_ de um determinado produto tem distribuição normal, com desvio-padrão 2 kg. A diretoria de uma firma que fabrica esse produto resolveu que retiraria o produto da linha de produção se a média de consumo _per capita_ fosse menor do que 8 kg. Caso contrário, continuaria a fabricá-lo. Foi realizada uma pesquisa de mercado, tomando-se uma amostra de 25 indivíduos, e verificou-se que $sum_(i=1)^25 X_i = 180$ kg, em que $X_i$ representa o consumo mensal do $i$-ésimo indivíduo da amostra.

(a) Construa um teste de hipótese adequado, utilizando $alpha = 0,05$, e com base na amostra colhida determine a decisão a ser tomada pela diretoria. Identifique a região crítica e o valor-p.

(b) Qual a probabilidade do erro do tipo II, $beta$, de se tomar uma decisão errada se, na realidade, a média populacional for $mu = 7,8$ kg? Qual o poder do teste nesse ponto?

(c) Se a diretoria tivesse fixado $alpha = 0,01$, a decisão seria a mesma? Justifique.

(d) Se o desvio-padrão da população fosse 4 kg, qual seria a decisão, com $alpha = 0,05$? Justifique.

*Exercício 9* (Bussab e Morettin E.25 p.358 -- Lista 9, Ex. 10). A precipitação pluviométrica anual numa certa região tem desvio-padrão $sigma = 3,1$ e média desconhecida. Para os últimos 9 anos, foram obtidos os seguintes resultados:

#align(center)[
	#table(
		columns: 9,
		inset: 2.5pt,
		align: center,
		stroke: none,
		[30,5], [34,1], [27,9], [35,0], [26,9], [30,2], [28,3], [31,7], [25,8],
	)
]

(a) Construa um teste de hipótese adequado para saber se a média da precipitação pluviométrica anual é maior que 30,0 unidades. Utilize $alpha = 5%$ e apresente o valor-p.

(b) Discuta o mesmo problema, considerando $sigma$ desconhecido. O que muda na estatística de teste e na distribuição de referência?

(c) Supondo que, na realidade, $mu = 33,0$, qual a probabilidade de tirarmos uma conclusão errada?

*Exercício 10* (2#super[a] Prova SME0320, Questão 2). Uma empresa de manufatura afirma que a proporção de peças defeituosas produzidas em uma determinada linha de produção é de 5%. Um engenheiro de produção suspeita que essa proporção seja maior do que a informada. Para verificar essa afirmação, foi selecionada uma amostra aleatória de 100 peças produzidas pela linha, das quais 9 apresentaram defeitos.

(a) Defina a variável aleatória de interesse e sua distribuição de probabilidade. Formule o teste de hipóteses adequado para avaliar a afirmação da empresa.

(b) Realize o teste de hipóteses utilizando um nível de significância de 5%. Calcule o valor-p e interprete o resultado.

(c) Obtenha um intervalo de confiança de 95% para a proporção de peças defeituosas produzidas pela linha.

(d) Por que a estatística do teste usa $p_0$ no denominador, enquanto o intervalo de confiança usa $hat(p)$?

= IV. Comparação de Duas Médias

*Exercício 11* (Walpole et al. E.10.46 p.228 -- Lista 9, Ex. 16). Em um estudo conduzido pelo Departamento de Nutrição Humana e Alimentos da Universidade da Virgínia, foram registrados os dados de comparação dos resíduos de ácido sórbico, em partes por milhão, em presunto imediatamente depois de mergulhado em uma solução de sorbato e após 60 dias de armazenamento.

#align(center)[
	#table(
		columns: 3,
		inset: 3pt,
		align: center,
		[*Fatia*], [*Antes do armazenamento*], [*Depois do armazenamento*],
		[1], [224], [116],
		[2], [270], [96],
		[3], [400], [239],
		[4], [444], [329],
		[5], [590], [437],
		[6], [660], [597],
		[7], [680], [576],
	)
]

(a) Justifique por que as amostras são *dependentes* e qual teste é o adequado. Que suposição é necessária?

(b) Formalize o problema: defina $D_i$, sua distribuição e as hipóteses.

(c) Assumindo que as populações são normalmente distribuídas, há evidência suficiente, num nível de significância de 0,05, para dizermos que o tempo de armazenamento influencia as concentrações residuais de ácido sórbico?

*Exercício 12* (Walpole et al. E.10.36 p.226 -- Lista 9, Ex. 15). Uma grande indústria automobilística está decidindo se compra a marca A ou B de pneus para seus novos modelos. Para ajudá-la a chegar a uma conclusão, um experimento é conduzido usando-se 12 pneus de cada marca. Os pneus são usados até o desgaste. Os resultados são $overline(x)_1 = 37900$ km e $s_1 = 5100$ km, referentes à marca A, e $overline(x)_2 = 39800$ km e $s_2 = 5900$ km, referentes à marca B.

(a) Formalize o problema definindo as variáveis, as amostras, as distribuições e as hipóteses.

(b) Assuma que as populações são aproximadamente normais com *variâncias iguais*. Obtenha a variância amostral combinada $S_p^2$ e os graus de liberdade.

(c) Teste a hipótese de que não há diferença no desgaste médio das duas marcas, com 5% como nível de significância.

*Exercício 13* (Bussab e Morettin E.9 p.372 -- Lista 9, Ex. 24). Para investigar a influência da opção profissional sobre o salário inicial de recém-formados, investigaram-se dois grupos de profissionais: um de liberais (L.) em geral e outro de formados em Administração de Empresas (A.E.). Os resultados abaixo estão expressos em salários mínimos. Verificou-se que as variâncias populacionais são estatisticamente *diferentes*. Considere $alpha = 5%$.

#align(center)[
	#table(
		columns: 9,
		inset: 2.5pt,
		align: center,
		stroke: none,
		[*L.*], [6,6], [10,3], [10,8], [12,9], [9,2], [12,3], [7,0], [],
		[*A.E.*], [8,1], [9,8], [8,7], [10,0], [10,2], [8,2], [8,7], [10,1],
	)
]

(a) Formalize o problema e apresente as hipóteses.

(b) Calcule as médias e as variâncias amostrais, a estatística de teste e os graus de liberdade $nu$ (fórmula de Welch-Satterthwaite).

(c) Apresente a conclusão do teste e o valor-p. Quais seriam suas conclusões no contexto do problema?

= V. Testes Qui-Quadrado

*Exercício 14* (Magalhães e Lima E.27 p.287 -- Lista 10, Ex. 7). O número de dias, em uma semana, em que ocorrem acidentes de trabalho numa grande indústria foi anotado para uma amostra de 200 semanas. Verifique se os dados apresentados abaixo aderem ao modelo Binomial com parâmetros $n = 5$ e $p = 0,2$. Considere $alpha = 10%$.

#align(center)[
	#table(
		columns: 7,
		inset: 3pt,
		align: center,
		[*N#super[o] de acidentes*], [0], [1], [2], [3], [4], [5],
		[*Frequência*], [64], [56], [40], [24], [8], [8],
	)
]

(a) Formule as hipóteses do teste de aderência.

(b) Calcule as frequências esperadas sob $H_0$. Verifique a condição $E_i >= 5$ e agregue as classes quando necessário.

(c) Obtenha a estatística do teste e os graus de liberdade. Por que aqui $nu = s - 1$ e não $s - 1 - k$?

(d) Apresente a conclusão ao nível de significância de 10%.

*Exercício 15* (2#super[a] Prova SME0320, Questão 3). Uma empresa deseja investigar se existe associação entre a realização de um curso de capacitação e a aprovação em uma avaliação interna. Para isso, foram selecionados 100 funcionários, obtendo-se os resultados apresentados na tabela abaixo.

#align(center)[
	#table(
		columns: 3,
		inset: 3.5pt,
		align: center,
		[*Participou do curso*], [*Aprovado: Sim*], [*Aprovado: Não*],
		[Sim], [38], [12],
		[Não], [27], [23],
	)
]

(a) Defina as variáveis envolvidas e formule as hipóteses do teste qui-quadrado de independência. Calcule as frequências esperadas sob a hipótese de independência.

(b) Obtenha a estatística do teste qui-quadrado e os graus de liberdade. Utilizando um nível de significância de 5%, apresente a conclusão do teste e o valor-p.

(c) Interprete o resultado no contexto do problema. A associação observada permite concluir que o curso *causa* a aprovação? Justifique.

= Respostas

#set text(size: 8pt)

*1.* (a) $cal(l)(beta) = n ln(beta+1) + beta sum ln x_i$; $hat(beta) = -1 - n/(sum_(i=1)^n ln x_i)$. (b) $sum ln x_i = -4,8621 arrow.r hat(beta) = 0,23$. (c) Por invariância, $hat(E(X)) = (hat(beta)+1)/(hat(beta)+2) = 0,55$.

*2.* (a) $E(T_1) = E(T_2) = mu$ (não viesados); $E(T_3) = (n mu)/(n+1)$, viés $= -mu/(n+1)$. (b) $"Var"(T_1) = sigma^2/n$, $"Var"(T_2) = sigma^2/2$, $"Var"(T_3) = (n sigma^2)/(n+1)^2$; $"EQM"(T_1) = sigma^2/n$, $"EQM"(T_2) = sigma^2/2$, $"EQM"(T_3) = (n sigma^2 + mu^2)/(n+1)^2$. (c) $T_1$ e $T_3$ são consistentes; $T_2$ não (variância não tende a 0). (d) $T_1$ é mais eficiente que $T_2$ para $n > 2$; $"EQM"(T_3) < "EQM"(T_1)$ se $mu^2 < (sigma^2 (2n+1))/n$.

*3.* (b) $z_(0,02) = 2,05$; $"IC"_(96%) = [765,00 ; 795,00]$. (c) $n = 68$.

*4.* (b) $t_(0,01 ; 49) = 2,40$; $"IC"_(98%) = [172,15 ; 176,85]$. (c) erro máximo $approx 2,35$ cm.

*5.* (b) $z_(0,03) = 1,88$; otimista $[0,223 ; 0,477]$; conservador $[0,217 ; 0,483]$. (c) amplitudes 0,254 e 0,266.

*6.* (a) $n = 271$. (b) $n = 174$. (c) $epsilon = 0,091$. (d) $0,85$.

*7.* (a) a variância (ou o desvio-padrão); $overline(x) = 130,91$, $s^2 = 114,09$, $s = 10,68$. (b) $Q = (10 S^2)/sigma^2 ~ chi^2_10$; $chi^2_(0,025) = 3,247$, $chi^2_(0,975) = 20,483$; $"IC"_(95%)(sigma^2) = [55,70 ; 351,38]$. (c) $"IC"_(95%)(sigma) = [7,46 ; 18,75]$.

*8.* (a) $H_0 : mu = 8$ vs $H_1 : mu < 8$; $overline(x) = 7,2$, $z = -2,00$, $R_c = {z < -1,645}$, valor-p $= 0,023$ $arrow.r$ rejeita $H_0$: retira o produto. (b) $overline(x)_c = 7,34$; $beta = 0,874$, poder $= 0,126$. (c) $z_(0,01) = -2,33$: não rejeita $H_0$ -- a decisão muda. (d) $z = -1,00$: não rejeita $H_0$.

*9.* (a) $H_0 : mu = 30$ vs $H_1 : mu > 30$; $overline(x) = 30,04$; $z = 0,043$, $z_(0,05) = 1,645$, valor-p $= 0,483$ $arrow.r$ não rejeita $H_0$. (b) $s = 3,15$, $t = 0,042$ com 8 g.l., $t_(0,05;8) = 1,86$, valor-p $= 0,484$ $arrow.r$ mesma conclusão. (c) $overline(x)_c = 31,70$; $beta = 0,104$.

*10.* (b) $hat(p) = 0,09$; $z = 1,84$, $z_(0,05) = 1,645$, valor-p $= 0,033 < 0,05$ $arrow.r$ rejeita $H_0$: há evidência de que a proporção é maior que 5%. (c) $"IC"_(95%) = [0,034 ; 0,146]$ (otimista). (d) sob $H_0$ a variância de $hat(p)$ é conhecida e vale $p_0(1-p_0)\/n$; já no IC não há $H_0$, então $p$ é estimado por $hat(p)$.

*11.* (b) $D_i$ = antes $-$ depois: 108, 174, 161, 115, 153, 63, 104. (c) $overline(d) = 125,43$, $s_D = 39,06$, $t = 8,50$ com 6 g.l., $t_(0,025;6) = 2,45$, valor-p $< 0,001$ $arrow.r$ rejeita $H_0$: o armazenamento influencia a concentração residual.

*12.* (b) $S_p^2 = 30.410.000$, $S_p = 5514,53$, $nu = 22$. (c) $t = -0,84$, $t_(0,025;22) = 2,07$, valor-p $= 0,408$ $arrow.r$ não rejeita $H_0$: não há diferença no desgaste médio.

*13.* (b) $overline(x) = 9,87$, $overline(y) = 9,23$, $s_x^2 = 5,919$, $s_y^2 = 0,788$; $t = 0,665$, $nu = 7,39 approx 7$. (c) $t_(0,025;7) = 2,36$, valor-p $= 0,527$ $arrow.r$ não rejeita $H_0$: não há evidência de diferença salarial entre os grupos.

*14.* (b) $E_i$: 65,54; 81,92; 40,96; 10,24; 1,28; 0,06. Como $E_4, E_5 < 5$, agregam-se as classes $>= 3$: $O = 40$, $E = 11,58$. (c) $s = 4$ classes, $nu = 3$ (nenhum parâmetro foi estimado); $Q = 77,97$. (d) $chi^2_(3; 0,10) = 6,25 arrow.r$ rejeita $H_0$: os dados não aderem ao modelo Binomial(5; 0,2).

*15.* (a) $E_(i j)$: 32,5 e 17,5 na primeira linha; 32,5 e 17,5 na segunda. (b) $Q = 5,32$, $nu = 1$, $chi^2_(1; 0,05) = 3,84$, valor-p $= 0,021$ $arrow.r$ rejeita $H_0$. (c) Há evidência de associação entre fazer o curso e ser aprovado, mas associação não implica causalidade (pode haver confundimento, p. ex. funcionários mais dedicados procuram o curso e também estudam mais).
