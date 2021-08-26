    .data
matriz:     .word     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
navios1:     .string     "3\n0 3 1 1\n0 3 3 0\n1 1 7 3\n1 4 3 5" # disposicao, comprimento, linha inicial, coluna inicial
navios2:     .string     ""
navios3:     .string     ""
matriz_tiro: .string     ""
navio:      .string     "ABCDEFGHIJK"
msg_1:      .string     "Escolha o conjunto de posicionamento dos navios (1, 2 ou 3): "
invalida_fora:      .string     "Posição inválida por estar fora da matriz"
invalida_sobreposto:  .string    "Posição inválida por estar sobreescrevendo navio existente"
invalida_n:          .string     "Posição inválida pois o navio é maior que a matriz"
br_n:       .string     "\n"
space:      .string     " "
    .text
main:
    # jal insere_embarcacoes
    jal printa_matriz
    j fim
insere_embarcacoes:
    la a0, msg_1
    li a7, 4
    ecall

    li a7, 5 # a0 é o int
    ecall

    add s10, zero, ra
    jal quebra
    add ra, zero, s10

    addi t0, zero, 1
    beq a0, t0, carrega1
    addi t0, zero, 2
    beq a0, t0, carrega2
    addi t0, zero, 3
    beq a0, t0, carrega3
    carrega1:
        la a1, navios1
        j continua_ins
    carrega2:
        la a1, navios2
        j continua_ins
    carrega3:
        la a1, navios3
        # j continua_ins # 

    addi s11, zero, 1 # contagem barco
    continua_ins:
    add t1, zero, zero # para navios diposicao horizontal
    addi t2, zero, 1 # para navios disposição vertical

    la a2, matriz # a2 navios
    lw a3, (a2) # matriz onde vai os navios
    lb a4, (a1) # string com a descricao dos navios

    add s10, zero, ra
    jal altera
    add ra, zero, s10
    add t0, a4, zero # contagem de navios

    addi a1, a1, 2
    teste_condicao_ins:
        beq t0, zero, fim_ins
    corpo_laco_ins:
        lb a4, (a1) # string com a descricao dos navios
        add s10, zero, ra
        jal altera
        add ra, zero, s10
        add a5, a4, zero # disposicao do navio

        addi a1, a1, 2
        lb a4, (a1) # string com a descricao dos navios
        add s10, zero, ra
        jal altera
        add ra, zero, s10
        addi t3, a4, 0 # comprimento do navio

        addi a1, a1, 2
        lb a4, (a1) # string com a descricao dos navios
        add s10, zero, ra
        jal altera
        add ra, zero, s10
        addi t4, a4, 0 # linha do navio

        addi a1, a1, 2
        lb a4, (a1)
        add s10, zero, ra
        jal altera
        add ra, zero, s10
        addi t5, a4, 0 # coluna do navio | t0 = contagem de navios, t3 = comprimento do navio, t4 = linha, t5 = coluna
        # Deslocamento = (L * QTD_colunas + C) * 4

        addi t6, zero, 9
        addi s3, zero, 4
        mul s0, t4, t6 # multiplicação da linha por 9(número de colunas da matriz)
        add s1, s0, t5 # soma de s0 com a coluna
        mul s0, s1, s3 # resultado final do deslocamento 
        
        add a2, a2, s0
        lw a3, (a2)

        # add s10, zero, ra
        # jal verifica_validade
        # add ra, zero, s10
        
        sw s11, (a2)
        addi t3, t3, -1
        teste_condicao_ins_h:
            beq t3, zero, fim_ins_h
        corpo_laco_ins_h:
            sw s11, (a2)
        incremento_controle_ins_h:
            addi t3, t3, -1
            beq a5, t1, horizontal_ins
            beq a5, t2, vertical_ins
            horizontal_ins:
                addi a2, a2, 4
                j continua_ins_h
            vertical_ins:
                addi a2, a2, 40 # mesmo que 4 * 10 posições
            continua_ins_h:
                j corpo_laco_ins_h
        fim_ins_h:
            addi s11, s11, 1
            j teste_condicao_ins

    incremento_controle_ins:
        addi t0, t0, -1
        addi a1, a1, 2
        la a2, matriz
        j teste_condicao_ins
    fim_ins:
        ret

# verifica_validade:
#     add s9, s0, zero # deslocamento
#     add s8, t3, zero
#     teste_condicao_val:
#         beq 
altera: # função cedida pelo Jeferson da dupla Jeferson Krumenauer e Vinícius Todescato
    addi a6,zero,48
    beq a4,a6,troca48
    addi a6,zero,49
    beq a4,a6,troca49
    addi a6,zero,50
    beq a4,a6,troca50
    addi a6,zero,51
    beq a4,a6,troca51
    addi a6,zero,52
    beq a4,a6,troca52
    addi a6,zero,53
    beq a4,a6,troca53
    addi a6,zero,54
    beq a4,a6,troca54
    addi a6,zero,55
    beq a4,a6,troca55
    addi a6,zero,56
    beq a4,a6,troca56
    addi a6,zero,57
    beq a4,a6,troca57
    troca48:
        addi a4,zero,0
        ret
    troca49:
        addi a4,zero,1
        ret
    troca50:
        addi a4,zero,2
        ret
    troca51:
        addi a4,zero,3
        ret
    troca52:
        addi a4,zero,4
        ret
    troca53:
        addi a4,zero,5
        ret
    troca54:
        addi a4,zero,6
        ret
    troca55:
        addi a4,zero,7
        ret
    troca56:
        addi a4,zero,8
        ret
    troca57:
        addi a4,zero,9
        ret

printa_matriz:
    add t0, zero, zero # quando chegar em 100, termina
    addi t1, zero, 100 
    add t2, zero, zero # a cada 10, um \n
    addi t3, zero, 10
    la a1, matriz
    teste_condicao_prin:
        beq t0, t1, fim_prin
        beq t2, t3, pula_prin
        j corpo_laco_prin
    pula_prin:
        add t2, zero, zero
        la a0, br_n
        li a7, 4
        ecall
    corpo_laco_prin:
        lw a0, (a1)
        li a7, 1
        ecall

        la a0, space
        li a7, 4
        ecall
        # j incremento_prin, não precisa chamar pois vai continuar no fluxo do programa- acho
    incremento_controle_prin:
        addi a1, a1, 4
        addi t0, t0, 1
        addi t2, t2, 1
        j teste_condicao_prin
    fim_prin:
        ret


quebra: # só pra dar quebra de linha de forma mais limpa = \n
    la a0, br_n
    li a7, 4
    ecall
    ret

fim:
    nop
