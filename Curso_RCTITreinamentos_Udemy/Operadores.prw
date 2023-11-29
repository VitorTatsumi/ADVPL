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

User Function OperadoresL()
    //Operadores relacionais, utilizados para retornar um valor lógico (.T. ou .F.)
    LOCAL nVar := 2
    LOCAL nVar1 := 3
   //Será feito o teste lógico dos elementos e o MSGALERT irá exibir o resultado lógico 
    MSGALERT( nVar1 < nVar )
    MSGALERT( nVar1 > nVar )
    MSGALERT( nVar1 = nVar )
    MSGALERT( nVar1 == nVar )
    MSGALERT( nVar1 >= nVar )
    MSGALERT( nVar1 <= nVar )
    MSGALERT( nVar1 != nVar )
    
RETURN
