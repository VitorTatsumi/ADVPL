#INCLUDE 'protheus.ch'
#INCLUDE 'TopConn.ch'
#INCLUDE 'parmtype.ch'

user function CONSULTA()
    Local cQuery := ""
    Local aArea := SB6->(GetArea())
    Local aDados := {}
    Local nCount := 1

    //A variável cQuery é utilizada para armazenar a String do código SQL neste caso
    //RetSQLName é utilizado para informar a tabela referente à qual empresa está sendo referida
    cQuery := " SELECT B6_SALDO AS SALDO, B6_PRODUTO AS PRODUTO, B6_DOC AS NOTA" 
    cQuery += " FROM "+ RetSQLName("SB6")
    cQuery += " WHERE B6_PRODUTO IN ('FV2400024C0142') "

        //Leitura da Query e atribuição à uma tabela temporária
        TCQuery cQuery New Alias "TMP"
        //EoF = End Of File
        //Laço WHILE para verificar se a tabela temporária já atingiu o final do arquivo
        While ! TMP->(EoF())
            //Adição dos dados específicos na tabela temporária
            AADD( aDados, TMP-> SALDO)
            AADD( aDados, TMP-> PRODUTO)
            AADD( aDados, TMP-> NOTA)
            //DbSkip() pula para o proximo registro
            TMP->(DbSkip())
        ENDDO

            //Laço FOR para exibição dos registros
            For nCount := 1 To Len(aDados)
                //ValType() é uma função que faz a verificação do tipo do parâmetro passado. Retorna uma string com a sigla do tipo de dado
                //Verifica o dado e se for "N" (numérico) ele faz um tratamento
                If ValType(aDados[nCount]) == "N"
                    //cValToChar para fazer a conversão do dado 
                    MSGINFO(cValToChar(aDados[nCount]))
                else
                    MSGINFO(aDados[nCount])
                Endif
            Next nCount

            //Fechando a tabela temporária
            TMP->(DBCLOSEAREA())
            //Restaura os dados/Finaliza a sessão
            RestArea(aArea)
RETURN
