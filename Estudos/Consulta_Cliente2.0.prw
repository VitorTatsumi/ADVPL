#INCLUDE 'Totvs.ch'
#INCLUDE 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
 
User Function TESTE01()
    //Declaração de variáveis
    Local aArea                 := GetArea()
    Local cLinha                := CHR(13) + CHR(10)
    Local cTabelaTemp           := ""   
    Local aColumns              := {}    
    Local cQry                  := ""
    Private oTabelaTemp         := Nil
    Private oDlg
    Private oMarkBrowse
    Public nLimiteC             := 0
    Public nSalDup              := 0
    Public nBloqueados          := 0
    Public aPergs               := {}
    Public cDataUltCompraDe     := FIRSTDATE(DATE())
    Public cDataUltCompraAte    := LASTDATE(DATE())
    Public nVinc                := {"Sim", "Não"}

    //Cria as perguntas
    aAdd(aPergs, {1, "Limite de crédito: ",             nLimiteC,           "@E 9 999,999.99",  ".T.",  "",     ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Valor em aberto: ",               nSalDup,            "@E 9 999,999.99",  ".T.",  "",     ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Data da última compra (De): ",    cDataUltCompraDe,   "",                 ".T.",  "",     ""   , 60,  .F.})
    aAdd(aPergs, {1, "Data da última compra (Até): ",   cDataUltCompraAte,  "",                 ".T.",  "",     ""   , 60,  .F.})
    aAdd(aPergs, {2, "Exibir bloqueados",              1,                  nVinc,              60,     "",     .F.})

    //Atribui o resultado das perguntas às respectivas variáveis
    If ParamBox(aPergs, "Informe os parâmetros")
        nLimiteC            := MV_PAR01
        nSalDup             := MV_PAR02
        cDataUltCompraDe    := MV_PAR03
        cDataUltCompraAte   := MV_PAR04
        nBloqueados         := MV_PAR05
    EndIf
     
    //Constrói estrutura da temporária
    cTabelaTemp := fBuildTmp(@oTabelaTemp) 
    
    //Seleciona a tabela temporária e posiciona na primeira linha
    DbSelectArea(cTabelaTemp)
    (cTabelaTemp)->(DbSetOrder(1))
    (cTabelaTemp)->(DbGoTop())
    //Alimentando a cQry com a Query SQL 
    cQry := " SELECT "                                                                                      + cLinha
    cQry += "     A1_COD, "                                                                                 + cLinha
    cQry += "     A1_NREDUZ, "                                                                              + cLinha
    cQry += "     A1_LC, "                                                                                  + cLinha
    cQry += "     A1_SALDUP, "                                                                              + cLinha
    cQry += "     A1_MSBLQL "                                                                               + cLinha
    cQry += " FROM "                                                                                        + cLinha
    cQry += "     " + RetSQLName('SA1') + " SA1 "                                                           + cLinha
    cQry += " WHERE "                                                                                       + cLinha
    cQry += "     A1_LC >= " + cValToChar(MV_PAR01) + " "                                                   + cLinha
    cQry += "     AND A1_SALDUP >= " + cValToChar(MV_PAR02) + " "                                           + cLinha
    cQry += "     AND A1_ULTCOM BETWEEN '" + Dtos(MV_PAR03) + "' AND '" + Dtos(MV_PAR04) + "' "             + cLinha
    IF (nBloqueados := 1)
        cQry += " AND A1_MSBLQL IN ('1', '2') "                                                             + cLinha
    ELSE
        cQry += " AND A1_MSBLQL != 1 "                                                                      + cLinha
    ENDIF
    cQry += "     AND D_E_L_E_T_ = '' "                                                                     + cLinha

    //Executa a Query
    PLSQuery(cQry, "QRY_SA1")

    //Se houver dados
    If ! QRY_SA1->(EoF())
        //Pegando o total de registros
        DbSelectArea("QRY_SA1")
        Count To nTotal
        QRY_SA1->(DbGoTop())
        //Enquanto houver dados, irá alimentar a tabela temporária
        While ! QRY_SA1->(EoF())  
            RecLock(cTabelaTemp, .T.)
                (cTabelaTemp)->OK       := ""
                (cTabelaTemp)->COD      := QRY_SA1->A1_COD
                (cTabelaTemp)->NREDUZ   := QRY_SA1->A1_NREDUZ
                (cTabelaTemp)->LC       := QRY_SA1->A1_LC
                (cTabelaTemp)->SALDUP   := QRY_SA1->A1_SALDUP
                (cTabelaTemp)->BLOQUEIO := QRY_SA1->A1_MSBLQL
            (cTabelaTemp)->(MsUnlock())
            QRY_SA1->(DbSkip())
        EndDo
    //Se nao houver dados, irá exibir a mensagem e armazenar valores vazios
    Else
        MsgStop("Nao foi encontrado registros!", "Atencao")
        RecLock(cTabelaTemp, .T.)
            (cTabelaTemp)->OK       := ""
            (cTabelaTemp)->COD      := ""
            (cTabelaTemp)->NREDUZ   := ""
            (cTabelaTemp)->LC       := 0
            (cTabelaTemp)->SALDUP   := 0
            (cTabelaTemp)->BLOQUEIO := ""
        (cTabelaTemp)->(MsUnlock())
    EndIf

    QRY_SA1->(DbCloseArea())
    (cTabelaTemp)->(DbGoTop())
    RestArea(aArea)
     
    //Constrói estrutura das colunas do FWMarkBrowse
    aColumns := fBuildColumns()
     
    //Adiciona os filtros
    aSeek := {}
    aAdd(aSeek,{"Código"    ,{{"","C",TamSX3("A1_COD")[1]   ,0,,}} } )
    aAdd(aSeek,{"Nome"      ,{{"","C",TamSX3("A1_NREDUZ")[1],0,,}} } )

    //Constrói a tela com os parâmetros informados
    oDlg := msDialog():new(180,180,600,1100,'Clientes',,,,,CLR_BLACK,CLR_WHITE,,,.T.)

    //Criando o FWMarkBrowse
    oMarkBrowse := FWMarkBrowse():New()
    oMarkBrowse:SetOwner(oDlg)
    oMarkBrowse:SetSeeAll(.T.)
    oMarkBrowse:SetAlias(cTabelaTemp)                
    oMarkBrowse:SetDescription('Seleção de Clientes')
    oMarkBrowse:DisableReport()
    oMarkBrowse:SetFieldMark( 'OK' )
    oMarkBrowse:SetTemporary(.T.)
    oMarkBrowse:oBrowse:SetDBFFilter(.T.)
    oMarkBrowse:oBrowse:SetSeek(.T., aSeek)

    //Inicializa com todos registros marcados
    oMarkBrowse:AllMark(.T.) 

    //Adicionando legendas ao Browse
    oMarkBrowse:AddLegend("BLOQUEIO = '1'", "RED", "Bloqueado")
    oMarkBrowse:AddLegend("BLOQUEIO = '2'", "GREEN", "Ativo")

    //Definiri colunas do Browse
    oMarkBrowse:SetColumns(aColumns)

    //Criação dos botôes
    oMarkBrowse:AddButton("Bloquear"	, { || fBloqueia()},,,  4, .F., 2 )
    oMarkBrowse:AddButton("Atualizar"	, { || fAtualiza()},,,  5, .F., 2 )

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
    aAdd(aFields, { "OK"        , "C", 1,                       0})
    aAdd(aFields, { "COD"       , "C", TamSX3('A1_COD')[01],    0})
    aAdd(aFields, { "NREDUZ"    , "C", TamSX3('A1_NREDUZ')[01], 0})
    aAdd(aFields, { "LC"        , "N", TamSX3('A1_LC')[01],     0})
    aAdd(aFields, { "SALDUP"    , "N", TamSX3('A1_SALDUP')[01], 0})
    aAdd(aFields, { "BLOQUEIO"  , "C", TamSX3('A1_MSBLQL')[01], 0})

         
    oTabelaTemp:SetFields( aFields )
    oTabelaTemp:AddIndex("01", {"COD"})   
    oTabelaTemp:AddIndex("02", {"NREDUZ"})    
 
    oTabelaTemp:Create()    
 
