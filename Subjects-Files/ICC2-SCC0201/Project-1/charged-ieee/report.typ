#import "@preview/charged-ieee:0.1.4": ieee
#import "@preview/algo:0.3.6": algo, i, d

#show: ieee.with(
  title: [T1 - Análise de Complexidade de Algoritmos de Ordenação],
  authors: (
    (
      name: "Ariel Alves da Silva",
      department: [Bach. Ciências da Computação - ICMC (USP)],
      location: [8847378],
      email: "arielalves@usp.br"
    ),
  ),
  bibliography: none,
)

= Introdução

O atual relatório consiste na análise de dois algoritmos de ordenação, sendo um deles de complexidade $O(n^2)$ e o outro de complexidade $O(n log n)$ ou superior. Será realizada análise teórica (análise assintótica) e análise empírica, utilizando medições de tempo de execução para 4 diferentes casos de organização e vetores: aleatórios, aleatórios com repetição, ordenados e ordenados de modo decrescente.

Além disso, será realizada uma análise dos resultados de uma tabela de Baseline de algoritmos proposta pelo professor, de modo a avaliar algoritmos desconhecidos e suas peculiaridades.

Esse relatório se divide em 4 partes: definição dos algoritmos utilizados, análise teórica, resultados experimentais, análise experimental, resultados exeperimentais do baseline e análise do baseline.

= Algoritmos utilizados

== Insertion Sort

O insertion sort consiste em ordenar um subarray que começa com tamanho `n=1` e se inicia no primeiro índice, inserindo o elemento imediatamente à direita do subarray dentro do subarray (ordenado) a cada iteração.

#algo(title: [insertionSort])[

  *para* $i$ *de* $1$ *até* $n$ *faça*:#i\
    $"aux" <- A[i]$\
    $j <- i-1$\
    *enquanto* $(j >= 0) and ("aux" < A[j])$ *faça*:#i\
        $A[j+1] <- A[j]$\
        $j <- j-1$#d\
    *fim_enquanto*#i\
      $A[j+1] <- "aux"$#d\
  *fim_para*
]

== Heap Sort na modalidade max_heap

Um vetor $A[1 .. n]$ é um _max\_heap_ se $A[j] >= A[2j]$ e $A[j] >= A[2j+1]$ sempre que os índices não ultrapassam $n$ @max_heap.

O heap sort consiste em organizar os elementos do vetor de modo a construir uma heap. Ao construir a heap, $V[0]$ será o maior elemento do subarray, e será colocado fora da heap (imediatamente após). Fazendo-se isso consecutivamente, o array terminará ordenado.

#algo(title: [heapSort])[
  *para* $i$ *de* $floor(n/2)-1$ *até* $0$ *faça*:#i\
    $"fazHeap"(A, n, i)$#d\
  *fim_para*\

  *para* $i$ *de* $n-1$ *até* $0$ *faça*:#i\
    $"troca"(A[0], A[i])$\
    $"fazHeap"(A, i, 0)$#d\
  *fim_para*
]

O algoritmo fazHeap é simples: se $A[i]$ é maior ou igual que seus filhos então não é preciso fazer nada; senão, troque $A[i]$ com o maior dos filhos e repita o processo para o filho envolvido na troca @max_heap.

#algo(title: [fazHeap], parameters: ("A","n","i",))[
  $L <- 2 dot i + 1$\
  $R <- 2 dot i + 2$\
  $C <- i$\
  *se* $(L < n) and (A[L] < A[C])$: $C <- L$\
  *se* $(R < n) and (A[R] < A[C])$: $C <- R$\
  *se* $(C != i)$:#i\
    $"troca"(A[C], A[i])$\
    $"fazHeap"(A, n, C)$
]

= Análise teórica

== Insertion Sort

No insertion sort, a única condição capaz de interromper o loop interno é a condição _$A[j] <= "aux"$_. Com base nela serão definidos o pior, melhor e caso médio.

=== Pior caso

No pior caso, a condição _$A[j] <= "aux"$_ só é verdadeira na última comparação do loop interno. Assim, o subarray será percorrido por inteiro em todos os loops. A quantidade de comparações total é:

