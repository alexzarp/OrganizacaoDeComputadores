# Trabalho feito por:
# Alex Sandro Zarpelon - 1911100039
# Bruna Gabriela Disner - 1911100007
    .data
matriz:     .word     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
controle_barcos:    .word  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
recorde:    .word     99,99,99 # tenho que partir de um valor maior que 0 para comportar a condição de salvamento
voce:       .word     0,0,0,0,0
space:      .space      46
space_4:    .space      4
situacaojogo_msg:   .string     "A sua situção de jogo atual se encotra da forma:\n"
recorde_msg: .string     "Recorde\n"
voce_msg:   .string     "Você\n"
tiros_msg:    .string    "\tTiros: "
acertos_msg:  .string    "\tAcertos: "
afundados_msg:  .string     "\tAfundados: "
ultimotiro_msg:    .string     "\tÚltimo Tiro: "
navios1:     .string     "4\n0 4 1 1 \n0 4 3 0 \n1 2 7 3 \n1 5 3 5 " # disposicao, comprimento, linha inicial, coluna inicial
navios2:     .string     "2\n0 4 1 1 \n0 4 3 0 " # posicao invalida de teste
navios3:     .string     "1\n0 4 1 1 " # comprimento invalido de teste
msg_1:      .string     "Escolha o conjunto de posicionamento dos navios (1, 2 ou 3): "
invalida_fora:      .string     "Posição inválida por estar fora da matriz"
invalida_sobreposto:  .string    "Posição inválida por estar sobreescrevendo navio existente"
invalida_maior:       .string     "Posição inválida pois o navio é maior que a matriz"
msg_2:      .string     "Bem vindo à batalha naval!\n"
menu_jogo:       .string     "O que deseja fazer agora?\n0 - Reiniciar o game\n1 - Mostrar o estado da matriz(espião)\n2 - Fazer uma jogada\n3 - Terminar o jogo\n$ "
tiro:       .string     "Insira as posições de tiro (linha coluna): "
atingiu:    .string     "Barco Atingido!\n"
errou:      .string     "O tiro caiu na água!\n"
afundou:    .string     "Você afundou o barco!\n"
terminou:   .string     "Você venceu! Todos os barcos foram afundados!\n"
# br_n:       .string     "\n"
# space:      .string     " "
    .text
main:
    jal insere_embarcacoes
    jal jogo
    j fim

