#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#Include "TOTVS.ch"


User Function TESTE01()

    Local aArea := GetArea()
    
    //Fontes
    Local cFontUti    := "Tahoma"
    Local oFontAno    := TFont():New(cFontUti,,-38)
    Local oFontSub    := TFont():New(cFontUti,,-20)
    Local oFontSubN   := TFont():New(cFontUti,,-20,,.T.)
    Local oFontBtn    := TFont():New(cFontUti,,-14)

    Public aPergs   := {}
    Public nLimiteC := 00000000 
    //Public cLimiteC := Space(100)
    Public cDataUltCompraDe  := FIRSTDATE(DATE())
    Public cDataUltCompraAte  := LASTDATE(DATE())
    // Local nValorAberto  := 0
    
    //Cria as perguntas
    aAdd(aPergs, {1, "Limite de crédito: ",nLimiteC, "@E 999,999.99", ".T.", "",    ".T.", 80, .T.})
    aAdd(aPergs, {1, "Data da última compra (De): ",  cDataUltCompraDe,  "", ".T.", "", "", 60,  .F.})
    aAdd(aPergs, {1, "Data da última compra (Até): ",  cDataUltCompraAte,  "", ".T.", "", "", 60,  .F.})
    // aAdd(aPergs, {1, "Valor em aberto: ",nValorAberto,"@E 9,999.99", ".T.", "", "", 80,  .F.})



    If ParamBox(aPergs, "Informe os parâmetros")
         Alert(MV_PAR01)
         Alert(MV_PAR02)
         Alert(MV_PAR03)
    //     Alert(MV_PAR04)
    EndIf

    
 

    //Janela e componentes
    Private oDlgGrp
    Private oPanGrid
    Private oGetGrid
    Private aColunas := {}
    Private cAliasTab := "TMPSA1"
    //Tamanho da janela
    Private    aTamanho := MsAdvSize()
    Private    nJanLarg := aTamanho[5]
    Private    nJanAltu := aTamanho[6]
  
    //Cria a temporária
    oTempTable := FWTemporaryTable():New(cAliasTab)
      
    //Adiciona no array das colunas as que serão incluidas (Nome do Campo, Tipo do Campo, Tamanho, Decimais)
    aFields := {}
    aAdd(aFields, {"XXCOD", "C", TamSX3('A1_COD')[01],   0})
    aAdd(aFields, {"XXNREDUZ", "C", TamSX3('A1_NREDUZ')[01],    0})
    aAdd(aFields, {"XXLC", "N", TamSX3('A1_LC')[01],  0})
    // aAdd(aFields, {"XXPROORI", "C", TamSX3('BM_PROORI')[01],  0})
    // aAdd(aFields, {"XXTOTALP", "N", 18,                       0})
    // aAdd(aFields, {"XXSBMREC", "N", 18,                       0})
      
    //Define as colunas usadas, adiciona indice e cria a temporaria no banco
    oTempTable:SetFields( aFields )
    oTempTable:AddIndex("1", {"XXCOD"} )
    oTempTable:Create()
  
    //Monta o cabecalho
    fMontaHead()
  
    //Montando os dados, eles devem ser montados antes de ser criado o FWBrowse
    FWMsgRun(, {|oSay| fMontDados(oSay) }, "Processando", "Buscando Clientes")
  
    //Criando a janela
    DEFINE MSDIALOG oDlgGrp TITLE "Clientes" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Labels gerais
        @ 004, 003 SAY "CLIENTES"                      SIZE 200, 030 FONT oFontAno  OF oDlgGrp COLORS RGB(149,179,215) PIXEL
        @ 004, 050 SAY "Listagem de"              SIZE 200, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(031,073,125) PIXEL
        @ 014, 050 SAY "Clientes"       SIZE 200, 030 FONT oFontSubN OF oDlgGrp COLORS RGB(031,073,125) PIXEL
  
        //Botões
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"        SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Ver Grupo"     SIZE 050, 018 OF oDlgGrp ACTION (fGrupo()) PIXEL
  
        //Dados
        @ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "Grupos (Para ver a legenda basta clicar duas vezes em alguma bolinha): " OF oDlgGrp COLOR 0, 16777215 PIXEL
        oGrpDad:oFont := oFontBtn
            oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
            oGetGrid := FWBrowse():New()
            oGetGrid:DisableFilter()
            oGetGrid:DisableConfig()
            oGetGrid:DisableReport()
            oGetGrid:DisableSeek()
            oGetGrid:DisableSaveConfig()
            oGetGrid:SetFontBrowse(oFontBtn)
            oGetGrid:SetAlias(cAliasTab)
            oGetGrid:SetDataTable()
            oGetGrid:SetInsert(.F.)
            oGetGrid:SetDelete(.F., { || .F. })
            oGetGrid:lHeaderClick := .F.
            // oGetGrid:AddLegend(cAliasTab + "->XXLC <= '0'", "RED",    "Nao Original")
            // oGetGrid:AddLegend(cAliasTab + "->XXLC >= '1'", "GREEN",  "Original")
            // oGetGrid:AddLegend("Empty(" + cAliasTab + "->XXLC)", "BLACK",  "Sem Classificacao")
            oGetGrid:SetColumns(aColunas)
            oGetGrid:SetOwner(oPanGrid)
            oGetGrid:Activate()
    ACTIVATE MsDialog oDlgGrp CENTERED
  
    //Deleta a temporaria
    oTempTable:Delete()
  
    RestArea(aArea)
