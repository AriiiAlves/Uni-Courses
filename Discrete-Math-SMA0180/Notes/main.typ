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


#definition("Teorema de Euler")[
		Seja $m = phi(n)$. O conjunto dos *coprimos* (não todos os elementos, mas apenas os que possuem inverso multiplicativo!) de $n$ é:

		$ {x_1,...,x_m} $

		Multiplicamos por $a$ com $m d c(a, n) = 1$. Isso garante a inexistência de fatores em comum, e o novo conjunto contém os mesmos números do conjunto original, mas em uma ordem diferente. Nenhum se repete.

		$ {a x_1, ..., a x_m} $

		Como os conjuntos contém os mesmos elementos, o produto de todos os elementos de cada conjunto é equivalente.

		$ (x_1 dot ... dot x_m) = a^m dot (x_1 dot ... dot x_m) mod n $

		Como o produto ($x_1 dot ... dot x_m$) é coprimo com $n$, podemos cancelá-lo dos dois lados da igualdade (*coprimo = $m d c(a,n) = 1$, logo para cada $x_i$ existe um inverso multiplicativo*). O que sobra é o teorema de Euler.

		$ (x_1 dot ... dot x_m)(x_1^(-1) dot ... dot x_m^(-1)) = a^m dot (x_1 dot ... dot x_m)(x_1^(-1) dot ... dot x_m^(-1)) mod n $
		$ therefore 1 = a^phi(n) mod n $
	
		Isso significa que *as potências de um tamanho qualquer $a in NN^*$ em módulo $n$ posusi tamanho de ciclo que divide ou é igual a $phi(n)$*. A cada $phi(n)/n$ multiplicações, o resultado volta para 1.
		
		#v(1em)

		Para encontrar o tamanho do ciclo, basta *encontrar o menor expoente positivo $k$ que resulta em 1* para $a^k mod 7$ (ao chegar em 1, é confirmado o reset do ciclo). Se $k=2$, os ciclos possuem tamanho 2.
]

#definition("Função totiente")[
	Para $n$ fatorado em primos de modo que $n = p_1^(a_1) dot p_2^(a_2)...$, a função totiente é definida como:

	$ phi(n) = n dot (1-1/p_1) dot (1-1/p_2)... $
	
	E fornece a quantidade de números menores ou igual a $n$ co-primos com respeito a ele (Ex: $phi(8)=4$, pois 1,3,5,7 são co-primos). Isso fornece o *tamanho exato do conjunto de elementos que possuem inverso multiplicativo módulo n* ($a$ tal que $m d c(a,n) = 1$), ou coprimos.

	#v(1em)
	
	1) Em particular: dado $n = p dot q$, com $p,q$ primos, a função totiente é calculada como:
	
	$ phi(n) = (p-1)(q-1) $

	2) Em particular: dado $n$ primo, $phi(n) = n-1$.
]

#definition("Pequeno teorema de Fermat")[
	Caso particular do teorema de Euler para $p$ primo:

	$ a^(p-1) = 1 mod p $

	Em particular, se $a in ZZ_p$ então:
	
	$ a^1 dot a^(p-2) = 1 mod p $
	$ therefore a^(-1) = a^(p-2) mod p $

	Na prática, isso permite simplificar potências gigantescas: 

	$ a^k = a^(k mod phi(n)) mod p $
	
	#proof[
		$ 7^1020 mod 103 $
		$ phi(103) = 102 $
		$ 1020 = 10 dot (102) + 0 $
		$  7^(1020 mod 102) dot 7^0 mod 103 =  7^(10 dot 102 mod 102) dot 7^0 mod 103 = 1 mod 103 $
	]
]

