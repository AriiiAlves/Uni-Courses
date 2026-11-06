.data
.align 0
str_input: .asciz "Entre com um numero: "
str_saida1: .asciz "O fatorial de "
str_saida2: .asciz " e "
str_num_invalido: .asciz "Numero invalido"

.text
.align 2
.globl main

main:
	# Imprime string
	addi a7, zero, 4
	la a0, str_input
	ecall
	
	# Le numero
	addi a7, zero, 5
	ecall
	
	add s0, zero, a0
	
	blt s0, zero, num_invalido
	
	# chama funcao fatorial (a0 = parametro)
	jal fatorial
	
	addi a7, zero, 1
	ecall
	j encerra

num_invalido:
	addi a7, zero, 4
	la a0, str_num_invalido
	ecall

encerra:
	addi a7, zero, 10
	ecall

# Funçao fatorial
fatorial:
	addi t0, zero, 1
	addi t1, zero, 1
	
loop:
	mul t1, t0, t1
	addi, t0, t0, 1
	beq t0, a0, sai_loop
	j loop

sai_loop:
	# Retorna para valor salvo em ra
	add a0, zero, t1
	jr ra

	