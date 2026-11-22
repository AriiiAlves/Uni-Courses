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


= Paradigmas de Projeto de Algoritmos

A forma de atacar o problema define o desempenho: um paradigma pode levar a um algoritmo $cal(O)(n^3)$ e outro a um $cal(O)(2^n)$ para o *mesmo* problema. Não existe um paradigma melhor que todos.

#example[
  *Problema da mochila:* $n$ itens, cada um com peso $w_i$ e utilidade $c_i$, e uma mochila de capacidade $L$ que não comporta todos. Quais itens levar para maximizar a utilidade total? O mesmo problema é resolvido por força bruta, por algoritmo guloso (na versão fracionária) e por programação dinâmica.
]

== Divisão e conquista

+ *Dividir* o problema em subproblemas menores e independentes.
+ *Conquistar:* resolver cada parte (em geral por recursão; se a entrada é simples o bastante, resolve-se direto).
+ *Combinar* as soluções parciais em uma solução global.

Exemplos: merge sort, quick sort, Fibonacci recursivo, multiplicação de matrizes $2^n times 2^n$, subarranjo máximo e a busca binária (que divide, mas descarta uma das metades em vez de combinar).

== Algoritmos tentativa e erro (força bruta)

Gera e testa *exaustivamente* todas as soluções possíveis, sem usar critério para descartar caminhos ruins. As soluções são enumeradas como o percurso de uma árvore que contém todas elas — árvore que costuma crescer exponencialmente, tornando a inspeção inviável.

Para contornar isso usam-se *heurísticas de poda*, que descartam caminhos não promissores (muitas vezes com apoio de algoritmos aproximados).

Exemplos: 8 rainhas, Sudoku, labirinto, caixeiro viajante.

#example[
  *Caminho mínimo de 1 a 5:* a força bruta enumera todos os caminhos ($1 arrow 2 arrow 3 arrow 5 = 7$; $1 arrow 4 arrow 3 arrow 5 = 6$; $1 arrow 4 arrow 5 = 9$; $1 arrow 5 = 10$; ...) e escolhe o menor.
]

== Algoritmos gulosos

Em cada passo faz a escolha que *parece melhor no momento* (ótimo local) e nunca a revê, na esperança de chegar ao ótimo global. Típicos de problemas de otimização, mas não garantem a solução ótima.

Exemplos: algoritmo de Dijkstra (caminho mínimo), mochila fracionária (que dá respostas ruins para a mochila tradicional), codificação de Huffman.

#example[
  *Dijkstra de 1 a 5:* mantém-se o conjunto $S$ dos vértices já fechados e o vetor $D$ das distâncias conhecidas. A cada passo fecha-se o vértice de menor $D$ e atualizam-se os vizinhos:
  ```text
  S = {}              D = ∞ ∞ ∞ ∞ ∞
  S = {1}             D = 0 1 ∞ 3 10
  S = {1,2}           D = 0 1 6 3 10
  S = {1,2,4}         D = 0 1 5 3 9
  S = {1,2,4,3}       D = 0 1 5 3 6
  S = {1,2,4,3,5}     caminho mínimo até 5 = 6
  ```
]

== Programação dinâmica

Reduz o tempo de execução reaproveitando soluções ótimas de subproblemas *já calculados*. Baseia-se no princípio de que, numa sequência ótima de decisões, cada subsequência também é ótima — o menor caminho de São Carlos a São Paulo passando por Campinas é a concatenação dos menores caminhos dos dois trechos.

+ Dividir o problema em subproblemas.
+ Computar os valores de forma *ascendente* e armazená-los (*memorização*), normalmente numa tabela/matriz.
+ Construir a solução ótima a partir dos valores guardados.

Vale a pena quando (i) a solução ótima se compõe das soluções ótimas dos subproblemas e (ii) a solução ingênua recalcula o mesmo subproblema várias vezes.

Exemplos: mochila (tabela de pesos $times$ itens), Fibonacci (a versão recursiva recalcula $f(n-2)$ várias vezes; a tabela resolve em $cal(O)(n)$).

== Algoritmos aproximados

Geram soluções que podem não ser ótimas, mas são próximas do ótimo — é preciso uma *medida de qualidade* para avaliar o quão próximo. Usados quando o ótimo é inviável de calcular. Exemplos: caixeiro viajante, empacotamento de caixas, engine de xadrez.

== Indução

Prova que uma afirmação vale para todo $n$; é a ferramenta por trás do método da substituição.

#Highlight1("Princípio da indução")[
  *Fraca:* se $p(1)$ é verdade (*caso base*) e, para todo $k$, "$p(k)$ verdade $arrow.r.double$ $p(k+1)$ verdade" (*passo indutivo*), então $p(n)$ vale para todo $n in NN$.

  *Forte:* o passo indutivo pode usar $p(1), ..., p(k)$ para provar $p(k+1)$.

  *Outro ponto inicial:* base em $p(n_0)$ e passo para todo $k >= n_0$ provam $p(n)$ para todo $n >= n_0$.
]

#example[
  *Soma da PA:* $p(n): sum_(i=1)^n i = (n(n+1))/2$.
  - Base: $n = 1 arrow.r.double 1(1+1)/2 = 1$. #sym.checkmark
  - Passo: supondo $p(k)$,
  $ p(k+1) = (k+1) + p(k) = (k+1) + (k(k+1))/2 = (k+1)(1 + k/2) = ((k+1)(k+2))/2 $
  que é exatamente $p(k+1)$. #sym.checkmark
]

= Métodos de Ordenação

== O problema da ordenação

*Ordenar* é organizar uma sequência de elementos de modo que $k_1 <= k_2 <= ... <= k_n$ segundo alguma relação de ordem. Estima-se que 25% do tempo de computação do mundo seja gasto ordenando: listas telefônicas, dicionários, bancos de dados.

Ordenar facilita a busca — mas não sempre: se a busca é feita uma única vez, pode dar menos trabalho procurar no conjunto desordenado do que ordenar e depois buscar. Se a busca é frequente, vale ordenar, pois a ordenação é feita *uma vez só*.

#Highlight1("Terminologia")[
  - *Registro* e *chave:* ordena-se um conjunto de registros pelo valor de uma chave.
  - *Interna* vs. *externa:* interna se todos os registros cabem na memória principal (um único vetor); externa se os dados precisam ficar em disco/fita.
  - *Estável:* a ordem original de registros com a *mesma chave* é preservada.
  - *Sobre os próprios registros:* os registros são trocados de posição.
  - *Por endereços:* mantém-se uma tabela de ponteiros para os registros e só os ponteiros são trocados — muito mais barato quando o registro é grande.
]

