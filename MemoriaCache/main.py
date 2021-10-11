import random as rd

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
    def inicio(self):
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
    
    def setRotulo(self, rotulo):
        if len(rotulo) <= 5:
            self.__rotulo = rotulo
        self.__completaBits(opcao = 'rotulo')
    
    def setFifo(self, fifo):
        if len(fifo) <= 3:
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
                self.__rotulo = bits + self.__fifo

memoria = []
def encheMemoria(memoria):
    for bloco_memoria in range(32):
        bloco = BlocoMemoria()

        for celula_memoria in range(4):
            celula = CelulaMemoria()