# a função "insere_embarcações" recebe como parâmetro a "matriz" para inserção dos barcos, 
# "controle_barcos" para registro do comprimento e comprimento de soma total dos barcos para fins de se afudou ou não,
# "navios1", "navios2" e "navios3" que descrevem como os barcos serão colocados na "matriz"
insere_embarcacoes:
    la a0, msg_1
    li a7, 4
    ecall # mostra a mensagem para escolha de um conjunto de barcos

    li a7, 5 # a0 é o int
    ecall # solicita o inteiro
    
    addi t0, zero, 1
    beq a0, t0, carrega1
    addi t0, zero, 2
    beq a0, t0, carrega2
    addi t0, zero, 3
    beq a0, t0, carrega3 # switch que leva para o conjunto de barcos escolhido

    carrega1: # -------
        la a1, navios1
        j continua_ins
    carrega2:
        la a1, navios2
        j continua_ins
    carrega3:
        la a1, navios3
    
    li a0, 10
    li a7, 11
    ecall # ------ continuação do switch de escolha do conjunto de barcos

    continua_ins:
    addi s11, zero, 1 # contagem barco

    la a2, matriz # a2 navios
    lw a3, (a2) # matriz onde vai os navios
    lb a4, (a1) # string com a descricao dos navios

    addi a4, a4, -48 # toda vez que se faz -48, é para obter o valor absoluto lido da string
    add t0, a4, zero # contagem de navios

    addi a1, a1, 2
    addi s9, zero, 32 # espaco na tabela ascii
    la s6, controle_barcos # para afundamento de barcos
    addi s6, s6, 8
    la s5, controle_barcos # para fim da partida (todos barcos afundados)
    teste_condicao_ins:
        beq t0, zero, fim_ins
    corpo_laco_ins: # nessa parte é um loop que obtem a informação de cada barco da string
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
        bne a4, s9, pos_invalida # invalidação por poscionamento fora da matriz

        addi a1, a1, 1
        lb a4, (a1)
        addi a4, a4, -48
        addi t5, a4, 0 # coluna do navio | t0 = contagem de navios, t3 = comprimento do navio, t4 = linha, t5 = coluna
        addi a1, a1, 1
        lb a4, (a1)
        bne a4, s9, pos_invalida # invalidação por poscionamento fora da matriz

        sw t3, (s6)
        addi s6, s6, 8 # informações úteis para controlarmos quando um barco será afundado

        # Deslocamento = (L * QTD_colunas + C) * 4
        # com os dados obtidos, calculamos e deslocamos para a posição inicial correta na matriz
        addi t6, zero, 10
        addi s3, zero, 4
        mul s0, t4, t6 # multiplicação da linha por 9(número de colunas da matriz)
        add s1, s0, t5 # soma de s0 com a coluna
        mul s0, s1, s3 # resultado final do deslocamento 

        add a2, a2, s0
        
        teste_condicao_ins_h: # este loop é responsável inserir o barco conforme seu comprimento e diposição
            beq t3, zero, fim_ins_h
        corpo_laco_ins_h:
            lw a3, (a2)
            bne a3, zero, sobre_invalido # aqui é validado se o barco não sobreescreve outro já existente
            sw s11, (a2)
            lw s4, (s5) 
            addi s4, s4, 1
            sw s4, (s5) # estou contando as posições do barco para no final saber quando o jogo terminou
        incremento_controle_ins_h:
            addi t3, t3, -1
            beq a5, zero, horizontal_ins
            j vertical_ins
            # se for horizontal = coluna inicial + comprimento do navio >9 invalido
            # se for vertical = linha inical + comprimento do navio >9 invalido
            horizontal_ins:
                add s8, t5, t3
                addi s7, zero, 10
                blt s7, s8, comp_invalido # testamos se o comprimeto rompre a matriz

                addi a2, a2, 4
                j continua_ins_h
            vertical_ins:
                add s8, t4, t3
                addi s7, zero, 10
                blt s7, s8, comp_invalido # testamos se o comprimeto rompre a matriz

                addi a2, a2, 40 # mesmo que 4 * 10 posições
            continua_ins_h:
                j teste_condicao_ins_h
        fim_ins_h:
            addi s11, s11, 1

    incremento_controle_ins:
        addi t0, t0, -1
        addi a1, a1, 2
        la a2, matriz
        j teste_condicao_ins
    fim_ins:
        ret
    pos_invalida: # aqui é notificada a invalidação por poscionamento fora da matriz
        la a0, invalida_fora
        li a7, 4
        ecall

        li a0, 10
        li a7, 11
        ecall

        # add s10, zero, ra
        # jal zera_matriz
        # add ra, zero, s10
        j fim
        # ret
    comp_invalido: # aqui é notificada a invalidação por comprimento rompendo a matriz
        la a0, invalida_maior
        li a7, 4
        ecall

        li a0, 10
        li a7, 11
        ecall

        # add s10, zero, ra
        # jal zera_matriz
        # add ra, zero, s10
        j fim
        # ret

    sobre_invalido: # aqui é notificada a invalidação por sobreposição do barco
        la a0, invalida_sobreposto
        li a7, 4
        ecall

        li a0, 10
        li a7, 11
        ecall
        
        # add s10, zero, ra
        # jal zera_matriz
        # add ra, zero, s10
        j fim
        # ret

# a função "printa_matriz_padrao" recebe como parâmetro a "matriz",
# à partir da matriz imprime os barcos atingidos e os tiros na água com base em uma soma que resulta em letras na tabela ASCII,
# "o" reprenta um tira na água, "a" ou "b" etc, reoresentam o respectivo barco e sua posição atingida
printa_matriz_padrao:
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
        li a0, 10 # código ascii do espaço
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
        li a0, 32 # código ascii do espaco
        li a7, 11 # printa char
        ecall

    incremento_controle_prin:
        addi a1, a1, 4
        addi t0, t0, 1
        addi t2, t2, 1
        j teste_condicao_prin
    fim_prin:
        ret

