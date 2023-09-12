#INCLUDE 'protheus.ch'

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


