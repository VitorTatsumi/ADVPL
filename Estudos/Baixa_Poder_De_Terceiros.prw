#INCLUDE 'protheus.ch'
#INCLUDE 'TopConn.ch'
#INCLUDE 'parmtype.ch'

user function baixaTerceiros()

    //Declaração das variáveis
    //Função UsrRetGrp(__cUserID) para retornar o código de grupo do usuário parametrizado. Neste caso, o __cUserID para informar o ID do usuário corrente.
    Local usuID := UsrRetGrp(__cUserID)
    Local aArea := SB6->(getArea())
    Local aDados  := {}
    Local nProd := 0
    Local nCod := 0
    Local cQuery := ""
    Local nCount := 0
    //Local usuNome := cUserName
    //Local aGrups := UsrRetGrp(usuID) //00045 decor

    SB6->(DbSetOrder())
    SB6->(DbGoTop())

    //Input Box para recebimento de informações
    nProd := FWInputBox("Insira o produto para verificação: ")
    nCod := FWInputBox("Insira o código para verificação: ")

    //Validação, para verificar se o usuário pertence ao grupo requerido.
    //Grupo 000045 - Promex Decor
    If  usuID[1] == "000045"
        //MSGALERT(usuID[1])
        //MSGALERT("Você pertence ao grupo " + usuID[1])

        //Leitura da Query e atribuição à variável cQuery
        cQuery := " SELECT B6_DOC AS NOTA, B6_PRODUTO AS PRODUTO, B6_SALDO AS SALDO "
        cQuery += " FROM " + RetSQLName("SB6")
        cQuery += " WHERE B6_PRODUTO = '" + alltrim(nProd) + "' AND B6_DOC = '" + alltrim(nCod) + "' 

        //Criação da tabela temporária TMP
        TCQuery cQuery New Alias "TMP"

        //Alimentação da tabela temporária.
        //Função EoF() para comparação se determinado valor atingiu o Fim do Arquivo (EoF()) - End Of File 
        While ! TMP->(EoF())
            AADD( aDados, TMP-> NOTA)
            AADD( aDados, TMP-> PRODUTO)
            AADD( aDados, TMP-> SALDO)
            //Comando para pular para a próxima linha do banco de dados
            TMP->(DbSkip())
        ENDDO

        //Laço de repetição para exibição dos resultados da Query
        //Comando Len() para comparar o tamanho do Vetor
        For nCount := 1 To Len(aDados)
            //Comparação para verificar se o tipo de valor do registro do Vetor é numérico ou não.
            //ValType() para retornar o tipo do registro do vetor
            If ValType(aDados[nCount]) == "N"
                    //cValToChar() para realizar a conversão de valores para caractere
                    MSGINFO(cValToChar(aDados[nCount]))
                else
                    MSGINFO(aDados[nCount])
                Endif
            Next nCount
            
            TMP->(DBCLOSEAREA())
            RestArea(aArea)
    else 
        MSGALERT( "Você não está autenticado")
        
    endif
RETURN
