#INCLUDE 'protheus.ch'

//Início da User Function para o loop WHILE
user function loopwhile()
    //Criação das variáveis
    Local nCont := 1
    Local cNome := "Vitor"

    //Início do Loop, onde enquanto o valor da variável nCont for diferente de 5 e o conteúdo da variável cNome for diferente de Tatsumi, adicione +1 ao valor de nCont
    While nCont != 5 .AND. cNome != "Tatsumi"
        nCont++
            //Se o valor da variável nCont for exatamente 3, atualize o valor do cNome para Tatsumi
            If nCont == 3
            cNome := "Tatsumi"
            EndIf
    EndDo
    //Exibe as mensagens com os valores finais das variáveis
    MsgAlert("Nome: " + cNome)
    MsgAlert("Número: " + cValToChar(nCont))
    //O comando cValToChar converte o valor para Char
return
