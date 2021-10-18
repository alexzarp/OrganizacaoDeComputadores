import random as rd
# from random import randrange

class CelulaMemoria(object):
    def __init__(self): # construtor 
        self.__dado = '00000000'
        self.__linha = '0000000'

    def setDado(self, dado):
        if len(dado) <= 8:
            self.__dado = dado
        self.__completaBits(opcao = 'dado')

    def setLinha(self, linha):
        if len(linha) <= 7:
            self.__linha = linha
        self.__completaBits(opcao = 'linha')

    def getDado(self):
        return self.__dado

    def getLinha(self):
        return self.__linha

    def __completaBits(self, opcao):
        if opcao == 'dado':
            if len(self.__dado) != 8:
                diferenca = 8 - len(self.__dado)
                bits = ''
                for i in range(diferenca):
                    bits = bits + '0'
                self.__dado = bits + self.__dado

        elif opcao == 'linha':
            if len(self.__linha) != 7:
                diferenca = 7 - len(self.__linha)
                bits = ''
                for i in range(diferenca):
                    bits = bits + '0'
                self.__linha = bits + self.__linha

class BlocoMemoria(object):
    def __init__(self):
        self.__celula = []
        self.__rotulo = '00000'

    def setBloco(self, bloco):
        self.__celula = bloco
        
    def addCelula(self, celula):
        if len(self.__celula) < 4:
            self.__celula.append(celula)
    
    def setRotulo(self, rotulo):
        if len(rotulo) <= 5:
            self.__rotulo = rotulo
        self.__completaBits()
    
    def __completaBits(self):
        if len(self.__rotulo) != 5:
            diferenca = 5 - len(self.__rotulo)
            bits = ''
            for i in range(diferenca):
                bits = bits + '0'
            self.__rotulo = bits + self.__rotulo
    
    def getRotulo(self):
        return self.__rotulo
    
    def getCelula(self):
        return self.__celula

class ConjuntoCache(object):
    def __init__(self):
        self.__conjunto = []
    
    def getConjunto(self):
        return self.__conjunto
    
    def addConjunto(self, conjunto):
        self.__conjunto.append(conjunto)

class LinhaCache(object):
    def __init__(self):
        self.__rotulo = '00000'
        self.__valido = '0'
        self.__fifo = '000' # contador FIFO
        self.__bloco = []
    
    def getRotulo(self):
        return self.__rotulo
    
    def getValido(self):
        return self.__valido
    
    def getFifo(self):
        return self.__fifo
    
    def getBloco(self):
        return self.__bloco
        
    def setBloco(self, bloco):
        # self.__bloco = bloco
        self.__bloco = []
        self.__bloco.append(bloco)
    
    def setRotulo(self, rotulo):
        if len(rotulo) <= 5:
            self.__rotulo = rotulo
        self.__completaBits(opcao = 'rotulo')

    def incrementaFifo(self):
        fifo = int(self.__fifo, 2)
        fifo+=1
        fifo = str(format(fifo, "b"))
        self.__fifo = fifo
        self.__completaBits(opcao = 'fifo')
    
    def setValido(self, valido):
        self.__valido = valido

    def __completaBits(self, opcao):
        if opcao == 'rotulo':
            if len(self.__rotulo) != 5:
                diferenca = 5 - len(self.__rotulo)
                bits = ''
                for i in range(diferenca):
                    bits = bits + '0'
                self.__rotulo = bits + self.__rotulo
        
        elif opcao == 'fifo':
            if len(self.__fifo) != 3:
                diferenca = 3 - len(self.__fifo)
                bits = ''
                for i in range(diferenca):
                    bits = bits + '0'
                self.__fifo = bits + self.__fifo

def incrementaFifo(cache, conjuntoDestino):
    conjunto = cache[conjuntoDestino].getConjunto()
    for linha_cache in range(len(conjunto)):
        conjunto[linha_cache].incrementaFifo()
# 2 conjuntos
# 4 linhas dentro do conjunto
# 1 bloco dentro da linha
# 4 celulas dentro do bloco
def insereCache(cache):
    for conjunto_cache in range(2):
        conjunto = ConjuntoCache()
        for linha_cache in range(4):
            linha = LinhaCache()
            bloco = BlocoMemoria()
            celula = CelulaMemoria()
            for celula_memoria in range(4):
                bloco.addCelula(celula)
            linha.setBloco(bloco)
            conjunto.addConjunto(linha)
        cache.append(conjunto)

    return cache

def encheMemoria(memoria):
    contador = 0
    contBloco = 0
    for bloco_memoria in range(32):
        bloco = BlocoMemoria()
        bloco.setRotulo(str(format(contBloco, "b")))
        contBloco+=1

        for celula_memoria in range(4):
            celula = CelulaMemoria()
            celula.setDado(str(format(rd.randrange(256), 'b')))
            celula.setLinha(str(format(contador, 'b')))
            contador+=1
            bloco.addCelula(celula)

        memoria.append(bloco)

    return memoria

# 2 conjuntos
# 4 linhas dentro do conjunto
# 1 bloco dentro da linha
# 4 celulas dentro do bloco
    
