# somatorio_10_100: Fazer um programa em linguagem assembly
# do RISC-V que, através de um laço, realiza a
# soma de todos os valores impares entre 10 e 100.
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
# RESULTADO = 2475
    .data

    .text
main:
    addi s0, zero, 10
    add s1, zero, zero
    addi s2, zero, 101
    addi t2, zero, 2
    jal teste_condicao
teste_condicao:
    blt s0, s2, corpo_laco
    jal fim
corpo_laco:
    rem t1, s0, t2 # testa se gera um resto
    beq t1, zero, par # <-- o problema foi resolvido(aviso ao professor)
    jal impar
par:
    jal incremento_controle
impar:
    add s1, s0, s1
    jal incremento_controle
incremento_controle:
    addi s0, s0, 1
    jal teste_condicao
fim:
	nop
	li a7, 93
	ecall 
