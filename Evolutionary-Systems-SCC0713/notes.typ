= Algoritmos Evolutivos Aplicados à Robótica

== Algoritmo genético

Baseado na teoria da evolução.

1. *Inicialização* - Inicialize a população de cromossomos
2. *Avaliação* - Avalie cada cromossomo na população
3. *Seleção*, *Crossover* e *Mutação* - Selecione os pais para gerar novos cromossomos. Aplique os
operadores de recombinação e mutação a estes pais de forma a gerar os
indivíduos da nova geração
4. Apague os velhos membros da população
5. Avalie todos os novos cromossomos e insira-os na população
6. Se o tempo acabou, ou o melhor cromossomo satisfaz os
requerimentos e performance, retorne-o, caso contrário volte para o
passo 3).

=== 1. Iniciar população

Definimos quantos indivíduos vai ter.

- `Vetor(Tamanho População) = {Genes1, Genes2, Genes3, ...}`
- `Genes = {Angulo1(float), Angulo2(float), Velocidade(int), FlagSensor1(bool),...}`

=== 2. Avaliação

Depende da aplicação. Pode ser:

- `f(x,y,z,...)`
- Provar Café
- Protótipo
- Simulador

Essa fase é que faz o algoritmo genético ficar pesado.

=== 3. Seleção

Selecionar os melhores, segundo o método de avaliação, para cruzar com outros indivíduos.

Nunca perca o melhor de todos.

==== Roulette Whell Method

Dada uma função de avaliação $F(x)$ para N indivíduos, a probabilidade de avaliação é dada por:

$ "FP"(i) = F_i/(sum_(i=1)^(n=6)F_i) $

```
FP(x1) = 0.2
FP(x2) = 0.45
FP(x3) = 0.05
FP(x4) = 0.1
FP(x5) = 0.12
FP(x6) = 0.08
```

Em seguida, colocamos isso de modo acumulativo, e geramos N números aleatórios entre 0 e 1.

#image("assets/image.png")

Assim, temos os seguintes indivíduos selecionados: 1,1,2,2,5,6. Assim, para a próxima etapa de Crossover, os indivíduos 3,4 foram descartados.

- `NovoVetor(Tamanho Populacao) = [Genes1,Genes1,Genes2,Genes5,Genes6]`

=== 4. Crossover

Serão utilizados apenas indivíduos selecionados.

- *Binário/Símbolo* -> Por sorteio: Sorteia os genes recebidos

```
GATACCAAAAGGGTTTCACACA -> Pai
CCCTTTCCGGGGGCCCGCGCGG -> Mãe
----------------------
GCCTCCAAGGGGGTTCCAGCCA -> Filho
```

- *Inteiro/Float* -> Média de cada par

```
20,40,80 -> Pai
40,80,70 -> Mãe
--------
30,60,50 -> Filho
```

=== Binary Crossover

1. Expressamos os cromossomos (conjunto de genes ou indivíduo) em termos binários (inclusive inteiros). Somente serão utilizados indivíduos selecionados.

2. Utiliza-se o $0<"crossover parameter"<1$. É a probabilidade de um indivíduo ser selecionado para crossover. Selecionamos 2 pais.

3. *Single Point Crossover*: Trocamos o material genético dos 2 pais.

- Filho 1: Início do Pai 1 + Fim do Pai 2
- Filho 2: Início do Pai 2 + Fim do Pai 1

=== 5. Mutação

Cada bit do filho tem uma chance muito pequena de inverter, para evitar que a população fique presa em soluções ruins.

