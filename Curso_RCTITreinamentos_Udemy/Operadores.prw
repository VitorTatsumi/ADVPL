#INCLUDE 'protheus.ch'

//Operadores de atribuição, relacionais, lógicos e matemáticos

//Operadores de atribuição
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

//Operadores lógicos
User Function OperadoresL()
    //Operadores relacionais, utilizados para retornar um valor lógico (.T. ou .F.)
    LOCAL nVar := 2
    LOCAL nVar1 := 3
   //Será feito o teste lógico dos elementos e o MSGALERT irá exibir o resultado lógico 
    MSGALERT( nVar1 < nVar )
    MSGALERT( nVar1 > nVar )
    MSGALERT( nVar1 = nVar ) //Comparação IGUAL. Valor x é igual ou não ao valor y.
    MSGALERT( nVar1 == nVar ) //Comparação EXATAMENTE IGUAL. Valor x é exatamente igual ao y.
    MSGALERT( nVar1 >= nVar )
    MSGALERT( nVar1 <= nVar )
    MSGALERT( nVar1 != nVar )
RETURN

//Operadores matemáticos
User Function OperadoresM()
    //Variáveis locais, geralmente utiliza-se a inicial em minúsculo referente ao tipo de dado no inicio do nome da variável
    LOCAL nVar := 2
    LOCAL nVar1 := 3
    LOCAL nResSub := nVar1 - nVar
    LOCAL nResMult := nVar1 * nVar
    LOCAL nResDiv := nVar1 / nVar
    
    //Variáveis públicas
    PUBLIC cVar := 'Vitor'
    //Variáveis privadas 
    PRIVATE __cVar := 'Tatsumi'
    //Para efetuar operações matemáticas, simplesmente é neessário inserir os parâmetros seguidos do operador
    //Para soma ou concatenação dos elementos
    MSGALERT( 'Soma: ' + cVar + " " + __cVar )
    //Para subtração dos elementos
    MSGALERT( 'Subtração: ' + cValToChar(nResSub) )
    //Para a multiplicação
    MSGALERT( 'Multiplicação: ' + cValToChar(nResMult) )
    //Para Divisão
    MSGALERT( 'Divisão: ' + cValToChar(nResDiv))
    //Resto de divisão
    MSGALERT( 'Resto de divisão: ' + cValToChar(nVar1 % nVar))
    //Foi necessário para concatenação dos elementos efetuar a conversão dos elementos para os tipos de dados corretos (Também, para facilitar, é melhor armazenar os dados em uma variável)
RETURN
