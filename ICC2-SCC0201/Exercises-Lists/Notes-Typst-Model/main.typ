#import "./lib.typ": *

#show: project.with(
	title: "Lista 2 - Complexidade",
	author: "Ariel Alves da Silva",
	academic-year: "Academic year 2026",
	orcid: "https://orcid.org/xxxx-xxxx-xxxx-xxxx", // Your number
	github: "https://github.com/AriiiAlves",
)

= O que falta

- Método mestre (wikipedia)
- Algoritmos de ordenação (só os ferrados)

= Resumo

== Séries

$ sum_(i=0)^n 2^i = 2^(n+1)-1 $
$ sum_(i=0)^n a^i = (a^(n+1)-1)/(a-1) $
$ sum_(i=1)^n i = n(n+1)/2 $

== Ordem de complexidade

$ c <= log n <= log^2 n <= n <= n log n <= n^2 <= n^3 <= 2^n <= n! $

== Notações

$ T(n) = cal(O)(f(n)) arrow.r.double 0 <= T(n) <= c dot f(n) $
$ T(n) = Omega(f(n)) arrow.r.double T(n) >= c dot f(n) >= 0 $
$ T(n) = Theta(f(n)) arrow.r.double 0 <= c_1 dot f(n) <= T(n) < = c_2 dot f(n) $

Obs: c é sempre maior que zero. (se for menor que zero, isso contraria a desigualdade da ddefinição) 

== Método da substituição

Escolha um limite superior para a função e verifique se ela não extrapola esse limite.

$ T(n) = cal(O)(2^n) arrow.r.double T(n) <= c dot 2^n $

Construir indução.

$ T(0) = 3 <= c dot 2^0 $
$ T(1) = 3 <= c dot 2^1 $
#align(center)[...]
$ T(k-1) <= c dot 2^(k-1) $
$ T(k-2) <= c dot 2^(k-2) $

Substituir.

$ T(n) = T(n-1) + T(n-2)+6 $
$ T(n) = c dot 2^(n-1) + c dot 2^(n-2) + 6 <= c dot 2^n $
$ c dot 2^(n-1) + c dot 2^(n-2) + 6 <= c dot 2^n $
$ c (1/2 + 1/4)2^n + 6 <= c dot 2^n $
$ 6 <= c(1-3/4)2^n $
$ 6 <= c dot 2^n/4 $
$ c >= 24/2^n $

O importante é que existe um $c$ que satisfaz a inequação para todo $n>=0$: $c=24$. Isso comprova a complexidade assumida.

Exemplo onde $c$ não converge:

$ c >= n/((n ln n)-(n-1)ln(n-1)) $
$ d(n)/(d n) = 1 $
$ d((n ln n)-(n-1)ln(n-1)) = ln(n/(n-1)) $

Como o numerador sempre cresce mais rápido que o denominador, não existe $c$ que satisfaça a inequação para $n>n_0$ fixo.

== Método Mestre

Para recursões do tipo:

$ T(n) = a T(n/b)+f(n) $

+ Se $f(n) = cal(O)(n^(log_b (a-epsilon)))$ para $epsilon > 0$, então $T(n) = Theta(n^(log_b a))$
+ Se $f(n) = Theta(n^(log_b a))$, então $T(n) = Theta(n^(log_b a) log n)$
+ Se $f(n) = Omega(n^(log_b (a+epsilon)))$ para $epsilon>0$, e se $a f(n/b) <= c f(n)$ para $c<1$ e $n$ suficientemente grande, então $T(n)=Theta(f(n))$

Basicamente:

+ O trabalho para dividir/recombinar um problema é reduzido pelos seus subproblemas.
+ O trabalho para dividir/recombinar um problema é comparável aos subproblemas.
+ O trabalhos para dividir/recombinar um problema domina os subproblemas.

== Onde o método mestre ganha da substituição

$ T(n) = 4 T(n/2) + n $

Por método mestre:

$ f(n) = cal(O)(n) arrow.r.double cal(O)(n^(log_2 4 - epsilon)) = cal(O)(n) arrow.r.double "Caso 1." $
$ T(n) = Theta(n^2) $

Por substituição:

$ T(n/2) <= c dot (n/2)^2 = c dot n^2/4 $
$ T(n) <= 4(c dot n^2/4) + n <= c dot n^2$
$ n <= 0 $

Inválido, pois $n>0$.

A omissão dos termos de menor ordem invalidou a indução, pois não se conseguiu lidar com a sobra positiva. Temos que adicionar um termo na complexidade interna para anular a sobra externa.

$ T(n/2) <= c dot (n/2)^2 - b dot n/2 $
$ T(n) <= 4(c(n^2/4) - b dot n/2) + n <= c dot n^2 $
$ T(n) <= c dot n^2 - 2b dot n + n <= c dot n^2 $
$ (2b - 1)n >= 0 $

$n>0$ para $forall c in RR,b>1/2$. A indução não se contradiz.

= Lista 2 

== Ex. 1

$ 100 n^2 = 2^n $
$ log_2(2^n) = log_2(100n^2) $
$ n = 2 dot log_2(100n) $

=== Modo analítico

Precisa utilizar a função W de Lambert.

#definition("Função W de Lambert")[
	A função W de Lambert é a função inversa de $f(x)=x e^x$. Busca-se deixar a equação nessa forma.
]

1. Transformer base 2 para base natural

$ e^(n ln(2)) = 100n^2 $

2. Extrair raiz dos lados

$ e^((n ln(2))/2)=plus.minus 10n $

3. Isolar termos com n multiplicando a base natural

$ plus.minus 1/10 = n dot e^((-(ln(2))/2)n) $

4. Igualar coeficiente ao expoente

$ plus.minus ln(2)/20 = (-ln(2)/2 n)dot e^(-(ln(2)/2)n) $

5. Aplicar função W de Lambert

$ W(plus.minus ln(2)/20) = -ln(2)/2 n $

$ -0.03351 = -ln(2)/2 n arrow.r.double n = $

=== Modo normal

Complexidade só utiliza números inteiros. Sabe-se que a taxa de crescimento da exponencial é maior que a quadrática.

- $100 dot 10^2 < 2^10 arrow.r.double 10000 = 1024$ (OK)
- $100 dot 9^2 < 2^9 arrow.r.double 8100 = 512$ (X)

$n$ deve ser no mínimo 2.

== Ex. 2

A notação Big-O representa o pior caso. Dizer que o tempo de execução *mínimo* é representado pela notação Big-O está errado. Deveria-se usar a notação $Omega$.

== Ex. 3

Sim. Não.

== Ex. 4

== Ex. 5

$ T(n) = T(n-1)+n $
$ T(n-1) = T(n-2)+n-1 $
...
$ T(2) = 1 + 2 $
$ T(1) = 1 $

$ 1 + 2 $
