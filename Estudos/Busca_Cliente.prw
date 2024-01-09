#INCLUDE 'Protheus.ch'

/*----------------------------------------------
{Protheus.doc} Consulta de clientes
Consulta de cliente por código
@author         Vitor Tatsumi Tuda Rosa
@since          09/01/2024
@version        12/superior
----------------------------------------------*/

User Function BuscaCli()
    //Declaração das variáveis necessárias
    Local   cAlias      := "SB1"
    Private cCadastro   := "Filtro de clientes"
    Private aRotina     := {}

    //Adicionando os botões ao vetor aRotina
    //Atenção ao  "U_" antes dos pontos de entrada modificados 
    AADD( aRotina,  {"Pesquisar",       "AxPesqui",     0, 1})
    AADD( aRotina,  {"Procurar Codigo", "u_procura",    0, 6})

    //Abrindo a tabela que será utilizada. Neste caso a tabela SA1
    DBSELECTAREA(cAlias)
    //Ordenando os dados da tabela de acordo com o indice 2
    DBSETORDER(2)
    //Indo ao topo da tabela
    DBGOTOP()
    //Criando a tabela com a função MBrowse
    mBrowse(6,1,22,75,cAlias,,,,,,)
RETURN

//Funções de usuário e pontos de entrada modificados para efetuar as ações personalizadas.
//Primeiramente temos a função u_procura(), que executa a busca através do código do cliente, executando a Query e retornando na tela o nome do cliente do código informado.
User Function procura()
    Local cAlias    := "SA1"
    Local cCod      := 0
    Local cQuery    := ""
    Local aDados    := {}
    //FWInputBox para recebimento de valores, neste caso o código do cliente
    cCod    := FWInputBox("Insira o código do cliente: ")

    //Query SQL para verificação do código do cliente na tabela SA1
    cQuery := " SELECT TOP 1 A1_NOME AS NOME, A1_COD AS CODIGO FROM " + RetSQLName(cAlias)
    cQuery += " WHERE A1_COD IN ('" + allTrim(cCod) + "')" 
    
    //Atribuição do resultado da Query à uma tabela Temporária TMP
    TCQuery cQuery New Alias "TMP"

    //Abrindo a tabela temporária
    DBSELECTAREA("TMP")

    //Adicionando ao aDados os valores da tabela temporária 
    AADD( aDados, TMP-> NOME)
    AADD( aDados, TMP-> CODIGO)

    //Exibindo os dados encontrados
    MSGINFO(cValToChar(aDados[1]), "Nome do cliente")

RETURN
