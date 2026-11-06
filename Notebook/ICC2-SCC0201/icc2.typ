#import "../lib.typ": *

= Análise de Algoritmos

Comparamos *algoritmos*, não programas: a análise independe de hardware, linguagem e habilidade do programador. $T(n)$ é o custo do algoritmo para uma entrada de tamanho $n$.

== Notações assintóticas

#Highlight1("Definições")[
  Para constantes $c, c_1, c_2 > 0$ e todo $n >= n_0$:
  - $T(n) = cal(O)(f(n)) arrow.l.r.double T(n) <= c dot f(n)$ #h(1fr) (limite *superior*)
  - $T(n) = Omega(f(n)) arrow.l.r.double T(n) >= c dot f(n)$ #h(1fr) (limite *inferior*)
  - $T(n) = Theta(f(n)) arrow.l.r.double c_1 dot f(n) <= T(n) <= c_2 dot f(n)$ #h(1fr) (limite *justo*)

  Em $f(n)$ não se escrevem constantes nem termos de menor ordem.
]

#example[
  $T(n) = 3n + 3$:
  - $cal(O)(n)$: $3n + 3 <= c n$ vale com $c = 4$ (para $n >= 3$). #sym.checkmark
  - $cal(O)(log n)$: $3n + 3 <= c log n$ não vale para nenhum $c$, pois $n$ cresce mais que $log n$. #sym.crossmark
  - $Omega(n)$: $3n + 3 >= c n$ vale com $c = 3$. #sym.checkmark
  - $Omega(log n)$: $3n + 3 >= c log n$ vale com $c = 1$. #sym.checkmark
  Logo, $T(n) = Theta(n)$.
]

#Highlight1("Ordem de crescimento")[
  $ 1 < log n < log^2 n < n < n log n < n^2 < n^3 < 2^n < n! $
  Para comparar duas funções, simplifique as duas até chegar nesta escala. Ex.: dividindo por $n$, comparar $n^(1.5)$ com $n log n$ vira comparar $n^(0.5)$ com $log n$. Como $sqrt(n)$ cresce mais que $log n$, temos $n log n < n^(1.5)$.
]

#Highlight1("Séries úteis")[
  $ sum_(i=1)^n i = (n(n+1))/2 quad quad sum_(i=0)^n 2^i = 2^(n+1) - 1 quad quad sum_(i=0)^n a^i = (a^(n+1) - 1)/(a - 1) $
]

*Melhor, médio e pior caso:* $T_"melhor"(n) <= T_"médio"(n) <= T_"pior"(n)$. Normalmente se analisa o pior caso.

== Exemplo: subarranjo máximo (divisão e conquista)

Achar o subarranjo contíguo de maior soma. Divide o vetor ao meio; a resposta é o maior entre:
+ o melhor subarranjo da metade esquerda (recursão);
+ o melhor da metade direita (recursão);
+ o melhor que *cruza o meio* (calculado em $cal(O)(n)$).

```text
-2 11 -4 13 | -5 -2
esquerda: 11 -4 13 = 20    direita: -2 (ou vazio = 0)    cruzando: 11 -4 13 = 20
resposta: 20
```

Custo: $T(n) = 2T(n/2) + Theta(n) = Theta(n log n)$, contra $Theta(n^2)$ da força bruta.

== Recorrências

A complexidade de um algoritmo recursivo é dada por uma *recorrência*: uma equação que descreve $T(n)$ em termos de $T$ em entradas menores.

#example[
  *Fibonacci:* $f(0) = 0$, $f(1) = 1$, $f(n) = f(n-1) + f(n-2)$.
  ```c
  int fib(int n) {
      if (n <= 1) return n;
      return fib(n - 1) + fib(n - 2);
  }
  ```
  Contando operações: $T(0) = T(1) = 3$ e $T(n) = T(n-1) + T(n-2) + 6$ para $n >= 2$.
]

=== Método da substituição

#Highlight1("Método da substituição")[
  + *Chute* um limite (por experiência).
  + *Prove por indução* que $T(n)$ não passa dele: assuma que vale para valores menores e mostre que vale para $n$.
  A prova só vale se *uma mesma constante $c$* servir para todo $n >= n_0$.
]

#example[
  *Fibonacci é $cal(O)(2^n)$.* Hipótese: $T(k) <= c dot 2^k$ para $k < n$.
  $ T(n) = T(n-1) + T(n-2) + 6 <= c dot 2^(n-1) + c dot 2^(n-2) + 6 = 3/4 c dot 2^n + 6 $
  Queremos $3/4 c dot 2^n + 6 <= c dot 2^n$, ou seja, $6 <= c dot 2^n / 4$, isto é, $c >= 24 / 2^n$.

  O lado direito diminui com $n$, então $c = 24$ serve para todo $n >= 0$ (e cobre as bases $T(0) = T(1) = 3$). #sym.checkmark
]