# a função "printa_matriz_espiao" recebe como parâmetro a "matriz",
# é reposnsável por printar tudo o que está na matriz se esconder nada, com base em soma na tabela ASCII gerando letras,
# "o" reprenta um tira na água, "a" ou "b" etc, reoresentam o respectivo barco e sua posição atingida,
# "A" ou "B" etc, representam um barco flutuante não atingido na determina posição
printa_matriz_espiao:
    add t0, zero, zero # quando chegar em 100, termina
    addi t1, zero, 100 
    add t2, zero, zero # a cada 10, um \n
    addi t3, zero, 10
    la a1, matriz
    teste_condicao_esp:
        beq t0, t1, fim_esp
        beq t2, t3, pula_esp
        j corpo_laco_esp
    pula_esp:
        add t2, zero, zero
        li a0, 10
        li a7, 11
        ecall
    corpo_laco_esp:
        lw a0, (a1)
        addi a0, a0, 64
        li a7, 11
        ecall

        li a0, 32
        li a7, 11
        ecall

    incremento_controle_esp:
        addi a1, a1, 4
        addi t0, t0, 1
        addi t2, t2, 1
        j teste_condicao_esp
    fim_esp:
        ret
# a função "zera_matriz" recebe como parâmetro a "matriz",
# é reposável por fazer a limpeza de todos os barcos para que uma novo jogo com novos barcos seja iniciado futuramente
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
# a função "zera_voce" recebe como parâmetro a .word "voce",
# responsável por zerar suas estatíticas de jogo ao final de uma partida, para dar espaço para uma nova partida futura
zera_voce:
    la s0, voce
    sw zero, (s0)
    addi s0, s0, 4
    sw zero, (s0)
    addi s0, s0, 4
    sw zero, (s0)
    addi s0, s0, 4
    ret

# a função "zera_controledebarcos" recebe como parâmetro a .word "controle_barcos",
# responsável por zerar a .word "controle_barcos" para permitir o controle de afundamentos em uma nova partida futura
zera_controledebarcos:
    la s0, controle_barcos
    add t0, zero, zero
    addi t1, zero, 20

    teste_condicao_zera:
        beq t0, t1, fim_zera
    corpo_laco_zera:
        sw zero, (s0)
    incremento_controle_zera:
        addi s0, s0, 4
        addi t0, t0, 1
        j teste_condicao_zera
    fim_zera:
        ret
# a função jogo recebe como parâmetro todos os parâmetros das outras funções, pois ela é um switch de opções,
# para seu uso interno, recebe como parâmetro a .word "voce" e .word "recorde",
# faz o controle de fim de jogo e inicia uma nova partida automaticamente
jogo:
    la a0, msg_2 # mensagem de boas vindas
    li a7, 4
    ecall

    addi t1, zero, 1
    addi t2, zero, 2
    addi s11, zero, 1
    teste_condicao_jogo:
        beq s11, zero, fim_jogo
    corpo_laco_jogo:
        addi t1, zero, 1
        addi t2, zero, 2
        la a0, menu_jogo
        li a7, 4
        ecall
        li a7, 5
        ecall # a0 é o int

        beq a0, zero, reinicia
        beq a0, t1, mostra_mat
        beq a0, t2, jogada
        j sair # switch para uso do jogo

        reinicia: # caso quisermos reiniciar em uma nova partida
            add s10, zero, ra
            jal zera_matriz # limpa as alterações da matriz
            jal zera_voce
            jal zera_controledebarcos
            jal insere_embarcacoes # insere novamente podendo escolher um novo conjunto de barcos
            add ra, zero, s10
            j incremento_controle_jogo

        mostra_mat: # caso quisermos mostrar a matriz em modo espião
            add s10, zero, ra
            jal printa_matriz_espiao
            add ra, zero, s10
            li a0, 10
            li a7, 11
            ecall
            j incremento_controle_jogo

        jogada: # caso quisermos jogar
            add s10, zero, ra
            jal jogar
            add ra, zero, s10
            # verfica o fim abaixo
            la s0, controle_barcos
            lw s2, (s0)
            addi s0, s0, 4
            lw s1, (s0)
            # addi s1, s1, 1
            # sw s1, (s0)
            beq s1, s2, fim_jogo_vitoria
            j incremento_controle_jogo

        sair: # para sair do jogo, simplesmente dropa o programa
            j fim

    incremento_controle_jogo:
        add s10, zero, ra
        jal printa_situacao
        add ra, zero, s10
        j teste_condicao_jogo
    fim_jogo_vitoria: # somos direcionados para cá caso todos barcos tenham sido afundados
        la a0, terminou
        li a7, 4
        ecall
        la s0, voce
        la s1, recorde
        lw s2, (s0)
        lw s3, (s1) # vou usar a menor quantidade de tiros como critério de recorde, foi o que consegui ver como melhor
        blt s2, s3, salva_novo_recorde # se você deu menos tiros que o recorde
        j reinicia

        salva_novo_recorde: # somos direionados para cá caso um novo recorde seja aplicável
            sw s2, (s1)
            addi s0, s0, 4
            addi s1, s1, 4
            lw s2, (s0)
            sw s2, (s1)
            addi s0, s0, 4
            addi s1, s1, 4
            lw s2, (s0)
            sw s2, (s1)
            j reinicia
    fim_jogo:
        ret

