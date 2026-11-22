#import "../lib.typ": *
#set par(justify: true, leading: 0.65em)

= Primeira Parte

== Arquitetura de Von-Neumann

Design de computador onde as instruções e dados são armazenados no mesmo espaço de memória. Os componentes são:

- CPU (CU + ALU)
- Registradores armazenados na CPU
- Dispositivos I/O operados pela CU
- Memória

=== CPU

#set align(center)
#image("./images/image-1.png", width: 60%)
#set align(left)

- *CU (Control Unit)* - Gerencia como o processador funciona mandando sinais de controle (0/1) ao decodificar instruções.
- *ALU (Arithmetic and Logic Unit)* - Parte da CPU que lida com cálculos. Performa adição, subtração e operações lógicas, como comparações e deslocamento de bits em dados.

=== Registers

Tipo mais rápido de memória localizado na CPU.

- *PC (Program Counter)* - Endereço da próxima instrução a ser executada
- *IR (Instruction Register)* - Mantém a instrução atual sendo executada
- *MAR (Memory Address Register)* - Armazena o endereço da localização de memória sendo acessada
- *MDR (Memory Data Register)* - Armazena dados transferidos da/para a memória
- *Accumulator* - Armazena resultados intermediários de aritmética e operações lógicas
- *General Purpose Registers* - Uso para armazenamento temporário de dados

=== Bus

Sistema de comunicação que transfere dados, endereços, e sinais de controle entre a CPU, memória e dispositivos I/O. Na arquitetura de Von Neumann, um único bus é compartilhado para ambos dados e instruções.

== Ciclo de instrução

Dois passos:
- Ciclo de busca (fetch)
- Ciclo de execução (execute)

=== Ciclo de busca

- PC tem endereço da próxima instrução
- Processador busca instrução na posição de memória armazenada no PC
  - MAR = PC
  - MBR = memória(MAR)
- PC = PC+4 (exceto em branch)
- Instrução armazenada no IR - IR = MBR

=== Ciclo de execução

- CU decodifica instrução e define sinais de controle
- Execução da instrução se resume a uma das seguintes possibilidades:
  - *Processador-memória*: Transferir dados do processador para a memória ou vice-versa
  - *Processador-I/O*: Transferir dados entre processador e dispositivo I/O
  - *Processamento de dados*: Executar operações aritméticas/lógicas sobre os dados
  - *Controle*: Especifica que a sequência de execução de instruções seja alterada
  - *Combinação dessas 4 possibilidades*

== Arquitetura RISC-V

- Arquitetura de 32 bits
- 32 registradores de propósito geral
- 32 registradores para float

=== Compilando .asm

1. `sudo apt install nasm`
2. `sudo apt install binutils`
3. `nasm -f elf64 file.asm -o file.o` (monta arquivo)
4. `ld file.o -o file` (cria executável)

=== Estrutura de código

- `.data` - Início da seção de dados estáticos
- `.text` - Início da seção de código
- `.global label` - Entry point. Permite que outros arquivos chamem essa função durante o processo de link.

=== Diretivas

- `.align n` - Alinha a memória em $2^n$ bytes. Força o próximo dado/instrução a começar em um endereço de memória alinhado, utilizando padding.
  - `n = 0` para strings.
  - `n = 2` para instruções.
- `label: .asciz "str"` - Guarda string e encerra ela com `\0`
- `label: .byte b1,...,bn` - Reserva e inicializa cada byte sequencialmente.
- `label: .word w1,...,wn` - Reserva e inicializa cada word sequencialmente.
- `label: .double d1,...,dn` - Reserva e inicializa cada double sequencialmente.
- `label: .space n` - Reserva $n$ bytes

=== Registradores

- `ra` - Return address
- `sp` - Stack pointer
- `t0-t6` - Temporary
- `a0-a6` - Function arguments
- `a7` - Syscall register
- `s0-s11` - Saved values

=== Comandos

_Referência: #link("https://projectf.io/posts/riscv-cheat-sheet/")[Risc-V Cheat Sheet]_

*Aritmética*
- `add rd, rs1, rs2` - `rd = rs1 + rs2` (2 registradores)
- `addi rd, rs1, imm` - `rd = rs1 + imm` (1 registrador, 1 valor imediato/constante)
- `sub rd, rs1, rs2` - `rd = rs1 - rs2`
- `mul rd, rs1, rs2` - `rd = rs1 * rs2`
- `div rd, rs1, rs2` - `rd = rs1 / rs2`
- `rem rd, rs1, rs2` - `rd = rs1 % rs2`
- `remu rd, rs1, rs2` - `rd = rs1 % rs2` (unsigned remainder)
- `xor rd, rs1, rs2` - `rd = rs1 xor rs2`

*Load/Store*
- `la rd, label` - `rd = label_addr`
- `lw rd, imm(rs1)` - `rd = mem[rs1+imm]` (word = 4 bytes)
- `lb rd, imm(rs1)` - `rd = mem[rs1+imm]` (byte)
- `sw rs2, imm(rs1)` - `mem[rs1+imm] = rs2`
- `sb rs2, imm(rs1)` - `mem[rs1+imm] = rs2`

*Jump/Function*
- `j label` - `pc += label` (Obs: Usa half-words para pular. `jmp 4` -> `pc += 4 * 2 bytes`)
- `jal rd, label` - `rd = pc+4; pc += label` (salva endereço de retorno)
- `jr ra` - `pc = ra`
- `call symbol` - `ra = pc+4; pc = &symbol`
- `ret` - `pc = ra`

*Branch (imm pode também ser um label)*
- `beq rs1, rs2, imm` - `if(rs1 == rs2) pc += imm`
- `bne rs1, rs2, imm` - `if(rs1 != rs2) pc += imm`
- `blt rs1, rs2, imm` - `if(rs1 < rs2) pc += imm`
- `ble rs1, rs2, imm` - `if(rs1 <= rs2) pc += imm`
- `bgt rs1, rs2, imm` - `if(rs1 > rs2) pc += imm`
- `bge rs1, rs2, imm` - `if(rs1 >= rs2) pc += imm`
- `bnez rs1, imm` - `if(rs1 != 0) pc += imm`

*Comparadores*
- `slt rd, rs1, rs2` - `rd = (rs1 < rs2)`
- `slti rd, rs1, imm` - `rd = (rs1 < imm)`

=== Ecalls

- `a7` - Armazena número da ecall
- `ecall` - Chama a ecall

#set align(center)
#image("./images/image-2.png", width: 90%)
#set align(left)

=== Alocando na stack

*Empilhando*
- `addi sp, sp, -8` - Reserva 8 words
- `sw a0, 4(sp)` - Salva `a0` na stack (sp+4)
- `sw ra, 0(sp)` - Salva `ra` na stack (sp)

*Desempilhando*
- `lw a0, 4(sp)`
- `lw ra, 0(sp)`
- `addi sp, sp, 8`

=== Instruction Set Architecture

Modelo abstrato que define a interface programável da CPU do computador, definindo como o software interage com o hardware. Um dispositivo que interpreta as instruções descritas por uma ISA é uma implementação da ISA.

- Quantidade e função dos registradores
- Formato das instruções (6 tipos)

=== Formato das instruções (6 tipos)

#set align(center)
#image("./images/image-3.png", width: 80%)
#set align(left)

==== Tipo R (register)
Operações matemáticas e lógicas: `add`, `sub`, `and`, `or`, `sll`
- `opcode` - Código da operação
- `rd` - Endereço do registrador destino
- `funct3` - Auxílio para definição da operação
- `rs1` - Endereço do primeiro registrador de origem
- `rs2` - Endereço do segundo registrador de origem
- `funct7` - Auxílio para definição da operação

Ex: `add rd1, rs1, rs2` -> `0000000 01000 01001 000 10010 0110011`

==== Tipo I (immediate)
Operações aritméticas com constantes ou instruções de leitura da memória: `addi`, `lw`, `andi`, `jalr`
- `opcode` - Código da operação
- `rd` - Endereço do registrador destino
- `funct3` - Auxílio para definição da operação
- `rs1` - Endereço do primeiro registrador de origem
- `imm` - Valor imediato