#example[
  Para `struct no { int chave; char valor[10]; }`, a troca muda conforme o esquema:
  ```c
  // ordenação por registro: copia o conteúdo
  void swap(struct no *n1, struct no *n2) {
      struct no aux;
      aux.chave = n1->chave;  strcpy(aux.valor, n1->valor);
      n1->chave = n2->chave;  strcpy(n1->valor, n2->valor);
      n2->chave = aux.chave;  strcpy(n2->valor, aux.valor);
  }

  // ordenação por endereço: troca só os ponteiros
  void swap(struct no **n1, struct no **n2) {
      struct no *aux = *n1;
      *n1 = *n2;
      *n2 = aux;
  }
  ```
]

Os métodos independem de o registro ser complexo ou um simples inteiro; por tradição, assume-se entrada de inteiros em ordem crescente. Para comparar os métodos, compara-se a complexidade, e a *operação dominante* é, na maioria dos casos, o *número de comparações entre elementos*.

Os métodos se agrupam por ideia central:
- *Troca:* bubble sort, quick sort.
- *Inserção:* inserção simples (direta), shell sort.
- *Seleção:* seleção direta, heap sort.
- *Contagem:* contagem de menores, contagem de tipos.
- *Distribuição:* radix sort.

== Bubble Sort

Percorre o vetor várias vezes comparando cada elemento com o sucessor (`v[j]` com `v[j+1]`) e trocando-os se estiverem fora de ordem. Ao fim do passo $i$, o elemento `v[n-i]` já está na posição correta (os maiores "borbulham" para o fim), então são necessárias $n - 1$ iterações.

```text
passo 0 (original)  25 57 48 37 12 92 86 33
passo 1             25 48 37 12 57 86 33 92
passo 2             25 37 12 48 57 33 86 92
passo 3             25 12 37 48 33 57 86 92
passo 4             12 25 37 33 48 57 86 92
passo 5             12 25 33 37 48 57 86 92   (já ordenado)
```

Duas melhorias: percorrer só até `n-i-1` (o sufixo já está pronto) e parar quando uma passada não fizer *nenhuma* troca.

```c
void bubblesort_aprimorado(int v[], int n) {
    int i, j, aux, troca = 1;
    for (i = 0; i < n && troca; i++) {
        troca = 0;
        for (j = 0; j < n - i - 1; j++)
            if (v[j] > v[j+1]) {
                troca = 1;
                aux = v[j]; v[j] = v[j+1]; v[j+1] = aux;
            }
    }
}
```

- Comparações: $(n-1) + (n-2) + ... + 1 = (n(n-1))/2 = cal(O)(n^2)$ (pior e médio caso).
- Melhor caso (vetor já ordenado): uma passada sem trocas, $cal(O)(n)$.
- Espaço: $cal(O)(n)$ (o próprio vetor; nenhuma estrutura auxiliar).

== Insertion Sort (inserção simples)

Mantém um prefixo ordenado à esquerda e insere nele, um a um, os elementos da direita: no $i$-ésimo passo, insere `v[i]` na posição correta entre `v[0], ..., v[i-1]`, *realocando* os maiores uma casa à frente.

```text
[10] 2 7 5  ->  [2 10] 7 5  ->  [2 7 10] 5  ->  [2 5 7 10]
```

```text
X = (44, 55, 12, 42, 94, 18, 06, 67)
passo 1 (55)   44 55 12 42 94 18 06 67
passo 2 (12)   12 44 55 42 94 18 06 67
passo 3 (42)   12 42 44 55 94 18 06 67
passo 4 (94)   12 42 44 55 94 18 06 67
passo 5 (18)   12 18 42 44 55 94 06 67
passo 6 (06)   06 12 18 42 44 55 94 67
passo 7 (67)   06 12 18 42 44 55 67 94
```

```c
void ordenacao_por_insercao(int v[], int n) {
    int i, j, elem;
    for (i = 1; i < n; i++) {
        elem = v[i];
        for (j = i - 1; j >= 0 && elem < v[j]; j--)
            v[j+1] = v[j];
        v[j+1] = elem;
    }
}
```

- Melhor caso (já ordenado): $cal(O)(n)$. Pior caso (ordem inversa): $cal(O)(n^2)$. Espaço: $cal(O)(n)$.
- É *estável*, é um dos métodos mais intuitivos, é melhor que o bubble sort e é muito eficiente em arquivos "quase" ordenados.

== Selection Sort (seleção direta)

Busca o menor elemento entre `v[i], ..., v[n-1]` e o troca com `v[i]`, da esquerda para a direita; após $i$ passos, `v[0], ..., v[i-1]` estão ordenados. Diferença em relação à inserção direta: aqui o elemento sai *direto para sua posição final*, sem realocar os demais.

```text
X = (44, 55, 12, 42, 94, 18, 06, 67)
passo 1 (06)   06 55 12 42 94 18 44 67
passo 2 (12)   06 12 55 42 94 18 44 67
passo 3 (18)   06 12 18 42 94 55 44 67
passo 5 (44)   06 12 18 42 44 55 94 67
passo 7 (67)   06 12 18 42 44 55 67 94
```

```c
void selection_sort(int v[], int n) {
    int i, j, min, aux;
    for (i = 0; i < n - 1; i++) {
        min = i;
        for (j = i + 1; j < n; j++)
            if (v[j] < v[min]) min = j;
        if (i != min) {
            aux = v[i]; v[i] = v[min]; v[min] = aux;
        }
    }
}
```

- $(n-1) + (n-2) + ... + 1 = (n(n-1))/2 = cal(O)(n^2)$ comparações *sempre*: não melhora se a entrada já está ordenada.
- Só $cal(O)(n)$ trocas e pouco espaço extra — útil quando mover registros é caro. Vale a pena apenas para $n$ pequeno.

== Shell Sort

A inserção simples só movimenta elementos *adjacentes*: se o menor elemento está na última posição, precisa de $n-1$ comparações e movimentos para chegar ao início. O shell sort permite a troca de elementos *distantes*: aplica inserção simples a subvetores formados por elementos à distância $h$ (diz-se que a sequência fica *$h$-ordenada*), com $h$ decrescendo até 1 — daí o nome "incrementos decrescentes". O último incremento deve ser sempre 1, e nessa passada final o shell sort *é* a inserção simples, mas com pouco trabalho a fazer.

Para incremento $h$, o $i$-ésimo elemento do $j$-ésimo subconjunto é `x[(i-1)*h + j - 1]`.

