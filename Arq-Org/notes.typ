= Aula-Lab

== Arquitetura RISC-V

- Arquitetura de 32 bits
- 32 registradores de propósito geral
- 32 registradores para float

== Compilando .asm

1. sudo apt install nasm
2. sudo apt install binutils
3. nasm -f elf64 file.asm -o file.o (monta arquivo)
4. ld file.o -o file (cria executável)

== Registradores no RARS

- a7 -> Registrador de syscall
- a0-a6 -> Argumentos
- s0-s7 -> Variáveis
- t0-t7 -> Temporários

== Comandos

- add -> Adiciona 2 registradores
- addi -> Adiciona valor a registrador
