1) As vantagens são:

- Com formato fixo, a decodificação é mais eficiente
- Como todas as instruções passam pelos mesmos estágios com tempos parecidos, o pipeline fica balanceado. A consequência é que, como todas essas instruções passam por estágios (busca da instrução, decodificação da instrução, operação na ULA, busca/escrita na memória, escrita em bancos de registradores) com tempos parecidos, podemos quebrá-las em estágios menores.

A desvantagem é que uma instrução simples ocupa o mesmo espaço que uma instrução complexa. Isso impacta no consumo de memória.

#divider()

2) Pipeline é um modo de execução de instruções onde dividimos cada instrução em estágios. Assim, ao invés de esperar uma instrução inteira ser executada para poder executar a próxima, executamos um estágio, e quando a instrução atual avançar para o próximo estágio, a próxima instrução entra no estágio liberado.

O pipeline segue a ideia de uma linha de montagem. Ele não acelera a execução das instruções, mas aumenta a quantidade de instruções executadas por segundo. Isso é extremamente importante para o desempenho de um processador, pois maximiza o aproveitamento da arquitetura, sendo mais eficiente do que monociclo e multiciclo.

#divider()

Obs: Latẽncia = tempo total da instrução

Multiciclo:

- Tempo de ciclo/Latência o será o tempo da *instrução* mais lenta (`lw`, ocupa todos os estágios). No multiciclo/pipeline, tempo de ciclo será o tempo do *estágio* mais lento.
- Troughput = 1 instrução por ciclo

Pipeline: 

- Tempo de clock: Estágio mais lento + Registrador - $T_("clk") = max(t_1,t_2,...) + t_"reg"$
- Latência de instrução: Número de estágios vezes clock. $k times T_"clk"$

3)

a)

Monociclo A: 

- Tempo de ciclo: 300 + 400 + 250 + 500 + 100 = 1550 ps
- Latência de uma instrução: 1550 ps (sempre)
- Throughput: 1 instrução por ciclo

Monociclo B: 

- Tempo de ciclo: 200 + 150 + 120 + 190 + 140 = 800 ps
- Latência de uma instrução: 800 ps (sempre)
- Throughput: 1s/800ps = 1 250 000 instruções p/s

b)

Pipeline A:

- Tempo de ciclo: 500 ps + 20 ps = 520 ps (estágio mais lento + registrador)
- Latência de uma instrução: 
    - `beq` (+ rápida) - 3 x 520 ps =  - 1560 ps
    - `lw` (+ lenta) - 5 x 520 ps - 2600 ps
    - Latência: 1560 ps a 2600 ps
- Throughput (ideal, 1 instrução executada por ciclo) - 1s/520ps = 1 923 077 instruções p/s

Pipeline B: 

- Tempo de ciclo: 200 ps + 20 ps = 220 ps (estágio mais lento + registrador)
- Latência de uma instrução: 
    - `beq` (+ rápida) - 3 x 220 ps =  - 660 ps
    - `lw` (+ lenta) - 5 x 220 ps - 1100 ps
    - Latência: 660 ps a 1100 ps
- Throughput (ideal, 1 instrução executada por ciclo) - 1s/220ps = 4 545 454 instruções p/s

c)

Ideia de quebrar um estágio em dois: diminui o tempo de clock.

Quebrar MEM de A: Novo tempo de clock = 400 ps + 20 ps = 420 ps (diminui 100 ps)
Quebrar MEM de B: Novo tempo de clock = 190 ps + 20 ps = 210 ps (diminui 20 ps)

Compensa mais dividir o estágio MEM de A ao meio, pois a vantagem é maior. O novo throughput seria de 1s/420ps = 2 380 953 instruções p/s 

#divider()

Anotação:

- lw - IF, ID, EX, MEM, WB (5 estágios, mais lento)
- sw - IF, ID, EX, MEM (sem WB)
- Tipo R (add, sub, aritméticas/lógicas) - IF, ID, EX, WB (sem MEM)
- beq - IF, ID, EX (3 estágios, a mais rápida)

#divider()

4)

- 50% aritméticas/lógicas - 4 estágios
- 25% beq - 3 estágios
- 15% lw - 5 estágios
- 10% sw - 4 estágios