```text
X = 25 57 48 37 12 92 86 33
h = 5: (x0,x5) (x1,x6) (x2,x7) (x3) (x4)  =>  25 57 33 37 12 92 86 48
h = 3: (x0,x3,x6) (x1,x4,x7) (x2,x5)      =>  25 12 33 37 48 92 86 57
h = 1: inserção simples no vetor todo     =>  12 25 33 37 48 57 86 92
```

```c
void shellsort(int v[], int n, int incrementos[], int numinc) {
    int incr, i, j, h, aux;
    for (incr = 0; incr < numinc; incr++) {
        h = incrementos[incr];
        for (i = h; i < n; i++) {
            aux = v[i];
            for (j = i - h; j >= 0 && v[j] > aux; j -= h)
                v[j+h] = v[j];
            v[j+h] = aux;
        }
    }
}
```

A complexidade depende da *sequência de incrementos*:
- Sequência de Pratt (números $2^i 3^j$: 1, 2, 3, 4, 6, 8, 9, ...): $approx cal(O)(n log^2 n)$.
- Sequência de Knuth (1973), $h_1 = 1$ e $h_(i+1) = 3 h_i + 1$ (1, 4, 13, 40, 121, 364, 1093, ...), aplicada no sentido inverso: $cal(O)(n^(3/2))$.

== Quick Sort

Melhoramento do bubble sort pela mesma razão do shell sort: trocas entre elementos distantes são mais efetivas. É divisão e conquista — divide o vetor em dois, ordena cada parte independentemente.

Escolhe um *pivô* $x$ (a escolha é importantíssima), coloca-o na posição correta e deixa os menores ou iguais à esquerda e os maiores ou iguais à direita (*partição*):

+ Avança $i$ da esquerda até `v[i] >= x`.
+ Recua $j$ da direita até `v[j] <= x`.
+ Se $i <= j$, troca `v[i]` e `v[j]`, faz `i++`, `j--` e continua.
+ Quando $i$ e $j$ se cruzam, a partição acaba: `v[0]...v[j]` $<= x$ e `v[i]...v[n-1]` $>= x$. Ordena recursivamente os dois subvetores.

```text
pivô = v[(0+7)/2] = 37
25 57 35 37 12 86 92 33   i=0, j=7   (inicial)
25 57 35 37 12 86 92 33   i=1        (procura-se v[i] >= pivô)
25 57 35 37 12 86 92 33   j=7        (procura-se v[j] <= pivô)
25 33 35 37 12 86 92 57   troca, i=2, j=6
25 33 35 37 12 86 92 57   i=3, j=4
25 33 35 12 37 86 92 57   troca, i=4, j=3  ->  cruzaram, fim
      subvetores: v[0..3] = 25 33 35 12   e   v[4..7] = 37 86 92 57
```

```c
void quicksort(int v[], int inf, int sup) {
    int aux, meio = (inf + sup) / 2, pivo = v[meio];
    int i = inf, j = sup;
    do {                                  // partição
        while (v[i] < pivo) i++;
        while (v[j] > pivo) j--;
        if (i <= j) {
            aux = v[i]; v[i] = v[j]; v[j] = aux;
            i++; j--;
        }
    } while (i < j);
    if (j > inf) quicksort(v, inf, j);
    if (i < sup) quicksort(v, i, sup);
}
```

- Pior caso (pivô é sempre o menor/maior elemento — p. ex. vetor já ordenado com pivô num dos extremos): subvetores desiguais, $n$ chamadas recursivas que eliminam 1 elemento cada, $T(n) = T(n-1) + cal(O)(n) = 1/2 n(n+1) = cal(O)(n^2)$.
- Melhor caso (pivô divide ao meio): $approx log_2 n$ níveis de $n$ comparações, $T(n) = 2T(n/2) + n = cal(O)(n log n)$.
- Caso médio: $approx 1.386 n log_2 n - 0.846 n = cal(O)(n log n)$ (Sedgewick e Flajolet, 1996).

#Highlight2("Como evitar o pior caso")[
  - *Mediana de três:* escolher 3 elementos (p. ex. primeiro, meio e último) e usar a mediana deles como pivô.
  - *Pivô aleatório.*
  - Usar *inserção simples* nos subvetores pequenos (menos de ~25 elementos), reduzindo o número de chamadas recursivas: melhoria de cerca de 20% (Sedgewick, 1988).
]

É frágil a erros simples de implementação e a recursão exige alguma memória adicional.

== Heap Sort

Um *heap* é uma estrutura com ordenação entre elementos, representada por uma árvore binária. (Cuidado: a palavra "heap" também designa o espaço de variáveis dinâmicas em várias linguagens — outra coisa.) Um heap respeita duas propriedades:

#Highlight1("Ordem e forma")[
  - *Ordem:* o item de cada nó satisfaz uma relação de ordem com os filhos.
    - *Heap máximo* (descendente): pai $>=$ filhos, a raiz é o maior elemento.
    - *Heap mínimo* (ascendente): pai $<=$ filhos, a raiz é o menor elemento.
  - *Forma:* a árvore é completa até pelo menos o penúltimo nível e, se o último nível não estiver completo, seus nós estão todos agrupados à esquerda.
]

A árvore é guardada num vetor, com a raiz na posição 0:

#Highlight1("Heap em vetor (índice " + $k$ + ")")[
  - Pai: $floor((k - 1)/2)$
  - Filho esquerdo: $2k + 1$, filho direito: $2k + 2$
  - Folhas: posições $floor(n/2)$ até $n - 1$
]

```text
árvore:  16              vetor:  0  1  2  3  4  5  6  7  8  9
       14    10                 16 14 10  8  7  9  3  2  4  1
     8   7  9  3
    2 4 1
```

Distingue-se `comprimento(v)` (número de elementos do vetor) de `tamanho_do_heap(v)` (quantos deles ainda pertencem ao heap, sempre $<=$ comprimento): os elementos além de `v[tamanho_do_heap-1]` são válidos, mas já saíram do heap.

=== Rearranjar o heap

Recebe um vetor e um índice $i$ e assume que as subárvores dos filhos de $i$ já são heaps máximos, mas que `v[i]` pode ser menor que seus filhos. Deixa `v[i]` "escorregar" até a posição correta, tornando a subárvore com raiz em $i$ um heap máximo.

```c
void rearranjar_heap(int v[], int i, int tamanho_do_heap) {
    int esq = 2*i + 1, dir = 2*i + 2, maior, aux;
    if ((esq < tamanho_do_heap) && (v[esq] > v[i])) maior = esq;
    else maior = i;
    if ((dir < tamanho_do_heap) && (v[dir] > v[maior])) maior = dir;
    if (maior != i) {
        aux = v[i]; v[i] = v[maior]; v[maior] = aux;
        rearranjar_heap(v, maior, tamanho_do_heap);
    }
}
```

