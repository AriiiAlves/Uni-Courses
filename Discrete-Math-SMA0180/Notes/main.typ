#import "./lib.typ": *
#import "@preview/diverential:0.3.0": *

#show: project.with(
	title: "Notas de Matemática Discreta",
	author: "Ariel Alves da Silva",
	academic-year: "Academic year 2026",
	orcid: "https://orcid.org/xxxx-xxxx-xxxx-xxxx", // Your number
	github: "https://github.com/AriiiAlves",
)

= Contagem

#definition("Conceitos importantes")[
	- _Disjunto_ - Dois conjuntos são disjuntos se não possuem elemento em comum.
	- _Mutuamente disjuntos_ - Um conjunto de conjuntos é uma família de conjuntos mutuamente disjuntos se todos os pares possíveis $S_i$ são disjuntos.
	- _Tamanho de um conjunto_ - Número de elementos distintos em $S$
]

#definition("Princípio da soma")[
	O tamanho de uma união de conjuntos finitos *mutuamente disjuntos* é a soma do tamanho dos conjuntos.

	$ |union_(i=1)^m S_i| = sum_(i=1)^m |S_i| $

	#proof[
		```
		i = 1, ..., r
			j = 1, ..., m
				k = 1, ..., n
		```

		$ |S_(i,j)| = n $
		$ |T_i| = |union_(j=1)^m S(i,j)| = sum_(j=1)^m S(i,j) = sum_(j=1)^m n = m dot n $
		$ "Total" = |union_(i=1)^r T_i| = sum_(i=1)^r T_i = sum_(i=1)^r m dot n = m dot n dot r $
	]
]

#definition("Princípio do produto")[
	O tamanho de uma união de m conjuntos disjuntos de tamanho n é igual a $m dot n$. 

	Ou então, se temos _n maneiras de realizar A_ e _m maneiras de realizar B_, então temos $n dot m$ maneiras de realizar A e B.
]

= Contagem de listas, permutações e subconjuntos

#theorem("Uso do princípio da soma e do produto")[
	Uma senha pode conter 4,5,6,7 ou 8 caracteres. Quantas senhas no total?

	$ P = P_4 union P_5 union P_6 union P_7 union P_8 $

	Como $P_i$ são mutuamente disjuntos, pode-se aplicar o princípio da soma:

	$ |P| = sum_(i=4)^8 |P_i| $

	Para cada letra, há 52 escolhas. Assim, pelo princípio do produto:

	$ |P| = 52^4 + 52^5 + 52^6 + 52^7 + 52^8 $
]

#definition("Princípio da bijeção")[
	Dois conjuntos possuem o mesmo tamanho se, e somente se, há uma função um-para-um de um conjunto em outro.
]

#theorem("Permutação de k-elementos de um conjunto")[
	Quantas permutações de ${1,2,...,n}$ podemos fazer? Ex: Escolher $k=3$ pessoas diferentes de um grupo de $n$ pessoas.

	Lógica: $n dot (n-1) dot (n-2) ...$
	
	$ n!/(n-k)! $
]

#theorem("Contando subconjuntos de um conjunto")[
	Quantos subconjuntos *únicos* de $k$ elementos pode-se fazer em um conjunto de tamanho $n$? A ordem não importa, ou seja, ${1,2} = {2,1}$. Deve-se remover as permutações.
	Usa-se coeficiente binomial para "escolher $k$ dentre $n$":

	$ binom(n,k) = n!/((n-k)!k!) $

	#proof[
		Contar caminhos em 10 passos. Direções possíveis: ${D,D,D,D,D,D,C,C,C,C}$

		$ "_ _ _ _ _ _ _ _ _ _" $

		- $binom(10,4)$: Escolher 4 posições de 10 para C. Elimina repetições (CDC = CDC)
		
		- Ou $binom(10,6)$: Escolher 6 posições de 10 para D.
	]
]

= Coeficientes binomiais

#definition("Relação de Pascal")[
	$ binom(n,k) = binom(n-1, k-1) + binom(n-1, k) $
]

#definition("Teorema binomial")[
	$ (x+y)^n = sum_(i=0)^n binom(n,i) x^(n-i)y^i $

	#theorem("Prova")[
		$ (x+y)^3 = \ = (x x + x y + y x + y y)(x + y) = (x x + x y + y x + y y)x + (x x + x y + y x + y y)y = \ = x x x + x y x + y x x + y x x + x x y + x y y + y x y + y y y $

		- Coeficiente de $x x x = binom(3, 0)$ (escolher 0 posições para y)
		- Coeficiente de $x x y = binom(3, 1)$ (escolher 1 posição para y)
		- Coeficiente de $x y y = binom(3, 2)$ (escolher 2 posições para y)
		- Coeficiente de $y y y = binom(3, 3)$ (escolher 3 posições para y)
	]
]

