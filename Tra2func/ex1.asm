# laço for:
# 1) inicializar variáveis
# 2) testar condição de
# parada
# 3) corpo do laço
# 4) atualizar variável de
# controle
# 5) voltar para o teste de
# condição de parada
    .data
frase:		.string     "determinada frase aqui consta" # 12 vogais (dtrmnd frs q cnst)
print_1:    .string     "A contagem de aeiou é igual a: "
print_2:    .string     "\n"
print_3:    .string     "A nova frase é: "
frase_nova: .string     ""
vogais_m:   .string     "aeiou"
    .text
main:
    addi t0, zero, 5 # indice vogais
    addi t1, zero, 0 # indice inicial das vogais
    addi t2, zero, 29 # indice caracteres da string
    addi t3, zero, 0 # indice inicial da string
    addi s0, zero, 0 # contagem de vogais
    la a0, frase
    la a1, vogais_m

    jal conta_vogais
    jal elimina_vogais
    j fim

conta_vogais:
    lb a2, 0(a0) # carrega a0 em a2 - frase
    lb a3, 0(a1) # carrega a1 em a3 - vogal
    teste_condicao_c:
        beq  t3, t2, fim_c  # =
    corpo_laco_c:
        beq a2, a3, conta_vogais_c # =
        j incremento_controle_c
    conta_vogais_c:
        addi s0, s0, 1 # contagem de vogais
    incremento_controle_c:
        addi a0, a0, 1 # frase
        addi t3, t3, 1 # indice inicial da string
        j conta_vogais
    fim_c:
        addi a1, a1, 1 # vogal 
        addi t1, t1, 1 # indice inicial das vogais
        beq t1, t0, print_c # =
        la a0, frase
        addi t3, zero, 1 # indice inicial da string
        j conta_vogais
    print_c:
        la a0, print_1 # "A contagem de aeiou é igual a: "
        li a7, 4    # printa string
        ecall

        add a0, zero, s0 # contagem
        li a7, 1    # printa inteiro
        ecall

        la a0, print_2
        li a7, 4
        ecall

        addi t1, zero, 0 # indice inicial das vogais
        addi t3, zero, 0 # indice inicial da string
        ret

elimina_vogais:
    la a0, frase
    la a4, frase_nova
    teste_condicao_vog:
        beq t3, t2, fim_vog
    corpo_laco_vog: # testei de diversas formas e não consegui certo com 3 loops, então esse conceito de if é melhor
        la a1, vogais_m
        lb a2, 0(a0) # carrega a0 em a2 - frase

        lb a3, 0(a1) # carrega a1 em a3 - vogal - a
        beq a2, a3, incremento_controle_vog
        addi a1, a1, 1
        lb a3, 0(a1) # carrega a1 em a3 - vogal - e
        beq a2, a3, incremento_controle_vog
        addi a1, a1, 1
        lb a3, 0(a1) # carrega a1 em a3 - vogal - i
        beq a2, a3, incremento_controle_vog
        addi a1, a1, 1
        lb a3, 0(a1) # carrega a1 em a3 - vogal - o
        beq a2, a3, incremento_controle_vog
        addi a1, a1, 1
        lb a3, 0(a1) # carrega a1 em a3 - vogal - u
        beq a2, a3, incremento_controle_vog
        j salva
    salva:
        sb a2, 0(a4)
        addi a4, a4, 1
    incremento_controle_vog:
        addi t3, t3, 1
        addi a0, a0, 1
        j teste_condicao_vog
    fim_vog:
        la a0, print_3 # "A nova frase é: "
        li a7, 4    # printa string
        ecall

        la a0, frase_nova # "dtrmnd frs q cnst"
        li a7, 4    # printa string
        ecall

        la a0, print_2
        li a7, 4
        ecall

        ret
fim:
    nop