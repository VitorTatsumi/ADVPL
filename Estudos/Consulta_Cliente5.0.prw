#INCLUDE 'Totvs.ch'
#INCLUDE 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'PRTOPDEF.CH'


static oBmpOK := LoadBitmap(GetResource(), "LBOK")
static oBmpNo := LoadBitmap(GetResource(), "LBNO")
//Define cLinha 
 
User Function TESTE01()

    //Declaração de variáveis
    Local oDlgMain              := NIL                  //Objeto da tela principal (MSDialog)
    Local oMsNewGet             := NIL                  //Objeto da tela de grid (MSNewGet)
    Local aHeader               := {}                   //Cabeçalho
    Local aCmpAlt               := {}                    
    Local nOpc                  := 0
    Local nValid                := 0                   
    Local aCols                 := {}
    Local nLC                   := 0                    //Limite de crédito
    Local nSalDup               := 0                    //Saldo de duplicatas
    Local nBloq                 := 0                    //Exibir bloqueados?
    Local aPergs                := {}                   //Array das perguntas
    Local cDtUltComDe           := FIRSTDATE(DATE())    //Data de última compra (De)
    Local cDtUltComAte          := LASTDATE(DATE())     //Data de última compra (Até)
    Local nVinc                 := 1                    //Combobox para os bloqueados
    Local o_ChavIden
    Local c_ChavIden      := Space(TamSx3("A1_NREDUZ")[1])

    //Cria as perguntas
    aAdd(aPergs, {1, "Limite de crédito: ",             nLC,           "@E 9 999,999.99",               ".T.",  "",     ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Valor em aberto: ",               nSalDup,       "@E 9 999,999.99",               ".T.",  "",     ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Data da última compra (De): ",    cDtUltComDe,   "",                              ".T.",  "",     ""   , 50,  .F.})
    aAdd(aPergs, {1, "Data da última compra (Até): ",   cDtUltComAte,  "",                              ".T.",  "",     ""   , 50,  .F.})
    aAdd(aPergs, {2, "Exibir bloqueados",               nVinc,         {"1=Ambos", "2=Sim", "3=Não"},   60,     "",                 .F.})

    //Atribui o resultado das perguntas às respectivas variáveis
    //Enquanto a validação não ocorrer, continuará solicitando a confirmação dos dados inseridos
    while nValid = 0
        IF ParamBox(aPergs, "Informe os parâmetros")
            IF FWAlertNoYes("Confirma os dados inseridos?", "Continuar?")
                nLC            := MV_PAR01
                nSalDup             := MV_PAR02
                cDtUltCompDe        := MV_PAR03
                cDtUltComAte        := MV_PAR04
                nBloq         := cValToChar(MV_PAR05)
                nValid              := 1
            ELSE    
                nValid := 0
            ENDIF
        ELSE
            Return
        EndIf
    End
     
    //Após a validação dos dados inseridos nas perguntas, irá alimentar o Array de cabeçalho com os campos das colunas.
    AADD(aHeader, {"OK",                                "CHECK",        "@BMP",                        002, 0, ".T.", "", "C"})
    AADD(aHeader, {"Bloqueio",                          "A1_MSBLQL",    "@!",                          002, 0, ".T.", "", "C"})
    AADD(aHeader, {"Código",                            "A1_COD",       "@!",                          30, 00, ".T.", "", "N"})
    AADD(aHeader, {"Nome",                              "A1_NREDUZ",    "@!",                          75, 00, ".T.", "", "C"})
    AADD(aHeader, {"Loja",                              "A1_LOJA",      "@!",                          30, 00, ".T.", "", "N"})
    AADD(aHeader, {"Limite",                            "A1_LC",        "@E 999,999,999,999,999.99",   30, 00, ".T.", "", "D"})
    AADD(aHeader, {"Vencimento",                        "A1_VENCLC",    "@!",                          25, 00, ".T.", "", "D"})
    AADD(aHeader, {"Valor em aberto",                   "A1_SALDUP",    "@E 999,999,999,999,999.99",   30, 00, ".T.", "", "D"})
    
    //Com o cabeçalho criado e as colunas definidas, alimentará o grid com as informações retornadas da função fCarregaAcols()
    Processa({|| fCarregaACols(aCols, nBloq)}, "Processando")

    //Criação da tela principal, para melhor dimensionamento do oMSNewGet()
    oDlgMain := MsDialog():New(000, 000, 700, 1280, "Principal", Nil, Nil, Nil, Nil, Nil, Nil,Nil, Nil, .T., Nil, Nil, Nil, .F.)

    //Linha, Coluna, Largura, Altura
    @320,012 BUTTON "Bloquear"               SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 1, oMSNewGet:aCols))
    @320,075 BUTTON "Desbloquear"            SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 2, oMSNewGet:aCols))
    //@320,137 BUTTON "Alterar Limite"         SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 3, oMSNewGet:aCols))
    @320,137 BUTTON "Alterar Limite"         SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 3, oMSNewGet:aCols))
    //@320,200 BUTTON "Alterar Vencimento"     SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 4, oMSNewGet:aCols))
    @320,200 BUTTON "Alterar Vencimento"     SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 4, oMSNewGet:aCols))
    @320,263 BUTTON "Marcar Todos"           SIZE 060, 015 PIXEL OF oDlgMain ACTION (fMarcaDesmarca(1, oMSNewGet, oMSNewGet:aCols))
    @320,326 BUTTON "Desmarcar Todos"        SIZE 060, 015 PIXEL OF oDlgMain ACTION (fMarcaDesmarca(2, oMSNewGet, oMSNewGet:aCols))
    @321,490 MsGet o_ChavIden Var c_ChavIden SIZE 100, 010 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgMain
    @320,590 BUTTON "Pesquisar"              SIZE 040, 015 PIXEL OF oDlgMain ACTION (fPesquisa(@oMSNewGet, 1, c_ChavIden, aCols))
    o_ChavIden:cPlaceHold := "Pesquisar por nome ou código"



    //Criação do grid para apresentação dos dados da Query
    oMSNewGet := MsNewGetDados():New(;
            000,;                        //Distância da extremidade superior
            001 ,;                       //Distância da extremidade esquerda
            310,;                        //Distância da extremidade inferior
            639,;                        //Distância da extremidade direita
            GD_UPDATE,;                  
            "AllwaysTrue",; 
            "AllwaysTrue",;
            "",; 
            aCmpAlt,;
            ,; 
            999,;                        //Quantidade máxima de colunas
            "AllwaysTrue",; 
            "",; 
            "AllwaysTrue",; 
            oDlgMain,;                   //Objeto pai
            @aHeader,;                   //Cabeçalho
            @aCols;                      //Colunas
            )

    oMSNewGet:oBrowse:BLDBLCLICK := {||fCheckfield(@oMSNewGet)}
    oDlgMain:Activate()

