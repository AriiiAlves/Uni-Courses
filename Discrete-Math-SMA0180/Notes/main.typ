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
]

= Coeficientes binomiais

== 
