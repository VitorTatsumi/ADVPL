#INCLUDE 'protheus.ch'

//Início da User Function para o loop WHILE
User Function loopWhile()
    //Criação das variáveis
    Local nCont := 1
    Local cNome := "Vitor"

    //Início do Loop, onde enquanto o valor da variável nCont for diferente de 5 e o conteúdo da variável cNome for diferente de Tatsumi, adicione +1 ao valor de nCont
    While nCont != 5 .AND. cNome != "Tatsumi"
        //Podemos utilizar para quebra de linha tanto o CHR(13) + CHR(10) quanto a Tag HTML <br> e também o comando CRLF
        MsgAlert("Nome: " + cNome + CHR(13) + CHR(10) + "Número: " + cValToChar(nCont))
        nCont++
            //Se o valor da variável nCont for exatamente 3, atualize o valor do cNome para Tatsumi
            If nCont == 3
            cNome := "Tatsumi"
            EndIf
    EndDo
Return