$ sum_(k=1)^(n-1) k = ((n-1)[(n-1) - 1])/2 = (n^2 - 3n + 2)/2 $

E, portanto, a complexidade é $cal(O)(n^2)$.

=== Melhor caso

No melhor caso, a condição _$A[j] <= "aux"$_ sempre é verdadeira na primeira comparação, interrompendo o loop interno o mais cedo possível. Esse caso é sempre válido se, e somente se o array está ordenado.

Como cada loop interno será executado somente uma vez com complexidade $cal(O)(1)$ (apenas uma comparação simples) e o loop externo é executado de $1$ até $n$, a complexidade é linear: $Omega(n)$.

=== Caso médio

Para definir o caso médio, assume-se que para um elemento na posição $i$, em média, metade dos elementos anteriores são maiores do que ele. Portanto, ele precisará recuar $i/2$ posições para encontrar seu lugar correto. Assim, cada loop interno será executado pela metade.

Para a metade de uma iteração ímpar, será considerado o teto da divisão:

$ ("iteração", "operações") = {(1,1),(2,1),(3,2),(4,2),...}"    " $

Assim, por indução infinita, podem-se assumir duas fórmulas para o total de operações:

$ sum_(k=1)^(n-1) ceil(k/2) = cases(
  2 dot (n/2 dot [n/2-1])/2=", n=par",
  2 dot ((n-1)/2 dot [(n-1)/2-1])/2 + ceil(n/2)", n=ímpar",
) $

Onde o termo de maior grau das duas fórmulas é de segundo grau e, portanto, a complexidade no caso médio é $cal(O)(n^2)$.

== Heap Sort

No heap sort, a única condição capaz de reduzir a quantidade de operações é a de $C=i$. Para cada chamada principal de fazHeap(), o máximo de iterações possíveis (por recursão) é $ceil(log_2(n))$, com n sendo o número de elementos.

=== Pior caso

Para o pior caso, será considerado que sempre haverá uma troca ($C!=i$ sempre é válido) para toda chamada da função fazHeap().

No primeiro loop, $i$ vai de $floor(n/2)-1$ até $0$. Para cada iteração, a "árvore parcial" terá $n-i$ elementos. De maneira formal:

$ sum_(k=n)^(n-(floor(n/2)-1)) ceil(log_2(k))  $

Pode-se simplificar o limite superior da somatória para $n/2$ com $n$ par, e retirar a função teto para posibilitar o uso da propriedade de soma de logaritmos.

$ sum_(k=n)^(n/2) log_2(k) = log_2(n dot (n-1) dot ... dot (n/2)) = \
  = log_2(n!/(n/2 -1)!) $ <eq:fat_log>

Aqui, é possível aplicar a aproximação de Stirling @stirling_log para o fatorial , onde $n! ~ sqrt(2 pi n)(n/e)^n$. Desenvolvendo a expressão <eq:fat_log> e descartando coeficientes e termos lineares, tem-se a complexidade do primeiro loop no pior caso: $cal(O)(n log_2 n ) $.

No segundo loop, a lógica segue sendo a mesma, porém com $i$ de $n-1$ até $0$. Isto muda somente os coeficientes e termos da expressão, de modo que a função principal continua sendo $cal(O)(n log_2 n)$.

Portanto, a complexidade do algoritmo no pior caso é $cal(O)(n log_2 n)$.

=== Melhor caso

No melhor caso, o array já se encontra na configuração de _max\_heap_.

Esta configuração faz com que o primeiro loop nunca execute sub-chamadas dentro da função fazHeap ($C=i$ sempre). A complexidade do primeiro loop é $Omega(n)$.

Já no segundo loop, não é possível afirmar o mesmo. Ao tirar a raiz da árvore e colocá-la imediatamente após a heap, a heap é bagunçada e precisa ser reorganizada. Essa reorganização sempre possui um custo proporcional a $n log_2 n$, pois sempre haverão chamadas recursivas (mesmo que em menor quantidade no melhor caso) para a ordenação do array. Assim, não existe array onde o segundo loop possui complexidade linear: Da mesma forma que no estudo no pior caso, sua complexidade é $Omega(n log_2 n)$.

