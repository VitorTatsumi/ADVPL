#INCLUDE 'protheus.ch'
#INCLUDE 'TopConn.ch'
#INCLUDE 'parmtype.ch'

user function MBrowse()
    Local cAlias        := "SB6"
    Local aCores        := {}
    Local cFiltra       := " B6_EMISSAO >= '20230101' .AND. D_E_L_E_T_ == '' "
    Private cCadastro   := "MBrowser - Teste"
    Private aRotina     := {}
    Private aIndexSB6   := {}
    //Função FilBrowse para filtrar os dados da busca da MBrowse
    Private bFiltraBrw  := {||FilBrowse(cAlias, @aIndexSB6, @cFiltra)}

    /*
    Adiciona ao Vetor aRotina o botão, com seu parametro.
    Sintaxe é AADD(Vetor,{"NomeDoBotão", "NomeDaFução", Número reservado, Tipo de operação})
    Tipos de operação: [1] Pesquisar, [2] Visualizar, [3] Incluir, [4] Altera, [5] Deleta, [6] Outras ações
    Através da opção [6] é possível adicionar uma função qualquer, já criada
    Esses botões aparecerão no canto superior da tela, assim como os botões padrões de Incluir usuário, Visualizar, etc.
    As funções AxPesqui, AxVisual, AxInclui, AxAltera, AxDeleta são todas padrões do sistema
    */
    AADD(aRotina, {"Pesquisar",     "AxPesqui", 0, 1})
    AADD(aRotina, {"Visualizar",    "AxVisual", 0, 2})
    AADD(aRotina, {"Incluir",       "u_BxInclui", 0, 3})
    AADD(aRotina, {"Alterar",       "u_BxAltera", 0, 4})
    AADD(aRotina, {"Excluir",       "u_BxDeleta", 0, 5})
    AADD(aRotina, {"Legenda",       "u_BLegenda", 0, 6})

    
    //Alimentação do Vetor aCores com as legendas de cores e condicionais referentes
    
    AADD(aCores, {" B6_TIPO == 'E'",    "BR_VERDE"})
    AADD(aCores, {" B6_TIPO != 'E'",    "BR_VERMELHO"})
    AADD(aCores, {" Empty(B6_TIPO)",    "BR_PRETO"})



    dbSelectArea(cAlias)
    dbSetOrder(1)
    Eval(bFiltraBrw)
    dbGoTop()
    mBrowse(6,1,22,75,cAlias,,,,,,aCores)
    EndFilBrw(cAlias, aIndexSB6)
    //Chamando a função MBROWSE
    mBrowse(cTitulo,,,,cAlias)
RETURN


/*--------------------------
    Função para inclusão
--------------------------*/

User function BxInclui(cAlias, nReg, nOpc)
    Local nOpcao        := 0
    nOpcao        := AxInclui(cAlias, nReg, nOpc)
    If nOpcao == 1
        MSGINFO("Incluído")
    Else 
        MSGINFO("Não incluído")
    ENDIF
RETURN

/*----------------------------
    Função para Alteração
----------------------------*/

User function BxAltera(cAlias, nReg, nOpc)
    Local nOpcao  := 0
    nOpcao        := AxAltera(cAlias, nReg, nOpc)
    If nOpcao == 1
        MSGINFO("Alterado")
    Else 
        MSGINFO("Não alterado")
    ENDIF
RETURN

/*----------------------------
    Função para Exclusão
----------------------------*/

User function BxDeleta(cAlias, nReg, nOpc)
    Local nOpcao  := 0
    nOpcao        := AxDeleta(cAlias, nReg, nOpc)
    If nOpcao == 1
        MSGINFO("Deletado")
    Else 
        MSGINFO("Não deletado")
    ENDIF
RETURN

/*----------------------------
    Função para Legenda
----------------------------*/

User function BLegenda()
    Local aLegenda := {}
    AADD(aLegenda, {"BR_VERDE",     "De terceiros"})
    AADD(aLegenda, {"BR_VERMELHO",  "Em terceiros"})
    AADD(aLegenda, {"BR_PRETO",     "Sem preenchimento"})
    BrwLegenda(cCadastro, "Legenda", aLegenda)
return