#definition("Propriedades da potenciação modular")[
	Definimos:

	$ a^k mod n $

	Propriedades:

	- $a^(k_1+k_2) mod n = a^(k_1) dot a^(k_2) mod n$
	- Pequeno teorema de Fermat: $a^phi(n) mod n = 1 mod n$
	- Pequeno teorema de Fermat: para $a,n$ coprimos, $a^(-1) = a^(n-2) mod n$
	- O tamanho de ciclo é um divisor de $phi(n)$.
	
	#v(1em)

	*Propriedade de ciclo para $a,n$ coprimos*:

	Para encontrar o tamanho de ciclo $K$, basta encontrar $K$ tal que:

	$ a^K = 1 mod n_1 $

	#v(1em)

	*Propriedade de ciclo para $a,n$ não coprimos*:

	A parte coprima $n_1$ é a multiplicação de todos os fatores de $n$ que não compartilham primos com $a$. 

	A parte não coprima $n_2$ é a multiplicação de todos os fatores de $n$ que compartilham primos com $a$. Eles são tais que:

	$ n = n_1 dot n_2 $
	$ m d c(n_1,n_2) = 1 $


	A parte coprima $n_1$ define o tamanho de ciclo $K$. Basta encontrar $K$ tal que:

	$ a^K = 1 mod n_1 $

	A parte não coprima $n_2$ define um pré-período de modo que ele termina em $k=K-1$. Bata encontrar $K$ tal que:

	$ a^K = 0 mod n_2 $

	#proof[
		$ 4^k mod 20 $

		+ $10=2^2 dot 5$
		+ $4=2^2$
		+ $n_1 = 5$
		+ $n_2 = 2^2$
		
		Verificando:

		- $20 = 5 dot 2^2$
		- $m d c(5,4) = 1$

		Encontrando tamanho do ciclo:

		$4^k mod 5 = 4,[1],...$

		O tamanho do ciclo é 2.

		Encontrando pré-período:

		$4^k mod 4 = [0]$

		O ciclo começa em $k=1$. Ou seja, sem pré-período.

		Resumo:

		- Ciclo de tamanho 2
		- Sem pré-período

		Potenciação completa:

		$ 4^k mod 20 = 4,16,4,16,4,16,... $
	]
]

#definition("Achar solução de sistema de equações modulares")[
	$ cases(
		x mod 5 = 4,
		x mod 7 = 5
	) $

	+ Escolha uma equação e coloque na forma completa: $x = 5k + 4$
	+ Substitua no valor de $x$ na segunda equação
	+ Ache o inverso modular do número que multiplica $k$ e multiplique dos dois lados para obter $k$
	+ Ao substituir $k$ na equação inicial, temos $x$.

	#v(1em)

	Obs: Na equação $5k = 2 (mod 7)$, basta encontrar $5^(-1) mod n$ e multiplicar dos dois lados. (isso que é "dividir" dos dois lados em aritmética modular).

	#v(1em)

	Obs: Se a constante que multiplica $k$ não tiver inverso multiplicativo, o sistema não possui solução.
]

#definition("Teorema Chinês do Resto")[
	Dado um sistema de equações do tipo:

	$ cases(
		x mod m_1 = a_1,
		x mod m_2 = a_2,
		...,
		x mod m_k = a_k,
	) $

	Se os módulos $m_1, m_2, .... , m_k$ forem primos entre si dois a dois (mdc = 1), o teorema garante que:

	+ O sistema sempre possui uma *solução única* dentro de um período (x = A + kB).
	+ A solução geral é dada módulo $M = m_1 dot m_2 ... m_k$ (produto dos módulos).

	#v(1em)

	Caso os módulos não sejam primos entre si, ainda assim podem ter solução. As congruências precisam ser analisadas dois a dois, de modo que:

	$ (a_1-a_2) = k dot m d c(m_1, m_2), k in ZZ $

	Se a condição for verdadeira, o sistema possui solução, e ela é única módulo o $m m c$ entre os módulos.

	Se a condição for falsa, o sistema não possui solução inteira.
]

