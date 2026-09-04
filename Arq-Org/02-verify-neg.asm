.data
.align 0
str1: .asciz "Hello World!++"
str2: .asciz "Hello World!--"

.text
.globl main
.align 2

main:
	addi a7, zero, 5 # Coloca int no a0
	ecall
	add s0, a0, zero # Tira do a0, pois a0 eh registrador de argumento
	blt s0, zero, print_neg
	addi a7, zero, 4
	la a0, str1
	ecall
	j the_end

print_neg:
	addi a7, zero, 4
	la a0, str2
	ecall
	# j the_end -> Não colocar, pois the_end seria a próxima instrução
	
the_end:
	addi a7, zero, 10
	ecall
	
# add = para 2 registradores
# addi = para registrador e numero
