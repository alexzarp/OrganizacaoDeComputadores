# Fazer um programa em linguagem assembly do RISC-V percorre os elementos de um vetor_A
# presente na memória e contabiliza a quantidade total de valores pares (em a0) e impares (em a1).
# Considere que o vetor_A+ possui 12 elementos.
#
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
vetor_A:        .word   -5, 4, 2, -11, 9, -7, 4, -2, 3, 6, 12, 11 # 6 ímpares e 6 pares
vetor_tam:      .word   12 # 12 números
    .text
main:
    la a2, vetor_A
    lw t0, vetor_tam
    add a0, zero, zero # contagem de pares
    add a1, zero, zero # contagem de ímpares
initi:
    addi t1, zero, 0
    addi t2, zero, 2
teste_condicao:
    bge t1, t0, fim
    lw s0, (a2)
corpo_laco:
    remu t3, s0, t2   # testa se gera um resto
    beq t3, zero, par # testa se par ou impar
    j impar
par:
    addi a0, a0, 1
    j incremento_controle
impar:
    addi a1, a1, 1
    j incremento_controle # nem precisa
incremento_controle:
    addi a2, a2, 4
    addi t1, t1, 1
    j teste_condicao
fim:
	nop