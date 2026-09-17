= Métodos de Ordenação

== Bubble Sort

=== Lógica

Percorrer o array várias vezes, trocando elementos consecutivos não ordenados, até que não haja mais trocas.

=== Complexidade

2 for aninhados. Complexidade: $O(n^2)$

== Quick Sort

=== Lógica

Escolhe um pivô, coloca menores que ele à esquerda, maiores que ele à direita, divide e conquista.

1. Percorre esquerda até `v[i] >= x`
2. Percorre direita até `v[i] <= x`
3. Troca `v[i]`, `v[j]`
4. Continua incrementando até `i==j`
5. Divide e conquista

=== Complexidade

Se o pivô é o maior ou menor elemento:

$ T(n) = T(n-1) + O(n) arrow.r.double O(n^2) $

Se a escolha do pivô divide o vetor em partes iguais:

$ T(n) = 2T(n/2) + O(n) arrow.r.double O(n log_2 (n)) $

Caso médio (Sedgewick e Flajelot, 1996)

$ T(n) approx 1.386 n log_2 (n) - 0.846 n = O(n log_2 n)$

== Insertion Sort

=== Lógica

Criar um subarray à esquerda. Vamos inserir, um a um, os elementos à direita nesse subarray à esquerda.

```
[10] 2 7 5
[2 10] 7 5
[2 7 10] 5
[2 5 7 10]
```

=== Complexidade

$cal(O)(n^2)$ no pior caso.
$cal(O)(n)$ no melhor caso.

== Shell-Sort

=== Lógica

Dividir o vetor em subarrays de elementos de distância h. Aplica-se insertion sort a cada um, sendo que h é reduzido sucessivamente.

```
h = 2
[10] 2 [7] 5
[7] 2 [10] 5
7 [2] 10 [5]
7 2 10 5

h = 1
[7] 2 10 5
[2 7] 10 5
[2 5 7] 10
```

=== Complexidade

Com uma sequência adequada de incrementos de h, shell-sort é aproximadamente $O(n(log n)^2)$

Knuth (1973) sugere: define uma função recursiva h tal que $h(1) = 1$ e $h(i+1)=3*h(i)+1$

Complexidade: $O(n^(3/2))$

== Seleção Direta

Busca o menor elemento e o coloca na posição correta, da esquerda pra direita.

=== Complexidade

$cal(O)(n^2)$

== Heap Sort

Uma heap é uma estrutura de dados em que há uma ordenação entre elementos. A representação é via árvore binária.

Heap max: pai maior que filhos
Heap min: pai menor que filhos

- Nó esquerdo: menor entre 2 nós
- Nó direita: maior entre 2 nós

Um heap pode ser representado por um vetor.

- Pai do nó k: $(k-1)/2$ (inteiro)
- Filho esquerdo: $2k+1$
- Filho direito: $2k+2$
- Folhas de $n/2$ em diante (nós sem filhos).

Assume-se que:

- A raiz está sempre na posição 0 do vetor.
- comprimento(vetor) indica o número de elementos do vetor.
- tamanho_heap(vetor) indica o número de elementos no heap armazenado no vetor

```
[Pai, LFilho1, RFilho1, LFilho2, RFilho2, ...]
```

=== Lógica

+ Construir um max heap com base no vetor desordenado
+ Troca-se a raiz (maior elemento) com o último elemento e rearranja-se o heap, utilizando somente o que sobrou (último elemento ordenado)
+ Diminuir tamanho do heap em 1
+ Rearranjar max heap, se necessário
+ Repetir processo n-1 vezes

=== Complexidade

- O nível mais baixo tem aprox. n/2 nós e não precisam ser analisados.
- O segundo nível mais baixo tem aprox. n/4 nós e precisam de no máx 1 atualização.
- O terceiro nível mais baixo tem aprox n/8 nós e precisam de no máx 2 atualizações.

$ "custo_total" = n/2 dot 0 + n/4 dot 1 + n/8 dot 2 + ... + 1 dot log_2 n $
$ "custo_total" = n dot sum_(i=0)^(log_2 (n-1)) i/(2^(i+1)) = n/2 sum_(i=0)^(log_2 (n-1)) i/(2^i) $
