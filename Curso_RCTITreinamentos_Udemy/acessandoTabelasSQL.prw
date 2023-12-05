#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

user function EXIBE()
    //Cria uma variável e atribui ela à tabela SB1
    Local aArea := SB1->(GetArea())
    //Comando para abrir a tabela selecionada
    DbSelectArea("SB1")
    //Posiciona no índice 1
    SB1->(DbSetOrder(1))
    //Vai até o primeiro registro da tabela, no topo
    SB1->(DbGoTop())

    //sbSeek() é uma função que aponta para algum lugar, neste caso, para o índice Filial
    //FWXFilial("Tabela") + "CódigoParaBusca"
    //Retorna a filial da tabela informada
    If SB1->(dbSeek(FWXFilial("SB1") + "000012345"))
        //Segunda verificação para saber se o resultado retornado é realmente igual ao que desejamos ver
        If alltrim(SB1->B1_COD) = "000012345"
            Alert(SB1->B1_DESC)
        else
            Alert("Não encontrado")
        EndIf
    EndIf
    RestArea(aArea)
RETURN
