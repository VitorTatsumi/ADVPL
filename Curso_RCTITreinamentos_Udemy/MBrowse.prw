#INCLUDE 'protheus.ch'
#INCLUDE 'TopConn.ch'
#INCLUDE 'parmtype.ch'

user function MBrowse()
    Local cAlias := "SB6"
    Private cTitulo := "MBrowser - Teste"
    Private aRotina := {}

    //Adiciona ao Vetor aRotina o botão, com seu parametro.
    //Sintaxe é AADD(Vetor,{"NomeDoBotão", "NomeDaFução", Número reservado, Tipo de operação})
    // Tipos de operação: [1] PEsquisar, [2] Visualizar, [3] Incluir, [4] Altera, [5] Deleta, [6] Outras ações
    //Através da opção [6] é possível adicionar uma função qualquer, já criada
    //Esses botões aparecerão no canto superior da tela, assim como os botões padrões de Incluir usuário, Visualizar, etc.
    //As funções AxPesqui, AxVisual, AxInclui, AxAltera, AxDeleta são todas padrões do sistema
    AADD (aRotina, {"Pesquisar", "AxPesqui", 0, 1})
    AADD (aRotina, {"Visualizar", "AxVisual", 0, 2})
    AADD (aRotina, {"Incluir", "AxInclui", 0, 3})
    AADD (aRotina, {"Alterar", "AxAltera", 0, 4})
    AADD (aRotina, {"Excluir", "AxDeleta", 0, 5})
    AADD (aRotina, {"Personalizada", "U_ADVINHA", 0, 6})

    dbSelectArea(cAlias)
    dbSetOrder(1)

    //Chamando a função MBROWSE
    mBrowse(,,,,cAlias)
RETURN
