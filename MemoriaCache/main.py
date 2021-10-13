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
        return self.___bloco
        
    def setBloco(self, bloco):
        self.__bloco = bloco
        #self.__bloco.append(bloco)
    
    def setRotulo(self, rotulo):
        if len(rotulo) <= 5:
            self.__rotulo = rotulo
        self.__completaBits(opcao = 'rotulo')
    
    # def setFifo(self, fifo):
    #     if len(fifo) <= 3:
    #         self.__fifo = fifo
    #     self.__completaBits(opcao = 'fifo')

    def incrementaFifo(self):
        fifo = int(self.__fifo, 2)
        fifo+=1
        fifo = str(format(fifo, "b"))
        self.__fifo = fifo
        self.__completaBits(opcao = 'fifo')

    # def zeraFifo(self):
    #     self.__fifo = '000'
    
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
                self.__rotulo = bits + self.__fifo

def incrementaFifo(cache, blocoDestino):
    bloco = []
    bloco.append(cache[blocoDestino].setBloco(bloco))
    # for i in range(4): # sempre será 4, mas enfim
    print(bloco)
        

def insereCache(cache):
    for bloco_cache in range(2):
        linha = LinhaCache()
        bloco = BlocoMemoria()
        for linha_cache in range(4):
            bloco.addCelula(CelulaMemoria())
        linha.setBloco(bloco)
        cache.append(linha) 

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

# def buscaEnderecoCache(cache, endereco):
#     for i, linha in cache:
#         if linha.getRotulo() == endereco[0:5] and linha.getValida() == '1':

memoria = []
cache = []
memoria = encheMemoria(memoria)
print(memoria)
cache = insereCache(cache)
# ler conteudo de um endereço de memoria
# escrever em um determinado endereco de memoria
incrementaFifo(cache, 0)