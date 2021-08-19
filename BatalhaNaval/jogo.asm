    .data
navio:      .string     "ABCDEFGHIJK"
navios1:     .string     "3\n0 3 1 1\n0 3 3 0\n1 1 7 3\n1 4 3 5"
navios2:     .string     ""
navios3:     .string     ""
msg_1:      .string     "Escolha o conjunto de posicionamento dos navios (1, 2 ou 3): "
br_n:       .string     "\n"
matriz:     .string     "**********\n**********\n**********\n**********\n**********\n**********\n**********\n**********\n**********\n**********\n"
matriz_tiro: .string     "**********\n**********\n**********\n**********\n**********\n**********\n**********\n**********\n**********\n**********\n"
    .text
main:
    la a2, matriz
    la a3, matriz_tiro
    jal insere_embarcacoes
    j fim
insere_embarcacoes:
    la a0, msg_1
    li a7, 4
    ecall

    li a7, 5 # a0 é o int
    ecall
    jal quebra

    addi t0, zero, 1
    beq a0, t0, carrega1
    addi t0, zero, 2
    beq a0, t0, carrega2
    addi t0, zero, 3
    beq a0, t0, carrega3
    carrega1:
        la a1, navios1
        j corpo
    carrega_2
        la a1, navios2
        j corpo
    carrega3:
        la a1, navios3
        j corpo # 
    teste_condicao_c:
    corpo_laco_c:
    incremento_controle_c:
    fim_c:

quebra: # só pra dar quebra de linha de forma mais limpa = \n
    la a0, br_n
    li a7, 4
    ecall
    ret

fim:
    nop