Portanto, a complexidade algorítmica no melhor caso é $Omega(n log_2 n)$.

=== Caso médio

Como a assíntota superior é $cal(O)(n log_2 n)$ e a assíntota inferior é $Omega(n log_2 n)$, conclui-se que no caso médio a complexidade do algoritmo é $Theta(n log_2 n)$.

= Dados Empíricos

Para análise empírica, os algoritmos Insertion Sort e Heap Sort foram escritos em C. Foi utilizada a biblioteca `<time>` para contagem do tempo de execução.

Cada configuração: algoritmo vs tipo de array foi executada 10 vezes e o resultado presente na tabela é a média das dez, de modo a evitar medições incomuns (casos excepcionais captados aleatoriamente que afetam drasticamente o desempenho do algoritmo).

== Tabelas de tempo relativo

Para facilitar a interpretação das tabelas, o algoritmo mais rápido obtém tempo de execução igual a 1 e o mais lento recebe o valor proporcional (ex: se o mais rápido rodou em 10ms e o mais lento em 20ms, o primeiro recebe 1 e o segundo 2), truncados para uma casa decimal. Os dados completos se encontram no apêndice A (@section:apendicis_a).

#figure(
  caption: [Tempo de execução relativo - Array ordenado],
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Insertion Sort], [1],[1],[1],[1],[1],
    [Heap Sort], [18.7], [29.8], [32.43], [38.9], [40.5]
  )
) <tab:execution_time1>

#figure(
  caption: [Tempo de execução relativo - Array decrescente],
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Insertion Sort], [2.7],[8.2],[14.2],[58.9],[106],
    [Heap Sort], [1], [1], [1], [1], [1]
  )
) <tab:execution_time2>

#figure(
  caption: [Tempo de execução relativo - Array aleatório],
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Insertion Sort], [1.4],[3.7],[6.3],[24.4],[44.8],
    [Heap Sort], [1], [1], [1], [1], [1]
  )
) <tab:execution_time3>

#figure(
  caption: [Tempo de execução relativo - Array aleatório com repetição],
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Insertion Sort], [1.3],[3.4],[6.4],[24.2],[46.9],
    [Heap Sort], [1], [1], [1], [1], [1]
  )
) <tab:execution_time4>

== Gráficos de tamanho vs tempo

Os gráficos abaixo são referentes aos mesmos valores das tabelas @tab:execution_sorted, @tab:execution_descendent, @tab:execution_random, @tab:execution_repetition no apêndice A.

Também estão presentes as assíntotas de melhor caso e pior caso para comparação visual. As constantes multiplicativas foram definidas arbitrariamente, por tentativa e erro, até se aproximarem dos limites superiores e inferiores.

=== Insertion Sort

Para o insertion sort, o limite superior é $cal(O)(n^2)$ e o inferior é $Omega(n)$. Foram definidas as seguintes constantes para os limites assintóticos:

- Limite superior: $(2.2 dot 10^(-6)) n^2$
- Limite inferior: $(1 dot 10^(-4)) n $

#figure(
  caption: [Tempo de execução para o Insertion Sort com limites assintóticos],
  image("assets/insertion_sort_limits.png")
) <img:insertion_sort_limits>

=== Heap Sort

Para o heap sort, tanto o limite superior quanto inferior são $Theta(n log_2 n)$. Os limites assintóticos e suas constantes multiplicativas foram definidos como:

- Limite superior: $(2 dot 10^(-5)) dot n log_2 n$
- Limite inferior: $(1 dot 10^(-5)) dot n log_2 n$

#figure(
  caption: [Tempo de execução para o Heap Sort com limites assintóticos],
  image("assets/heap_sort_limits.png")
) <img:heap_sort_limits>

= Análise Empírica

== Tabelas de tempo relativo

As tabelas de tempo relativo apresentaram consistência entre as diferentes categorias, de modo a apontar as vantagens e desvantagens de cada algoritmo.

