    .data
matriz:     .word     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
recorde:    .word     0,0,0
voce:       .word     0,0,0,0,0
situacaojogo_msg:   .string     "A suasitução de jogo atual se encotra da forma:\n"
recorde_msg: .string     "Recorde\n"
voce_msg:   .string     "Você\n"
tiros_msg:    .string    "\tTiros: "
acertos_msg:  .string    "\tAcertos: "
afundados_msg:  .string     "\tAfundados: "
ultimotiro_msg:    .string     "\tÚltimo Tiro: "
navios1:     .string     "4\n0 4 1 1 \n0 4 3 0 \n1 2 7 3 \n1 5 3 5 " # disposicao, comprimento, linha inicial, coluna inicial
navios2:     .string     "2\n0 5 2 1 \n1 4 2 4 " # posicao invalida de teste
navios3:     .string     "1\n0 7 0 4 " # comprimento invalido de teste
# matriz_tiro: .string     ""
# navio:      .string     "ABCDEFGHIO¤"
msg_1:      .string     "Escolha o conjunto de posicionamento dos navios (1, 2 ou 3): "
invalida_fora:      .string     "Posição inválida por estar fora da matriz"
invalida_sobreposto:  .string    "Posição inválida por estar sobreescrevendo navio existente"
invalida_maior:       .string     "Posição inválida pois o navio é maior que a matriz"
msg_2:      .string     "Bem vindo à batalha naval!\n"
menu_jogo:       .string     "O que deseja fazer agora?\n0 - Reiniciar o game\n1 - Mostrar o estado da matriz, recorde e sua situação no jogo\n2 - Fazer uma jogada\n$ "
tiro:       .string     "Insira as posições de tiro (linha coluna): "
br_n:       .string     "\n"
space:      .string     " "
    .text
main:
    jal insere_embarcacoes
    jal printa_matriz
    j fim
insere_embarcacoes:
    la a0, msg_1
    li a7, 4
    ecall

    li a7, 5 # a0 é o int
    ecall
    
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
    
    la a0, br_n
    li a7, 4
    ecall

    continua_ins:
    addi s11, zero, 1 # contagem barco
    # add t1, zero, zero # para navios diposicao horizontal
    # addi t2, zero, 1 # para navios disposição vertical

    la a2, matriz # a2 navios
    lw a3, (a2) # matriz onde vai os navios
    lb a4, (a1) # string com a descricao dos navios

    addi a4, a4, -48
    add t0, a4, zero # contagem de navios

    addi a1, a1, 2
    addi s9, zero, 32 # espaco na tabela ascii
    teste_condicao_ins:
        beq t0, zero, fim_ins
    corpo_laco_ins:
        lb a4, (a1) # string com a descricao dos navios
        addi a4, a4, -48
        add a5, a4, zero # disposicao do navio
        
        addi a1, a1, 2
        lb a4, (a1) # string com a descricao dos navios
        addi a4, a4, -48
        addi t3, a4, 0 # comprimento do navio


        addi a1, a1, 2
        lb a4, (a1) # string com a descricao dos navios
        addi a4, a4, -48
        addi t4, a4, 0 # linha do navio
        addi a1, a1, 1
        lb a4, (a1)
        bne a4, s9, pos_invalida # erro de pos invalida

        addi a1, a1, 1
        lb a4, (a1)
        addi a4, a4, -48
        addi t5, a4, 0 # coluna do navio | t0 = contagem de navios, t3 = comprimento do navio, t4 = linha, t5 = coluna
        addi a1, a1, 1
        lb a4, (a1)
        bne a4, s9, pos_invalida # erro de pos invalida

        # Deslocamento = (L * QTD_colunas + C) * 4
        addi t6, zero, 10
        addi s3, zero, 4
        mul s0, t4, t6 # multiplicação da linha por 9(número de colunas da matriz)
        add s1, s0, t5 # soma de s0 com a coluna
        mul s0, s1, s3 # resultado final do deslocamento 

        add a2, a2, s0
        
        teste_condicao_ins_h:
            beq t3, zero, fim_ins_h
        corpo_laco_ins_h:
            lw a3, (a2)
            bne a3, zero, sobre_invalido
            sw s11, (a2)
        incremento_controle_ins_h:
            addi t3, t3, -1
            beq a5, zero, horizontal_ins # beq a5, t2, vertical_ins
            j vertical_ins
            # se for horizontal = coluna inicial + comprimento do navio >9 invalido
            # se for vertical = linha inical + comprimento do navio >9 invalido
            horizontal_ins:
                add s8, t5, t3
                addi s7, zero, 9
                blt s7, s8, comp_invalido

                addi a2, a2, 4
                j continua_ins_h
            vertical_ins:
                add s8, t4, t3
                addi s7, zero, 9
                blt s7, s8, comp_invalido

                addi a2, a2, 40 # mesmo que 4 * 10 posições
            continua_ins_h:
                j teste_condicao_ins_h
        fim_ins_h:
            addi s11, s11, 1
            # j teste_condicao_ins

    incremento_controle_ins:
        addi t0, t0, -1
        addi a1, a1, 2
        la a2, matriz
        j teste_condicao_ins
    fim_ins:
        ret
    pos_invalida:
        la a0, invalida_fora
        li a7, 4
        ecall

        la a0, br_n
        li a7, 4
        ecall

        add s10, zero, ra
        jal zera_matriz
        add ra, zero, s10
        j fim
        # ret
    comp_invalido:
        la a0, invalida_maior
        li a7, 4
        ecall

        la a0, br_n
        li a7, 4
        ecall

        add s10, zero, ra
        jal zera_matriz
        add ra, zero, s10
        j fim
        # ret

    sobre_invalido:
        la a0, invalida_sobreposto
        li a7, 4
        ecall

        la a0, br_n
        li a7, 4
        ecall
        
        add s10, zero, ra
        jal zera_matriz
        add ra, zero, s10
        j fim
        # ret

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
        li a0, 32 # código ascii do espaço
        li a7, 11 # printa char
        ecall
    corpo_laco_prin:
        lb a0, (a1)
        addi a0, a0, 64
        addi a2, zero, 96
        blt a2, a0, printa_atingido # printa posições atingidas e tiros na água
        j printa_agua
        printa_agua:
            li a0, 64
            li a7, 11
            ecall
            j continua_prin
        printa_atingido:
            li a7, 11
            ecall
        continua_prin:
        la a0, 10 # código ascii do \n
        li a7, 11 # printa char
        ecall

    incremento_controle_prin:
        addi a1, a1, 4
        addi t0, t0, 1
        addi t2, t2, 1
        j teste_condicao_prin
    fim_prin:
        ret