#example[
  *Fibonacci não é $cal(O)(n^2)$.* A base já falha: $T(0) = 3 <= c dot 0^2 = 0$ é falso. E no passo indutivo:
  $ c(n-1)^2 + c(n-2)^2 + 6 <= c n^2 arrow.l.r.double c(-n^2 + 6n - 5) >= 6 $
  Para $n > 5$ o termo $-n^2 + 6n - 5$ é negativo, então nenhum $c > 0$ funciona. #sym.crossmark (De fato, $T(n)$ cresce como $1.618^n$.)
]

#Highlight2("Quando a substituição falha: subtrair um termo menor")[
  $T(n) = 4T(n/2) + n$ é $Theta(n^2)$ pelo método mestre, mas a hipótese $T(n) <= c n^2$ não fecha:
  $ T(n) <= 4 c (n/2)^2 + n = c n^2 + n lt.eq.not c n^2 $
  Sobra um $+n$. Solução: *fortalecer* a hipótese subtraindo um termo de menor ordem, $T(n) <= c n^2 - b n$:
  $ T(n) <= 4 (c (n/2)^2 - b n/2) + n = c n^2 - 2 b n + n <= c n^2 - b n arrow.l.r.double b >= 1 $
  A indução fecha com $b = 1$. #sym.checkmark
]

=== Método da árvore de recursão

Desenha-se a árvore das chamadas, soma-se o custo de cada nível e depois de todos os níveis.

#example[
  $T(n) = T(n/2) + c$: cada nível custa $c$ e o tamanho cai pela metade, então há $log_2 n + 1$ níveis.
  $ T(n) = c (log_2 n + 1) = Theta(log n) $
]

=== Método mestre

#Highlight2("Teorema mestre")[
  Para $T(n) = a T(n/b) + f(n)$, com $a >= 1$ e $b > 1$, compare $f(n)$ com $n^(log_b a)$:
  + Se $f(n) = cal(O)(n^(log_b a - epsilon))$ para algum $epsilon > 0$: $quad T(n) = Theta(n^(log_b a))$
  + Se $f(n) = Theta(n^(log_b a))$: $quad T(n) = Theta(n^(log_b a) log n)$
  + Se $f(n) = Omega(n^(log_b a + epsilon))$ para algum $epsilon > 0$ *e* $a f(n/b) <= c f(n)$ para algum $c < 1$: $quad T(n) = Theta(f(n))$

  Intuição: quem domina? (1) as folhas da recursão; (2) empate, e cada um dos $log n$ níveis custa igual; (3) o trabalho de dividir/combinar na raiz.
]

#align(center, table(
  columns: 5,
  inset: 6pt,
  align: center + horizon,
  stroke: 0.5pt + colors.primary,
  table.header([*Recorrência*], [$n^(log_b a)$], [$f(n)$], [*Caso*], [*Resultado*]),
  [$9T(n/3) + n$], [$n^2$], [$n$], [1], [$Theta(n^2)$],
  [$T(2n/3) + 1$], [$n^0 = 1$], [$1$], [2], [$Theta(log n)$],
  [$4T(n/2) + n$], [$n^2$], [$n$], [1], [$Theta(n^2)$],
  [$4T(n/2) + n^2$], [$n^2$], [$n^2$], [2], [$Theta(n^2 log n)$],
  [$4T(n/2) + n^3$], [$n^2$], [$n^3$], [3], [$Theta(n^3)$],
  [$2T(n/2) + n^3$], [$n$], [$n^3$], [3], [$Theta(n^3)$],
  [$T(9n/10) + n$], [$n^0 = 1$], [$n$], [3], [$Theta(n)$],
))

No caso 3, sempre verifique a condição de regularidade. Ex.: para $4T(n/2) + n^3$, $4 (n/2)^3 = n^3/2 <= c n^3$ com $c = 1/2 < 1$. #sym.checkmark

= Métodos de Ordenação

== Bubble Sort

Percorre o vetor várias vezes trocando vizinhos fora de ordem, até não haver trocas.
- Pior/médio caso: $cal(O)(n^2)$ (dois laços aninhados).
- Melhor caso: $cal(O)(n)$ se parar quando uma passada não fizer trocas.

== Insertion Sort

Mantém um prefixo ordenado à esquerda e insere nele, um a um, os elementos da direita.

```text
[10] 2 7 5  ->  [2 10] 7 5  ->  [2 7 10] 5  ->  [2 5 7 10]
```

- Pior caso: $cal(O)(n^2)$. Melhor caso (já ordenado): $cal(O)(n)$.