Ex: `lw s2, 0(sp)` -> `000000000000 00010 010 10010 0000011`

==== Tipo S (Store)
Escrever dados de um registrador para a memória: `sw`
- `opcode` - Código da operação
- `imm[4:0]` e `imm[11:5]` - Valor imediato (Separa os bits)
- `funct3` - Auxílio para definição da operação
- `rs1` - Endereço do primeiro registrador de origem
- `rs2` - Endereço do segundo registrador de origem

Ex: `sw s2, 0(sp)` -> `00000000 10010 00010 010 00000 0100011`

==== Tipo B (branch)
Desvios condicionais: `beq`, `bne`, etc
- `opcode` - Código da operação
- `imm[4:0]`, `imm[11]`, `imm[11:5]`, `imm[12]` - Valor imediato
- `funct3` - Auxílio para definição da operação
- `rs1` - Endereço do primeiro registrador de origem
- `rs2` - Endereço do segundo registrador de origem

Ex: `beq s1, s0, 4` -> `0 000000 01000 01001 000 0100 0 1100011`

==== Tipo U (Upper immediate)
Carregar números muito grandes diretamente nos bits superiores de um registrador: `lui`, `auipc`
- `opcode` - Código da operação
- `rd` - Endereço do registrador destino
- `imm[31:12]` - Valor imediato

Ex: `lui s0, 0x01234` -> `[0000 0001 0010 0011 0100] 01000 0110111`

==== Tipo J
Pulos incondicionais de longo alcance (chamadas de função e desvios obrigatórios): `jal`
- `opcode` - Código da operação
- `rd` - Endereço do registrador destino
- `imm[20]`, `imm[10:1]`, `imm[11]`, `imm[19:12]` - Valor imediato

Ex: `jal s0, -4` -> `1 1111111100 1 11111111 01000 1101111`

== Monociclo (RISC-V)

A instrução é executada em um único ciclo de clock. Final de ciclo: tudo o que está nas conexões (linhas) é salvo nos registradores.

Componentes: PC, Banco registradores, ULA, UC, Memória, I/O.

Conjunto reduzido de instruções:
- Tipo R: `add`, `sub`, `and`, `or`
- Tipo I: `lw`
- Tipo S: `sw`
- Tipo B: `beq`

=== Metodologia de Clocking

Quaisquer valores armazenados em um elemento lógico sequencial são atualizados apenas em uma transição de clock: `State 1 -> Combinational Logic -> State 2`, em apenas 1 ciclo de clock.

=== Componentes

==== Arquitetura do banco de registradores
*READ*
1. 32 registradores
2. A saída de cada registrador vai para 2 MUX (saída duplicada)
3. 5 bits entram no Select do primeiro MUX -> Read Register 1 (5 bits)
4. 5 bits entram no Select do segundo MUX -> Read Register 2 (5 bits)
5. Saída do primeiro MUX -> Read Data 1 (32 bits)
6. Saída do segundo MUX -> Read Data 2 (32 bits)

*WRITE*
1. 32 registradores
2. Entrada Write Register (5 bits)
3. Entrada Write Data (32 bits)

#set align(center)
#image("./images/image-4.png", width: 100%)
#set align(left)

==== Arquitetura da ALU
1. Recebe 2 entradas (32 bits)
2. Devolve saída (32 bits)

#set align(center)
#image("./images/image-5.png", width: 30%)
#set align(left)

==== Arquitetura de operações com memória
*Mem. Instrução:*
1. Recebe endereço do PC (32 bits)
2. Devolve instrução (32 bits)

#set align(center)
#image("./images/image-6.png", width: 30%)
#set align(left)

*Mem. Dados:*
1. Recebe endereço da ULA (32 bits) -> Devolve Read Data (32 bits)
_ou_
1. Recebe endereço (32 bits) -> Escreve Write Data (32 bits)

#set align(center)
#image("./images/image-7.png", width: 30%)
#set align(left)

=== Execução de instruções

==== Execução das instruções tipo R
- Leitura de dois registradores
- Realização de operação aritmética/lógica
- Escrita do resultado no registrador

#set align(center)
#image("./images/image-8.png", width: 70%)
#set align(left)

==== Execução de load/store

- *Load*: Leitura de registrador origem e valor imediato
	- Calcula endereço usando deslocamento de 12 bits (usa ALU)
	- Lê a memória e atualiza o registrador destino.
- *Store*: Leitura de dois registradores origem e valor imediato
	- Calcula endereço usando deslocamento de 12 bits (usa ALU)
	- Escreve o valor do registrador na memória.

#set align(center)
#image("./images/image-9.png", width: 70%)
#set align(left)

==== Execução de Branch

- Leitura de registradores
- Comparação dos dois através da ALU (se forem iguais, `zero = 1`)
- Endereço destino = PC + offset

#set align(center)
#image("./images/image-10.png", width: 70%)
#set align(left)

=== Arquitetura completa

#set align(center)
#image("./images/image-11.png", width: 100%)
#set align(left)

=== Tabelas e Blocos Auxiliares

#set align(center)
#figure(image("./images/image-12.png", width: 80%))
#figure(image("./images/image-13.png", width: 80%))
#figure(image("./images/image-14.png", width: 80%))
#set align(left)

== Notas avulsas

=== -4 em binário (20 bits)

Ao invés de usar bit de sinal, podemos usar complemento de dois: Inverte e soma 1.

```text
00000000000000000100 -> 4
11111111111111111011 -> Complemento
+                  1
--------------------
11111111111111111100 -> -4
```

=== Formato de números inteiros

- 1 bit de sinal, 15 bits de magnitude.

= Revisão de Lógica digital

== Circuitos combinacionais e sequenciais

- Circuitos combinacionais - Função apenas de sinais de entrada.
- Circuitos sequenciais - Sinal de saída depende dos sinais anteriores de saída.

== Identidades básicas

#set align(center)
#image("./images/image-15.png", width: 90%)
#set align(left)

== Mapas de Karnaugh

Bits em ordem de Gray code (apenas 1 bit muda de estado a cada incremento/decremento).

Soma de produtos: Agrupar 1s em clusters de 1, 2, 4, 8, ...

#set align(center)
#image("./images/image-16.png", width: 70%)
#set align(left)

== Principais circuitos

- Half Adder - 2 entradas, 1 saída, 1 Cout.
- Full Adder - 2 entradas, 1 Cin, 1 saída, 1 Cout.
- Demux - Entrada de $n$ bits, saída de $2^n$ bits. Somente uma saída é ativada para cada combinação de entradas.
- Mux - Até $2^n$ entradas e $n$ valores seletores. Direciona uma das entradas para a saída.

== Flip Flops

São circuitos sequenciais.

=== Flip-Flop S-R

- Duas entradas: $S$ (set) e $R$ (reset)
- Duas saídas: $Q$ e $bar(Q)$
- $S=R=1$ deve ser evitada. Resolve-se com flip-flop de entrada única (Flip-Flop D).

=== Flip-Flop J-K

- $J=K=0$ - Mantém
- $J=1, K=0$ - Saída = 1
- $J=0, K=1$ - Saída = 0
- $J=K=1$ - Inverte

== Registradores

Exemplo de uso de flip-flops.

- Registradores paralelos - Carregamento e descarregamento feito simultaneamente.
- Registradores de deslocamento - Transfere informações serialmente. Uso em I/O e também dentro da ALU (deslocamento lógico e rotação).
- Contadores - Registrador cujo valor é incrementado de 1 módulo a capacidade do registrador.

= Segunda Parte

== Multiciclo

Desvantagem do monociclo: o ciclo de clock tem que ser do tamanho da instrução *mais lenta* (ex: multiplicação de ponto flutuante), então instruções rápidas desperdiçam tempo.

Solução (multiciclo): quebrar a instrução em passos, *1 passo = 1 ciclo* (clock menor). Etapas: IF, ID, EX, MEM, WB. Nem todas as instruções usam o mesmo número de ciclos (CPI variável). Uma instrução só começa quando a anterior termina.

