1) Nos computadores atuais, existem 3 principais hierarquias de memória: registradores, cache e memória principal. Quanto mais rápido o acesso a uma memória, menor sua capacidade de armazenamento. O custo também influencia, de modo que é mais viável dividir a memória em hierarquias, equilibrando velocidade, custo e armazenamento.

2) Memórias voláteis perdem sua informação quando o dispositivo é desligado. As não voláteis mantém a informação mesmo sem fonte de energia.

3) 

- ROM - Tem conteúdo fixo, gravado na fabricação. Mais barata.
- EPROM - É reprogramável, apagada por UV.
- E2PROM - É reprogramável eletronicamente, a nível de byte. Mais cara.
- FLASH - É reprogramável eletronicamente, a nível de bloco.

4) A memória RAM estática usa flip-flop, com o valor estável enquanto houver energia. A memória RAM dinãmica (DRAM) usa capacitor, de modo que a energia "vaza" com o tempo e precisa ser realimentada periodicamente. Ler também consome o capacitor, e o valor precisa ser reescrito.

5)

Cache L1: 20% hit, 5 ns
Cache L2: 60% hit, 10 ns
Memória principal: 100% hit, 50ns

Tempo médio de acesso: 

- L1: $0.2 dot 5"ns" = 1"ns"$ 
- L2: $0.8 dot 0.6 dot 10"ns" = 4.8"ns"$ (sobra 80% de L1. Disso, 60% vai ser hit)
- Memória Principal: $0.8 dot 0.4 dot 50"ns" = 16"ns"$ (sobra 80% de L1. Disso, 40% vai ser miss)

Tempo médio total: $21.8" ns"$

6) 

- Mais palavras por bloco, menos blocos (localidade espacial): Ideal para dados sequenciais na memória, como vetores, tensores, etc. Mas é ruim para muitos dados pequenos espalhados pela memória, diminuindo a capacidade de cache de agregar mais dados distantes.

- Menos palavras por bloco, muitos blocos (localidade temporal): Ideal para dados espalhados na memória não sequenciais. Mas ruim para dados sequenciais, cuja sequência pode ser cortada, aumentando a taxa de miss.

Sequência de acesso que favorece localidade espacial: 0, 1, 2, 3, 4, ...

Sequência de acesso que favorece localidaded temporal: 0, 5, 10, 15, ...

7)

Memória endereça $2^(32)$ bytes (32 bits). *Uma word tem 4 bytes*.

- Mapeamento direto: Index, WO, BO
- Mapeamento totalmente associativo: Tag, WO, BO
- Mapemaento associativo por conjunto: Tag, Set, WO, BO (k=4)

Obs: Se a word tem 4 bytes, o BO sempre vai ser [11].
Obs: o quantidade de linhas da cache só importa pro mapeamento direto.

a) Cache com 16 words, 1 word por bloco (portanto, 16 linhas)

Obs: 1 word, não precisa de WO.

- Direto: [11111111111111111111111111][1111][11] (tag, index, BO)
- Associativo: [111111111111111111111111111111][11] (tag, BO)
- Conjunto: [1111111111111111111111111111][11][11] (tag, set, BO)

b) Cache com 32 words, 1 word por bloco (portanto, 32 linhas)

Obs: 1 word, não precisa de WO.

- Direto: [1111111111111111111111111][11111][11] (tag, index, BO)
- Associativo: [111111111111111111111111111111][11] (tag, BO)
- Conjunto: [1111111111111111111111111111][11][11] (tag, set, BO)

c) Cache com 64 words, 1 word por bloco (portanto, 64 linhas)

Obs: 1 word, não precisa de WO.

- Direto: [111111111111111111111111][111111][11] (tag, index, BO)
- Associativo: [111111111111111111111111111111][11] (tag, BO)
- Conjunto: [1111111111111111111111111111][11][11] (tag, set, BO)

d) Cache com 128 words, 2 words por bloco (portanto, 64 linhas)

- Direto: [1111111111111111111111][1111111][1][11] (tag, index, WO, BO)
- Associativo: [11111111111111111111111111111][1][11] (tag, WO, BO)
- Conjunto: [111111111111111111111111111][11][1][11] (tag, set, WO, BO)

e) Cache com 128 words, 4 words por bloco (portanto, 32 linhas)

- Direto: [111111111111111111111][1111111][11][11] (tag, index, WO, BO)
- Associativo: [1111111111111111111111111111][11][11] (tag, WO, BO)
- Conjunto: [11111111111111111111111111][11][11][11] (tag, set, WO, BO)

f) Cache com 1024 linhas, 8 words por bloco (portanto, 8192 words)

- Direto: [111111111111111111][111111111][111][11] (tag, index, WO, BO)
- Associativo: [111111111111111111111111111][111][11] (tag, WO, BO)
- Conjunto: [1111111111111111111111111][11][111][11] (tag, set, WO, BO)

g) Cache com 256 linhas, 2 words por bloco (portanto, 512 words)

- Direto: [1111111111111111111111][1111111][1][11] (tag, index, WO, BO)
- Associativo: [11111111111111111111111111111][1][11] (tag, WO, BO)
- Conjunto: [111111111111111111111111111][11][1][11] (tag, set, WO, BO)

8)

a) Cache com 16 words, 1 word por bloco (portanto, 16 linhas)

Obs: 1 word, não precisa de WO.

- Direto: [11111111111111111111111111][1111][11] (tag, index, BO)
- Associativo: [111111111111111111111111111111][11] (tag, BO)
- Conjunto: [1111111111111111111111111111][11][11] (tag, set, BO)

- 2 - Endereço de byte: [00000000000000000000000000][0010][00] - index  = 2 - $2 mod 16 = 2$
- 3 - 3 
- 11 - 11
- 16 - $16 mod 16 = 0$
- 21 - $21 mod 16 = 5$
- 13 - 13
- 64 - $64 mod 16 = 0$
- 48 - $48 mod 16 = 0$
- 19 - $19 mod 16 = 3$
- 11 - 11
- 3 - 3
- 22 - $22 mod 16 = 6$
- 4 - 4
- 27 - $27 mod 16 = 11$
- 6 - 6
- 11 - 11

9) 

Obs: Tag, V, M, LRU, W0, W1

- L1 - Direto, 4 linhas, cada uma com 2 words.
- L2 - 8 conjuntos, 2 linhas cada, cada uma com 2 words.
- L3 - Totalmente associativa, 16 linhas, cada uma com 4 words.
- RAM - 1024 bytes

- Write-back - Escreve na cache e marca M = 1. Bloco volta ao nível inferior quando substituído.
- Write-allocate - Traz bloco para a cache no read-miss e depois escreve nele (write-hit). Bloco é trazido para L1 e vai descendo.

Obs: 

1. A L1 dá miss e pede o bloco à L2.
2. A L2 dá miss e pede à L3.
3. A L3 dá miss e pede à RAM.
4. A RAM manda o bloco para a L3, que guarda uma cópia e repassa para a L2.
5. A L2 guarda uma cópia e repassa para a L1.
6. A L1 recebe o bloco.

Política de Substituição - FIFO

Acessos:

1. Escrita, 72 (decimal)
2. Escrita, 64 (decimal)
3. Escrita, 136 (decimal)
4. Leitura, 36 (decimal)

Conteúdo: Endereço do 1° byte daquela word (o próprio endereço)
Escrita: 1° byte multiplicado por 10.

#set page(columns: 2)
#figure(image("images/1.jpeg", width: 100%))
#figure(image("images/2.jpeg", width: 100%))
#figure(image("images/3.jpeg", width: 100%))