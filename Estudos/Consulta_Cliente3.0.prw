#INCLUDE 'Totvs.ch'
#INCLUDE 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

static oBmpOK := LoadBitmap(GetResource(), "LBOK")
static oBmpNo := LoadBitmap(GetResource(), "LBNO")

 
User Function TESTE01()

    Local oDlgMain := NIL
    Local oMsNewGet := NIL
    Local aHeader := {}
    Local aCmpAlt :={}



    //Declaração de variáveis
    Local aArea                 := GetArea()
    Local cLinha                := CHR(13) + CHR(10)
    Local cTabelaTemp           := ""   
    Local aColumns              := {}    
    Local cQry                  := ""
    Local nValid                := 0
    Public aCols := {}

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
    aAdd(aPergs, {2, "Exibir bloqueados",               1,                  nVinc,              60,     "",     .F.})



    //Atribui o resultado das perguntas às respectivas variáveis
    while nValid = 0
        IF ParamBox(aPergs, "Informe os parâmetros")
            IF FWAlertNoYes("Confirma os dados inseridos?", "Continuar?")
                nLimiteC            := MV_PAR01
                nSalDup             := MV_PAR02
                cDataUltCompraDe    := MV_PAR03
                cDataUltCompraAte   := MV_PAR04
                nBloqueados         := MV_PAR05
                nValid              := 1
            ELSE    
                nValid := 0
            ENDIF
        ELSE
            Return
        EndIf
    End
     
    

    AADD(aHeader, {"OK",                    "CHECK",        "@BMP",                         002, 0, ".T.", "", "C"})
    AADD(aHeader, {"Bloqueio",              "A1_MSBLQL",    "@!",                           002, 0, ".T.", "", "C"})
    AADD(aHeader, {"Código",                "A1_COD",       "@!",                           30,00,  ".T.", "", "N"})
    AADD(aHeader, {"Nome",                  "A1_NREDUZ",    "@!",                           90,00,  ".T.", "", "C"})
    AADD(aHeader, {"Loja",                  "A1_LOJA",      "@!",                           30,00,  ".T.", "", "N"})
    AADD(aHeader, {"Limite",                "A1_LC",        "@E 999,999,999,999,999,999",   30,00,  ".T.", "", "D"})
    AADD(aHeader, {"Valor em aberto",       "A1_SALDUP",    "@E 999,999,999,999,999,999",   30,00,  ".T.", "", "D"})
    
    Processa({|| fCarregaACols()}, "Processando")
    
    //AADD(aCols, {oBmpOK, "XYZ", 123.456, Date(), .F.})
    //AADD(aCols, {oBmpOK, "ABC", 122.566, Date(), .F.})

    oDlgMain := MsDialog():New(000, 000, 720, 1280, "Exemplo 01", Nil, Nil, Nil, Nil, Nil, Nil,Nil, Nil, .T., Nil, Nil, Nil, .F.)

    //Linha, Coluna, Largura, Altura
    @320,012 BUTTON "Bloquear"          SIZE 060, 020 PIXEL OF oDlgMain ACTION (fBloqueia(@oMSNewGet), oMSNewGet:Refresh())
    @320,075 BUTTON "Desbloquear"       SIZE 060, 020 PIXEL OF oDlgMain ACTION ()
    @320,137 BUTTON "Alterar Limite"    SIZE 060, 020 PIXEL OF oDlgMain ACTION (fCarregaACols(), oMSNewGet:Refresh())

    oMSNewGet := MsNewGetDados():New(020, 000 , 300, 1000, GD_UPDATE, "AllwaysTrue", "AllwaysTrue","", aCmpAlt,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgMain, @aHeader, @aCols)


    oMSNewGet:oBrowse:BLDBLCLICK := {||fCheckfield(@oMSNewGet)}
    oDlgMain:Activate()

Return()

Static function fCarregaACols()
    Local cLinha                := CHR(13) + CHR(10)
    //Local aCols := {}
    //Local aArea  := GetArea()
    Local cQry   := ""
    // Local nAtual := 0
    // Local nTotal := 0
    //Local oBmpAux

    cQry := " SELECT "                                                                                      + cLinha
    cQry += "     A1_COD, "                                                                                 + cLinha
    cQry += "     A1_NREDUZ, "                                                                              + cLinha
    cQry += "     A1_LOJA, "                                                                                + cLinha
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

    If ! QRY_SA1->(Eof())
        DbSelectArea("QRY_SA1")
        QRY_SA1->(DbGoTop())
        While ! QRY_SA1->(EoF())
            aAdd(aCols, {;
                oBmpOK,;
                QRY_SA1->A1_MSBLQL,;
                QRY_SA1->A1_COD,;
                QRY_SA1->A1_NREDUZ,;
                QRY_SA1->A1_LOJA,;
                QRY_SA1->A1_LC,;
                QRY_SA1->A1_SALDUP,;
                .F.,;               
            })
            QRY_SA1->(DbSkip())
        EndDo
        QRY_SA1->(DbCloseArea())
    EndIf

Return







Static Function fCheckfield(oMSNewGet)

    Local nLine := oMSNewGet:nAt
    Local nColumn := aScan(oMSNewGet:aHeader, {|x| x[2] == 'CHECK'})
    Local oCheck := oMSNewGet:aCols[nLine, nColumn]

    If oCheck == oBmpNo
        oMSNewGet:aCols[nLine, nColumn] := oBmpOK
    else
        oMSNewGet:aCols[nLine, nColumn] := oBmpNo
    EndIf

    oMSNewGet:Refresh()
Return









Static Function fBloqueia(oMSNewGet, oDlgMain)
    Local nLine := oMSNewGet:nAt
    Local nColumn := aScan(oMSNewGet:aHeader, {|x| x[2] == 'CHECK'})
    Local oCheck := oMSNewGet:aCols[nLine, nColumn]
    Local aArea := GetArea()
    Local nAtual    := 0
    Local nSelecao  := 0
    Local nBloq     := 0
     


    
    dbSelectArea("SA1")
    dbSetOrder(1) // A1_FILIAL + A1_COD + A1_LOJA
    //Percorrendo os registros
    For nCont := 1 to Len(aCols)
        nAtual++
        //Caso esteja marcado
        IF oMSNewGet:aCols[nCont][1] = oBmpOK
            nSelecao++
            dbSeek(xFilial("SA1") + aCols[nCont][3] + aCols[nCont][5])
            IF FOUND() 
                IF oMSNewGet:aCols[nCont][2] = "1"
                    FWAlertError('Cliente <b>' + RTRIM(SA1->A1_NREDUZ) +  '</b> já bloqueado.', 'Atenção')
                ELSE
                    //RecLock("SA1", .F.)
                    oMSNewGet:aCols[nCont, 2] := "1"
                    //SA1->(MsUnlock())
                    nBloq++
                    //FWAlertInfo('Cliente ' + TRIM((cAliasTemp)->NREDUZ) + ' bloqueado.', 'Atenção!')
                ENDIF
            ENDIF
        EndIf
        SA1->(DbSkip())
    NEXT

    //Caso não tenha sido marcado nenhum registro, informar o usuário
    IF nSelecao = 0
        FWAlertInfo('Selecione ao menos um registro.')
    ENDIF

    IF nBloq = 0
        FWAlertInfo('Nenhum cliente foi bloqueado.', 'Atenção!')
    ELSE
        FWAlertInfo('Registro(s) bloqueado(s)', 'Bloqueado(s)!')
    ENDIF     

    //Posiciona no topo da tabela temporária
    SA1->(DbGoTop())
    //Faz a atualização da MarkBrowse


Return
