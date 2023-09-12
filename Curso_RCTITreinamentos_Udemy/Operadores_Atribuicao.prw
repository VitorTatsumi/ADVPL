#INCLUDE 'protheus.ch'

User Function OperadorA()
    //Operadores relacionais, utilizados para retornar um valor lógico (.T. ou .F.)
    LOCAL nVar := 2
    LOCAL nVar1 := 3
    //Operadores de atribuição
    nVar += nVar1 //nVar = nVar + nVar1
    nVar -= nVar1 //nVar = nVar - nVar1
    nVar *= nVar1 //nVar = nVar * nVar1
    nVar /= nVar1 //nVar = nVar / nVar1
    nVar %= nVar1 //nVar = nVar % nVar1
RETURN