= Relações de equivalência e contagem

#definition("Relação entre conjuntos")[
	Uma relação entre 2 conjuntos X, Y é um conjunto de pares ordenados:

	$ R = {(x,y)| x in X, y in Y" satisfazem ..."} $

	Quando $(x,y) in R$, escrevemos $x~y$.

	Propriedades:

	+ Reflexiva - $x~x$
	+ Simétrica - $x~y arrow.r.l.double y~x$
	+ Transitiva - $x~y,y~z arrow.r.double x~z$

	Uma relação é de equivalência se é reflexiva, simétrica e transitiva. 

	Dada uma relação de equivalência, as classes de equivalência são os conjuntos formados por elementos *relacionados* ($x=1 arrow.r {y_1,y_2,...}$). De modo geral:

	$ [x] = {y|y~x} $

	As classes de equivalência codificam simetrias/invariâncias.
]

= Aritmética modular

#definition("Conjunto modular")[
	$ZZ_n$ = Inteiros módulo n. Possui as operações de adição e multiplicação.
]

#definition("Propriedades da adição modular")[
	+ $ a mod n = (a + k dot n) mod n $
	+ $ (a + b) mod n = a mod n + b mod n $

	Adicionar/subtrair dos dois lados sempre conserva a igualdade.
]

#definition("Propriedades da multiplicação modular")[
	+ $ (a dot b) mod n = (a mod n dot b mod n) mod n $
	+ $ a = b " "(mod n) arrow.r.double a c = b c " "(mod n) $
	+ $ a = b " "(mod n) arrow.r.double a/c = b/c " "(mod n) arrow.r.l.double m d c(c,n) = 1 $

	Multiplicar dos dois lados sempre conserva a igualdade.
	
	Dividir dos dois lados só conserva a igualdade se o divisor for coprimo com $n$ (sem fatores em comum).
]

#definition("Coprimo")[
		Um número $a$ é coprimo com $n$ se $m d c(a, n) = 1$. Isso também pode ser visto como a existência de inverso multiplicativo.
	]


#definition("Inverso multiplicativo e Algoritmo estendido de Euclides")[
	Dado $a in ZZ_n$, o inverso multiplicativo na operação de módulo é caracterizado por:

	$ a a^(-1) = 1 mod n $

	Essa equação só tem solução se $m d c(a,n) = 1$ (Teorema de Bezault é válido para 1).


	#definition("Algoritmo de Euclides")[
		Dado $a > b$:

		$ m d c(a,b) $
		$ a = k dot b + r $
		$ m d c(a,b) = m d c(r,b) $

		E assim por diante, até $ m d c(x,1) $.

		Resumo: Pega maior e substitui pelo módulo com o menor.
	]

	#definition("Teorema de Bezault")[
		Dados $a, n in ZZ$,  $exists alpha,beta in ZZ$ tal que: 

		$ m d c(a,n) = alpha a + beta n $
	]

		
	#definition("Algoritmo estendido de Euclides")[
		Dado o teorema de Bezault, o algoritmo estendido de Euclides consiste em encontrar $alpha, beta$ tal que:

		$ alpha dot a + beta dot b = m d c(a,b) $

		Através do seguinte algoritmo:

		+ Calcular $m d c$ através do algoritmo de Euclides, guardando todas as expressões do tipo $a = k dot b + r$
		+ Ao chegar em $r=m d c(a,b)$, deve-se colocar $m d c(a,b)$ em função de $a,b$, substituindo todos os restos, da última para a primeira expressão.
		
		#proof[
			Dado $m d c(1097, 520) = 1$, queremos encontrar $alpha, beta$ tal que $alpha dot 1097 + beta dot 520 = 1$.

			Primeiro, o algoritmo de Euclides.

			$ m d c(1097,520) = m d c(57, 520) = m d c(57, 7) = m d c(1,7) $
			$ cases(
				107 = 2 dot 520 + 57,
				520 = 9 dot 57 + 7,
				57 = 8 dot 7 + 1
			) $

			Depois, isolamos os restos:

			$ cases(
				57 = 107 - 2 dot 520,
				7 = 520 - 9 dot 57,
				1 = 57 - 8 dot 7 
			) $

			E substituímos, do último para o primeiro:

			$ 1 = 57 - 8 dot 7 $
			$ 1 = 57 - 8 dot (520 - 9 dot 57) $
			$ 1 = -8 dot 520 + 73 dot 57 $
			$ 1 = - 8 dot 520 + 73(1097 - 2 dot 520) $
			$ 1 = - 154 dot 520 + 73 dot 1097 $
			
			Assim:

			$ therefore alpha = 73, beta = -154 $
		]
	]

	
	Exemplo de cálculo de inverso multiplicativo.
	
	#proof[
		Para $a=520, n=1097$:

		$ m d c(520,1097)=1 $

		Aplicando Euclides estendido:

		$ -154 dot 520 + 73 dot 1097 = 1 $

		Aplicando $mod 1097$:

		$ -154 dot 520 mod 1097 = 1 mod 1097 $

		A solução precisa estar em $ZZ_(1096)$, ou seja, $a^(-1) in {0, 1096}$. Para isso, basta somar o módulo, que encontra-se um resultado equivalente:

		$ (-154 + 1097) dot 520 mod 1097 = - 154 dot 520 mod 1097 + 1097 dot 520 mod 1097 = 1 mod 1097 $

		Portanto:

		$ therefore a^(-1) = -154+1097 = 943 $
	]

	Obs: Se o resultado for negativo, basta aplicar:

	$ a^(-1) equiv a^(-1) + n $

	Para encontrar um resultado equivalente dentro de $ZZ_n$.
]

