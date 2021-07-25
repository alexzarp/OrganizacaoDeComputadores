	.data

	.text
main:
	addi a0, zero, 4
	addi s0, zero, 2
	addi t0, zero, 2

	andi t0, a0, 1
	beq t0, zero, par
	jal impar
par:
	add s0, zero, zero
	jal fim
impar:
	addi s0, zero, 1
	jal fim
fim:
	nop
	li a7, 93
	ecall 

