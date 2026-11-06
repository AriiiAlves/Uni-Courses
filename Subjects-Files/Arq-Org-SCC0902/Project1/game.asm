.data
.align 0
welcome_message: .asciz "Welcome to 'guess the number'! You must guess a randomly generated integer number between 1 and 100. \n\nAfter each guessing, you will receive a feedback (guessing it greater than, less than, or correct). Good luck!\n"
input_message: .asciz "\nWrite a number [1,100]: "
lt_message: .asciz "Less than generated number.\n"
gt_message: .asciz "\nGreater than generated number."
eq_message: .asciz "\nCongrats! You guessed it."
n_attempts_message: .asciz "\nNumber of attempts: "
attempts_message: .asciz "\nAttemtps: "
arrow_str: .asciz " -> "
end_str: .asciz "END\n"
.align 2
lkd_list_head: .space 4
lkd_list_tail: .space 4

.text
.global main
.align 2

main:
	# PRINTS WELCOME MESSAGE
	la a0, welcome_message # la for symbols
	addi a7, zero, 4
	ecall
	
	# GENERATE RAND INTEGER
	jal ra, gen_rand_int
	# LOOP
	jal ra, loop
	# SHOW ATTEMPTS
	jal ra, show_attempts
	# ENDS PROGRAM
	j end

gen_rand_int:
	addi a7, zero, 30 # Current time (seed) -> a0 = low 32 bits of time
	ecall
	addi t0, zero, 1 # a
 	mul t1, t0, a0 # ax
 	addi t1, t1, 5 # aX + c
 	addi t2, zero, 100 # m
 	remu t3, t1, t2 # (ax + c) mod m (use unsigned remainder!)
 	beqz t3, gen_rand_int # if 0, try to generate again

	addi a0, t3, 0
	ret

show_attempts:
	la t0, lkd_list_head
	lw t0, 0(t0) # t0 = heap addr
	
	# PRINTS MESSAGE
	la a0, attempts_message
	addi a7, zero, 4
	ecall

inner_show_attempts:
	# PRINTS USER NUMBER
	lw a0, 0(t0)
	addi a7, zero, 1
	ecall

	# PRINTS ->
	la a0, arrow_str
	addi a7, zero, 4
	ecall

	lw t0, 4(t0) # t0 = Next
	bnez t0, inner_show_attempts
	
	# PRINTS END
	la a0, end_str
	addi, a7, zero, 4
	ecall

	ret
 
loop:
	# STORES PARAMETERS AND RA IN STACK
	addi sp, sp, -16
	sw ra, 12(sp) # sp+12 = ra
	sw a0, 8(sp) # sp+8 = rand_int
	xor t0, t0, t0
	sw t0, 4(sp) # sp+4 = user number
	sw t0, 0(sp) # sp = 0 (loop count)

inner_loop:
	# INCREMENTS LOOP COUNT
	lw t0, 0(sp)
	addi t0, t0, 1
	sw t0, 0(sp)
	# PRINTS INPUT MESSAGE
	la a0, input_message
	addi a7, zero, 4
	ecall
	# GETS NUMBER
	addi a7, zero, 5
	ecall
	sw a0, 4(sp) 
	# ADD ATTEMPT
	jal ra, add_attempt
	# GETS USER NUMBER
	lw t0, 4(sp) # t0 = user number
	xor a0, a0, a0 # Resets
	add a0, a0, t0
	# GETS RAND
	lw t1, 8(sp) # t1 = rand_int
	xor a1, a1, a1 # Resets
	add a1, a1, t1
	# VERIFY NUMBER
	jal ra, verify_number # (0 ==, 1 <, 2 >)
	xor t0, t0, t0 # Resets
	bne a0, t0, inner_loop

	# PRINTS NUMBER OF ATTEMPTS
	la a0, n_attempts_message
	addi a7, zero, 4
	ecall

	lw a0, 0(sp)
	addi a7, zero, 1
	ecall

	# DELETES STACK FRAME AND RECOVERS RA
	addi sp, sp, 12
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

add_attempt:
	# STORE PARAMETERS AND RA IN STACK
	addi sp, sp, -12
	sw ra, 8(sp) # sp+4 = ra
	xor t0, t0, t0
	sw t0, 4(sp) # sp+4 = new heap addr
	sw a0, 0(sp) # a0 = user number
	
	# ASKS FOR HEAP ALLOCATION
	addi a0, zero, 8 # [number][next_addr]
	addi a7, zero, 9
	ecall
	
	# SAVES HEAP ADDR IN STACK
	sw a0, 4(sp)
	
	# VERIFY IF HEAD == NULL
	la t0, lkd_list_head # gets lkd_list_head addr
	lw t0, 0(t0) # gets heap addr
	bnez t0, add_attempt_tail # Verify if heap addr != NULL
	
	# IF NULL, ALLOCATE HEAD == TAIL == Allocated
	lw t0, 4(sp) # Gets new heap addr from stack
	la t1, lkd_list_head
	sw t0, 0(t1) # Saves new heap addr
	la t1, lkd_list_tail
	sw t0, 0(t1) # Saves new heap addr
	
	# SAVING NUMBER IN HEAP ADDR
	lw t1, 0(sp) # Number from stack
	sw t1, 0(t0) # Saves number in heap
	xor t1, t1, t1 # Resets
	sw t1, 4(t0) # Next = NULl

	j add_attempt_end

add_attempt_tail:
	# NEW TAIL
	lw t0, 4(sp) # Gets new heap addr
	# UPDATES TAIL->NEXT
	la t1, lkd_list_tail
	lw t1, 0(t1) # Gets old tail heap addr
	sw t0, 4(t1) # oldtail.next = new heap addr
	# UPDATES TAIL
	la t1, lkd_list_tail
	sw t0, 0(t1)

	# SAVES USER NUMBER
	lw t1, 0(sp)
	sw t1, 0(t0)
	xor t1, t1, t1 # Resets
	sw t1, 4(t0) # next = NULl
	
add_attempt_end:
	# DELETES STACK FRAME AND RECOVERS RA
	addi sp, sp, 8
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

verify_number:
	# STORES PARAMEMTERS AND RA IN STACK
	addi sp, sp, -12
	sw ra, 8(sp)
	sw a0, 4(sp) # a0 = user number
	sw a1, 0(sp) # a1 = reference number

	# Saves (a0, a1) to (t0, t1)
	lw t0, 4(sp)
	lw t1, 0(sp)

	# Verify a0 < a1 (1 if True, 0 if False)
	slt t3, t0, t1
	
	xor t4, t4, t4 # Resets to zero
	beq t3, t4, verify_number_gt

	# PRINTS LESS THAN MESSAGE
	la a0, lt_message
	addi a7, zero, 4
	ecall

	# RETURN PARAMETER
	addi a0, zero, 1
		
	j verify_number_exit

verify_number_gt:
	# Verify a0 > a1 (1 if True, 0 if False)
	slt t3, t1, t0 # a0

	beq t3, t4, verify_number_eq

	# PRINTS GREATER THAN MESSAGE
	la a0, gt_message
	addi a7, zero, 4
	ecall

	# RETURN PARAMETER
	addi a0, zero, 2

	j verify_number_exit

verify_number_eq:
	# PRINTS EQ MESSAGE
	la a0, eq_message
	addi a7, zero, 4
	ecall

	# RETURN PARAMETER
	addi a0, zero, 0

verify_number_exit:
	# DELETES STACK FRAME AND RECOVERS RA
	addi, sp, sp, 8
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

end:
	addi a7, zero, 10
	ecall
