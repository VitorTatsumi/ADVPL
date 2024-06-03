#Include 'Totvs.ch'
#include 'protheus.ch'
#INCLUDE 'totvs.ch'
#INCLUDE 'FWMVCDEF.CH'
 
User Function TESTE01()
    
    Local aArea                 := GetArea()
    Local cLinha                := CHR(13) + CHR(10)
    Local oTabelaTemp           := Nil
    Local oMarkBrowse
    Local oDlg
    Local cTabelaTemp           := ""   
    Local aColumns              := {}    
    Local cQry                  := ""
    Local nAtual                := 0

    //Variáveis das perguntas
    Public nLimiteC             := 0
    Public nBloqueados          := 0
    Public aPergs               := {}
    Public cDataUltCompraDe     := FIRSTDATE(DATE())
    Public cDataUltCompraAte    := LASTDATE(DATE())
    Public nVinc                := {"Sim", "Não"}

    //Cria as perguntas
    aAdd(aPergs, {1, "Limite de crédito: ",             nLimiteC,           "@E 999,999.99",    ".T.",  "",     ".T.", 80, .T.})
    aAdd(aPergs, {1, "Data da última compra (De): ",    cDataUltCompraDe,   "",                 ".T.",  "",     "", 60,  .F.})
    aAdd(aPergs, {1, "Data da última compra (Até): ",   cDataUltCompraAte,  "",                 ".T.",  "",     "", 60,  .F.})
    aAdd(aPergs, {2, "Exibir bloqueados?",              1,                  nVinc,              60,     "",     .F.})


    If ParamBox(aPergs, "Informe os parâmetros")
        nLimiteC            := MV_PAR01
        cDataUltCompraDe    := MV_PAR02
        cDataUltCompraAte   := MV_PAR03
        nBloqueados         := MV_PAR04
    EndIf
     
    //Constrói estrutura da temporária
    cTabelaTemp := fBuildTmp(@oTabelaTemp) 
     
    DbSelectArea(cTabelaTemp)
    (cTabelaTemp)->( DbSetOrder(1) )
    (cTabelaTemp)->( DbGoTop() )
    lAcao := .T.

    cQry := " SELECT "                                                                                      + cLinha
    cQry += "     A1_COD, "                                                                                 + cLinha
    cQry += "     A1_NREDUZ, "                                                                              + cLinha
    cQry += "     A1_LC "                                                                                   + cLinha
    cQry += " FROM "                                                                                        + cLinha
    cQry += "     " + RetSQLName('SA1') + " SA1 "                                                           + cLinha
    cQry += " WHERE "                                                                                       + cLinha
    cQry += "     A1_LC >= " + cValToChar(MV_PAR01) + " "                                                   + cLinha
    cQry += "     AND A1_ULTCOM BETWEEN '" + Dtos(MV_PAR02) + "' AND '" + Dtos(MV_PAR03) + "' "             + cLinha
    IF (nBloqueados := 1)
        cQry += " AND A1_MSBLQL IN ('1', '2') "                                                             + cLinha
    ELSE
        cQry += " AND A1_MSBLQL != 1 "                                                                      + cLinha
    ENDIF
    cQry += "     AND D_E_L_E_T_ = '' "                                                                     + cLinha

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
            //oSay:SetText("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
  
            RecLock(cTabelaTemp, .T.)
                (cTabelaTemp)->OK := ""
                (cTabelaTemp)->COD := QRY_SA1-> A1_COD
                (cTabelaTemp)->NREDUZ := QRY_SA1->A1_NREDUZ
                (cTabelaTemp)->LC := QRY_SA1->A1_LC
            (cTabelaTemp)->(MsUnlock())
  
            QRY_SA1->(DbSkip())
        EndDo
  
    Else
        MsgStop("Nao foi encontrado registros!", "Atencao")
  
        RecLock(cTabelaTemp, .T.)
            (cTabelaTemp)->OK := ""
            (cTabelaTemp)->COD := ""
            (cTabelaTemp)->NREDUZ := ""
            (cTabelaTemp)->LC := 0
        (cTabelaTemp)->(MsUnlock())
    EndIf
    QRY_SA1->(DbCloseArea())
    (cTabelaTemp)->(DbGoTop())
  
    RestArea(aArea)
     
    //Constrói estrutura das colunas do FWMarkBrowse
    aColumns := fBuildColumns()
     

    aSeek := {}
    aAdd(aSeek,{"Código" ,{{"","C",TamSX3("A1_COD")[1],0,,}} } )
    aAdd(aSeek,{"Nome" ,{{"","C",TamSX3("A1_NREDUZ")[1],0,,}} } )



    oDlg := msDialog():new(180,180,600,800,'Clientes por limite de crédito',,,,,CLR_BLACK,CLR_WHITE,,,.T.)


    //Criando o FWMarkBrowse
    oMarkBrowse := FWMarkBrowse():New()
    oMarkBrowse:SetOwner(oDlg)
    oMarkBrowse:SetSeeAll(.T.)
    oMarkBrowse:SetAlias(cTabelaTemp)                
    oMarkBrowse:SetDescription('Seleção de Clientes')
    oMarkBrowse:DisableReport()
    oMarkBrowse:SetFieldMark( 'OK' )
    oMarkBrowse:SetTemporary(.T.)
    oMarkBrowse:SetColumns(aColumns)
    oMarkBrowse:oBrowse:SetDBFFilter(.T.)
    oMarkBrowse:oBrowse:SetSeek(.T., aSeek)
    //Inicializa com todos registros marcados
    oMarkBrowse:AllMark(.T.) 

    oMarkBrowse:AddButton("Bloquear"	, { || fBloq()},,,4, .F., 2 )

    //Ativando a janela
    oMarkBrowse:Activate()
    oDlg:activate(,,,.t.,{||,.t.},,{||})

         
    oTabelaTemp:Delete()
    oMarkBrowse:DeActivate()
    FreeObj(oTabelaTemp)
    FreeObj(oMarkBrowse)
    RestArea( aArea )