#figure(image("./images/image-17.png", width: 100%))

== Pipeline

Divide a instrução em estágios (1 estágio = 1 ciclo) e *sobrepõe* estágios de instruções diferentes no mesmo ciclo. Ideia de linha de montagem (lavanderia).

=== Estágios

#table(
  columns: (auto, auto, auto),
  inset: 5pt,
  table.header([*Estágio*], [*O que faz*], [*Unidade*]),
  [IF - Instruction Fetch], [Busca a instrução, PC + 4], [Mem. Instrução],
  [ID - Instruction Decode], [Decodifica e lê registradores], [UC / Banco Reg.],
  [EX - Execute], [Executa a operação ou calcula endereço], [ULA],
  [MEM - Memory Access], [Lê/escreve na memória de dados], [Mem. Dados],
  [WB - Write Back], [Escreve o resultado no registrador], [Banco Reg.],
)

- `lw` é a instrução mais longa (usa os 5 estágios).
- ID e WB acessam o banco de registradores: *escrita na 1ª metade do ciclo (WB), leitura na 2ª metade (ID)*. Por isso uma instrução em WB e outra em ID no mesmo ciclo não conflitam.

#figure(image("./images/image-18.png", width: 100%))

=== Considerações

- Não diminui o tempo de cada instrução (latência), mas *aumenta o throughput*.
- A taxa do pipeline é limitada pelo *estágio mais lento*.
- Speedup potencial = n° de estágios. O tempo para "encher" e "esvaziar" o pipeline diminui o speedup.
- O pipeline trava se houver dependências (hazards).

=== Comparação: Monociclo x Multiciclo x Pipeline

Obs: CPI = clocks per instruction; IPC = instructions per clock.

Para $n$ instruções em um pipeline de $k$ estágios: $"ciclos" = k + (n - 1)$.

Exemplo com 100 instruções:

- *Monociclo*: $45 "ns" dot 1 "CPI" dot 100 = 4500 "ns"$
- *Multiciclo*: $10 "ns" dot 4.2 "CPI" dot 100 = 4200 "ns"$
- *Pipeline (5 estágios)*: $10 "ns" dot (100 + 4) = 1040 "ns"$ (os 4 ciclos extras são para encher/esvaziar o pipeline)

=== Registradores intermediários do pipeline

Ficam entre os estágios e guardam tudo o que a instrução precisa nos estágios seguintes.

#figure(image("./images/image-19.png", width: 100%))

#figure(image("./images/image-20.png", width: 100%))

#table(
  columns: (auto, auto, auto, auto),
  inset: 5pt,
  table.header([*IF/ID*], [*ID/EX*], [*EX/MEM*], [*MEM/WB*]),
  [PC, IR], [PC, A, B, Imm, rd], [ALUOutput, BranchTarget, B, rd, zero], [ALUOutput, LMD, rd],
)

- A, B = conteúdo de rs1, rs2. LMD = Load Memory Data (dado lido da memória).

#figure(image("./images/image-21.png", width: 100%))

=== Sinais de controle

Gerados no ID e "viajam" pelos registradores intermediários. Cada estágio consome os seus e repassa o resto.

#table(
  columns: (auto, auto, auto, auto),
  inset: 5pt,
  table.header([*Usado em*], [*EX*], [*MEM*], [*WB*]),
  [Sinais], [ALUOp, ALUSrc], [MemRead, MemWrite, Branch], [RegWrite, MemToReg],
)

- ID/EX carrega todos (EX + MEM + WB); EX/MEM carrega MEM + WB; MEM/WB carrega só WB.
- *ALUOp*: `00` = soma (lw/sw), `01` = subtração (beq), `10` = depende de funct3/funct7 (tipo R).
- *ALUSrc*: `0` = 2º operando vem do registrador; `1` = vem do imediato.
- *MemToReg*: `1` = escreve no registrador o dado da memória (LMD); `0` = escreve ALUOutput.
- Se `RegWrite = 0`, `MemToReg = X` (don't care).

=== Simulação do Pipeline

```
End  Instrução
0    lw  t1, 0(sp)
4    add t2, t3, t4
8    sw  t5, 4(sp)
12   lw  t6, 4(t7)
16   add t8, t0, t0
```

Obs: X = don't care. Cada instrução anda uma coluna (ciclo) por registrador intermediário. Sem dependências entre elas, logo não há bolhas.

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
  [IR], [lw], [add], [sw], [lw], [add], [], [], [],
  table.cell(rowspan: 12)[ID/EX],
  [PC], [], [0], [4], [8], [12], [16], [], [],
  [A], [], [(sp)], [(t3)], [(sp)], [(t7)], [(t0)], [], [],
  [B], [], [X], [(t4)], [(t5)], [X], [(t0)], [], [],
  [Imm], [], [0], [X], [4], [4], [X], [], [],
  [rd], [], [t1], [t2], [X], [t6], [t8], [], [],
  [ALUOp], [], [00], [10], [00], [00], [10], [], [],
  [ALUSrc], [], [1], [0], [1], [1], [0], [], [],
  [MemRead], [], [1], [0], [0], [1], [0], [], [],
  [MemWrite], [], [0], [0], [1], [0], [0], [], [],
  [Branch], [], [0], [0], [0], [0], [0], [], [],
  [RegWrite], [], [1], [1], [0], [1], [1], [], [],
  [MemToReg], [], [1], [0], [X], [1], [0], [], [],
  table.cell(rowspan: 10)[EX/MEM],
  [ALUOutput], [], [], [(sp)+0], [(t3)+(t4)], [(sp)+4], [(t7)+4], [(t0)+(t0)], [],
  [BranchTarget], [], [], [X], [X], [X], [X], [X], [],
  [rd], [], [], [t1], [t2], [X], [t6], [t8], [],
  [B], [], [], [X], [X], [(t5)], [X], [X], [],
  [zero], [], [], [X], [X], [X], [X], [X], [],
  [MemRead], [], [], [1], [0], [0], [1], [0], [],
  [MemWrite], [], [], [0], [0], [1], [0], [0], [],
  [Branch], [], [], [0], [0], [0], [0], [0], [],
  [RegWrite], [], [], [1], [1], [0], [1], [1], [],
  [MemToReg], [], [], [1], [0], [X], [1], [0], [],
  table.cell(rowspan: 5)[MEM/WB],
  [ALUOutput], [], [], [], [X], [(t3)+(t4)], [X], [X], [(t0)+(t0)],
  [LMD], [], [], [], [MEM[(sp)+0]], [X], [X], [MEM[(t7)+4]], [X],
  [rd], [], [], [], [t1], [t2], [X], [t6], [t8],
  [RegWrite], [], [], [], [1], [1], [0], [1], [1],
  [MemToReg], [], [], [], [1], [0], [X], [1], [0],
)
]

Dicas:
- `lw`: ALUOp `00`, ALUSrc `1`, MemRead `1`, RegWrite `1`, MemToReg `1`, B = X.
- `sw`: ALUOp `00`, ALUSrc `1`, MemWrite `1`, RegWrite `0`, rd = X, B = (rs2) (é o dado a ser escrito).
- Tipo R: ALUOp `10`, ALUSrc `0`, RegWrite `1`, MemToReg `0`, Imm = X.

== Dependências / Conflitos (Hazards)

- *Estruturais*: 2+ estágios querem o mesmo recurso ao mesmo tempo (ex: memória).
- *De dados*: instrução depende de resultado de instrução anterior ainda não completada.
- *De controle*: a próxima instrução não está no endereço seguinte (desvios).

=== Conflitos estruturais

#table(
  columns: (auto, auto),
  inset: 5pt,
  table.header([*Problema*], [*Solução*]),
  [Acessos concorrentes à memória], [Memória multi-portas ou com múltiplos bancos independentes],
  [Busca de instrução + leitura/escrita de dado ao mesmo tempo], [Arquitetura *Harvard*: caches de instrução e dados separadas],
  [Acesso simultâneo ao banco de registradores], [Banco de registradores com múltiplas portas],
  [Uso simultâneo da mesma unidade funcional], [Replicar a unidade ou implementá-la em pipeline],
)