Para arrays ordenados (@tab:execution_time1), o insertion sort obteve um desempenho superior. Isso já era esperado, uma vez que, na análise teórica dos algoritmos, o array ordenado resulta no melhor caso, uma complexidade linear. O heap sort, mesmo com complexidade não-quadrática, ainda assim sofreu com arrays ordenados, o que também era esperado: montar uma heap "bagunça" o vetor já consolidado para ordenar novamente.

Isso mostra a fraqueza do heap sort: apesar de ter limites assintóticos bem restritos, não há vantagem no caso trivial. Uma solução simples seria verificar se o array já está ordenado, operação que tem complexidade $cal(O)(n)$.

Para arrays decrescentes (@tab:execution_time2), o heap sort foi superior em todos os casos. O insertion sort se mostrou muito distante do desempenho do heap sort para $n >= 1000$. Para $n=100,500$, a diferença ainda assim é significativa, mas pequena comparada a quando $n$ começa a ficar muito grande.

Para arrays aleatórios (@tab:execution_time3) e arrays aleatórios com repetição (@tab:execution_time4), o resultado foi similar. Nota-se um contraste interessante: para $n = 100$, o insertion sort é praticamente equivalente ao heap sort, com pouca diferença. Essa diferença cresce gradualmente e se mantém "baixa" até $n=1000$. A partir de $n=1000$ o tempo de execução aumenta drasticamente, e o insertion sort se torna uma péssima opção de ordenação em comparação ao heap sort.

É difícil afirmar sobre qual dos dois tipos de array o insertion sort leva vantagem. Nos dois primeiros tamanhos, o insertion sort possui melhor desempenho no array aleatório com repetição. Já nos dois tamanhos seguintes, o desempenho noarray aleatório comum é o melhor. Além disso, os desempenhos estão próximos. Pode-se afirmar que não há diferença significativa, para o insertion sort, no fato de haver repetição ou não no array.

As tabelas contrastam e afirmam as curvas assintóticas definidas anteriormente. O insertion sort tem melhor desempenho em arrays ordenados. Para arrays aleatórios, sejam com repetição ou sem, o insertion sort só consegue competir com o heap sort em valores $n <= 500$. Para array decrescente ocorre o mesmo, mas o limite de tamanho tolerável é menor. Também é notável o fato do heap sort ter dificuldade em lidar com arrays ordenados.

== Gráficos de tamanho vs tempo

== Insertion Sort

No gráfico do insertion sort, há um contraste interessante. O melhor e pior casos propostos teoricamente são evidenciados aqui por uma grande diferença de comportamento.

Para arrays ordenados, o limite inferior é uma função linear com coeficiente baixíssimo, o que denota uma grande eficácia do insertion sort nesse tipo de vetor.

Para arrays decrescentes, o limite superior já tem uma disparidade muito grande, principalmente pelo fato de ser quadrático. É possível ver que o limite superior é adequado para o algoritmo: o pior caso (array descendente) comeca próximo do limite superior mas se afasta conforme $n$ cresce. Isso mostra graficamente que o limite superior quadrático é, de fato, uma assíntota para a função e é válido para $n -> infinity$ (por análise gráfica).

Para arrays aleatórios, é possível ver uma leve diferença de desempenho para $n=10000$, onde o insertion sort encontra maior dificuldade com arrays aleatórios com repetição. Isto faz sentido para o modo como o algoritmo foi feito: o loop interno somente é interrompido se o item comparado for *menor* que o item a ser inserido. Assim, se houverem vários números iguais ao novo item, o loop interno percorrerá a todos antes de inseri-lo. Nesse caso, a correção é simples: basta estabelecer uma verificação de *menor ou igual* (o que também faz com que o algoritmo passe a ser estável). É um indicativo de erro de lógica básica no código que se desenvolve em um problema real de complexidade.

== Heap Sort

No gráfico do heap sort, nota-se uma consistência: todos os pontos tiveram o mesmo comportamento de função. Isso confirma a análise teórica de limite superior e inferior denotados pela mesma complexidade.

Apesar de os limites superior e inferior serem definidos pela mesma função principal, eles conseguem envolver adequadamente os quatro casos de array: aproximam-se dos pontos para $n$ pequeno e distanciam-se para $n$ grande. Esse comportamento atesta a validade das assíntotas para $n -> infinity$ (por análise gráfica).

