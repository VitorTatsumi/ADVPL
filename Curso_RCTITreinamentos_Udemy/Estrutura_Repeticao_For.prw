#INCLUDE 'protheus.ch'

User Function OlaMundo()

//A estrutura FOR e ADVPL possui um fechamento de repetião que se chama NEXT. O NEXT irá executar o fim do processo após o loop ser finalizado.

    LOCAL nCont
    LOCAL nNum := 0

//O loop FOR pode conter após o parâmetro de finaliação, um STEP, que seriam os passos que serão dados a cada loop. Então caso sejam 2 passos por loop, um loop que teria 10 voltas será feito somente em 5.
    FOR nCont := 0 TO 10 STEP 2
        //O loop for adiciona automaticamente 1 à variável por cada loop dado
        nNum += nCont
        MSGALERT( nCont)

    NEXT
        //Ao final do loop, o NEXT é executado, informado qual o valor da variável nNum
        MSGINFO( cValToChar(nNum) )
    
RETURN