Return()

Static function fCarregaACols(aCols, nBloq)
    Local cLinha    := CHR(13) + CHR(10)
    Local cQry      := ""

    cQry := " SELECT "                                                                                      + cLinha
    cQry += "     A1_COD, "                                                                                 + cLinha
    cQry += "     A1_NREDUZ, "                                                                              + cLinha
    cQry += "     A1_LOJA, "                                                                                + cLinha
    cQry += "     A1_LC, "                                                                                  + cLinha
    cQry += "     A1_VENCLC, "                                                                              + cLinha
    cQry += "     A1_SALDUP, "                                                                              + cLinha
    cQry += "     A1_MSBLQL "                                                                               + cLinha
    cQry += " FROM "                                                                                        + cLinha
    cQry += "     " + RetSQLName('SA1') + " SA1 "                                                           + cLinha
    cQry += " WHERE "                                                                                       + cLinha
    cQry += "     A1_LC >= " + cValToChar(MV_PAR01) + " "                                                   + cLinha
    cQry += "     AND A1_SALDUP >= " + cValToChar(MV_PAR02) + " "                                           + cLinha
    cQry += "     AND A1_ULTCOM BETWEEN '" + Dtos(MV_PAR03) + "' AND '" + Dtos(MV_PAR04) + "' "             + cLinha
    IF (nBloq == "1")
        cQry += " AND A1_MSBLQL IN ('1', '2') "                                                             + cLinha
    ELSEIF (nBloq == "2")
        cQry += " AND A1_MSBLQL != 2 "                                                                      + cLinha
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
                QRY_SA1->A1_VENCLC,;
                QRY_SA1->A1_SALDUP,;
                .F.,;               
            })
            QRY_SA1->(DbSkip())
        EndDo
        QRY_SA1->(DbCloseArea())
    EndIf