Return 
 

Static Function fBuildTmp(oTabelaTemp)
 
    Local aFields       := {}
    Public cAliasTemp   := "TMPSA1"
        
    oTabelaTemp:= FWTemporaryTable():New(cAliasTemp)

    //Monta estrutura de campos da temporária
    aAdd(aFields, { "OK"        , "C", 2,                       0})
    aAdd(aFields, { "COD"       , "C", TamSX3('A1_COD')[01],    0})
    aAdd(aFields, { "NREDUZ"    , "C", TamSX3('A1_NREDUZ')[01], 0})
    aAdd(aFields, { "LC"        , "N", TamSX3('A1_LC')[01],     0})
         
    oTabelaTemp:SetFields( aFields )
    oTabelaTemp:AddIndex("01", {"COD"})   
    oTabelaTemp:AddIndex("02", {"NREDUZ"})    
 
    oTabelaTemp:Create()    
 
Return oTabelaTemp:GetAlias()
 

Static Function fBuildColumns()
     
    Local nX       := 0 
    Local aColumns := {}
    Local aStruct  := {}
    
    AAdd(aStruct, {"OK"            , "C", 2 , 0})
    AAdd(aStruct, {"COD"           , "C", TamSX3('A1_COD')[01] , 0})
    AAdd(aStruct, {"NREDUZ"        , "C", TamSX3('A1_NREDUZ')[01] , 0})
    AAdd(aStruct, {"LC"            , "N", TamSX3('A1_LC')[01] , 0})
             
    For nX := 2 To Len(aStruct)    
        AAdd(aColumns,FWBrwColumn():New())
        aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
        aColumns[Len(aColumns)]:SetTitle(aStruct[nX][1])
        aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
        aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4])              
    Next nX
    
Return aColumns

Static Function fBloq()

    MsgInfo("Bloquear usuário: " + (cAliasTemp)->NREDUZ, "Atenção")
    IF(cAliasTemp->OK = "OK")
        MsgInfo()
Return

	// //Exibe uma caixa de mensagem com um círculo vermelho e X no centro
    // FWAlertError("Mensagem de erro", "Título FWAlertError")
	// /**
	// Exibe uma caixa de mensagem com um ícone triangular com uma exclamação no centro, com opções de seleção para continuar editando, salvar e sair da página.
	// Para retornar os valores nas respectivas opções, é necessário atribuir valores aos parâmetros. São blocos de código. Será executado o comando que for passado como referência ao parâmetro neste bloco de código.
	// **/
    // FWAlertExitPage("Mensagem de navegação de página", "Título FWAlertExitPage", {||MsgAlert('Texto da opção: Sair da página', 'Título da opção: Sair da página')}, {||MsgAlert('Texto da opção: Salvar', 'Título da opção: Salvar')}, {||MsgAlert('Texto da opção: Continuar editando', 'Título da opção: Continuar editando')})

    // FWAlertHelp("Mensagem do problema", "Mensagem da solução - FWAlertHelp")
    // FWAlertInfo("Mensagem informativa", "Título FWAlertInfo")
    // FWAlertNoYes("Mensagem de pergunta Não / Sim", "Título FWAlertNoYes")
    // FWAlertSuccess("Mensagem de sucesso", "Título FWAlertSuccess")
    // FWAlertWarning("Mensagem de aviso", "Título FWAlertWarning")
    // FWAlertYesNo("Mensagem de pergunta Sim / Não", "Título FWAlertYesNo")



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