Return oTabelaTemp:GetAlias()
 

Static Function fBuildColumns()
     
    Local nX       := 0 
    Local aColumns := {}
    Local aStruct  := {}
    
    AAdd(aStruct, {"OK"            , "C", 1                         , 0                     ,,               "" })
    AAdd(aStruct, {"COD"           , "C", TamSX3('A1_COD')[01]      , 0                     ,,          "Código"})
    AAdd(aStruct, {"NREDUZ"        , "C", TamSX3('A1_NREDUZ')[01]   , 0                     ,,            "Nome"})
    AAdd(aStruct, {"LC"            , "N", TamSX3('A1_LC')[01]       , 0 ,"@E 999,999,999.99","Limite de Crédito"})
    aAdd(aStruct, {"SALDUP"        , "N", TamSX3('A1_SALDUP')[01]   , 0 ,"@E 999,999,999.99",  "Valor em Aberto"})
    //aAdd(aStruct, {"BLOQUEIO"      , "C", TamSX3('A1_MSBLQL')[01]   , 0                   , })
             
    For nX := 2 To Len(aStruct)    
        AAdd(aColumns,FWBrwColumn():New())
        aColumns[Len(aColumns)]:SetData( &("{||"+aStruct[nX][1]+"}") )
        aColumns[Len(aColumns)]:SetTitle(aStruct[nX][6])
        aColumns[Len(aColumns)]:SetPicture(aStruct[nX][5])
        aColumns[Len(aColumns)]:SetSize(aStruct[nX][3])
        aColumns[Len(aColumns)]:SetDecimal(aStruct[nX][4]) 
        aColumns[Len(aColumns)]:SetAlign(aStruct[nX][4])
    Next nX       