=== Dependência de dados

Uma instrução usa um operando que ainda está sendo produzido por outra instrução no pipeline.

#table(
  columns: (auto, auto, auto),
  inset: 5pt,
  table.header([*Tipo*], [*Definição*], [*Exemplo*]),
  [*RAW* (Read After Write) - verdadeira/direta], [Lê operando produzido por instrução *anterior*], [`add R1, R2, R3` \ `sub R4, R1, R6`],
  [*WAR* (Write After Read) - antidependência (falsa)], [Lê operando que é escrito por instrução *sucessora*], [`sub R4, R1, R6` \ `add R1, R2, R3`],
  [*WAW* (Write After Write) - de saída (falsa)], [Escreve operando que também é escrito por instrução *sucessora*], [`add R4, R2, R3` \ `sub R4, R1, R6`],
)

Soluções:
- *Verdadeiras (RAW)*: parar o pipeline (*interlock/stall*), inserir `nop` ou *escalonar* (reordenar) instruções pelo compilador, *forwarding* (resolve em alguns casos).
- *Falsas (WAR/WAW)*: não são problema em pipelines que mantêm a ordem de execução; são problema em processadores *superescalares*. Solução: *renomeação de registradores*.

==== Adiantamento de dados (forwarding / bypassing)

Caminho interno no pipeline da saída da ULA (ou da memória) de volta para a entrada da ULA. Usa os *registradores intermediários* em vez de esperar o dado ser escrito no banco de registradores.

#figure(image("images/image-22.png", width: 100%))

Exemplo (`sub` produz `x2`, as seguintes usam):

#figure(image("images/image-24.png", width: 100%))

- `sub` → `and`: dependência *EX* (resolvida via EX/MEM).
- `sub` → `or`: dependência *MEM* (resolvida via MEM/WB).
- `sub` → `add`: sem problema, o banco escreve na 1ª metade e lê na 2ª metade do ciclo.
- `sub` → `sd`: sem hazard.

#figure(image("images/image-25.png", width: 100%))

*Unidade de forwarding*: controla MUXes nas entradas da ULA (ForwardA = 1º operando, ForwardB = 2º).

#figure(image("images/image-26.png", width: 100%))

#figure(image("images/image-27.png", width: 70%))

Resumo: `00` = banco de registradores (sem forwarding), `10` = vem de EX/MEM, `01` = vem de MEM/WB.

Condições (só adianta se a instrução escreve em registrador, `rd != x0` e `rd` = registrador fonte):

```
// Dependência EX
if (EX/MEM.RegWrite and (EX/MEM.rd != 0)
    and (EX/MEM.rd == ID/EX.rs1)) ForwardA = 10
if (EX/MEM.RegWrite and (EX/MEM.rd != 0)
    and (EX/MEM.rd == ID/EX.rs2)) ForwardB = 10

// Dependência MEM
if (MEM/WB.RegWrite and (MEM/WB.rd != 0)
    and (MEM/WB.rd == ID/EX.rs1)) ForwardA = 01
if (MEM/WB.RegWrite and (MEM/WB.rd != 0)
    and (MEM/WB.rd == ID/EX.rs2)) ForwardB = 01
```

*Problema (dependência dupla)*: acumulando no mesmo registrador:

```
add x1, x1, x2
add x1, x1, x3
add x1, x1, x4
```

O 3º `add` depende dos dois anteriores (EX/MEM e MEM/WB têm `rd = x1`). Queremos o valor *mais recente* (EX/MEM). Então a dependência MEM só vale se *não* houver dependência EX:

```
if (MEM/WB.RegWrite and (MEM/WB.rd != 0)
		and (EX/MEM.rd != ID/EX.rs1))
    and (MEM/WB.rd == ID/EX.rs1)) ForwardA = 01
if (MEM/WB.RegWrite and (MEM/WB.rd != 0)
		and (EX/MEM.rd != ID/EX.rs2))
    and (MEM/WB.rd == ID/EX.rs2)) ForwardB = 01
```

==== Load-use: quando o forwarding não resolve

Se uma instrução usa o registrador carregado por um `lw` *imediatamente anterior*, o dado só existe após o MEM do `lw`, mas é preciso no EX da seguinte. Obrigatoriamente há *1 bolha* (stall), mesmo com forwarding.

#figure(image("images/image-23.png", width: 100%))

*Unidade de detecção de hazard* (atua no estágio ID):

```
if (ID/EX.MemRead and                // instrução em EX é um load
    ((ID/EX.rd == IF/ID.rs1) or      // destino (EX) == origem 1 (ID)
    (ID/EX.rd == IF/ID.rs2)))       // destino (EX) == origem 2 (ID)
  stall the pipeline
```

Como fazer o stall:
1. *Não atualiza* o PC nem o IF/ID (instruções em IF e ID ficam paradas e repetem no próximo ciclo).
2. Insere uma *bolha (`nop`)* no EX: zera todos os sinais de controle de EX, MEM e WB no ID/EX.

==== Escalonamento de instruções (exemplo)

`a = b + e; c = b + f;`

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  [
    Original (2 stalls load-use):
    ```
    lw  t1, 0(t0)
    lw  t2, 4(t0)
    add t3, t1, t2   // stall (t2)
    sw  t3, 12(t0)
    lw  t4, 8(t0)
    add t5, t1, t4   // stall (t4)
    sw  t5, 16(t0)
    ```
  ],
  [
    Reordenado (0 stalls c/ forwarding):
    ```
    lw  t1, 0(t0)
    lw  t2, 4(t0)
    lw  t4, 8(t0)
    add t3, t1, t2
    sw  t3, 12(t0)
    add t5, t1, t4
    sw  t5, 16(t0)
    ```
  ],
)

=== Dependência de controle

Instruções que alteram o fluxo:
- *Condicionais*: `beq`, `bne`, `bnez`... (if-then-else, for).
- *Incondicionais*: `jal` (chamada), `j` (goto), `jr` (return), `jalr` (endereço em tabela).

Problema: só se sabe se o desvio será tomado durante a execução. Se for tomado, as instruções buscadas depois dele precisam ser descartadas.

==== Soluções

1. *Congelar o pipeline* até saber o resultado do desvio (insere bolhas). Ruim para pipelines longos.
2. *Assumir desvio não tomado*: continua buscando sequencialmente. Se for tomado, faz *flush* (zera os sinais de controle das instruções erradas, como no stall).
  - Com a decisão no estágio MEM, é preciso descartar as instruções em IF, ID e EX (3 ciclos perdidos).
3. *Reduzir o atraso do desvio*: mover cálculo do endereço alvo e comparação para o *ID* → só 1 instrução descartada.
  - Ex: `40 beq x1, x3, 7` → alvo $= 40 + 4 + 7 dot 4 = 72$ (convenção do slide).
4. *Delayed branch (desvio atrasado)*: a instrução logo após o desvio (*delay slot*) é *sempre executada*. O compilador preenche o slot com uma instrução útil (reordenamento).
  - Variante com *anulação*: se o desvio não for tomado, a instrução do slot é anulada. Permite colocar no slot uma instrução do *alvo* (útil em loops; previsão implícita de "sempre tomado").
5. *Predição de desvio*: tomado → `PC = PC + offset`; não tomado → `PC = PC + 4`.

==== Predição estática

Fixa, não se adapta ao programa; menor taxa de acerto. Errou → bolhas.
- Todos não tomados (predicted-untaken).
- Todos tomados (predicted-taken).
- Por opcode (certos tipos de desvio são assumidos tomados).
- *BTFNT* (Backward Taken, Forward Not Taken): desvios para trás (loops) tomados; para frente não tomados.

==== Predição dinâmica

Hardware prevê com base no histórico do desvio. Alta taxa de acerto.

