= Análise de Algoritmos I

Buscamos formas de comparar algoritmos de forma independente de Hardware, Linguagem de Programação e Habilidade do Programador. Comparamos algoritmos, e não programas.

== Notações

A função $T(n)$ é o custo real.

- $T(n) = cal(O)(f(n)) arrow.r.double T(n) <= c dot f(n)$  , p/ $n>n_0$ - Upper Bound. Maior ou igual ao custo real da função. ($f(n)=n^2$, por ex)
- $T(n) = Omega(f(n)) arrow.r.double T(n) >= c dot f(n)$  , p/ $n>n_0$ - Lower Bound. Menor ou igual ao custo real da função.
- $T(n) = Theta(f(n)) arrow.r.double >= c_1 dot f(n) <= T(n) <= c_2 dot f(n)$  , p/ $n>n_0$ - Intermediário.

Na função $f(n)$ não se costuma incluir constantes ou termos de menor ordem.

Ex: $T(n) = 3n+3$ (nossa função)

$ T(n) = cal(O)(n)? $
$ 3n+3<=c dot n $
$ c in NN, c>= 4 $

Provado que $T(n)$ é $cal(O)(n)$.

$ T(n) = cal(O)(log(n))? $
$ 3n+3<=c dot log(n) $

Não existe $c$ tal que satisfaça a condição acima. Provado que $T(n) != cal(O)(log(n))$.

$ T(n) = Omega(n)? $
$ 3n+3>=c dot n $
$ c in NN^*, c<= 3 $

Provado que $T(n)$ é $Omega(n)$.

$ T(n) = cal(O)(log(n))? $
$ 3n+3>=c dot log(n) $
$ c in NN^* $

Provado que $T(n)$ é $Omega(log(n))$.

== Exercício

$ f(n)=n^(1.5) =>^("/n") n^(0.5) =>^("^2") n $
$ g(n)=n log(n) =>^("/n") log(n) =>^("^2") log^2(n) $

Para comparar, manipulamos de acordo a chegar nos algoritmos da tabela.

$ c <= log <= log^2 <= n <= n log(n) <= n^2 <= n^3 <= 2^n $

== Escolhendo T(n): Melhor, pior, média

A função $T(n)$ pode ser o melhor, pior ou melhor caso.

$ T_"melhor"(n) <= T_"média"(n) <= T_"pior"(n) $

== Exercício: maxSubArray

Divisão e conquista:

-2 11 -4 13 -5 -2
-2 11 -4 13 | -5 -2
-2 11 | -4 13 | -5 -2 -> Retorna 11 | 13 | 0

== Cálculo de complexidade para sub-rotinas recursivas

É necessário recorrer à análise de recorrência: Equação ou desigualdade que descreve uma função em termos de seu valor em entradas menores.

Ex: Fibonacci

- f(0)=0, f(1)=1, f(i)=f(i-1)+f(i-2)

```
sub-rotina fib(n: numérico)
início
declare aux numérico;
se n≤1
  então auxß1
  senão auxßfib(n-1)+fib(n-2);
retorne aux;
fim
```

Caso 1: $n=0,n=1$ -> $T(0)=T(1)=3$

Caso 2: $n>=2$ -> $T(n)=T(n-1)+T(n-2)+6$

$cases(
  T(0)=T(1)=3
  T(n)=T(n-1)+T(n-2)+6 " p/ "n >=2
)$

=== Método da substituição

Supõe-se (aleatoriamente ou com base em experiência) um limite superior para a função e verifica-se se ela não extrapola esse limite (uso de indução matemática)

*Hipótese: $O(2^n)$* 

$ T(n) = O(2^n) arrow.r T(n) <= c dot 2^n" , "c>0 $

Base da indução: 

$ T(0)=3 <= c dot 2^0 $
$ T(1)=3 <= c dot 2^1 $

$ T(k-1) <= c dot 2^(k-1) $
$ T(k-2) <= c dot 2^(k-2) $

Mostrar que $T(k) <= c dot 2^k $ substituindo:

$ T(k) = T(k-1) + T(k-2) + 6 $
$ T(k) <= c dot 2^(k-1) + c dot 2^(k-2) + 6 $
$ T(k) <= c dot 2 dot 2^(k-2) + c dot 2^(k-2) + 6 $
$ T(k) <= c dot 3 dot 2^(k-2) + 6 $
$ T(k) <= c dot (3/2^2)2^k + 6 $

Necessário encontrar uma constante que satisfaça a desigualdade:

$ c dot (3/2^2)2^k + 6 <= c dot 2^k $
$ c dot 2^k dot (3/4 - 1) <= -6 $
$ c <= -6 / (2^k dot (3/4 - 1)) $
$ c >= 24 / 2^k $

