.data                          # Início do seg de dados
.align 0                       # Padding de 2^0 = 1 byte daqui em diante (string)
string: .asciz "Hello World"   # asciz -> String + \0
.align 2                       # Padding de 2^2 = 4 bytes daqui em diante (int). Se precisar de padding, coloca NOP (ou 0)
int: .word 157                 # Define inteiro. word = 

.text                          # Início do seg de texto
.align 2                       # Padding de 2^2 = 4 bytes dauqi em diante. (Obs: Todas as instrucoes tem 4 bytes)
.globl main

main:
        addi a7, x0, 4  # a7 = 0 + 4 (4 = ecall de PrintString)
        la a0, string   # Load Address. Carrega endereço de memória de rótulo em registrador
        ecall

        addi a7, x0, 10 # a7 = 0 + 10 (10 = ecall de Exit)
        ecall