- *Branch Prediction Buffer* (tabela de histórico de desvios): pequena memória indexada pelos bits menos significativos do endereço da instrução de desvio.
- *Previsor de 1 bit*: guarda se o desvio foi tomado da última vez; errou → inverte o bit. Em *loops aninhados* erra *2 vezes* no loop interno (na saída do loop e na reentrada).
- *Previsor de 2 bits (bimodal)*: contador de 0 a 3 (tomado: +1, não tomado: −1). 0, 1 → prevê não tomado; 2, 3 → prevê tomado. Precisa *errar 2 vezes* para mudar a previsão.
- *Preditor correlacionado (m, n)*: usa o comportamento dos últimos $m$ desvios para escolher entre $2^m$ preditores de $n$ bits. Ex: GShare, GSelect, GAg.

Localização do buffer: cache especial (acessada no IF, bits usados no ID) ou junto às instruções na cache de instruções.

*BTB (Branch Target Buffer)*: cache de instruções de desvio que guarda também o *endereço alvo*. Normalmente o desvio só é identificado no ID (perde 1 ciclo); com o BTB já se sabe no *IF* que é desvio e para onde ir.

== Hierarquia de Memória

Características conflitantes: grande capacidade, acesso rápido e custo baixo. Solução: *hierarquia*.

```
Registradores        ↑ mais rápido, mais caro por bit, menor
Cache (L1, L2, L3)   |
Memória principal    |
Memória secundária   ↓ mais lento, mais barato, maior
(disco, fita)
```

=== Características de um sistema de memória

- *Localização*: interna à CPU (registradores, cache), principal (endereçada diretamente pelo processador), secundária (dispositivos de armazenamento em volume, transferem pela MP).
- *Capacidade*: tamanho da palavra × número de palavras. Unidade de endereçamento: byte ou palavra.
- *Unidade de transferência*: MP → n° de bits lidos/escritos de uma vez; secundária → blocos.
- *Métodos de acesso*:
  - *Sequencial*: registros em sequência, tempo variável (fita).
  - *Direto*: blocos com endereço, tempo variável (disco).
  - *Aleatório*: cada posição tem endereço único, tempo constante (MP).
  - *Associativo*: busca pelo conteúdo, compara bits (cache).
- *Desempenho*:
  - *Tempo de acesso (latência)*: tempo de uma leitura/escrita (ou de posicionar o mecanismo, se não aleatório).
  - *Tempo de ciclo*: tempo até a memória estar pronta para o próximo acesso.
  - *Taxa de transferência*: velocidade de entrada/saída de dados.
- *Físicas*: volátil / não volátil; apagável / não apagável.

=== Tipos de memória

#table(
  columns: (auto, auto, auto, auto, auto),
  inset: 5pt,
  table.header([*Tipo*], [*Categoria*], [*Apagar*], [*Escrita*], [*Volátil*]),
  [ROM], [Só leitura], [Não], [Máscara (fábrica)], [Não],
  [PROM], [Só leitura], [Não], [Elétrica (1 vez)], [Não],
  [EPROM], [Principalmente leitura], [Luz U.V.], [Elétrica], [Não],
  [E²PROM], [Principalmente leitura], [Elétrica (byte)], [Elétrica], [Não],
  [FLASH], [Principalmente leitura], [Elétrica (bloco)], [Elétrica], [Não],
  [RAM], [Leitura e escrita], [Elétrica (byte)], [Elétrica], [*Sim*],
)

- *ROM*: conteúdo fixo, gravado na fabricação. Rápida e barata em grande escala; não pode ser alterada. Uso: UC, BIOS, sub-rotinas muito usadas.
- *PROM*: programada pelo usuário *1 vez*, por fusíveis (bit 1 = fusível intacto, 0 = rompido). Valor padrão: 1.
- *EPROM*: reprogramável; apagada por U.V. (15–30 min), precisa ser *retirada do circuito*.
- *E²PROM*: apagada/escrita eletricamente *no próprio circuito*, em nível de *byte*. Mais cara e menos densa.
- *FLASH*: intermediária entre EPROM e E²PROM; apaga em nível de *bloco* (não de palavra). Mais densa que E²PROM, durável, n° limitado de escritas.
  - *NOR*: mais antiga, acesso aleatório, mais cara.
  - *NAND*: acesso sequencial, leitura mais rápida.
- *RAM*: leitura e escrita, volátil, tempo de acesso pequeno.
  - *SRAM (estática)*: bit = *flip-flop*. Não precisa de refresh → *mais rápida*. Usada em *caches*.
  - *DRAM (dinâmica)*: bit = *capacitor* (capacitância parasita). Precisa de *refresh* periódico. Células simples → *mais barata e densa*. Usada na *memória principal*.

== Memória Cache

Memória pequena e rápida entre CPU e MP. Acesso *associativo* (localiza pelo conteúdo/tag). Cada nível mais próximo do processador é um *subconjunto* do nível mais distante.

*Princípio da localidade*:
- *Temporal*: um dado usado agora provavelmente será usado de novo em breve.
- *Espacial*: se um dado foi usado, os vizinhos provavelmente serão usados também.

Caches bem implementadas atingem taxa de acerto > 95%.

=== Definições

- *Bloco*: menor unidade de informação transferida entre dois níveis.
- *Hit (acerto)* / *Miss (falha)*: dado está / não está no nível.
- *Taxa de acerto*: fração dos acessos encontrados no nível. *Taxa de falha* $= 1 - "taxa de acerto"$.
- *Tempo de acerto*: tempo para acessar o nível (incluindo decidir se é hit ou miss).
- *Penalidade por falha*: tempo para buscar o bloco do nível inferior, transmitir e inserir no nível onde ocorreu a falha.

Parâmetros de projeto: tamanho da cache, tamanho do bloco, estrutura, função de mapeamento, algoritmo de substituição, política de escrita, número de caches.

- *Tamanho da cache*: compromisso custo × desempenho. Maior → mais acertos, mas mais lenta (mais portas no endereçamento).
- *Tamanho do bloco*: maior bloco → mais acertos (localidade espacial), até o ponto em que os dados trazidos são menos úteis que os substituídos.

=== Linha da cache

```
| Tag | V | M | Alg. Subst. | Dados (bloco) |
```

- *Tag*: identifica qual bloco da MP está na linha.
- *V (validade)*: `1` = linha contém dado válido.
- *M (modificação / dirty bit)*: `1` = dado foi alterado na cache. Só necessário com *write-back*.
- *Alg. Subst.*: bits do algoritmo de substituição. Só necessário em mapeamento *associativo* ou *associativo por conjunto*.
- *Dados*: bloco (conjunto de palavras) vindo do nível inferior.

Nomenclatura: Stallings chama de *linha* (dados + bits de controle); Patterson & Hennessy chama de *bloco*.

=== Divisão do endereço

```
| Tag | Index ou Set | Word Offset | Byte Offset |
```

- *Byte offset (BO)*: byte dentro da palavra → $log_2("bytes por palavra")$ bits (4 bytes → 2 bits).
- *Word offset (WO)*: palavra dentro do bloco → $log_2("palavras por bloco")$ bits.
- *Index*: linha da cache (mapeamento direto) → $log_2(m)$ bits.
- *Set*: conjunto (associativo por conjunto) → $log_2(v)$ bits.
- *Tag*: o restante dos bits do endereço.
- N° do bloco da MP: $j = "endereço" div "bytes por bloco"$ (= bits Tag + Index/Set).

=== Funções de mapeamento

Como há menos linhas na cache do que blocos na MP, é preciso definir onde cada bloco pode ficar.

==== Mapeamento direto

Cada bloco da MP vai para *uma única linha*:

$ i = j mod m $

$i$ = linha da cache, $j$ = n° do bloco da MP, $m$ = n° de linhas da cache.

- Ex. ($m = 2$): bloco 0 → linha 0, bloco 1 → linha 1, bloco 2 → linha 0, bloco 3 → linha 1...
- Vários blocos caem na mesma linha → a *tag* diz qual deles está lá.
- Busca: o Index seleciona a linha; compara a tag da linha com a tag do endereço (1 comparador). Iguais e `V = 1` → hit.
- *Vantagens*: simples, barato.
- *Desvantagem*: blocos usados alternadamente que caem na mesma linha ficam se substituindo (taxa de acerto baixa).
- *Não precisa de algoritmo de substituição* (a linha já é determinada).

