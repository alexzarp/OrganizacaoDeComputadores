    .data
print_1:    .string     "Quantos valores inserir?: "
print_2:    .string     "Digite o valor: "
print_3:    .string     "O vetor contem os valores: "
print_vir:  .string     ", "
print_n:    .string     "\n"
vetor:      .word       0 # não sei como começa sem colocar nada, ele dá erro de desalinhamento de memória!
    .text
main:
    add t0, zero, zero # controle de indice
    # t1 contem o tamanho do vetor informado via teclado
    jal preenche_vetor
    jal imprime_vetor
    jal ordena_vetor
    jal imprime_vetor
    j fim
preenche_vetor:
    la a1, vetor

    la a0, print_1
    li a7, 4
    ecall

    li a7, 5 # a0 é o int
    ecall
    add t1, a0, zero 

    la a0, print_n
    li a7, 4
    ecall
    teste_condicao_vec:
        beq t0, t1, fim_vec  # =
    corpo_laco_vec:
        la a0, print_2 # mensagem
        li a7, 4
        ecall

        li a7, 5 # a0 é o int, lendo o numero
        ecall

        sw a0, 0(a1)
        addi a1, a1, 4

        la a0, print_n
        li a7, 4
        ecall
    incremento_controle_vec:
        addi t0, t0, 1
        j teste_condicao_vec
    fim_vec:
        add t0, zero, zero
        ret

imprime_vetor:
    la a1, vetor

    la a0, print_3
    li a7, 4
    ecall
    teste_condicao_imp:
        beq t0, t1, fim_imp  # =
    corpo_laco_imp:
        lw a0, 0(a1)
        li a7, 1    # printa inteiro
        ecall

        la a0, print_vir
        li a7, 4
        ecall
    incremento_controle_imp:
        addi a1, a1, 4
        addi t0, t0, 1
        j teste_condicao_imp
    fim_imp:
        la a0, print_n
        li a7, 4
        ecall

        add t0, zero, zero
        ret
ordena_vetor: # bubblesort
    la a1, vetor
    la a2, vetor
    addi a2, a2, 4
    # t0 controle de indice
    addi t2, t1, -1 # contém o tamanho do vetor -1 a cada iteração completa
    teste_condicao_ord:
        beq t0, t2, fim_ord
    corpo_laco_ord:
        # 2 < 1 
        lw	s2, (a1)
        lw	s3, (a2) # isso aqui fazia parte do swap, porém faz sentido colocar aqui
        blt s2, s3, swap_# < = swap+m
    incremento_controle_ord:
        addi a1, a1, 4
        addi a2, a2, 4
        addi t0, t0, 1
        j teste_condicao_ord
    fim_ord:
        la a1, vetor
        la a2, vetor
        addi a2, a2, 4
        add t0, zero, zero
        addi t2, t2, -1 # <--
        bne t2, t0, teste_condicao_ord
        ret
    swap_: # tentei usar isso como uma função jump and link, porém não sei como fazer isso através do blt, se o professor puder me responder e ensinar como, fico grato!
        sw	s2, (a2)
        sw	s3, (a1)
        j incremento_controle_ord
fim:
    nop