Return
  
Static Function fMontaHead()

    Local nAtual
    Local aHeadAux := {}
  
    //Adicionando colunas
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    aAdd(aHeadAux, {"XXCOD", "Código",            "C", TamSX3('A1_COD')[01],   0, ""})
    aAdd(aHeadAux, {"XXNREDUZ", "Nome",         "C", TamSX3('A1_NREDUZ')[01],    0, ""})
    aAdd(aHeadAux, {"XXLC", "Limite de crédito",      "N", TamSX3('A1_LC')[01],  0, ""})
    // aAdd(aHeadAux, {"XXPROORI", "Procedencia",       "C", TamSX3('BM_PROORI')[01],  0, ""})
    // aAdd(aHeadAux, {"XXTOTALP", "Total de Produtos", "N", 18,                       0, "@E 999,999,999,999,999,999"})
    // aAdd(aHeadAux, {"XXSBMREC", "SBM RecNo",         "N", 18,                       0, "@E 999,999,999,999,999,999"})
  
    //Percorrendo e criando as colunas
    For nAtual := 1 To Len(aHeadAux)
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&("{|| " + cAliasTab + "->" + aHeadAux[nAtual][1] +"}"))
        oColumn:SetTitle(aHeadAux[nAtual][2])
        oColumn:SetType(aHeadAux[nAtual][3])
        oColumn:SetSize(aHeadAux[nAtual][4])
        oColumn:SetDecimal(aHeadAux[nAtual][5])
        oColumn:SetPicture(aHeadAux[nAtual][6])
        aAdd(aColunas, oColumn)
    Next
Return
  