É possível ver que as curvas de complexidade para tipos de vetores se agruparam em duplas.

A primeira dupla é a de arrays ordenados e arrays decrescentes. Os dois apresentaram um desempenho muito similar, o que é curioso, dada tamanha distinção entre os dois. Assim, apesar de lidar mal com arrays ordenados em comparação ao insertion sort, o heap sort tem uma organização a tal ponto de tornar a ordenação de arrays decrescentes mais rápida do que a ordenação de arrays aleatórios comuns.

A segunda dupla é a de arrays aleatórios e aleatórios com repetição. Os dois também apresentaram um desempenho muito similar, com os arrays aleatórios sem repetição apresentando uma menor complexidade, assim como no insertion sort.

= Dados empíricos (baseline)

Os dados a seguir são de algoritmos desconhecidos, fornecidos pelo professor.

#figure(
  caption: [Tempo de execução (ms) - Array Ordenado],
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Alg A], [0.199],[10.47],[37.50],[1177.1],[4997.5],
    [Alg B], [0.199], [2.294], [3.787], [15.36], [36.48],
    [Alg C], [45.61], [187.79], [392.4], [1999.0], [3886.4],
    [Alg D], [0.0], [1.563], [3.124], [17.277], [40.779]
  )
) <tab:execution_time1_baseline>

#figure(
  caption: [Tempo de execução (ms) - Array Decrescente],
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Alg A], [0.497],[10.47],[60.94],[1379.2],[5752.4],
    [Alg B], [0.194],[1.599],[3.586],[22.54],[32.71],
    [Alg C], [39.89],[218.8],[397.8],[2032.3],[4234.9],
    [Alg D], [0.0],[1.577],[3.13],[14.105],[41.129],
  )
) <tab:execution_time2_baseline>

#figure(
  caption: [Tempo de execução (ms) - Array Aleatorizado],
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Alg A], [0.0],[9.375],[57.25],[1440.5],[5479.5],
    [Alg B], [0.199],[1.395],[2.991],[16.45],[34.61],
    [Alg C], [40.17],[194.2],[404.0],[2071.7],[4153.1],
    [Alg D], [0.0],[1.563],[3.16],[15.738],[37.591]
  )
) <tab:execution_time3_baseline>

#figure(
  caption: [Tempo de execução (ms) - Array Aleatorizado com Repetição],
  table(
    // Table styling is not mandated by the IEEE. Feel free to adjust these
    // settings and potentially move them into a set rule.
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Alg A], [0.595],[13.76],[47.07],[1242.4],[5286.8],
    [Alg B], [0.299],[1.594],[3.972],[16.06],[32.99],
    [Alg C], [43.18],[200.5],[375.5],[2080.7],[4132.3],
    [Alg D], [0.0],[1.560],[3.126],[15.698],[31.393],
  )
) <tab:execution_time4_baseline>

= Análise Empírica (baseline)

== Array ordenado
Para o array ordenado, houveram resultados bem variados entre os quatro algoritmos.

O melhor algoritmo para $n in [100,1000]$ é Alg D, e o segundo melhor, Alg B. Mas, para $n >= 5000$, os papéis se invertem: Alg B passa a ser o melhor e Alg D passa a ser o pior. Isso mostra que, para arrays ordenados, Alg D é o melhor se o tamanho for pequeno, e Alg B se destaca em arrays grandes.

O Alg A inicia com uma complexidade muito competitiva para $n=100$, mas a complexidade piora cada vez mais a partir de $n=500$. O mesmo ocorre para Alg C, que inicia com tempos de execução muito maiores que Alg A, mas começa a ganhar de Alg A em $n=10000$. Disto, conclui-se que Alg A é melhor que Alg C para arrays pequenos, mas Alg C é melhor que Alg A para arrays grandes. Porém, ainda assim, possuem uma eficiência muito ruim comparados a Alg B e Alg D.

Para este caso em específico, Alg A e Alg C aparentam ter complexidade muito maior que Alg B e Alg D, que, possuem melhor desempenho para qualquer $n$, exceto em casos específicos para $n$ pequeno.

== Array decrescente

