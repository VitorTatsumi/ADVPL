#INCLUDE 'protheus.ch'

user function ADVINHA()
    //Cria as variáveis numéricas para armazenar os valores
    Local nNum := 50
    Local nChute := 0
    Local nTentativas := 0
    //Atribui o valor randômico e o valor de chute às variáveis
    nNum := RANDOMIZE( 1, 100 )
    //Laço de repetição para executar enquanto o número não for correto
    WHILE nNum != nChute
        //A função VAL() para conversão de CHAR para NUMÉRICO
        //A função FWInputBox para criar uma caixa de TEXTO para inserção de valores
        nChute := Val(FWInputBox("Digite o número: ", ""))
        //Estrutura condicional para verificação da relação das variáveis
        IF nNum == nChute
            //Pode-se utilizar algumas Tags HTML para modificar as mensagens exibidas. A Tag <br> pode ser utilizada para a quebra de linha.
            MSGINFO("Você acertou!" + CHR(13) + CHR(10) + "<br> Número correto é <b>" + cValToChar(nChute) + "</b>")
        ELSEIF nNum < nChute
            MSGINFO("Mais baixo...")
        ELSE
            MSGINFO("Mais alto...")
        ENDIF
        //Adição à variável de quantidade de tentativas
        nTentativas++
    END
    //Exibição da quantidade de tentativas
    //cValToChar para converter NUMÉRICO para CHAR
    MSGINFO("Foram necessárias <b>" + cValToChar(nTentativas) + '</b> tentativa(s)')
RETURN