# a função "printa_situação" recebe como parâmetro a .word "voce" e .word "recorde", além de todos parâmetros da função,
# "printa_matriz_padrao", é reponsável após, cada jogada, mostrar a pontuação de jogo, recorde e situação de atingimento na matriz
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
    # ----------------------------------
    add s10, zero, ra
    jal printa_matriz_padrao
    add ra, zero, s10

    li a0, 10
    li a7, 11
    ecall

    ret
# a função jogar recebe como parâmetro a .word "voce" e a "matriz",
# é reponsável por solicitar as coordenadas do tiro e executá-las
jogar:
    la a5, voce
    lw a4, (a5)
    addi a4, a4, 1
    sw a4, (a5)

    la a0, tiro
    li a7, 4
    ecall
    la a0, space
    li a7, 4
    ecall
    li a1, 4
    li a7, 8 # vamos ler uma string
    ecall # a0 é a string
    
    add a1, a0, zero
    li a0, 10 # \n na tabela ascii
    li a7, 11 # printar char
    ecall # pula a linha

    addi t2, zero, 10
    addi t3, zero, 4
    lb a2, (a1) # linha
    addi a2, a2, -48 # a2 linha
    addi a1, a1, 2 # pulamos para a coluna
    lb a3, (a1) # coluna
    addi a3, a3, -48 # a3 coluna
    la a5, voce
    addi a5, a5, 12
    lw a4, (a5)
    sw a2, (a5)
    addi a5, a5, 4
    sw a3, (a5)

    # Deslocamento = (L * QTD_colunas + C) * 4
    mul a2, a2, t2
    add a2, a2, a3
    mul s0, a2, t3 # resultado de deslocamento em s0
    # add s9, zero, s10 # salva o deslocamento para na próxima limpar a posição do tiro

    la a1, matriz
    add a1, a1, s0
    lw a2, (a1)
    bne a2, zero, barco_atingido
    addi t6, zero, 32
    bge a2, t6, pula
    addi a2, zero, 47 # representa o "o" após a soma com 64 feita na hora da função de print
    pula:
    la a0, errou
    li a7, 4
    ecall
    sw a2, (a1)
    j fim_jogar
    barco_atingido:
        bge a2, t6, pulaa
        la a0, atingiu
        li a7, 4
        ecall

        la s0, controle_barcos
        addi s0, s0, 4
        lw s1, (s0)
        addi s1, s1, 1
        sw s1, (s0)

        la s0, controle_barcos
        add s1, zero, a2
        addi s2, zero, 8 # usando o proóprio valor do barco, pulamos de duas em duas posições até encontrar o barco certo
        mul s1, s1, s2
        add s0, s0, s1
        lw s1, (s0)
        addi s0, s0, 4
        lw s2, (s0)
        addi s2, s2, 1
        sw s2, (s0)

        addi a2, a2, 32
        sw a2, (a1)
        pulaa:
        la a5, voce
        addi a5, a5, 4
        lw a4, (a5)
        addi a4, a4, 1
        sw a4, (a5)

    fim_jogar:
        beq s1, s2, barco_afundado
        ret

    barco_afundado:
        la a0, afundou
        li a7, 4
        ecall
        la a1, voce
        addi a1, a1, 8 # pulamos para a contagem de afundados
        lw a2, (a1)
        addi a2, a2, 1
        sw a2, (a1)
        ret

# fim é um flag para indicar o encerramento do programa
fim:
    nop