Custo: desce no máximo a altura da árvore, $cal(O)(log n)$.

```text
v = 16 4 10 14 7 9 3 2 8 1
rearranjar_heap(v,1)  ->  16 14 10 4 7 9 3 2 8 1   (4 troca com 14)
  recursão em 3       ->  16 14 10 8 7 9 3 2 4 1   (4 troca com 8)
```

=== Construir o heap

Percorre de forma ascendente os nós que não são folhas (de $floor(n/2) - 1$ até 0) chamando `rearranjar_heap`. A cada chamada a subárvore daquele nó se torna um heap máximo; ao chegar à raiz, o heap completo está pronto.

```c
void construir_heap(int v[], int n) {
    int i;
    for (i = n/2 - 1; i >= 0; i--)
        rearranjar_heap(v, i, n);
}
```

#Highlight2("Construir o heap custa " + $cal(O)(n)$)[
  Numa árvore binária com $n$ elementos: o nível mais baixo tem $approx n/2$ nós que nem são analisados (folhas); o próximo tem $approx n/4$ nós que exigem até 1 reorganização; o seguinte $approx n/8$ nós com até 2; e a altura é $log_2 n$. Somando:
  $ "custo" = n/4 dot 1 + n/8 dot 2 + ... + 1 dot log_2 n = n sum_(i=0)^(log n) i/2^i $
  Pela soma geométrica ponderada $sum i x^i = x/(1-x)^2$, com $x = 1/2$, o somatório converge para 2. Logo o custo é $cal(O)(n)$ — e não $cal(O)(n log n)$ como pareceria.
]

=== O algoritmo

+ Constrói um max-heap com o vetor (`construir_heap`).
+ Troca a raiz (maior elemento) com o último elemento do heap: ele já está na posição final.
+ Diminui o tamanho do heap em 1.
+ Rearranja o heap a partir da raiz (`rearranjar_heap`), se necessário.
+ Repete $n - 1$ vezes.

```c
void heapsort(int v[], int n) {
    int i, aux, tamanho_do_heap;
    construir_heap(v, n);
    tamanho_do_heap = n;
    for (i = n - 1; i > 0; i--) {
        aux = v[0]; v[0] = v[i]; v[i] = aux;   // raiz vai para o fim
        tamanho_do_heap--;
        rearranjar_heap(v, 0, tamanho_do_heap);
    }
}
```

- Construir o heap: $cal(O)(n)$; depois $n - 1$ chamadas a `rearranjar_heap` de $cal(O)(log n)$ cada. Total: $cal(O)(n log n)$ *sempre*, sem memória extra — eficiente mesmo com o vetor já ordenado.
- O anel interno é mais complexo que o do quick sort, que na prática é cerca de 2x mais rápido. Para arquivos grandes, o heap sort é melhor que o shell sort.

== Merge Sort

Divisão e conquista: divide o vetor ao meio, ordena recursivamente cada metade e *intercala* (merge) as duas metades ordenadas percorrendo-as uma vez, com um vetor auxiliar.

$ T(n) = 2T(n/2) + Theta(n) = Theta(n log n) $

Executa sempre em $cal(O)(n log n)$ e é *estável*, mas precisa de memória adicional $cal(O)(n)$ para a intercalação. Junto com o heap sort, é a escolha de quem não pode tolerar variação no tempo de ordenação.

== Ordenação por contagem de menores

Ideia: se sabemos quantos elementos são menores que um dado valor, sabemos a posição que ele ocupa no vetor ordenado — se há 5 valores menores que 7, o 7 vai para a sexta posição. Usa-se um arranjo auxiliar `X` com as contagens e outro, `B`, para montar o resultado.

```text
A = 4 2 1 3 7 9 8 3 0 5    (original)
X = 5 2 1 3 7 9 8 3 0 6    (X[i] = nº de elementos de A menores que A[i])
B = 0 1 2 3 3 4 5 7 8 9    (A[i] vai para a posição X[i] de B)
```

Repare no cuidado com o *3 duplicado*: a comparação usa `<` num lado e `else` no outro, de modo que elementos iguais recebem posições distintas.

```c
void contagem_de_menores(int v[], int n) {
    int X[n], B[n], i, j;
    for (i = 0; i < n; i++) X[i] = 0;        // inicializa
    for (i = 1; i < n; i++)                  // conta menores
        for (j = i - 1; j >= 0; j--)
            if (v[i] < v[j]) X[j]++;
            else X[i]++;
    for (i = 0; i < n; i++) B[X[i]] = v[i];  // monta o final
    for (i = 0; i < n; i++) v[i] = B[i];     // copia de volta
}
```

- Tempo: $cal(O)(n^2)$ (dois laços aninhados). Espaço: $cal(O)(3n)$ (`v`, `X` e `B`).

== Ordenação por contagem de tipos (counting sort)

Conta quantas vezes *cada valor* ocorre; se há $k$ elementos antes dele, ele ocupa a posição $k+1$. Restrição: os elementos devem estar num intervalo $[min, max]$ de inteiros positivos.

```text
A = 1 3 2 7 6 3 1 2 1 7     (original; min = 1, max = 7)
valor:  1 2 3 4 5 6 7
X    =  3 2 2 0 0 1 2       (X[i] = nº de ocorrências do valor i)
   -> há 3 uns, que ocupam as posições 0, 1, 2 de B
   -> há 2 dois, que ocupam as posições livres seguintes (3 e 4) ...
B = 1 1 1 2 2 3 3 6 7 7     (ordenado)
```

```c
void contagem_de_tipos(int v[], int n) {
    int B[n], i, j, max = v[0];
    for (i = 1; i < n; i++)                  // determina o máximo
        if (v[i] > max) max = v[i];
    int X[max+1];
    for (i = 0; i < max + 1; i++) X[i] = 0;  // inicializa
    for (i = 0; i < n; i++) X[v[i]]++;       // conta tipos
    j = 0;                                   // monta o final
    for (i = 0; i < max + 1; i++)
        while (X[i] != 0) { B[j++] = i; X[i]--; }
    for (i = 0; i < n; i++) v[i] = B[i];     // copia de volta
}
```

- Tempo: $cal(O)(n)$ se $max <= n$ — melhor que o limite $cal(O)(n log n)$ porque *não é uma ordenação por comparação*. Espaço: $cal(O)(3n)$ nas mesmas condições.

== Radix Sort

Ordena os números dígito a dígito, *do menos para o mais significativo*, usando uma fila por dígito (0 a 9). Inspirado no funcionamento das antigas perfuradoras de cartões.

+ Distribui os números nas filas pelo dígito atual.
+ Junta as filas em ordem (0, 1, ..., 9), mantendo a ordem dentro de cada fila (estável).
+ Repete para o próximo dígito.