Return

Static Function fCheckfield(oMSNewGet)

    Local nLine     := oMSNewGet:nAt
    Local nColumn   := aScan(oMSNewGet:aHeader, {|x| x[2] == 'CHECK'})
    Local oCheck    := oMSNewGet:aCols[nLine][nColumn]


    If oCheck == oBmpNo
        oMSNewGet:aCols[nLine][nColumn] := oBmpOK
    else
        oMSNewGet:aCols[nLine][nColumn] := oBmpNo
    EndIf

    oMSNewGet:Refresh()
Return

Static Function fMarcaDesmarca(nMarcaDesmarca, oMSNewGet, aCols)
    Local nX

    FOR nX := 1 TO Len(aCols)
        IF nMarcaDesmarca == 1
            oMSNewGet:aCols[nX][1] := oBmpOK
        ELSEIF nMarcaDesmarca == 2
            oMSNewGet:aCols[nX][1] := oBmpNo
        ELSE    
            FWAlertError("Errormarcar")
        ENDIF
    NEXT
Return


Static Function fPesquisa(oMSNewGet, nOpc, c_ChavIden, aCols)


//Local nStr := 0
Local nPos := 0
oMSNewGet:oBrowse:nAt := 1

    //If nOpc = 1                                      
        //nStr:= Len(AllTrim(c_ChavIden))
        nPos := aScan(aCols,{|X|UPPER(AllTrim(c_ChavIden)) $ Alltrim(X[4])})
        nPosCli := aScan(aCols,{|X|UPPER(AllTrim(c_ChavIden)) $ Alltrim(X[3])})
        IIF(nPos > 0, nPos, IIF(nPosCli >0, nPosCli, 0))
          n:= nPos
          oMSNewGet:oBrowse:nAt := nPos
        IF EMPTY(c_ChavIden)
            oMSNewGet:oBrowse:nAt := 1
        //ENDIF
        Endif
        oMSNewGet:Refresh()
Return