#definition("Pequeno teorema de Fermat")[
	Dado $p$ primo:

	$ a^(p-1) = 1 mod p $

	Em particular, se $a in ZZ_p$ então:

	$ a^(-1) = a^(p-2) mod p $

	Na prática, isso permite simplificar potências gigantescas.
	
	#proof[
		$ 7^1020 mod 103 $
		$ 1020 = 10 dot (103-1) + 0 $
		$ 7^(10 dot 102) dot 7^0 mod 103 $
		
		Por Fermat, $7^102 = 1 mod 103 $

		$ (7^102)^10 dot 7^0 mod 103 = 1^10 dot 7^0 mod 103 = 1 mod 103 $
	]
]

= RSA

#definition("Função totiente")[
	Dado $n = p dot q$, com $p,q$ primos, a função totiente é calculada como:
	
	$ phi(n) = (p-1)(q-1) $

	E é definida como a quantidade de números menores ou igual a $n$ co-primos com respeito a ele (Ex: $phi(8)=4$, pois 1,3,5,7 são co-primos). Isso fornece o tamanho exato do conjunto de elementos que possuem inverso multiplicativo módulo n ($a$ tal que $m d c(a,n) = 1$), ou coprimos.
]

#definition("Teorema de Euler")[
		Seja $m = phi(n)$. O conjunto dos coprimos de $n$ é:

		$ {x_1,...,x_m} $

		Multiplicamos por $a$ com $m d c(a, n) = 1$. Isso garante a inexistência de fatores em comum, e o novo conjunto contém os mesmos números do conjunto original, mas em uma ordem diferente. Nenhum se repete.

		$ {a x_1, ..., a x_m} $

		Como os conjuntos contém os mesmos elementos, o produto de todos os elementos de cada conjunto é equivalente.

		$ (x_1 dot ... dot x_m) = a^m dot (x_1 dot ... dot x_m) mod n $

		Como o produto ($x_1 dot ... dot x_m$) é coprimo com $n$, podemos cancelá-lo dos dois lados da congruência (coprimo = $m d c(a,n) = 1$, logo possui inverso multiplicativo). O que sobra é o teorema de Euler.

		$ (x_1 dot ... dot x_m)(x_1 dot ... dot x_m)^(-1) = a^m dot (x_1 dot ... dot x_m)(x_1 dot ... dot x_m)^(-1) mod n $
		$ 1 = a^phi(n) mod n $
	
		Isso significa que as potências de tamanho $a$ em módulo $n$ entram em ciclos de tamanho $phi(n)$. A cada $phi(n)$ multiplicações, o resultado volta para 1.
]

#definition("RSA")[
	Dado $n = p dot q$ (público), com $p,q$ primos, $e in NN$ (púiblic) e uma mensagem $M < n$, a mensagem criptografada $y$ é:

	$ y = M^e mod n $

	A chave necessária para descriptografar é: 

	$ d = e^(-1) mod (p-1)(q-1) $
	
	Onde $e^(-1)$ é o inverso multiplicativo de $e mod n$, De modo que:

	$ y^d = y^(e e^(-1) mod (p-1)(q-1)) = M $
	
	A segurança no RSA consiste na dificuldade do cálculo dos primos $p,q$.
]

#theorem("Por que a descriptografia do RSA funciona")[
	Por definição:

	$ e d  = 1 mod phi(n) $

	Que pode ser reescrito como:

	$ e d  = 1 + k dot phi(n) $

	Aplicando a $M$:

	$ M^(e d) = M^(1+k dot phi(n)) = M^1 dot (M^phi(n))^k $
	
	Sabendo que $m d c(M, n) = 1 arrow.r.double M^phi(n) = 1 mod n$. Assim:

	$ M^(e d) = M dot (1)^k = M mod n $

	Sob estas condições, para uma recuperação perfeita, *$M$ deve ser menor que $n$*.
]