Ex.: 236 e 235 são separados já no 1º dígito (6 > 5); se empatassem, decidiria o dígito do meio e depois o mais significativo. Para que todos tenham o mesmo número de dígitos, completa-se com zeros à esquerda (026 e 235). São necessárias, no máximo, $m$ iterações, onde $m$ é o número de dígitos do maior número.

- Tempo: $cal(O)(m n)$ — se $m$ é pequeno, $cal(O)(n)$. Genericamente, $cal(O)(d (n + k))$ com $d$ dígitos e base $k$.
- Espaço: além do vetor, contam-se os espaços das filas.

== Cota inferior da ordenação por comparação

A *cota (ou limite) inferior* de um problema é um $C(n)$ tal que se prova ser impossível resolvê-lo em menos de $C(n)$ passos; um algoritmo que alcança a cota inferior é *ótimo*.

#Highlight2("Ordenação por comparação é " + $Omega(n log n)$)[
  Monta-se uma *árvore de decisão*, em que cada nó interno é uma comparação e cada folha é uma ordenação possível da entrada:
  ```text
                     a<b
          sim                  não
       b<c                        b<c
   sim      não              sim      não
  a<b<c   a<c   ...         a<c  ...  c<=b<=a
  ```
  - Número de folhas = número de permutações possíveis = $n!$.
  - Uma árvore binária de altura $h$ tem no máximo $2^h$ folhas.
  - O número de comparações no pior caso é a altura da árvore, então $2^h >= n!$, isto é, $h >= log(n!)$.
  - Pela aproximação de Stirling, $(n/3)^n < n! < (n/2)^n$ para $n > 5$, logo $log(n!) = Theta(n log n)$.

  Portanto $h = Omega(n log n)$: *nenhum* método baseado em comparação de elementos pode ser melhor que $cal(O)(n log n)$ — o que o counting sort só contorna porque não compara elementos.
]

== Comparação entre os métodos

Tempos relativos (o mais rápido = 1) para vetores de 500 a 30 000 elementos (Ziviani, 2007):

#figure(image("./images/image-1.png", width: 65%), caption: [Ordem aleatória])
#figure(image("./images/image-2.png", width: 65%), caption: [Já ordenado])
#figure(image("./images/image-3.png", width: 65%), caption: [Ordem inversa])

Conclusões dos experimentos:
- O quick sort é o mais rápido para todos os arranjos com elementos aleatórios.
- Heap sort e quick sort diferem por uma constante, sendo o heap sort mais lento.
- Só para arranjos *grandes e aleatórios* o heap sort é melhor que o shell sort.
- A inserção direta é a mais rápida para arranjos já ordenados e é melhor que a seleção direta para arranjos aleatórios.
- Shell sort e quick sort são sensíveis à ordem (ascendente/descendente) da entrada.

#align(center, table(
  columns: 4,
  inset: 6pt,
  align: (left, center, center, left),
  stroke: 0.5pt + colors.primary,
  table.header([*Método*], [*Melhor*], [*Pior*], [*Quando usar*]),
  [Bubble], [$n$], [$n^2$], [Didático; pior que a inserção direta em tudo],
  [Insertion], [$n$], [$n^2$], [Até cerca de 20 elementos ou quase ordenado; estável],
  [Selection], [$n^2$], [$n^2$], [Registros grandes (só $cal(O)(n)$ trocas), até ~1000 elementos],
  [Shell], [$n log n$], [$n^(3/2)$], [Tamanho moderado; sem pior caso ruim; ~2x o quick sort],
  [Heap], [$n log n$], [$n log n$], [Garantia de $n log n$ sem memória extra; arquivos grandes],
  [Merge], [$n log n$], [$n log n$], [Garantia de $n log n$; estável; usa memória extra],
  [Quick], [$n log n$], [$n^2$], [Mais rápido na prática; pivô pela mediana de três evita o pior caso],
  [Cont. menores], [$n^2$], [$n^2$], [Didático; espaço $cal(O)(3n)$],
  [Cont. tipos], [$n$], [$n$], [Chaves inteiras num intervalo pequeno ($max <= n$)],
  [Radix], [$n$], [$m n$], [Chaves com poucos dígitos; estável],
))

Outros métodos (não detalhados): *shake sort* (ou método da coqueteleira, melhoramento do bubble sort que alterna o sentido das passadas), *tree sort* (ordenação por árvore binária) e *bucket sort* (método do balde).

= Métodos de Busca

Dado um conjunto de elementos, cada um identificado por uma chave, o objetivo da busca é localizar o elemento que corresponde a uma chave específica. Certos métodos de organização dos dados tornam a busca muito mais eficiente — o objetivo é achar o registro com o menor custo possível.

== Conceitos

#Highlight1("Tabelas, registros e chaves")[
  *Tabela* é um termo genérico para qualquer estrutura usada para armazenar e organizar os dados: vetor de registros, lista encadeada, árvore, etc. Uma tabela é um conjunto de *registros*, e a cada registro está associada uma *chave*, que os diferencia.
  - *Chave interna:* está contida dentro do registro, numa posição específica.
  - *Chave externa:* fica numa tabela de chaves separada, com ponteiros para os registros.
  - *Chave primária:* conjunto exclusivo de chaves — dois registros não podem ter o mesmo valor.
  - *Chave secundária:* chaves não primárias, cujos valores não precisam ser exclusivos.
]

Um *algoritmo de busca* aceita um argumento $a$ e tenta encontrar o registro cuja chave seja $a$. Operações sobre a tabela: *inserção*, *remoção*, *recuperação* (achar e tornar disponível) e *busca e inserção* (insere se não encontrar).

A tabela pode ficar toda na memória (*busca interna*), toda em armazenamento auxiliar (*busca externa*) ou dividida entre os dois. Técnicas de busca interna: sequencial, sequencial indexada, binária, por interpolação, em árvores e hashing.

== Busca sequencial

A forma mais simples: percorre registro por registro procurando a chave. Aplicável a vetor ou lista encadeada.

```c
int busca_sequencial(int v[], int n, int x) {
    int i;
    for (i = 0; i < n; i++)
        if (v[i] == x) return i;
    return -1;
}
```

#Highlight2("Sentinela")[
  Adiciona-se um elemento de valor $x$ no fim da tabela (o vetor precisa ser declarado com uma posição a mais). Isso *garante* que o elemento será encontrado, eliminando o teste de fim de vetor do laço e melhorando o desempenho.
  ```c
  int busca_sequencial_com_sentinela(int v[], int n, int x) {
      int i;
      v[n] = x;
      for (i = 0; x != v[i]; i++);
      if (i < n) return i;
      else return -1;
  }
  ```
]