Static Function fAltera(oMSNewGet, nOpc, aCols)
    Local nAtual        := 0
    Local nSelecao      := 0
    Local aPergsLC      := {}
    Local nPergsLC      := 0
    Local aPergsVenc    := {}
    Local cPergsVenc    := FIRSTDATE(DATE())
    Local lValidBlq     := .F.
    Local lValidDsblq   := .F.
    Local lValidVenc    := .F.
    Local lValidLC      := .F.

    Local aNomes        := {}
    Local cAvisoNomes   := ""

    aAdd(aPergsLC, {1, "Limite de crédito: ",             nPergsLC,           "@E 9 999,999.99",  ".T.",  "",     ".T.", 80,  .T.})
    aAdd(aPergsVenc, {1, "Data de Vencimento: ",             cPergsVenc,           "",  ".T.",  "",     ".T.", 50,  .T.})

    
    dbSelectArea("SA1")
    dbSetOrder(1) // A1_FILIAL + A1_COD + A1_LOJA
    //Percorrendo os registros
    For nCont := 1 to Len(aCols)
        nAtual++
        //Caso esteja marcado
        IF (oMSNewGet:aCols[nCont][1] = oBmpOK)
            nSelecao++
            dbSeek(xFilial("SA1") + aCols[nCont][3] + aCols[nCont][5])
            IF FOUND() 
                IF nOpc == 1
                    WHILE lValidBlq = .F.
                        IF FWAlertNoYes("Confirma o <b>BLOQUEIO</b> de todos os clientes selecionados na base de dados?", "Atenção!")
                            //IF oMSNewGet:aCols[nCont][2] = "1"
                                //FWAlertError('Cliente <b>' + RTRIM(SA1->A1_NREDUZ) +  '</b> já bloqueado.', 'Atenção')
                                //AADD(aNomes, {SA1->A1_NREDUZ})
                                //Return
                            //ELSE
                            lValidBlq := .T.
                                //nBloq++
                                //FWAlertInfo('Cliente ' + TRIM((cAliasTemp)->NREDUZ) + ' bloqueado.', 'Atenção!')
                            //ENDIF
                        ELSE
                            lValidBlq = .F.
                            RETURN
                        ENDIF
                    EndDo
                    RecLock("SA1", .F.)
                    SA1->A1_MSBLQL := "1"
                    //oMSNewGet:aCols[nCont][9] := .T.
                    SA1->(MsUnlock())
                    oMSNewGet:aCols[nCont][1] := oBmpNo
                    oMSNewGet:aCols[nCont][2] := "1"
                ELSEIF nOpc == 2
                    WHILE lValidDsBlq = .F.
                        IF FWAlertNoYes("Confirma o <b>DESBLOQUEIO</b> de todos os clientes selecionados na base de dados?", "Atenção!")
                            //IF oMSNewGet:aCols[nCont][2] != "2"
                                //AADD(aNomes,{SA1->A1_NREDUZ})

                            //ELSE
                                lValidDsblq := .T.
                            //ENDIF
                        ELSE
                            lValidDsblq := .F.
                            RETURN
                        ENDIF
                    ENDDO
                    RecLock("SA1", .F.)
                    SA1->A1_MSBLQL := "2"
                    //oMSNewGet:aCols[nCont][9] := .T.
                    SA1->(MsUnlock())
                    oMSNewGet:aCols[nCont][1] := oBmpNo
                    oMSNewGet:aCols[nCont][2] := "2"
                    //nBloq++
                    //FWAlertInfo('Cliente ' + TRIM((cAliasTemp)->NREDUZ) + ' bloqueado.', 'Atenção!')
                ELSEIF nOpc == 3
                    WHILE lValidLC = .F.
                        IF ParamBox(aPergsLC, "Alteração do limite de crédito")
                            IF FWAlertNoYes("Confirma a alteração do limite de crédito na base de dados?", "Atenção!")
                                IF MV_PAR01 <= 0 .OR. MV_PAR01 > SUPERGETMV("MV_LCCLI", .F., 500)
                                    FWAlertInfo('Valor de limite deve estar entre <b>R$0,00</b> e <b>R$500,00</b><br><br>Insira um valor válido.', 'Atenção!')
                                ELSE
                                    nPergsLC            := MV_PAR01
                                    lValidLC            := .T.
                                ENDIF
                            ELSE    
                                lValidLC := .F.
                            ENDIF                        
                        ELSE
                            Return
                        EndIf
                    EndDo
                    RecLock("SA1", .F.)
                    SA1->A1_LC := nPergsLC
                    SA1->(MsUnlock())
                    oMSNewGet:aCols[nCont][1] := oBmpNo
                    oMSNewGet:aCols[nCont][6] := nPergsLC
                ELSEIF nOpc == 4
                    WHILE lValidVenc = .F.
                        IF ParamBox(aPergsVenc, "Informe os parâmetros")
                            IF FWAlertNoYes("Confirma a alteração dos dados?", "Atenção!")
                                cPergsVenc            := MV_PAR01
                                lValidVenc            := .T.
                            ELSE    
                                lValidVenc := .F.
                            ENDIF
                        ELSE
                            Return

                        EndIf
                    EndDo
                    RecLock("SA1", .F.)
                    SA1->A1_VENCLC := cPergsVenc
                    SA1->(MsUnlock())
                    oMSNewGet:aCols[nCont][1] := oBmpNo
                    oMSNewGet:aCols[nCont][7] := cPergsVenc
                    //oMSNewGet:aCols[nCont][9] := .T.
                ENDIF
                    //oMSNewGet:aCols[nCont][9] := .T.
                    //nPergsLC            := MV_PAR01
                    //End
                    //Reclock("SA1", .F.)
                    //SA1->A1_LC := nPergsLC
                    //SA1->(MsUnlock())
            ENDIF
        EndIf
        SA1->(DbSkip())
    NEXT

    // For nNomes := 1 TO Len(aNomes)
    //     cAvisoNomes := RTRIM(cAvisoNomes) + CHR(13) + CHR(10) + RTRIM(aNomes[nNomes][1])
    // NEXT

    // IF Len(aNomes) != 0
    //     FWAlertInfo("<b>" + cAvisoNomes + "</b>", "Atenção! <br>Clientes já bloqueados/desbloqueados: ")
    // ENDIF

    //Caso não tenha sido marcado nenhum registro, informar o usuário
    IF nSelecao = 0
        FWAlertInfo('Selecione ao menos um registro.')
    ENDIF

    SA1->(DbGoTop())
    oMSNewGet:oBrowse:nAt := 1
    oMSNewGet:oBrowse:Refresh()
Return