Taxa de utilização da memória de dados: 15% + 10% = 25%
Taxa de utilização da porta de escrita no banco de registadores: 50% + 15% = 65%

#divider()

- ALUOp:
    - `00` - Soma
    - `01` - Subtração
    - `10` - Depende de func3/func7 (tipo R - add, sub, and, or)
- ALUSrc:
    - `0` - 2° operando vem de rs2
    - `1` - 2° operando vem de imm
- Se RegWrite = 0, MemToReg = X.
- B no Ex/Mem é só usado pelo sw.
- MemToReg
    - `1` - Escreve da memória (LMD)
    - `0` - Escreve ALUOuput

5)

```
beq t1, t2, 4
lw s0, 0(t0)
add s3, s1, s2
sw s4, 0(t0)
addi t1, t1, -4
```

Obs: X = don't care (não é relevante pra nós). Cada instrução anda uma coluna (ciclo) por registrador intermediário. Sem dependências entre elas, logo não há bolhas.

#text(size: 8pt)[
#table(
  columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto, auto),
  inset: 4pt,
  align: horizon,
  table.header(
    [], [*Reg.*], [*CC1*], [*CC2*], [*CC3*], [*CC4*], [*CC5*], [*CC6*], [*CC7*], [*CC8*],
  ),
  table.cell(rowspan: 2)[IF/ID],
  [PC], [0], [4], [8], [12], [16], [], [], [],
  [IR], [beq], [lw], [add], [sw], [addi], [], [], [],
  table.cell(rowspan: 12)[ID/EX],
  [PC], [], [0], [X], [X], [X], [X], [], [],
  [A], [], [(t1)], [#text(fill: red)[X] $arrow.r$ (t0)], [(s1)], [(t0)], [(t1)], [], [],
  [B], [], [(t2)], [#text(fill: red)[(t0)] $arrow.r$ X], [(s2)], [(s4)], [X], [], [],
  [Imm], [], [4], [0], [X], [0], [-4], [], [],
  [rd], [], [X], [s0], [s3], [X], [t1], [], [],
  [ALUOp], [], [01], [00], [10], [00], [#text(fill: red)[10] $arrow.r$ 00], [], [],
  [ALUSrc], [], [0], [1], [0], [1], [1], [], [],
  [MemRead], [], [0], [1], [0], [0], [0], [], [],
  [MemWrite], [], [0], [0], [0], [1], [0], [], [],
  [Branch], [], [1], [0], [0], [0], [0], [], [],
  [RegWrite], [], [0], [1], [1], [0], [1], [], [],
  [MemToReg], [], [X], [1], [0], [X], [0], [], [],
  table.cell(rowspan: 10)[EX/MEM],
  [ALUOutput], [], [], [(t1)-(t2)], [(t0)+0], [(s1)+(s2)], [(t0)+0], [(t1)-4], [],
  [BranchTarget], [], [], [#text(fill: red)[PC+4] $arrow.r$ 4], [X], [X], [X], [X], [],
  [rd], [], [], [X], [s0], [s3], [X], [t1], [],
  [B], [], [], [X], [X], [X], [(s4)], [X], [],
  [zero], [], [], [(t1)-(t2) == 0], [X], [X], [X], [X], [],
  [MemRead], [], [], [0], [1], [0], [0], [0], [],
  [MemWrite], [], [], [0], [0], [0], [1], [0], [],
  [Branch], [], [], [1], [0], [0], [0], [0], [],
  [RegWrite], [], [], [0], [1], [1], [0], [1], [],
  [MemToReg], [], [], [X], [1], [0], [X], [0], [],
  table.cell(rowspan: 5)[MEM/WB],
  [ALUOutput], [], [], [], [X], [X], [(s1)+(s2)], [X], [(t1)-4],
  [LMD], [], [], [], [X], [MEM[(t0)+0]], [X], [X], [X],
  [rd], [], [], [], [X], [s0], [s3], [X], [t1],
  [RegWrite], [], [], [], [0], [1], [1], [0], [1],
  [MemToReg], [], [], [], [X], [1], [0], [X], [0],
)
]

Erros:

- ID/EX, CC3 (lw s0, 0(t0)), A e B invertidos - O registrador base do `lw` é o primeiro operando (A) da ALU.
- ID/EX, CC6 (addi), ALUOp = 10 está errado - addi é tipo I (não R).
- EX/MEM, CC3 (beq), BranchTarget = "PC+4" - Dá pra escrever apenas 4 (0 + 4).

#divider()

#table(
  columns: (auto, auto, auto, auto),
  inset: 6pt,
  align: (center + horizon, left + horizon, left + horizon, left + horizon),
  table.header(
    [*Tipo*], [*Uso*], [*Exemplos*], [*Campos*],
  ),
  [*R*], [registrador–registrador], [`add`, `sub`, `and`, `slt`], [funct7, rs2, rs1, funct3, rd, opcode],
  [*I*], [imediato, loads, `jalr`], [`addi`, `andi`, `lw`, `jalr`], [imm[11:0], rs1, funct3, rd, opcode],
  [*S*], [store], [`sw`, `sb`], [imm[11:5], rs2, rs1, funct3, imm[4:0], opcode],
  [*B*], [desvio condicional], [`beq`, `bne`, `blt`], [imediato embaralhado, rs2, rs1, funct3, opcode],
  [*U*], [imediato alto (20 bits)], [`lui`, `auipc`], [imm[31:12], rd, opcode],
  [*J*], [salto], [`jal`], [imediato de 20 bits embaralhado, rd, opcode],
)

#divider()

- Dependência é quando o dado de uma instrução depende de outra instrução.
    - Verdadeiras: RAW
    - Falsas: WAR, WAW (problema apenas ao escalar)
- Hazard é uma situação na qual a execução do pipeline é impedida de continuar, causando uma parada.


6)