Para o array decrescente, os comportamentos continuam similares, com exceção de que o Alg B necessita de uma quantidade maior de entradas para superar o Alg D, o que mostra uma dificuldade do Alg B lidar com arrays em ordem inversa.

== Array Aleatorizado

No array aleatorizado, fica mais evidente que Alg C é uma melhor opção para $n$ grande comparado a Alg A, enquanto Alg A é bem mais eficiente para $n$ pequeno.

É válido notar que Alg A atingiu a marca de $0.0$ ms para $n=100$, junto com Alg D, o que mostra que os dois lidam muito bem com arrays pequenos nessa situação.

Alg B e Alg D ficam próximos em desempenho, alternando entre si na primeira e segunda posição de algoritmos mais eficientes. É difícil dizer qual dos dois é melhor para $n$ pequeno e grande.

== Array Aleatorizado com Repetição

Alg A e Alg C mantiveram o mesmo comportamento do Array Aleatorizado. Alg D mostra ter um desempenho melhor que Alg B para todo $n$.

== Conclusão

Os algoritmos A e C são descartáveis, uma vez que possuem desempenho ruim em todos os casos, exceto em casos específicos, como em $n=100$ para Alg A em arrays aleatorizados, mas tal marco também é alcançado por Alg D. Os algoritmos A e C possuem uma complexidade muito maior do que os algoritmos B e D (podendo inclusive ser quadrática), fato visível quando $n=1000$ e o custo de Alg B e Alg D é cerca de 100 vezes menor.

Já quanto aos algoritmos B e D, a escolha do algoritmo depende do caso. Tanto no array crescente quanto no decrescente Alg B possui melhor desempenho para $n -> infinity$, enquanto Alg D possui melhor desempenho para $n$ pequeno. Nos arrays aleatorizados e aleatorizados com repetição, o desempenho dos dois é similar, mas Alg B sempre começa ligeiramente pior em $n=100$ do que Alg D.

Esse comportamento de começar mal e melhorar depois é característico de assíntotas que se interceptam, como $cal(O)(n)$ com coeficiente grande e $cal(O)(n^2)$ com coeficiente pequeno. Isso mostra que, se Alg B possui melhor desempenho para $n -> infinity$, então a complexidade de Alg B é menor que a Alg D. A escolha entre Alg B e Alg D dependerá do uso, com ambos possuindo vantagens e desvantagens.

= Dificuldades enfrentadas

Não houveram dificuldades significativas no trabalho.

#bibliography("refs.bib")

#pagebreak()

= Apêndice A: Tempo de Execução (ms) dos algoritmos escolhidos <section:apendicis_a>

#figure(
  caption: [Tempo de execução (ms) - Array ordenado],
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Insertion Sort], [0.001], [0.003], [0.004], [0.022], [0.045],
    [Heap Sort],      [0.014], [0.100], [0.143], [0.858], [1.833]
  )
) <tab:execution_sorted>

#figure(
  caption: [Tempo de execução (ms) - Array decrescente],
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Insertion Sort], [0.030], [0.718], [1.890], [48.34], [198.61],
    [Heap Sort],      [0.011], [0.088], [0.133], [0.821], [1.804]
  )
) <tab:execution_descendent>

#figure(
  caption: [Tempo de execução (ms) - Array aleatório],
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Insertion Sort], [0.018], [0.280], [0.968], [24.13], [98.03],
    [Heap Sort],      [0.013], [0.075], [0.153], [0.989], [2.187]
  )
) <tab:execution_random>

#figure(
  caption: [Tempo de execução (ms) - Array aleatório com repetição],
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center, center),
    inset: (x: 8pt, y: 4pt),
    stroke: (x, y) => if y <= 1 { (top: 0.5pt) },
    fill: (x, y) => if y > 0 and calc.rem(y, 2) == 0  { rgb("#efefef") },

    table.header[Algoritmo][n=100][n=500][n=1000][n=5000][n=10000],
    [Insertion Sort], [0.016], [0.224], [0.989], [23.93], [105.60],
    [Heap Sort],      [0.013], [0.066], [0.154], [0.987], [2.250]
  )
) <tab:execution_repetition>