def buscaEnderecoCache(cache, memoria):
    retorno = False
    endereco = int(input("Digite um endereço em decimal no intervalo de 0 a 128 " ))
    if endereco < 128 or endereco > 0:
        endereco = conversor(endereco,'dpb')
        endereco = completaEndereco(endereco)
        #print(endereco)
    for conjunto in cache:
        for i, linha in enumerate(conjunto.getConjunto()):
            for bloco in linha.getBloco():
                if linha.getRotulo() == endereco[0:5] and linha.getValido() == str(1):
                    bloco = linha.getBloco()
                    #print("Bloco", bloco)
                    celula = bloco.getCelula()
                    retorno = True
                    print("Esta na cache \n Linha da Cache: {}, Bloco Rotulo {}, Linha do endereco {}, Endereco {}, Dado{} ".format(i, linha.getRotulo(),endereco[-2::], celula.getLinha(), celula.getDado() ))
                    break
   
    if not retorno:
        print("Não foi encontrado na cache")
        print("\n")
        print("Procurando na memória")
        buscaMemoria(memoria, endereco)
        colocaNaCache(cache, memoria, endereco)
              
                          
def completaEndereco(endereco):
    if len(endereco) != 7:
       sub = 7 - len(endereco)
       add = "".join(['0' for i in range(sub)])
       endereco = add + endereco
    return endereco

def completaValor(valor):
    if len(valor) != 8:
       sub = 8 - len(valor)
       add = "".join(['0' for i in range(sub)])
       valor = add + valor
    return valor



def buscaMemoria(memoria, endereco):
    for bloco in memoria:
        if bloco.getRotulo() == endereco[0:5]:
            print("Encontrado na cache: endereço {} bloco {}".format(endereco, bloco.getRotulo()))
            break
    return bloco

    # cojunto = getConjunto()
    # linhaDaCache = cojunto[0].getLinha()
    # bloco = linhaDaCache[0].getBloco()
    # celula = bloco[0].getCelula()

def conversor(numero, modo):
    if modo == 'bpd':
        numero = int(numero, 2)
        
    elif modo == 'dpb':
        numero = str(format(numero, 'b'))

    return numero

def colocaNaCache(cache, memoria, endereco):
    print('Entrou na coloca')
    for bloco in memoria:
        if memoria[bloco].getRotulo() == endereco:
            conjunto = []
            if endereco[-2] == '0':
                conjunto = cache[0].getConjunto()
                incrementaFifo(cache, 0)
            else:
                conjunto = cache[1].getConjunto()
                incrementaFifo(cache, 1)
            maiorFifo = 0
            for linha in conjunto:
                if conversor(conjunto[linha].getFifo(), 'bpd') > maiorFifo:
                    maiorFifo =  conversor(conjunto[linha].getFifo(), 'bpd')
            for linha in conjunto: # coloquei na memória no retorno
                if conversor(conjunto[linha].getFifo(), 'bpd') == maiorFifo:
                    blocoCache = conjunto[linha].getBloco()
                    for blocoMemo in memoria:
                        if blocoCache.getRotulo() == memoria[blocoMemo].getRotulo():
                            memoria[blocoMemo].setBloco(blocoCache.getCelula())
                            break
                    break
            for linha in conjunto: # coloca na cache no lugar do fifo mais alto
                if conversor(conjunto[linha].getFifo(), 'bpd') == maiorFifo:
                    conjunto[linha].setBloco(memoria[bloco].getBloco())
                    break
            break
            
def escreve(cache, memoria):
    # print()
    endereco = int(input("Digite um endereço em decimal no intervalo de 0 a 128: "))
    if endereco < 128 or endereco > 0:
        endereco = conversor(endereco,'dpb')
        endereco = completaEndereco(endereco)
    # print()
    valor  = int(input("Digite o valor em decimal no intervalo de 0 a 256: "))
    if valor < 128 or valor > 0:
        valor = conversor(valor,'dpb')
        valor = completaValor(valor)
    
    if endereco[-2] == '0':
        conjunto = cache[0]
    else:
        conjunto = cache[1]

    restart = True
    while restart:
        cont = 0
        # print('ab')
        for linha in conjunto.getConjunto():
            if linha.getRotulo() == endereco[0:5]:
                bloco = linha.getBloco()
                print(bloco.getRotulo())
                celulas = bloco.getCelula()
                for celula in celulas:
                    if endereco == celula.getLinha():
                        celula.setDado(valor)
                        break
                restart = False
                break
            elif cont != 4:
                # print(cont)
                cont+=1
                continue
            else:
                print('teste')
                colocaNaCache(cache, memoria, endereco)
                break
        
    
####### print memoria
def printMemoria(memoria):
    for bloco in memoria:
        print("Bloco", bloco.getRotulo())
        for celula in bloco.getCelula():
            print("Linha {} - Dado: {}".format(celula.getLinha(), celula.getDado()))
        print("\n")
####### print cache
def printCache(cache):
    conjunto_ = 0
    for conjunto in cache:
        print('Conjunto:', conjunto_, '=====================')
        for linha in conjunto.getConjunto():
            print("Endereço {} \t Valido {} \t Fifo: {} \t ". format(linha.getRotulo(), linha.getValido(), linha.getFifo()))
            for bloco in linha.getBloco():
                for celula in bloco.getCelula():
                    print("Linha: {} - Dado: {}".format(celula.getLinha(), celula.getDado()))
        conjunto_+=1

# def printBloco(bloco):
#     for celula in bloco.getCelula():
#         print("Linha: {} - Dado: {}".format(celula.getLinha(), celula.getDado()))


memoria = []
cache = []
memoria = encheMemoria(memoria)
cache = insereCache(cache)

while(True):
    op = int(input('Escolha a opção do que deseja fazer:\n1 - Ler conteúdo de determinado endereço de memória\n2 - Escrever em determinado endereço de memória\n3 - Mostrar Memória Cache\n4 - Mostrar Memória Principal\n5 - Sair\n$ '))
    if op == 1:
        buscaEnderecoCache(cache, memoria)
    elif op == 2:
        escreve(cache, memoria)
        # escreve na cache
    elif op == 3:
        printCache(cache)
    elif op == 4:
        printMemoria(memoria)
    else:
        break