==== Mapeamento totalmente associativo

Um bloco pode ir para *qualquer linha*. Endereço: Tag + WO + BO (sem index).

- Busca: compara a tag do endereço com a tag de *todas* as linhas *em paralelo*.
- *Vantagem*: flexibilidade na escolha da linha a substituir.
- *Desvantagem*: circuito de comparação complexo (um comparador por linha).

==== Mapeamento associativo por conjunto (k-way)

Cache dividida em $v$ conjuntos de $k$ linhas. O bloco é mapeado diretamente em um *conjunto* e, dentro dele, em *qualquer linha*.

$ m = v dot k #h(2em) i = j mod v $

($i$ aqui é o n° do conjunto). Endereço: Tag + Set + WO + BO. A tag é comparada só com as $k$ tags do conjunto.

- $v = m$, $k = 1$ → mapeamento *direto*.
- $v = 1$, $k = m$ → *totalmente associativo*.

==== Exemplo de divisão do endereço

MP de 64 bytes (6 bits), palavra de 4 bytes, 2 palavras/bloco (8 blocos), cache de 4 linhas:

#table(
  columns: (auto, auto, auto, auto, auto),
  inset: 5pt,
  table.header([*Mapeamento*], [*Tag*], [*Index/Set*], [*WO*], [*BO*]),
  [Direto ($m = 4$)], [1 bit], [2 bits (Index)], [1 bit], [2 bits],
  [Totalmente associativo], [3 bits], [-], [1 bit], [2 bits],
  [2-way ($v = 2$, $k = 2$)], [2 bits], [1 bit (Set)], [1 bit], [2 bits],
)

Endereço `110100` (52): BO = `00`, WO = `1`, bloco $j$ = `110` = 6.
- Direto: linha $6 mod 4 = 2$ (`10`), tag `1`.
- Totalmente associativo: tag `110`, qualquer linha.
- 2-way: conjunto $6 mod 2 = 0$ (`0`), tag `11`.

=== Algoritmos de substituição

Quando um bloco novo chega e não há espaço. Só para mapeamento *associativo* e *associativo por conjunto* (no direto a linha já é determinada).

- *FIFO*: remove a linha que está há mais tempo na cache.
- *LRU (Least Recently Used)*: remove a que há mais tempo não é referenciada. Hardware: contador por linha; no acesso, zera o contador da linha e incrementa os demais; substitui o de maior valor. Problema: caro com muitas linhas.
- *LFU (Least Frequently Used)*: remove a menos usada (frequência = utilização / tempo, contador).
- *Aleatório*: contador incrementado a cada ciclo de clock; substitui a linha de índice igual ao contador no momento.
- *Aging* (aproximação de LRU): a cada intervalo, desloca o contador 1 bit à direita e coloca no bit mais significativo `1` se a linha foi usada, `0` se não. Substitui a de *menor* valor. Usos antigos vão "perdendo peso".

```
usada no intervalo:  10110101 >> 1, MSB = 1  →  11011010
não usada:           10110101 >> 1, MSB = 0  →  01011010
```

=== Políticas de escrita

Leitura não causa inconsistência; escrita sim (cache ≠ MP). Os valores devem ser consistentes por causa de E/S (que acessa a MP) e de múltiplos processadores.

*Write-hit* (dado está na cache):
- *Write-through*: escreve na cache *e* no nível inferior imediatamente. Simples, mas gera muito tráfego na memória (gargalo). Só 5% a 34% dos acessos são escritas.
- *Write-back*: escreve só na cache e marca `M = 1`. O bloco só volta ao nível inferior quando for *substituído* (e só se `M = 1`). Problema: E/S precisa acessar a MP via cache (circuito mais complexo).

*Write-miss* (dado não está na cache):
- *Write-allocate*: traz o bloco para a cache (read-miss) e depois escreve nele (write-hit).
- *No-write-allocate*: escreve direto na MP, *não* traz o bloco para a cache.

Combinações usuais: *write-through + no-write-allocate* e *write-back + write-allocate*.

*Flushing*: escreve todos os blocos modificados (dirty) na MP para sincronizar.

==== Exemplo (write-back + write-allocate, totalmente associativo)

MP: 6 bits de endereço, palavra de 4 bytes, conteúdo de cada palavra = endereço × 10 (MEM[8] = 80). Cache de 2 linhas, 2 palavras/bloco. Endereço: Tag (3) | WO (1) | BO (2).

```
lw   t1, 0(s0)      // s0 = 8  = 001|0|00 → tag 001, WO 0
addi t1, t1, 1
sw   t1, 0(s0)
```

- `lw`: miss → traz bloco `001` (MEM[8] = 80, MEM[12] = 120). `t1 = 80`.
- `sw`: hit → W0 = 81, `M = 1` (MP continua com 80).

```
xor  t2, t2, t2
addi t2, t2, 1000
sw   t2, 0(s1)      // s1 = 20 = 010|1|00 → tag 010, WO 1
```

- `sw`: write-miss → write-allocate traz bloco `010` (160, 200), escreve W1 = 1000, `M = 1`.

#table(
  columns: (auto, auto, auto, auto, auto, auto, auto),
  inset: 5pt,
  table.header([*Linha*], [*Tag*], [*V*], [*M*], [*LRU*], [*W0*], [*W1*]),
  [0], [010], [1], [1], [2], [160], [1000],
  [1], [001], [1], [1], [1], [81], [120],
)

(LRU aqui = ordem de uso; menor = menos recentemente usada → próxima a sair.)

=== Origem das falhas (3 Cs)

- *Compulsórias*: 1º acesso a um bloco que nunca esteve na cache.
- *Capacidade*: a cache não comporta todos os blocos necessários; blocos são substituídos e depois buscados de novo. Diminuem com cache maior.
- *Conflito (colisão)*: vários blocos disputam a mesma linha/conjunto (mapeamento direto ou por conjunto). Dependem do mapeamento.

=== Número de caches

- *Níveis*: L1 (dentro do processador), L2 (interna ou externa), L3 (mais recente; externa, com L2 indo para dentro do chip). Transferências entre níveis têm os mesmos problemas/soluções.
- *On-chip*: reduz uso do barramento externo (que fica livre para outras transferências) → mais desempenho.
- *Off-chip*: atende falhas da on-chip sem ir à MP pelo barramento lento. Em geral melhora o desempenho.
- *Inclusiva*: o que está em L1 também está em L2 (Intel Pentium 2/3/4). Vantagem: E/S só precisa olhar a L2.
- *Exclusiva*: o dado está em *apenas uma* (L1 ou L2); em miss na L1 com hit na L2, os blocos são trocados (AMD Athlon). Vantagem: capacidade total = L1 + L2.
- *Unificada*: dados e instruções juntos. Maior taxa de acerto (balanceamento automático), só um projeto. Usada em L2 e L3.
- *Separada (split)*: uma para dados e uma para instruções. Política de escrita só na de dados; parâmetros diferentes para cada; evita conflito estrutural no pipeline. Usada em L1.
- Ex. Core i7: L1 64 KB/núcleo (8-way), L2 256 KB/núcleo (8-way), L3 8 MB compartilhada (16-way).

=== Resumo: 4 perguntas

1. *Onde o bloco pode ser colocado?* Direto: 1 linha. Conjunto: qualquer linha do conjunto. Totalmente associativo: qualquer linha.
2. *Como o bloco é encontrado?* Direto: index + 1 comparação de tag. Conjunto: set + $k$ comparações. Totalmente associativo: compara todas as tags.
3. *Qual bloco substituir?* FIFO, LRU, LFU, aleatório (só associativo/conjunto).
4. *O que acontece na escrita?* Hit: write-through / write-back. Miss: write-allocate / no-write-allocate.

