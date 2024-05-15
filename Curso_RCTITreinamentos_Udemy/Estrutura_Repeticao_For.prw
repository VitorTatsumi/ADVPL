#INCLUDE 'protheus.ch'

User Function LoopFor()

    //A estrutura FOR e ADVPL possui um fechamento de repetição que se chama NEXT. O NEXT irá executar o fim do processo após o loop ser finalizado.

    	LOCAL nCont
	LOCAL nNum := 0
	LOCAL nCont
	LOCAL aNomes := {"Vitor", "João", "Roberth", "Maurício", "Cledison", "Cristiano", "Maurício"}

    //O loop FOR pode conter após o parâmetro de finaliação, um STEP, que seriam os passos que serão dados a cada loop. Então caso sejam 2 passos por loop, um loop que teria 10 voltas será feito somente em 5.
	//LEN() nesse caso, é utilizado para extrair o número de índices do Array
	FOR nCont := 1 TO LEN(aNomes)
		//Array percorrido com MsgInfo para exibir as informações. Utilizando MsgAlert ou Alert não funciona.
		MsgInfo(cValToChar(aNomes[nCont]))

	//NEXT será executado após o fim do laço FOR.	
	NEXT	
		MsgAlert("Array percorrido por completo!")
Return

//Neste seguinte caso, o resultado será exibido em somente uma MsgInfo
User Function LoopForUnion()
    //A estrutura FOR e ADVPL possui um fechamento de repetição que se chama NEXT. O NEXT irá executar o fim do processo após o loop ser finalizado.
	LOCAL nCont
	LOCAL aNomes := {"Vitor", "João", "Roberth", "Maurício", "Cledison", "Cristiano", "Maurício"}
    	LOCAL cFrase := ''

	FOR nCont := 1 TO LEN(aNomes)
        cFrase += cValToChar(aNomes[nCont]) + " - "
	NEXT	
        	MsgAlert(cValToChar(cFrase))
Return