Static Function fMontDados(oSay)
    Local cLinha := CHR(13) + CHR(10)
    Local aArea := GetArea()
    Local cQry  := ""
    Local nAtual := 0
    Local nTotal := 0
  
    //Zera a grid
    aColsGrid := {}
      
    //Montando a query
    oSay:SetText("Montando a consulta")
    cQry := " SELECT "                                                                                      + cLinha
    cQry += "     A1_COD, "                                                                                 + cLinha
    cQry += "     A1_NREDUZ, "                                                                              + cLinha
    cQry += "     A1_LC "                                                                                   + cLinha
    cQry += " FROM "                                                                                        + cLinha
    cQry += "     " + RetSQLName('SA1') + " SA1 "                                                           + cLinha
    cQry += " WHERE "                                                                                       + cLinha
    cQry += "     A1_LC >= " + cValToChar(MV_PAR01) + " "                                                   + cLinha
    cQry += "     AND A1_ULTCOM BETWEEN '" + Dtos(MV_PAR02) + "' AND '" + Dtos(MV_PAR03) + "' "             + cLinha
    cQry += "     AND D_E_L_E_T_ = '' "                                                                     + cLinha

  
    //Executando a query
    oSay:SetText("Executando a consulta")
    PLSQuery(cQry, "QRY_SA1")
  
    //Se houve dados
    If ! QRY_SA1->(EoF())
        //Pegando o total de registros
        DbSelectArea("QRY_SA1")
        Count To nTotal
        QRY_SA1->(DbGoTop())
  
        //Enquanto houver dados
        While ! QRY_SA1->(EoF())
  
            //Muda a mensagem na regua
            nAtual++
            oSay:SetText("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
  
            RecLock(cAliasTab, .T.)
                (cAliasTab)->XXCOD := QRY_SA1-> A1_COD
                (cAliasTab)->XXNREDUZ := QRY_SA1->A1_NREDUZ
                (cAliasTab)->XXLC := QRY_SA1->A1_LC
                // (cAliasTab)->XXPROORI := QRY_SA1->BM_PROORI
                // (cAliasTab)->XXTOTALP := QRY_SA1->TOT_PROD
                // (cAliasTab)->XXSBMREC := QRY_SA1->SBMREC
            (cAliasTab)->(MsUnlock())
  
            QRY_SA1->(DbSkip())
        EndDo
  
    Else
        MsgStop("Nao foi encontrado registros!", "Atencao")
  
        RecLock(cAliasTab, .T.)
            (cAliasTab)->XXCOD := ""
            (cAliasTab)->XXNREDUZ := ""
            (cAliasTab)->XXLC := ""
            // (cAliasTab)->XXPROORI := ""
            // (cAliasTab)->XXTOTALP := 0
            // (cAliasTab)->XXSBMREC := 0
        (cAliasTab)->(MsUnlock())
    EndIf
    QRY_SA1->(DbCloseArea())
    (cAliasTab)->(DbGoTop())
  
    RestArea(aArea)
Return
  
Static Function fGrupo()
    MsgInfo("Estou no grupo: " + (cAliasTab)->XXCOD, "Atencao")
Return



Return 

#Include "Totvs.ch"
  
/*/{Protheus.doc} User Function zGrid
Visualizacao de Grupos de Produtos com FWBrowse e FWTemporaryTable
@type  Function
@author Atilio
@since  14/06/2020
@version version
/*/
  


















	//Exibe uma caixa de mensagem com um círculo vermelho e X no centro
    FWAlertError("Mensagem de erro", "Título FWAlertError")
	/**
	Exibe uma caixa de mensagem com um ícone triangular com uma exclamação no centro, com opções de seleção para continuar editando, salvar e sair da página.
	Para retornar os valores nas respectivas opções, é necessário atribuir valores aos parâmetros. São blocos de código. Será executado o comando que for passado como referência ao parâmetro neste bloco de código.
	**/
    FWAlertExitPage("Mensagem de navegação de página", "Título FWAlertExitPage", {||MsgAlert('Texto da opção: Sair da página', 'Título da opção: Sair da página')}, {||MsgAlert('Texto da opção: Salvar', 'Título da opção: Salvar')}, {||MsgAlert('Texto da opção: Continuar editando', 'Título da opção: Continuar editando')})

    FWAlertHelp("Mensagem do problema", "Mensagem da solução - FWAlertHelp")
    FWAlertInfo("Mensagem informativa", "Título FWAlertInfo")
    FWAlertNoYes("Mensagem de pergunta Não / Sim", "Título FWAlertNoYes")
    FWAlertSuccess("Mensagem de sucesso", "Título FWAlertSuccess")
    FWAlertWarning("Mensagem de aviso", "Título FWAlertWarning")
    FWAlertYesNo("Mensagem de pergunta Sim / Não", "Título FWAlertYesNo")



// user function TESTE01()
// 	Local cAlias := "ZZC"

// 	cjnum := ZZC->(Recno())
// 	dbSelectArea(cAlias)
// 	dbsetorder(1)
// 	ZZC->(dbGoTo(cjnum))
// 	//ZZC->(fwxfilial("ZZC") + cjnum + "01" + "FV2500001C7609")

// 	IF ZZC->D_E_L_E_T_ == "*"
// 		ZZC->D_E_L_E_T_ = ""
// 	Endif

// 	cAlias->(DBCLOSEAREA())
// return