=== Simulação de Cache (L1 + L2)

- Palavra: 32 bits = 4 bytes. MP: 512 bytes → *9 bits* de endereço.
- *L1*: totalmente associativa, 2 linhas, 2 palavras/bloco → `Tag (6) | WO (1) | BO (2)`.
- *L2*: associativa por conjunto, 2 conjuntos, 2 linhas/conjunto (2-way), 4 palavras/bloco → `Tag (4) | Set (1) | WO (2) | BO (2)`.
- LRU, write-allocate, write-back. Cache inclusiva.
- Convenção do exercício: conteúdo da MP = endereço × 10; na escrita, o valor escrito = endereço.

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  inset: 5pt,
  table.header([*Acesso*], [*Op.*], [*Dec*], [*Binário*], [*L1 (Tag|WO|BO)*], [*L2 (Tag|Set|WO|BO)*]),
  [1], [Escrita], [4], [000000100], [000000|1|00], [0000|0|01|00],
  [2], [Escrita], [12], [000001100], [000001|1|00], [0000|0|11|00],
  [3], [Leitura], [24], [000011000], [000011|0|00], [0000|1|10|00],
  [4], [Leitura], [16], [000010000], [000010|0|00], [0000|1|00|00],
)

Fluxo de um miss total: L1 miss → L2 miss → MP envia bloco de 4 palavras para L2 → L2 envia bloco de 2 palavras para L1 → L1 envia a palavra para a CPU. A escrita é feita na L1 (mais próxima do processador).

*1) Escrita 4*: miss L1, miss L2. L2 (conj. 0) recebe bloco 0–15 = {0, 40, 80, 120}. L1 recebe {0, 40}. Escreve W1 = 4, `M = 1`.

*2) Escrita 12*: miss L1, *hit L2* (conj. 0, tag 0000). L1 linha livre recebe {80, 120}. Escreve W1 = 12, `M = 1`.

*3) Leitura 24*: miss L1, miss L2 (conj. 1 vazio). L2 (conj. 1) recebe bloco 16–31 = {160, 200, 240, 280}. L1 cheia → LRU sai a linha da tag `000000` (`M = 1` → *write-back* para L2: palavras 0 e 4 do conj. 0, `M = 1` na L2). L1 recebe {240, 280}. CPU lê 240.

*4) Leitura 16*: miss L1, *hit L2* (conj. 1). L1 → LRU sai tag `000001` (`M = 1` → write-back para L2: palavras 80 e 12). L1 recebe {160, 200}. CPU lê 160.

Estado final:

#table(
  columns: (auto, auto, auto, auto, auto, auto, auto),
  inset: 5pt,
  table.header([*L1*], [*Tag*], [*V*], [*M*], [*LRU*], [*W0*], [*W1*]),
  [Linha 0], [000011], [1], [0], [1], [240], [280],
  [Linha 1], [000010], [1], [0], [2], [160], [200],
)

#table(
  columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
  inset: 5pt,
  table.header([*L2*], [*Tag*], [*V*], [*M*], [*LRU*], [*W0*], [*W1*], [*W2*], [*W3*]),
  [Conj. 0], [0000], [1], [1], [1], [0], [4], [80], [12],
  [Conj. 0], [], [0], [], [], [], [], [], [],
  [Conj. 1], [0000], [1], [0], [1], [160], [200], [240], [280],
  [Conj. 1], [], [0], [], [], [], [], [], [],
)

MP não muda: as modificações só vão para a MP quando a L2 precisar liberar a linha (write-back em cascata: L1 → L2 → MP).

== Entrada e Saída (E/S)

Periféricos são caracterizados por:
- *Comportamento*: entrada (teclado), saída (monitor), armazenamento (disco).
- *Relacionamento*: com humanos (teclado, vídeo) ou com máquinas (disco, sensores, rede).
- *Taxa de transferência*: bytes/s ou transferências/s.

Por que não ligar direto na CPU? Diferentes quantidades de dados, periféricos mais lentos que CPU/RAM, formatos e tamanhos de palavra diferentes → *módulo (controlador) de E/S*.

=== Módulo de E/S

3º elemento do computador (com CPU e memória). Faz interface com CPU/memória (barramento) e com um ou mais periféricos; livra a CPU dos detalhes dos dispositivos.

Funções:
- *Controle e temporização*: CPU verifica estado → módulo retorna estado → se pronto, CPU envia comando → módulo obtém dado do dispositivo → dado vai para a CPU.
- *Comunicação com o processador*: decodificação de comandos (ex: READ SECTOR), troca de dados, informação de estado (READY/BUSY, erros), reconhecimento de endereço (cada dispositivo tem endereço).
- *Comunicação com o dispositivo*: comandos, estado e dados.
- *Buffer de dados*: compensa a diferença de velocidade (MP → módulo rápido; módulo guarda dados para não segurar a memória em transferência lenta).
- *Detecção de erros*: ex. bit de paridade (ASCII 7 bits + 1 bit para deixar o n° de 1s par ou ímpar).

Estrutura (ex: Intel 82C55A): registradores de dados (buffer) e de estado/controle; linhas de controle com a CPU; lógica de interface para cada dispositivo.

=== Endereçamento de E/S

- *Mapeada em memória (memory-mapped)*: *um único espaço* de endereços para memória e E/S. Registradores do módulo são vistos como posições de memória → usa as mesmas instruções (`lw`/`sw`).
- *Isolada / independente (port-mapped)*: espaços *separados*; uma linha de controle indica se o acesso é à memória ou à E/S; *instruções próprias* de E/S. Ex: 10 linhas de endereço → 1024 endereços de memória + 1024 de E/S.

=== Técnicas de E/S

#table(
  columns: (auto, auto, auto),
  inset: 5pt,
  table.header([], [*Sem interrupção*], [*Com interrupção*]),
  [*Transferência via CPU*], [E/S programada], [E/S dirigida por interrupção],
  [*Transferência direta E/S ↔ memória*], [-], [DMA],
)

==== E/S programada

- CPU envia comando → módulo executa e seta bit de estado → *CPU fica verificando o bit continuamente* (polling). O módulo não interrompe a CPU.
- Comandos: *Control* (ativa e diz o que fazer), *Test* (testa condições), *Read*, *Write*.
- *Desvantagem*: CPU perde tempo esperando dispositivo lento. Para não travar em caso de falha, pode-se usar um temporizador (timeout).

==== E/S dirigida por interrupção

- CPU emite comando e *vai fazer outra coisa*; o módulo *interrompe* a CPU quando o dado está pronto; CPU então transfere o dado.
- O sinal de interrupção é verificado *ao final de cada ciclo de instrução*. Se houver interrupção pendente:
  1. Suspende o programa e *salva o contexto*.
  2. PC ← endereço da *ISR* (Interrupt Service Routine).
  3. Executa a ISR.
  4. Restaura o contexto e continua o programa.
- Ex: controlador *8259A* (8 linhas de interrupção, para o 8086 que só tem 1): recebe interrupções → define prioridade → ativa INTR → CPU reconhece → 8259A coloca o *vetor* no barramento de dados → CPU trata.

==== DMA (Direct Memory Access)

Programada e por interrupção têm taxa limitada pela CPU e a sobrecarregam. Com DMA, os dados vão entre memória e dispositivo *sem passar pela CPU* (ganho com grandes blocos). Exige um módulo de hardware dedicado no barramento.

1. CPU programa o DMA: operação (leitura/escrita), endereço do dispositivo, *endereço inicial de memória* (registrador de endereço) e *n° de palavras* (contador de dados).
2. CPU continua o processamento; DMA transfere o bloco palavra por palavra.
3. DMA termina e envia *interrupção* à CPU (1 interrupção por bloco, não por palavra).

Modos de uso do barramento:
- *Roubo de ciclo*: DMA força o uso do barramento e suspende a CPU por um ciclo (logo antes de ela acessar o barramento). *Não é interrupção*: não há troca de contexto. Atrasa a CPU, mas menos que ela fazendo a transferência.
- *Transparente*: DMA usa o barramento só quando a CPU não está usando. Mais lento.