Complexidade:
- Registro na primeira posição: 1 comparação; na última: $n$ comparações.
- Se o argumento é igualmente provável em qualquer posição, em média $(n+1)/2$ comparações.
- Busca mal sucedida: $n$ comparações.
- Pior caso: $cal(O)(n)$.

O vetor tem tamanho fixo (pode faltar ou desperdiçar espaço); a lista encadeada resolve isso, mas a remoção passa a ser atualização de ponteiros em vez de realocação dos registros acima do removido.

#Highlight2("Reorganização para ganhar eficiência")[
  Reordenar continuamente a tabela para que os registros mais acessados fiquem no início — ambos se baseiam no fenômeno da *recuperação recorrente* de registros:
  - *Mover-para-frente:* a cada busca bem sucedida, o registro recuperado vai para o início da lista. Vantagem: melhores resultados para quantidades pequena e média de buscas. Desvantagem: uma única recuperação não indica que o registro será recuperado com frequência, e os outros registros perdem eficiência.
  - *Transposição:* o registro recuperado é trocado com o imediatamente anterior — subida gradual, menos sensível a acessos isolados.
]

*Tabela ordenada:* a busca é interrompida assim que se encontra uma chave maior que a procurada, então o caso médio cai para $n/2$ comparações; o pior caso (chave ausente) continua $n$. A dificuldade é manter a tabela ordenada nas inserções e remoções.

== Busca sequencial indexada

Mantém-se, além do arquivo ordenado, uma *tabela de índices*. Cada elemento do índice guarda uma chave `kindex` e um indicador (ponteiro ou inteiro) do registro correspondente no arquivo. A busca começa no ponto indicado pelo índice, não do início da tabela. Se a tabela for muito grande, usa-se um *índice secundário* — um índice para o índice primário; em geral não são necessários mais de 2 níveis.

#Highlight1("Como montar o índice primário")[
  + Se a tabela não estiver ordenada, ordene-a.
  + Divida o número de elementos pelo tamanho desejado do índice: $n\/"tam-índice"$.
  + Recupere da tabela os elementos nas posições $0$, $0 + n\/"tam-índice"$, $0 + 2n\/"tam-índice"$, etc.

  Cada elemento do índice representa (aponta para o começo de) um grupo de $n\/"tam-índice"$ elementos. Ex.: tabela de 1000 elementos e índice de 10 $arrow.r$ $1000\/10 = 100$, índice montado com as posições 0, 100, 200, ... Para o índice secundário, aplica-se o mesmo raciocínio sobre o índice primário.
]

```c
typedef struct { int kindex, pos; } bloco_indice;

void cria_indice(bloco_indice indice[], int tam_indice, int v[], int n) {
    int pos, i = 0;
    while (i < tam_indice) {
        pos = i * n / tam_indice;
        indice[i].kindex = v[pos];
        indice[i].pos = pos;
        i++;
    }
}

int busca_sequencial_indexada(int v[], int n, bloco_indice indice[],
                              int tam_indice, int x) {
    int i;
    for (i = 0; i < tam_indice && indice[i].kindex <= x; i++);  // no índice
    i = indice[i-1].pos;
    while ((i < n) && (v[i] < x)) i++;                          // na tabela
    if ((i < n) && (v[i] == x)) return i;
    else return -1;
}
```

- *Vantagem:* os itens podem ser examinados sequencialmente sem que todos os registros sejam acessados — o tempo de busca diminui consideravelmente.
- *Desvantagens:* a tabela tem que estar ordenada e é preciso espaço adicional para o(s) índice(s). A busca binária pode ser usada no lugar da busca sequencial *dentro* do índice.

#Highlight2("Inserção e remoção")[
  - *Remoção:* remove-se o elemento e rearranja-se a tabela e o(s) índice(s); ou marca-se a posição como esvaziada, indicando que pode ser ocupada futuramente.
  - *Inserção:* se houver espaço vago no bloco, rearranjam-se os elementos *localmente* (os seguintes "descem" uma posição). Se não houver, rearranja-se a tabela a partir do ponto apropriado e reconstrói-se o(s) índice(s).
]

== Busca binária

Em um arranjo *ordenado*, compara-se a chave com o elemento do meio: se igual, achou; se menor, busca-se na metade inferior; se maior, na metade superior. Em cada passo o espaço de busca é dividido por 2.

```text
busca por 25
inf=0                              sup=7
 12  25  33  37  48  57  86  92
             ^meio    25 < 37  ->  sup = meio-1 = 2
inf=0      sup=2
 12  25  33 ...
     ^meio            = 25     ->  achou
```

```c
int busca_binaria(int v[], int n, int x) {           // não recursiva
    int inf = 0, sup = n - 1, meio;
    while (inf <= sup) {
        meio = (inf + sup) / 2;
        if (x == v[meio]) return meio;
        else if (x < v[meio]) sup = meio - 1;
        else inf = meio + 1;
    }
    return -1;
}

int busca_binaria_rec(int v[], int inf, int sup, int x) {   // recursiva
    int meio;
    if (inf <= sup) {
        meio = (inf + sup) / 2;
        if (x == v[meio]) return meio;
        else if (x < v[meio]) return busca_binaria_rec(v, inf, meio-1, x);
        else return busca_binaria_rec(v, meio+1, sup, x);
    }
    return -1;
}
```

- Complexidade: $cal(O)(log n)$, pois cada comparação reduz os candidatos por um fator de 2.
- *Vantagens:* eficiência e simplicidade de implementação.
- *Desvantagens:* nem todo arranjo está ordenado; exige um *arranjo* para armazenar os dados (usa o fato de que os índices são inteiros consecutivos, o que uma lista encadeada não oferece); inserção e remoção são ineficientes por causa da realocação.

== Busca por interpolação

Se as chaves estiverem *uniformemente distribuídas*, em vez de ir ao meio pode-se estimar onde $x$ deve estar, como se procurássemos um nome numa lista telefônica:

$ "meio" = "inf" + ("sup" - "inf") dot (x - A["inf"])/(A["sup"] - A["inf"]) $

com `inf` e `sup` redefinidos iterativamente como na busca binária.

#example[
  $A = (3, 6, 9, 12, 15, 18, 21, 24)$, buscando 18:
  $ "meio" = 0 + (7 - 0) dot (18 - 3)/(24 - 3) = (7 dot 15)/21 = 5 $
  e $A[5] = 18$ — achou na primeira tentativa.
]

