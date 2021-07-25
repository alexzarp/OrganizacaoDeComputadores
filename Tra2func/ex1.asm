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
arroba:     .string     "@"
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

    # jal conta_vogais
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

        addi s0, zero, 0 # contagem de vogais vai ser reutilizada como flag
        addi t1, zero, 0 # indice inicial das vogais
        addi t3, zero, 0 # indice inicial da string
        ret

elimina_vogais:
    lb a2, 0(a0) # carrega a0 em a2 - frase
    lb a3, 0(a1) # carrega a1 em a3 - vogal
    la s0, arroba
    lb s1, 0(s0)
    teste_condicao_r:
        beq  t3, t2, fim_r  # =
    corpo_laco_r:
        beq a2, a3, troca_vogal # =
        j incremento_controle_r
    troca_vogal:
        sb s0, 0(a0)
    incremento_controle_r:
        addi a0, a0, 1 # frase
        addi t3, t3, 1 # indice inicial da string
        j elimina_vogais
    fim_r:
        addi a1, a1, 1 # vogal 
        addi t1, t1, 1 # indice inicial das vogais
        beq t1, t0, print_r # =
        la a0, frase
        addi t3, zero, 1 # indice inicial da string
        j elimina_vogais
    print_r:
        addi t1, zero, 0 # indice inicial das vogais
        addi t3, zero, 0 # indice inicial da string
        la a0, frase
        la a4, frase_nova
        teste_condicao_rr:
            lb a2, 0(a0) # carrega a0 em a2 - frase
            lb a3, 0(a4) # carrega a1 em a4 - frase nova
            beq  t3, t2, fim_rr  # =
        corpo_laco_rr:
            bne s0, a2, salva # =
            j incremento_controle_rr
        salva:
            sb a2, 0(a4)
            addi a4, a4, 1 # indice inicial da string
        incremento_controle_rr:
            addi a0, a0, 1 # frase
            addi t3, t3, 1 # indice inicial da string
            j teste_condicao_rr

        fim_rr:
            la a0, print_3 # "A nova frase é: "
            li a7, 4    # printa string
            ecall

            la a0, frase_nova # "A nova frase é: "
            li a7, 4    # printa string
            ecall

            la a0, print_2
            li a7, 4
            ecall
            ret

fim:
    nop