Configurações:
- *Barramento único, DMA separado*: cada transferência usa o barramento *2 vezes* (E/S → DMA, DMA → memória). Barato, ineficiente.
- *Barramento único, DMA–E/S integrados* ou *barramento de E/S próprio*: usa o barramento do sistema *1 vez* (DMA → memória). Permite comunicação DMA–dispositivo em paralelo com a CPU.

Ex: Intel 8237A (memória → disco): dispositivo ativa *DREQ* → DMA ativa *HRQ* (hold request) → CPU termina ciclo de barramento e ativa *HLDA* (hold ack) → DMA ativa *DACK* → DMA coloca endereço, ativa MEMR e IOW → decrementa contador e incrementa endereço até 0 → desativa HRQ, devolvendo o barramento.

=== Evolução do subsistema de E/S

1. CPU controla diretamente cada periférico.
2. Módulo de E/S + E/S programada.
3. E/S por interrupção.
4. DMA.
5. *Canal de E/S*: módulo vira processador especializado, executa *programas de E/S* armazenados na memória (CPU só inicia e indica o programa). O programa define dispositivos, áreas de memória, prioridades e tratamento de erros.
6. *Processador de E/S*: canal com memória local própria (é um computador).

=== Interfaces externas

- *Controlador*: CI na placa-mãe com função específica (ex: controlador USB, SATA).
- *Interface*: padrão de conexão (ex: o HD se conecta ao controlador via SATA).
- *Paralela*: várias linhas, vários bits ao mesmo tempo. *Serial*: uma linha, 1 bit por vez.
- *Ponto a ponto*: linha dedicada (ex: RS-232). *Multiponto*: barramento compartilhado (ex: SCSI).

#table(
  columns: (auto, auto, auto),
  inset: 5pt,
  table.header([*Interface*], [*Tipo*], [*Destaques*]),
  [Serial COM (RS-232C)], [Serial, ponto a ponto], [Terminal (DTE) ↔ modem (DCE); 20 Kbit/s, 15 m],
  [Paralela LPT (Centronics)], [Paralela, ponto a ponto], [Impressoras; 150 KB/s (EPP/ECP mais rápidas)],
  [PS/2], [Serial, ponto a ponto], [Teclado e mouse (mini-DIN)],
  [IDE / ATA / PATA], [Paralela], [Controladora no próprio HD; 1 master + 1 slave; até 133 MB/s],
  [SATA], [Serial], [1 dispositivo; 150 / 300 / 600 MB/s],
  [SCSI], [Paralela], [Até 32 dispositivos em cadeia; troca direta entre dispositivos (mestre–escravo); precisa de terminadores e IDs manuais],
  [SAS], [Serial], [SCSI serial; compatível com SATA; até 65535 dispositivos],
  [FireWire (IEEE 1394)], [Serial], [Até 63 dispositivos; mais barato que SCSI; sem terminadores, IDs automáticos],
  [USB], [Serial], [Host + até 127 dispositivos (via hubs); 1.0: 12 Mbps; 2.0: 480 Mbps; 3.0: 4,8 Gbps, bidirecional],
)

== Barramentos

Caminho de comunicação *compartilhado* entre dois ou mais dispositivos. Só *um* dispositivo pode transmitir por vez. Barramento de sistema: 50 a 100 linhas.

=== Estrutura

- *Linhas de dados*: transmitem dados (e instruções; não há distinção nesse nível). *Largura* (8, 16, 32, 64 bits) afeta o *desempenho*.
- *Linhas de endereço*: origem/destino dos dados (memória e portas de E/S). Largura determina a *capacidade máxima de memória*.
- *Linhas de controle*: comandos e temporização: leitura/escrita de memória e E/S, ACK de transferência, bus request / bus grant, interrupt request / ACK, clock, reset.

=== Barramento único x hierarquia

- Ponto a ponto entre tudo: ideal, mas caro e complicado.
- *Barramento comum*: muitos dispositivos → barramento mais longo, mais atraso de propagação, sem paralelismo.
- Solução: *hierarquia de barramentos*:
  - *Processador*: interno à CPU.
  - *Cache*: dedicado ao acesso à cache.
  - *Memória (system bus)*: processador ↔ memória.
  - *E/S local (high speed)*: dispositivos de desempenho crítico (vídeo, armazenamento, rede rápida). Ex: VLB, PCI, AGP.
  - *E/S padrão (expansion)*: dispositivos lentos (mouse, modem, som). Ex: ISA, EISA.

=== Mestre e escravo

- *Mestre*: inicia a transferência. Só *1 mestre* ativo por vez (se há vários → arbitragem).
- *Escravo*: responde ao mestre; pode haver vários.
- Transação: mestre envia endereço → escravos comparam com o próprio → o escravo correspondente se conecta → troca de dados → mestre encerra a conexão.
- Um mesmo módulo pode ser mestre ou escravo, mas nunca os dois ao mesmo tempo.

=== Elementos de projeto

*Tipo*:
- *Dedicado*: linhas separadas para dados e endereços. Alta taxa de transferência, mas maior custo e tamanho.
- *Multiplexado*: mesmas linhas para dados, endereços e controle (sinal "endereço válido"). Menos linhas, mas unidades mais complexas e menor desempenho.

*Arbitragem* (vários mestres, ex: CPU e DMA):
- *Centralizada*: um *árbitro* (controlador de barramento) decide (ex: PCI). Políticas:
  - Prioridade fixa (risco de *monopólio*).
  - *Round-robin*: cada mestre por vez, ciclicamente.
  - *Prioridade variante*: prioridade aumenta a cada pedido negado e volta ao valor inicial quando atendido.
- *Distribuída*: sem árbitro; cada mestre coloca seu código nas linhas de arbitragem e o de maior prioridade vence.

*Temporização*:
- *Síncrona*: eventos determinados por um *clock*; transmissão começa no início de um ciclo; diagrama de tempo fixo (sincroniza normalmente na borda de subida).
- *Assíncrona*: cada evento depende do anterior; *handshake* entre mestre e escravo; ciclo de duração variável.

*Largura*: dados → desempenho; endereço → capacidade.

*Tipos de transferência* (fases: arbitragem → endereçamento → dados):
- *Leitura* (escravo → mestre) e *escrita* (mestre → escravo).
- *Bloco*: 1 endereçamento + vários dados → alta taxa.
- *Read-Modify-Write (RMW)*: leitura seguida de escrita, *indivisível*.
- *Read-After-Write (RAW)*: escrita seguida de leitura, indivisível (verifica o que foi escrito).
- *Split transfer*: divide a transação quando o dado não está pronto (libera o barramento enquanto isso).

*Bandwidth (throughput)*: total de dados transferível por unidade de tempo (MB/s); na prática menor que o nominal (overhead de comandos/endereços). *Velocidade*: MHz; normalmente 1 bit por linha por ciclo.

=== Exemplos

- *ISA*: 8 bits / 4,77 MHz (8088) → 16 bits, 24 bits de endereço, 8 MHz (AT 80286). Imutável desde 1984 (compatibilidade).
- *MCA* (IBM, 1987): 32 bits, bus mastering, plug and play. Fracassou: incompatível com ISA e proprietário.
- *EISA*: resposta à MCA; 32 bits, compatível com ISA, bus mastering. Cara, poucas placas.
- *VLB* (VESA, 1992): 32 bits, 33 MHz, para vídeo; extensão do barramento do 80486; sem bus mastering; substituído pelo PCI.
- *AGP* (1997): canal exclusivo entre vídeo e processador/memória.
- *PCI* (Intel, 1990): 32/64 bits, arbitragem centralizada, pontes (bridges) com o barramento de sistema e com ISA. Barramento de E/S mais usado.
- *PCI Express*: *serial, ponto a ponto*; cada periférico tem canal exclusivo com o chipset, com várias *lanes* (1x, 4x, 8x, 16x, 32x).
- *LPC* (Low Pin Count): dispositivos de baixa bandwidth; substituiu o ISA.