Menor caso: $k = 0$ -> $24/2^k = 24$. Portanto, $exists " "c in R " t.q. " c>= 24/2^k$

*Hipótese: $O(n^2)$*

Base da indução: 

$ T(0)=3 <= c dot 0^2 $
$ T(1)=3 <= c dot 1^2 $

$ T(k-1) <= c dot (k-1)^2 $
$ T(k-2) <= c dot (k-2)^2 $

Mostrar que $T(k) <= c dot n^2 $ substituindo:

$ T(k) = T(k-1) + T(k-2) + 6 $
$ T(k) <= c dot (k-1)^2 + c dot (k-2)^2 + 6 $
$ T(k) <= c dot [k^2-2k+1 + k^2-4k+4] + 6 $
$ T(k) <= c dot [2k^2-6k+5] + 6 $

Logo:

$ c dot [2k^2-6k+5] + 6 <= c dot k^2 $
$ c dot [-k^2+6k-5] >= 6 $

Não existe c fixo que satisfaça a desigualdade para qualquer k.

$ c >= 6 /(-k^2+6k-5) $

Obs: ao dividir por um número negativo, o sentido da desigualdade inverte (continua não sendo válido)

=== Método da Árvore de recursão

```
T(n) -> c, T(n/2) -> c,c,T(n/4) -> c,...,c
```

Altura = `log n + 1`

=== Método Mestre

Teorema: Sejam $a>=1$ e $b>1$ constantes, seja $f(n)$ uma função e seja $T(n)$ definida como:

$ T(n) = a dot T(n/b)+f(n) $

Então $T(n)$ pode ser limitado assintoticamente como:

- Se $f(n) = O(n^(log_b(a)-x)$ para algum $x>0$, então $T(n)=Theta(n^(log_b a))$
- Se $f(n) = Theta(n^(log_b a))$, então $T(n) = Theta(n^(log_b a) log(n))$
- Se $f(n) = Omega(n^log_b(a)+x)$ para algum x>0, e se $a dot f(n/b) <= c dot f(n)$ para algum $c<1$ e para todo $n$ suficientemente grande, então $T(n)=Theta(f(n))$

Ex: $T(n) = 9T(n/3) + n$

- $a=9$
- $b=3$
- $f(n)=n$
- $n^(log_b a) = n^(log_3 9) = n^2$

Tentamos o caso 1: 

$ f(n)=cal(O)(n^(2-x)) $
$ n = cal(O)(n^(2-x)) $
$ n = cal(O)(n) $
$ n <= c dot n $

Vemos que o primeiro caso é satisfeito. Logo: 

$ T(n) = Theta(n^2) $

Ex: $ T(n) = T((2n)/3)+1 $

- $a=1$
- $b=3/2$
- $f(n)=1$
- $n^(log_b a) = n^0 = 1$

Tentamos o caso 1:

$ f(n) = O(n^(0-x)) $
$ n^0 <= c dot n^(0-x) $

O caso 1 não é válido.

Tentamos o caso 2:

$ f(n) = Theta(n^0) $
$ 1 = Theta(...) $ ???

==== Exercícios

*1) $T(n) = 4 T(n/2) + n$*

$a=4$, $b=2$, $f(n)=n$, $n^(log_b a) = n^(log_2 4) = 2$

Caso 1:

$ n = cal(O)(n^(log_2(4)-x)) $
$ n = cal(O)(n^(2-x)) $
$ n = cal(O)(n) arrow.r n <= c dot n $

Logo: $ T(n) = Theta(n^2) $

*2) $T(n) = 4 T(n/2) + n^2$*

Caso 1:

$ n^2 = cal(O)(n^(log_2(4)-x)) $
$ n^2 = cal(O)(n^(2-x)) $

Não existe $x > 0$ que satisfaça isso.

Caso 2:

$ n^2 = Theta(n^(log_2(4))) $
$ n^2 = Theta(n^2) $
$ c_1 dot n^2 <= n^2 <= c_2 dot n^2 $

Isso é satisfeito. Logo: 

$ T(n) = Theta(n^2 log(n)) $

*3) $T(n) = 4 T(n/2) + n^3$*

Caso 3:

$ n^3 = Omega(n^(log_2 4 + x)) $
$ n^3 = Omega(n^(2+x)) $
$ n^3 = Omega(n^3) arrow.r.double c dot n^3 <= n^3 $

Verificando segunda condição:

$ a dot f(n/b) <= c dot f(n) $
$ 4 (n/2)^3 <= c dot n^3 $
$ 1/2 <= c <= 1 $

Logo, $T(n) = Theta(n^3)$

*4) $T(n)=2T(n/2)+n^3$*

*5) $T(n)=T((9n)/10)+n$*