zera_matriz:
    add s2, zero, zero # quando chegar em 100, termina
    addi s3, zero, 100 
    la s1, matriz
    teste_condicao_zen:
        beq s2, s3, fim_zen
    corpo_laco_zen:
        sw zero, (s1)
    incremento_controle_zen:
        addi s1, s1, 4
        addi s2, s2, 1
        j teste_condicao_zen
    fim_zen:
        ret
jogo:
    la a0, msg_2
    li a7, 4
    ecall

    addi t1, zero, 1
    teste_condicao_jogo:
        beq s11, zero, fim_jogo
    corpo_laco_jogo:
        la a0, menu_jogo
        li a7, 4
        ecall
        li a7, 5
        ecall # a0 é o int
        la a0, br_n
        li a7, 4
        ecall

        beq a0, zero, reinicia
        beq a0, t1, mostra_mat
        j jogada

        reinicia:
            add s10, zero, ra
            jal zera_matriz # limpa as alterações da matriz
            jal insere_embarcacoes # insere novamente podendo escolher um novo conjunto de barcos
            add ra, zero, s10
            j incremento_controle_jogo

        mostra_mat:
            add s10, zero, ra
            jal printa_situacao
            jal printa_matriz
            li a0, 10
            li a7, 11
            ecall
            add ra, zero, s10
            j incremento_controle_jogo

        jogada:
            add s10, zero, ra
            jal jogar
            add ra, zero, s10

    incremento_controle_jogo:
        j teste_condicao_jogo
    fim_jogo:
        ret

printa_situacao:
    la a0, situacaojogo_msg
    li a7, 4
    ecall

    la a0, recorde_msg
    li a7, 4
    ecall

    la a0, tiros_msg
    li a7, 4
    ecall
    la a1, recorde
    lw a0, (a1)
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall

    addi a1, a1, 4
    la a0, acertos_msg
    li a7, 4
    ecall
    lw a0, (a1)
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall

    addi a1, a1, 4
    la a0, afundados_msg
    li a7, 4
    ecall
    lw a0, (a1)
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall
    # ----------------------------------
    la a0, voce_msg
    li a7, 4
    ecall

    la a0, tiros_msg
    li a7, 4
    ecall
    la a1, voce
    lw a0, (a1)
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall

    addi a1, a1, 4
    la a0, acertos_msg
    li a7, 4
    ecall
    lw a0, (a1)
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall

    addi a1, a1, 4
    la a0, afundados_msg
    li a7, 4
    ecall
    lw a0, (a1)
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall

    addi a1, a1, 4
    la a0, ultimotiro_msg
    li a7, 4
    ecall
    lw a0, (a1)
    li a7, 1
    ecall
    li a0, 32
    li a7, 11
    ecall
    addi a1, a1, 4
    lw a0, (a1)
    li a7, 1
    ecall
    li a0, 10
    li a7, 11
    ecall

    ret
jogar:
    la a0, tiro
    li a7, 4
    ecall
    li a1, 3
    li a7, 8 # vamos ler uma string
    ecall # a0 é a string
    add a1, a0, zero
    li a0, 10
    li a7, 11
    ecall # pula a linha

    addi t2, zero, 10
    addi t3, zero, 4
    lb a2, (a1) # linha
    addi a2, a2, -48 # a2 linha
    addi a1, a1, 2 # pulamos para a coluna
    lb a3, (a1) # coluna
    addi a3, a3, -48 # a3 coluna

    # Deslocamento = (L * QTD_colunas + C) * 4
    mul a2, a2, t2
    add a2, a2, a3
    mul s0, a2, t3 # resultado de deslocamento em s0
    add s9, zero, s10 # salva o deslocamento para na próxima limpar a posição do tiro

    la a1, matriz
    add a1, zero, s0
    lw a2, (a1)
    bne a2, zero, barco_atingido
    addi a2, zero, 48 # representa o "o" após a soma com 64 feita na hora da função de print
    sw a2, (a1)
    ret
    barco_atingido:
        addi a2, a2, 33
        ret

fim:
    nop