```riscv
I0: div t2, t5, t8
I1: sub t9, t2, t7
I2: sll t5, a0, 2
I3: mul a1, t9, t5
I4: beq t2, a1,100
I5: or t8, t5, t2
```

a) Dependẽncias verdadeiras:

- `t2` em I0, I1: RAW
    - Problema: sem forwarding
    - Em `div`, `t2` só é escrito após 5 estágios (WB). 
    - Em `sub`, a leitura é feita no 2° estágio. Aqui, `div` está no 3° estágio.
    - O pipeline de I1 terá que ficar parado por 3 estágios.

```
I0: IF ID EX MEM WB
I1:    IF ID ID  ID EX -> Fica esperando liberar t2
I2:       IF IF  IF ID -> Só pode usar ID quando liberar
```

OBS: Atrasar um atrasa o resto.

- `t9` em I1, I3: RAW 
- `t5` em I3, I5: RAW
- `a1` em I3, I4: RAW

```
       C1  C2  C3  C4  C5  C6  C7  C8  C9  C10 C11 C12 C13 C14 C15 C16
I0:    IF  ID  EX  MEM WB
I1:        IF  ID  ID  ID  EX  MEM WB                     -> espera t2 (I0)
I2:            IF  IF  IF  ID  EX  MEM WB                               
I3:                        IF  ID  ID  ID  EX  MEM WB     -> espera t9 (I1), t5 (I2)
I4:                            IF  IF  IF  ID  ID  ID  EX  MEM WB   -> espera a1 (I3)
I5:                                        IF  IF  IF  ID  EX  MEM WB   
```

Hazards:

- RAW: `t9` em I1, I3 / `t5` em I3, I5 / `a1` em I3, I4
- WAR: `t5` em I0, I1 / `t8` em I0, I5
- WAW: nenhum
- Controle: `beq` em I4: O I5 é buscado antes do `beq` ser resolvido

b) O processador para 3 vezes. I1: 2 ciclos. I3: 2 ciclos. I4: 2 ciclos. No total, são 16 ciclos. (4 pra encher, 6 pra encerrar, 6 stalls)

c) 

```riscv
I0: div t2, t5, t8
    nop
I1: sub t9, t2, t7
I2: sll t5, a0, 2
nop
nop
I3: mul a1, t9, t5
I4: beq t2, a1,100
I5: or t8, t5, t2
```