- Complexidade: $cal(O)(log log n)$ com chaves uniformemente distribuídas; raramente precisa de mais comparações.
- Se as chaves *não* estiverem uniformemente distribuídas, pode ser tão ruim quanto a busca sequencial. Na prática as chaves se aglomeram em torno de certos valores (há muito mais nomes começando com "S" do que com "Q").

== Busca em árvores binárias de busca (ABB)

- A lista encadeada é eficiente para inserção e remoção dinâmicas, mas ineficiente para busca.
- A lista sequencial ordenada é eficiente para busca, mas ineficiente para inserção e remoção.
- A *ABB* é eficiente para as três operações.

#Highlight1("Definição")[
  Uma árvore binária (cada nó tem no máximo 2 filhos) com raiz $R$ é uma *ABB* — também chamada árvore de pesquisa ou árvore ordenada — se:
  - a chave de cada nó da subárvore *esquerda* de $R$ é *menor* que a chave de $R$;
  - a chave de cada nó da subárvore *direita* de $R$ é *maior* que a chave de $R$;
  - as subárvores esquerda e direita também são ABBs.
]

A busca compara a chave com o elemento do nó: se menor, desce à esquerda; se maior, à direita. Desce-se verticalmente até as folhas no pior caso, *sem passar por mais de um nó por nível* — logo a busca visita no máximo tantos nós quanto a altura da árvore. E a altura é pequena porque o nível $N$ de uma árvore completa já acomoda $2^N - 1$ nós:

#align(center, table(
  columns: 2,
  inset: 6pt,
  align: center,
  stroke: 0.5pt + colors.primary,
  table.header([*Nível*], [*Nós que cabem*]),
  [1], [1], [2], [3], [3], [7], [4], [15],
  [10], [1.023], [13], [8.191], [16], [65.535], [20], [1.048.575],
  [30], [1.073.741.823], [$N$], [$2^N - 1$],
))

Na *busca*, comparando a chave com a informação do nó raiz, 4 casos podem ocorrer (e os mesmos valem recursivamente para as subárvores):
+ A árvore é vazia $arrow.r$ a chave não está na árvore.
+ Raiz $=$ chave $arrow.r$ achou.
+ Chave $<$ raiz $arrow.r$ a chave pode estar na subárvore esquerda.
+ Chave $>$ raiz $arrow.r$ a chave pode estar na subárvore direita.

A *inserção* e a *remoção* precisam preservar a ordenação: na inserção procura-se o local certo (sempre uma folha); na remoção, um nó com dois filhos é substituído pelo maior da subárvore esquerda (ou pelo menor da direita).

- Complexidade de busca, inserção e remoção: $cal(O)(log_2 n)$ — *desde que a árvore esteja balanceada*.
- *Contra-exemplo:* inserir os elementos 0, 1, 2, ..., 99 nessa ordem produz uma árvore degenerada em lista, com busca $cal(O)(n)$, equivalente ao acesso sequencial.
- Daí a necessidade de *balanceamento*: AVL, rubro-negra, treap, LLRB, etc.

== Hashing

Resumo do que se tem até aqui: acesso sequencial $cal(O)(n)$; busca binária $cal(O)(log n)$, restrita a arranjos ordenados; interpolação $cal(O)(log log n)$, com chaves uniformes; árvores de busca $cal(O)(log n)$ no melhor caso (pior caso equivalente ao sequencial) e AVL $cal(O)(log n)$ sempre. Falta o *acesso em tempo constante*.

#Highlight2("Endereçamento direto vs. hashing")[
  *Endereçamento direto:* cada chave $k$ é mapeada na posição $k$ do arranjo, isto é, $f(k) = k$.
  - *Vantagem:* acesso direto e rápido via indexação do arranjo.
  - *Desvantagem:* uso ineficiente do espaço — seria preciso declarar um arranjo do tamanho da maior chave; com chaves $\{1, 100\}$, sobram 98 posições vazias.

  *Hashing:* acesso direto com endereçamento *indireto*, $h(k) != k$ em geral. Resolve o desperdício de espaço e dá $cal(O)(c)$ em média, independentemente do tamanho do arranjo (idealmente $c = 1$).
]

Também chamado *tabela de espalhamento* ou *de dispersão*. A ideia é particionar um conjunto possivelmente infinito de elementos em um número finito de classes: $B$ classes, de 0 a $B - 1$, chamadas *buckets*. A função $h$ é a *função hash*, $h(k)$ é o *valor hash* de $k$ (usado como endereço para armazenar a informação de chave $k$), e $k$ pertence ao bucket $h(k)$. A função é usada para inserir, remover *e* buscar, e deve ser *determinística*.

#Highlight1("Colisão")[
  Ocorre quando a função hash produz o *mesmo endereço* para chaves diferentes; chaves com o mesmo endereço são *sinônimos*. Distribuição perfeitamente uniforme é muito difícil (depende de cálculos matemáticos e estatísticos complexos); uma função que aparente gerar endereços aleatórios já serve, embora alguns endereços sejam gerados mais de uma vez e outros nunca.

  Segredos de um bom hashing:
  + Escolher uma boa função hash (em função dos dados): distribui uniformemente (*hash uniforme*), evita colisões e é rápida de computar.
  + Estabelecer uma boa estratégia de tratamento de colisões.
]

*Função hash da divisão* — simples e muito usada, com bons resultados: para chaves inteiras, $h(k) = k mod B$, com $B$ o tamanho do espaço de endereçamento, de preferência *primo*. Para strings, trata-se cada caractere como seu valor ASCII, somam-se e toma-se o resto. A ideia por trás do resto é que os endereços sempre caem no intervalo $[0, B-1]$.

#example[
  $B = 7$, inserindo 1, 5, 10, 20, 25, 24:
  ```text
  1 % 7 = 1      5 % 7 = 5      10 % 7 = 3
  20 % 7 = 6     25 % 7 = 4     24 % 7 = 3  -> colisão com o 10

  pos:  0   1    2    3     4    5   6
            1         10,24 25   5   20
  ```
  Com string: $B = 13$, "LOWEL" $= 76+79+87+69+76 = 387$, e $h("LOWEL") = 387 mod 13 = 10$.
]

Outras funções possíveis: examinar as chaves em busca de um padrão; extrair dígitos de uma parte da chave e somá-los; elevar a chave ao quadrado e tomar os dígitos intermediários; extrair a raiz e usar só as casas decimais.

*Fator de carga:* armazenando $n$ elementos numa tabela de $m$ posições, o número esperado de elementos por posição é $alpha = n/m$.

#Highlight1("Tipos de hashing")[
  - *Estático:* o espaço de endereçamento não muda.
    - *Fechado:* armazena um conjunto de tamanho *limitado*, na própria tabela; colisões tratadas por técnicas de *rehash*.
    - *Aberto:* armazena um conjunto potencialmente *ilimitado*; colisões tratadas por *encadeamento*.
  - *Dinâmico:* o espaço de endereçamento pode aumentar (fora do escopo da disciplina).
]