Return aColumns

// Static Function fBloq()

//     MsgInfo("Bloquear usuário: " + (cAliasTemp)->NREDUZ, "Atenção")
// Return


Static Function fBloqueia()
    Local aArea     := FWGetArea()
    Local cMarca    := oMarkBrowse:Mark()
    Local nAtual    := 0
    //Local nTotal    := 0
    Local nTotMarc  := 0
    Local nSelecao := 0
     
    //Define o tamanho da régua
    // DbSelectArea(cAliasTemp)
    // (cAliasTemp)->(DbGoTop())
    // Count To nTotal
    // ProcRegua(nTotal)
     
    //Percorrendo os registros
    (cAliasTemp)->(DbGoTop())


    While ! (cAliasTemp)->(EoF())
        nAtual++
        //Caso esteja marcado
        IF oMarkBrowse:IsMark(cMarca)
            nSelecao++
            IF (cAliasTemp)->BLOQUEIO = "1"
                FWAlertError('Registro já bloqueado.', 'Atenção')
            ELSE
                nTotMarc++
                (cAliasTemp)->BLOQUEIO := "1"
                FWAlertInfo('Cliente ' + TRIM((cAliasTemp)->NREDUZ) + ' bloqueado.', 'Atenção!')
            ENDIF
        EndIf
        (cAliasTemp)->(DbSkip())
    EndDo
    
    //Caso não tenha sido marcado nenhum registro, informar o usuário
    IF nSelecao = 0
        FWAlertInfo('Selecione ao menos um registro.')
    ENDIF     
    //Mostra a mensagem de término e caso queria fechar a dialog, basta usar o método End()
    //FWAlertInfo('Foram bloqueados [' + cValToChar(nTotMarc) + '] registros', 'Atenção')
    //oDlgMark:End()
 
    FWRestArea(aArea)
Return


Static Function fAtualiza()
    oMarkBrowse:Refresh(.T.)
    //oMarkBrowse:AllMark(.F.)
Return