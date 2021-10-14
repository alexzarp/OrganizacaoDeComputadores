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
def buscaEnderecoCache(cache, endereco):
   pass
        
        
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

def colocaNaCache(cache, memoria, rotulo):
    for bloco in memoria:
        if memoria[bloco].getRotulo() == rotulo:
            conjunto
            if rotulo[-1] == '0':
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
            for linha in conjunto: # coloca na cache no luga do fifo mais alto
                if conversor(conjunto[linha].getFifo(), 'bpd') == maiorFifo:
                    conjunto[linha].setBloco(memoria[bloco].getBloco())
                    break
            break
            
def escreveNaCache(cache, endereco):
    pass

memoria = []
cache = []
memoria = encheMemoria(memoria)
cache = insereCache(cache)
incrementaFifo(cache, 0)