=== Hashing fechado

Os elementos são armazenados na própria tabela de buckets. Se a posição $h(k)$ está ocupada, aplica-se uma técnica de *rehash* sobre $h(k)$, que deve retornar o próximo bucket livre. Uma boa técnica de rehash cobre o máximo de índices entre 0 e $B-1$ e evita agrupamentos de dados; além do índice $h(k)$, pode usar a própria chave $k$ e outras funções hash.

*Overflow progressivo:* $"rehash"(h(k)) = (h(k) + i) mod B$, com $i$ indo de 1 a $B-1$, incrementado a cada tentativa. É a *sondagem linear*, pois no pior caso todas as posições da tabela são checadas.

```text
h(POTTER) = 10, mas o bucket 10 está ocupado por LOWEL
  2ª tentativa: 11 -> ocupado por LENNOI
  3ª tentativa: 12 -> livre, insere POTTER lá
```

*Sondagem quadrática:* $"rehash"(h(k)) = (h(k) + c_1 i + c_2 i^2) mod B$. Considerada melhor que a linear porque evita "mais" o agrupamento, mas não garante encontrar um espaço vazio mesmo que ele exista.

Alternativamente, pode-se juntar função hash e rehash em uma única função dependente do número da tentativa: $h(k, i) = (k + i) mod B$, com $i = 0, ..., B-1$ — para $i = 0$ é a função da divisão tradicional, e para $i >= 1$ já é a sondagem linear.

#Highlight2("Problema da remoção")[
  Como saber que a informação procurada *não* está armazenada? Buscando "SMITH" com $h("SMITH") = 7$, percorre-se 7, 8, 9, 10... até achar ou encontrar uma posição *vazia*. Se o elemento do índice 9 for simplesmente removido, a posição vazia faz a busca parar antes de chegar ao SMITH no índice 10 — falha na busca.

  *Solução:* não eliminar o elemento, mas *marcar* a posição como esvaziada (p. ex. `####`), indicando que ela pode receber um novo elemento mas que a busca deve *continuar*.
]

- *Vantagem:* simplicidade; e sobra mais espaço para a tabela, pois não há ponteiros nem campos extras como no hashing aberto.
- *Desvantagens:* agrupamento de dados causado pelas colisões; com a estrutura cheia, a busca fica lenta; inserções e remoções são difíceis. Com overflow progressivo, após várias inserções e remoções o número de acessos aumenta, e a tabela pode ficar cheia.

*2ª função hash (hash duplo):* usa duas funções, $h(k)$ primária e $h_"aux"(k)$ secundária, com $"rehash"(h(k)) = (h(k) + i dot h_"aux"(k)) mod B$, $i = 1, ..., B-1$. Boas escolhas: $h(k) = k mod B$ e $h_"aux"(k) = 1 + k mod (B-1)$. Evita o agrupamento em geral, mas é difícil achar funções que ao mesmo tempo cubram o máximo de índices e evitem agrupamento, e as operações ficam mais complicadas.

#example[
  Com $B = 10$, $h(k) = k mod 10$ e overflow progressivo, inserir 41, 10, 8, 7, 13, 52, 1, 89, 17:
  ```text
  pos:   0    1    2    3    4    5    6    7    8    9
        10   41    1   13   52   17        7    8   89
  ```
  (1 colide com 41 e vai para 2; 52 colide com 13... e 17 colide com 7, 8, 89 até achar 5.)
]

=== Hashing aberto

A tabela de buckets (0 a $B-1$) contém apenas *ponteiros para listas* de elementos. Quando há colisão, o sinônimo é inserido como um novo nó da lista daquele bucket; a busca percorre a lista.

```text
bucket 2 -> 2 -> 12 -> 32 -> 42
bucket 5 -> 5 -> 15 -> 25
```

- *Vantagens:* a tabela pode receber mais itens mesmo com um bucket já ocupado; permite percorrer a tabela por ordem de valor hash.
- *Desvantagens:* espaço extra para as listas; listas longas gastam muito tempo na busca. Manter as listas *ordenadas* reduz o tempo de busca, ao custo da ordenação.
- *Eficiência:* depende do tamanho das listas e da função hash — poucas colisões implicam listas pequenas.

=== Boas funções hash

#Highlight1("Três funções clássicas")[
  - *Divisão:* $h(k) = k mod m$, com $m$ primo de preferência.
  - *Multiplicação:* $h(k) = floor((k A mod 1) dot m)$, com $A in (0, 1)$ constante, onde $(k A mod 1)$ é a parte fracionária de $k A$. Knuth sugere $A = (sqrt(5) - 1)/2 = 0.6180...$
  - *Hash universal:* a função é escolhida *aleatoriamente no início de cada execução*, de forma a minimizar tendências das chaves. Ex.: $h(k) = ((A k + B) mod P) mod m$, onde $P$ é primo maior que a maior chave, $A$ é sorteado em $\{0, 1, ..., P-1\}$ e $B$ em $\{1, 2, ..., P-1\}$ no início da execução. Diz-se que $h$ representa uma *coleção universal* de funções.
]

*Principal desvantagem do hashing:* os elementos não são armazenados sequencialmente e não existe um método prático para percorrê-los em sequência (ordenada).

== Comparação entre os métodos de busca

#align(center, table(
  columns: 3,
  inset: 6pt,
  align: (left, center, left),
  stroke: 0.5pt + colors.primary,
  table.header([*Método*], [*Busca*], [*Requisitos / observações*]),
  [Sequencial], [$cal(O)(n)$], [Nenhum; vetor ou lista; sentinela e reorganização ajudam],
  [Seq. indexada], [$< cal(O)(n)$], [Tabela ordenada + espaço para os índices],
  [Binária], [$cal(O)(log n)$], [Arranjo ordenado; inserção/remoção caras],
  [Interpolação], [$cal(O)(log log n)$], [Chaves uniformemente distribuídas, senão degrada],
  [ABB], [$cal(O)(log n)$], [Só se balanceada; degenerada vira $cal(O)(n)$],
  [AVL], [$cal(O)(log n)$], [Garantido; custo do rebalanceamento],
  [Hashing], [$cal(O)(1)$ médio], [Boa função hash e tratamento de colisões; não percorre em ordem],
))

Critérios para eleger um método: eficiência da busca; eficiência das *outras* operações (inserção, remoção, listagem e ordenação dos elementos); frequência de cada operação na aplicação; dificuldade de implementação; e consumo de memória interna.