== Selection Sort (seleção direta)

Busca o menor elemento do restante e o coloca na próxima posição, da esquerda para a direita.
- Sempre $cal(O)(n^2)$ comparações, mas só $cal(O)(n)$ trocas.

== Shell Sort

Insertion sort aplicado a subvetores de elementos à distância $h$, com $h$ diminuindo até 1. Os elementos andam longe cedo, então a passada final ($h = 1$) tem pouco trabalho.

```text
h = 2:  posições pares [10, 7] -> [7, 10]   ímpares [2, 5] já ordenado   =>  7 2 10 5
h = 1:  insertion sort normal                                            =>  2 5 7 10
```

- A complexidade depende da sequência de $h$. Com a de Knuth ($h_1 = 1$, $h_(i+1) = 3 h_i + 1$: 1, 4, 13, 40, ...), é $cal(O)(n^(3/2))$.

== Quick Sort

Escolhe um *pivô* $x$, deixa os menores à esquerda e os maiores à direita (partição) e ordena cada lado recursivamente.

+ Avança $i$ da esquerda até `v[i] >= x`.
+ Recua $j$ da direita até `v[j] <= x`.
+ Se $i <= j$, troca `v[i]` e `v[j]` e continua.
+ Quando $i$ e $j$ se cruzam, ordena recursivamente as duas partes.

- Pior caso (pivô é sempre o menor/maior): $T(n) = T(n-1) + cal(O)(n) = cal(O)(n^2)$.
- Melhor caso (pivô divide ao meio): $T(n) = 2T(n/2) + cal(O)(n) = cal(O)(n log n)$.
- Caso médio: $approx 1.386 n log_2 n - 0.846 n = cal(O)(n log n)$ (Sedgewick e Flajolet, 1996).

== Heap Sort

Um *heap* é uma árvore binária completa em que o pai é maior que os filhos (*max-heap*) ou menor (*min-heap*). Ela é guardada num vetor, com a raiz na posição 0:

#Highlight1("Heap em vetor (índice " + $k$ + ")")[
  - Pai: $floor((k - 1)/2)$
  - Filho esquerdo: $2k + 1$, filho direito: $2k + 2$
  - Folhas: posições $floor(n/2)$ até $n - 1$
]

+ Constrói um max-heap com o vetor.
+ Troca a raiz (maior) com o último elemento do heap: ele já está na posição final.
+ Diminui o heap em 1 e reorganiza a raiz (desce até o lugar certo).
+ Repete $n - 1$ vezes.

- Construir o heap custa $cal(O)(n)$: metade dos nós são folhas (custo 0), $n/4$ descem no máximo 1 nível, $n/8$ no máximo 2, ... e $sum_i i/2^i$ converge.
- Cada uma das $n - 1$ remoções custa $cal(O)(log n)$. Total: $cal(O)(n log n)$ *sempre*, sem memória extra.

== Radix Sort

Ordena os números dígito a dígito, *do menos para o mais significativo*, usando uma fila por dígito (0 a 9):
+ Distribui os números nas filas pelo dígito atual.
+ Junta as filas em ordem (0, 1, ..., 9), mantendo a ordem dentro de cada fila (estável).
+ Repete para o próximo dígito.

Ex.: 236 e 235 são separados já no 1º dígito (6 > 5). Custo: $cal(O)(d (n + k))$, onde $d$ é o número de dígitos e $k$ a base.

== Comparação entre os métodos

Tempos relativos (o mais rápido = 1) para vetores de 500 a 30 000 elementos:

#figure(image("./images/image-1.png", width: 65%), caption: [Ordem aleatória])
#figure(image("./images/image-2.png", width: 65%), caption: [Já ordenado])
#figure(image("./images/image-3.png", width: 65%), caption: [Ordem inversa])

#align(center, table(
  columns: 4,
  inset: 6pt,
  align: (left, center, center, left),
  stroke: 0.5pt + colors.primary,
  table.header([*Método*], [*Melhor*], [*Pior*], [*Quando usar*]),
  [Insertion], [$n$], [$n^2$], [Até cerca de 20 elementos ou quase ordenado; estável],
  [Selection], [$n^2$], [$n^2$], [Quando mover registros é caro (só $cal(O)(n)$ trocas)],
  [Shell], [$n log n$], [$n^(3/2)$], [Tamanho moderado; sem pior caso ruim],
  [Heap], [$n log n$], [$n log n$], [Garantia de $n log n$ sem memória extra],
  [Merge], [$n log n$], [$n log n$], [Garantia de $n log n$; estável; usa memória extra],
  [Quick], [$n log n$], [$n^2$], [Mais rápido na prática; pivô pela mediana de três evita o pior caso],
))
