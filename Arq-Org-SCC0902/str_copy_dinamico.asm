.data
.align 0
str_src: .asciz "Teste"
ptr_dst: .space 4


.text
.align 2
.globl main

main:
	# contar o numero de caracteres a serem copiados
	# t0 = endereço inicial da str_src
	la t0, str_src
	
	# t2 = contador
	addi t2, zero, 0
	
loop_count:
	# le 1 byte de memoria
	lb t3, 0(t0)
	
	# Incrementa contador
	addi t2, t2, 1
	
	# Avança para o proximo byte
	addi t0, t0, 1
	
	bne t3, zero, loop_count

alloc:
	# Alocar na heap t2 bytes
	# a7 = 9 (serviço 9)
	# a0 = numero de bytes a serem alocados
	addi a7, zero, 9
	add a0, zero, t2
	ecall
	
	# Armazena o valor retornado em a0 (endereço do 1° byte alocado) em ptr_dst
	la t0, ptr_dst
	sw a0, 0(t0)
	
	la t0, str_src
	# Armazena em t1 o endereço inicial da string destino
	la t4, ptr_dst
	lw t1, 0(t4)
	
loop: 	
	# Ler em t3 o contador de memoria apontador por t0
	lb t3, 0(t0)
	# Escrever o conteudo de t3 na posiçao de memoria apontada por t1
	sb t3, 0(t1)
	
	# Avança ponteiros
	addi t0, t0, 1
	addi t1, t1, 1
	
	# Fim da string?
	bne t3, zero, loop
	
	# Impressao da string
	# a7 = 4 (serviço 4)
	# a0 = endereço do 1° byte da string a ser escrita na tela
	addi a7, zero, 4
	la t4, ptr_dst
	lw a0, 0(t4)
	
	addi a7, zero, 10
	ecall
	