```
       C1  C2  C3  C4  C5  C6  C7  C8  C9  C10 C11 C12 C13 C14
I0:    IF  ID  EX  MEM WB
       IF  ID  --  --  --
I1:            IF  ID  EX  MEM WB                -> pega t2 (I0) de MEM
I2:                IF  ID  EX  MEM WB
                       IF  ID  --  --  --
                           IF  ID  --  --  --           
I3:                            IF  ID  EX  MEM WB     -> pega t9 (I1), t5 (I2) de MEM
                                   IF  ID  --  --  -- 
I4:                                    IF  ID  EX  MEM WB   -> pega a1 (I3) de MEM
I5:                                        IF  ID  EX  MEM WB   
```

ERRADO. Todas as instruções são de ULA, não há nenhum lw (EX só espera MEM em lw). O resultado de uma instrução ULA sai do EX e pode ser encaminhado direto para o EX da instrução seguinte.

```riscv
I0: div t2, t5, t8
I1: sub t9, t2, t7
I2: sll t5, a0, 2
I3: mul a1, t9, t5
I4: beq t2, a1,100
I5: or t8, t5, t2
```

```
       C1  C2  C3  C4  C5  C6  C7  C8  C9  C10
I0:    IF  ID  EX  MEM WB
I1:        IF  ID  EX  MEM WB               -> pega t2 (I0) da saída da ULA
I2:            IF  ID  EX  MEM WB         
I3:                IF  ID  EX  MEM WB       -> pega t9 (I1), t5 (I2) da saída da ULA
I4:                    IF  ID  EX  MEM WB   -> pega a1 (I3) da saída da ULA
I5:                        IF  ID  EX  MEM WB   
```

Há 3 tipos de forward:

+ Sem forward (pega do registrador) - `00`
+ Operando da ALU (todos menos lw) - `10`
+ Operando da MEM (lw) - `01`

#divider()


Reserva: Tabela limpa

#text(size: 8pt)[
#table(
  columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto, auto),
  inset: 4pt,
  align: horizon,
  table.header(
    [], [*Reg.*], [*CC1*], [*CC2*], [*CC3*], [*CC4*], [*CC5*], [*CC6*], [*CC7*], [*CC8*],
  ),
  table.cell(rowspan: 2)[IF/ID],
  [PC], [], [], [], [], [], [], [], [],
  [IR], [], [], [], [], [], [], [], [],
  table.cell(rowspan: 12)[ID/EX],
  [PC], [], [], [], [], [], [], [], [],
  [A], [], [], [], [], [], [], [], [],
  [B], [], [], [], [], [], [], [], [],
  [Imm], [], [], [], [], [], [], [], [],
  [rd], [], [], [], [], [], [], [], [],
  [ALUOp], [], [], [], [], [], [], [], [],
  [ALUSrc], [], [], [], [], [], [], [], [],
  [MemRead], [], [], [], [], [], [], [], [],
  [MemWrite], [], [], [], [], [], [], [], [],
  [Branch], [], [], [], [], [], [], [], [],
  [RegWrite], [], [], [], [], [], [], [], [],
  [MemToReg], [], [], [], [], [], [], [], [],
  table.cell(rowspan: 10)[EX/MEM],
  [ALUOutput], [], [], [], [], [], [], [], [],
  [BranchTarget], [], [], [], [], [], [], [], [],
  [rd], [], [], [], [], [], [], [], [],
  [B], [], [], [], [], [], [], [], [],
  [zero], [], [], [], [], [], [], [], [],
  [MemRead], [], [], [], [], [], [], [], [],
  [MemWrite], [], [], [], [], [], [], [], [],
  [Branch], [], [], [], [], [], [], [], [],
  [RegWrite], [], [], [], [], [], [], [], [],
  [MemToReg], [], [], [], [], [], [], [], [],
  table.cell(rowspan: 5)[MEM/WB],
  [ALUOutput], [], [], [], [], [], [], [], [],
  [LMD], [], [], [], [], [], [], [], [],
  [rd], [], [], [], [], [], [], [], [],
  [RegWrite], [], [], [], [], [], [], [], [],
  [MemToReg], [], [], [], [], [], [], [], [],
)
]