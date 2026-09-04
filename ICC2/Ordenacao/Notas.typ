= Métodos de Ordenação

== Bubble Sort

2 for aninhados. Complexidade: $O(n^2)$

== Quick Sort

Se o pivô é o maior ou menor elemento:

$ T(n) = T(n-1) + O(n) arrow.r.double O(n^2) $

Se a escolha do pivô divide o vetor em partes iguais:

$ T(n) = 2T(n/2) + O(n) arrow.r.double O(n log_2 (n)) $

Caso médio (Sedgewick e Flajelot, 1996)

$ T(n) approx 1.386 n log_2 (n) - 0.846 n = O(n log_2 n)$