#definition("Teorema de Wilson")[
	O teorema de Wilson afirma que:

	$ (p-1)! mod p = (p-1) $

	Isso pois $(p-1)!$ é a multiplicação de todos os coprimos de $p$. Como todos são coprimos, todos possuem inverso multiplicativo. 

	Assim, aos pares, a multiplicação entre os coprimos resulta em $1$. O inverso multiplicativo de $(p-1)$ é ele mesmo, de modo que ele é o termo que sobra.
	
	Sempre serão formados pares formando apenas $(p-1)$, pois todos os primos são ímpares, exceto $2$.
	
	$ 1 dot 2 dot 3 dot 4 dot 5 dot 6 mod 7 $

	- $1^(-1) = 1$
	- $2^(-1) = 4$
	- $3^(-1) = 5$
	- $6^(-1) = 6$

	Portanto:

	$ [1] dot [2 dot 4] dot [3 dot 5] dot 6 mod 7 = 1 dot 6 mod 7 $
]

== Anotações

#theorem("Achar x de equação linear")[
	Para calcular equações do tipo:

	$ a dot_n x = b $

	Precisamos do inverso multiplicativo, de modo que:

	$ x = b dot_n a^(-1) $

	Lembrando que o inverso multiplicativo só existirá se $m d c(a, n) = 1$, e é calculado por Euclides estendido.
]

#theorem("multiplicando pelo inverso dos dois lados")[
	Se p é primo e $a < p$, $a$ sempre tem inverso multiplicativo:

	$ a x =_p 1 arrow.r.l.double  x =_p a^(-1) $

	Isso pois $m d c(p, a) = 1$ sempre (condição de existência de inverso multiplicativo).
]


#theorem("Observações sobre multiplicação com a,n primos entre si")[
	Para equação linear, com $a,n$ primos entre si:

	$ k dot a mod n $

	Como $n$ é primo, $phi(n) = n-1$. Essa é quantidade de elementos em um ciclo. 
	
	#v(1em)

	Na aritmética modular, quando você multiplica uma *sequência completa de restos* (k) por um *número que não compartilha fatores com o módulo* (a), o conjunto resultado não possui repetições, formando uma permutação perfeita. Essa demonstração é feita no teorema de Euler. 

	#v(1em)

	Para ilustrar, tome $n=11$. Como $phi(n) = 10$, $k in {0,1,2,3,4,5,6,7,8,9,10}$ (todos os restos possíveis). Tome $a=5$. Pela mesma demonstração do teorema de Euler, *multiplicar o conjunto dos restos de $mod n$ por uma constante qualquer mantém os mesmos restos, mas permutando sua ordem no conjunto* (por causa da existência de inverso multiplicativo). Sem repetição.

	#v(1em)

	Obs: $k,n$ e $a,n$ devem ser primos entre si para isso ser válido (atesta existência de inverso multiplicativo).
]

#theorem("Observações sobre multiplicação com a,n possuindo fatores em comum")[
	Para equação linear, com $a,n$ não primos entre si:

	$ k dot a mod n $

	Definindo $d = m d c(a,n)$:

	- Apenas múltiplos de $d$ aparecerão na sequência do ciclo.
	- O conjunto terá apenas $n/d$ números diferentes.
	- Cada um desses valores únicos se repetirá $d$ vezes ao longo do intervalo de $[0,n-1]$

	#proof[
		$ k dot 4 mod 6 $

		Para $k in[0,5]$:
		
		- Sequência: ${0,4,2,0,4,2)$
		- Valores únicos: $6/2 = 3$
		- Repetição: $d=2$ vezes
	]
]

= Outros

#definition("Algoritmo de Exponenciação Binária")[
	Para calcular: $2^m = 2^312$, ao invés de calcular 312 multiplicações, dividimos o expoente em potências de 2:

	$2^312 = 2^256 dot 2^32 dot 2^16 dot 2^8$

	+ $2^8 = ((2^2)^2)^2$ - 3 mult.
	+ $2^16 = (2^8)^2$ - 1 mult.
	+ $2^32 = (2^16)^2$ - 1 mult.
	+ $2^256 = ((((2^32)^2)^2)^2)$ = 3 mult.
	+ Multiplica tudo.

	Total de multiplicações: 8 + 4 (n° multiplicações)

	No geral: Total de multiplicações = $ceil(log_2(m)) + ("n° de bits 1 em m") - 2$

	#v(1em)

	Em geral, para um expoente $m$, $O(n) = log_2(m)$
]

= RSA


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
