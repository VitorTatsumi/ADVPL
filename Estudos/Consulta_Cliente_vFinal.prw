#INCLUDE 'Totvs.ch'
#INCLUDE 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'PRTOPDEF.CH'


static oBmpOK := LoadBitmap(GetResource(), "LBOK")
static oBmpNo := LoadBitmap(GetResource(), "LBNO")


//Função principal que vai criar as perguntas iniciais e de acordo com as respostas irá criar uma grid com os respectivos dados, botôes funcionais e barra de pesquisa 
User Function TESTE01()

    Local oDlgMain              := NIL                              //Objeto da tela principal (MSDialog)
    Local oMsNewGet             := NIL                              //Objeto da tela de grid (MSNewGet)
    Local lValid                := .F.                              //Validação das p
    Local nLC                   := 0                                //Limite de crédito
    Local nSalDup               := 0                                //Saldo de duplicatas
    Local nBloq                 := 0                                //Exibir bloqueados?
    Local aPergs                := {}                               //Array das perguntas
    Local cDtUltComDe           := FIRSTDATE(DATE())                //Data de última compra (De)
    Local cDtUltComAte          := LASTDATE(DATE())                 //Data de última compra (Até)
    Local nVinc                 := 1                                //Combobox para os bloqueados
    Local o_ChavIden            := NIL                              //Objeto MsGet para InputBox
    Local c_ChavIden            := Space(TamSx3("A1_NREDUZ")[1])    //Tamanho do campo 
    Local aHeader               := {}                   
    Local aCmpAlt               := {}      
    Local aCols                 := {}
              

    //Cria as perguntas
    aAdd(aPergs, {1, "Limite de crédito: ",             nLC,           "@E 9 999,999.99",               ".T.",  "",     ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Valor em aberto: ",               nSalDup,       "@E 9 999,999.99",               ".T.",  "",     ".T.", 80,  .F.})
    aAdd(aPergs, {1, "Data da última compra (De): ",    cDtUltComDe,   "",                              ".T.",  "",     ""   , 50,  .F.})
    aAdd(aPergs, {1, "Data da última compra (Até): ",   cDtUltComAte,  "",                              ".T.",  "",     ""   , 50,  .F.})
    aAdd(aPergs, {2, "Exibir bloqueados",               nVinc,         {"1=Ambos", "2=Sim", "3=Não"},   60,     "",                 .F.})

    //Atribui o resultado das perguntas às respectivas variáveis
    //Enquanto a validação não ocorrer, continuará solicitando a confirmação dos dados inseridos
    while lValid = .F.
        IF ParamBox(aPergs, "Informe os parâmetros")
            IF FWAlertNoYes("Confirma os dados inseridos?", "Continuar?")
                nLC              := MV_PAR01
                nSalDup          := MV_PAR02
                cDtUltCompDe     := MV_PAR03
                cDtUltComAte     := MV_PAR04
                nBloq            := cValToChar(MV_PAR05)
                lValid           := .T.
            ENDIF
        ELSE
            Return
        EndIf
    End
     
    //Após a validação dos dados inseridos nas perguntas, irá alimentar o Array de cabeçalho com os campos das colunas.
    AADD(aHeader, {"OK",                  "CHECK",        "@BMP",                        002, 0, ".T.", "", "C"})
    AADD(aHeader, {"Bloqueio",            "A1_MSBLQL",    "@!",                          002, 0, ".T.", "", "C"})
    AADD(aHeader, {"Código",              "A1_COD",       "@!",                          30, 00, ".T.", "", "N"})
    AADD(aHeader, {"Nome",                "A1_NREDUZ",    "@!",                          75, 00, ".T.", "", "C"})
    AADD(aHeader, {"Loja",                "A1_LOJA",      "@!",                          30, 00, ".T.", "", "N"})
    AADD(aHeader, {"Limite",              "A1_LC",        "@E 999,999,999,999,999.99",   30, 00, ".T.", "", "D"})
    AADD(aHeader, {"Vencimento",          "A1_VENCLC",    "@!",                          25, 00, ".T.", "", "D"})
    AADD(aHeader, {"Valor em aberto",     "A1_SALDUP",    "@E 999,999,999,999,999.99",   30, 00, ".T.", "", "D"})
    
    //Com o cabeçalho criado e as colunas definidas, alimentará o grid com as informações retornadas da função fCarregaAcols()
    Processa({|| fCarregaACols(aCols, nBloq)}, "Processando")

    //Criação da tela principal, para melhor redimensionamento do oMSNewGet()
    oDlgMain := MsDialog():New(000, 000, 700, 1280, "Principal", Nil, Nil, Nil, Nil, Nil, Nil,Nil, Nil, .T., Nil, Nil, Nil, .F.)

    //Criação dos botões e InputBox da tela
    //Parâmetros - Linha, Coluna, Largura, Altura
    @320,012 BUTTON "Bloquear"               SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 1, oMSNewGet:aCols))
    @320,075 BUTTON "Desbloquear"            SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 2, oMSNewGet:aCols))
    @320,137 BUTTON "Alterar Limite"         SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 3, oMSNewGet:aCols))
    @320,200 BUTTON "Alterar Vencimento"     SIZE 060, 015 PIXEL OF oDlgMain ACTION (fAltera(@oMSNewGet, 4, oMSNewGet:aCols))
    @320,263 BUTTON "Marcar Todos"           SIZE 060, 015 PIXEL OF oDlgMain ACTION (fMarcaDesmarca(1, oMSNewGet, oMSNewGet:aCols))
    @320,326 BUTTON "Desmarcar Todos"        SIZE 060, 015 PIXEL OF oDlgMain ACTION (fMarcaDesmarca(2, oMSNewGet, oMSNewGet:aCols))
    @321,490 MsGet o_ChavIden Var c_ChavIden SIZE 100, 011 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgMain
    @320,590 BUTTON "Pesquisar"              SIZE 040, 015 PIXEL OF oDlgMain ACTION (fPesquisa(@oMSNewGet, 1, c_ChavIden, aCols))
    o_ChavIden:cPlaceHold := "Pesquisar por nome ou código"

    //Criação do grid para apresentação dos dados da Query
    oMSNewGet := MsNewGetDados():New(000, 001, 310, 639, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aCmpAlt, , 999, "AllwaysTrue", "", "AllwaysTrue", oDlgMain, @aHeader, @aCols)
    //Função para marcar a Checkbox com duplo clique
    oMSNewGet:oBrowse:BLDBLCLICK := {||fCheckfield(@oMSNewGet)}
    oDlgMain:Activate()

Return

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


//Função que marca/desmarca a CheckBox
Static Function fCheckfield(oMSNewGet)

    IF  oMSNewGet:aCols[oMSNewGet:nAt][1] == oBmpNo
        oMSNewGet:aCols[oMSNewGet:nAt][1] := oBmpOK
    ELSE
        oMSNewGet:aCols[oMSNewGet:nAt][1] := oBmpNo
    ENDIF

    oMSNewGet:Refresh()

RETURN

//Função que marca/desmarca todos os registros do grid de acordo com o parâmetro passado
// [1] Marcar todos
// [2] Desmarcar todos
Static Function fMarcaDesmarca(nMarcaDesmarca, oMSNewGet, aCols)
    Local nX

    FOR nX := 1 TO Len(aCols)
        IF nMarcaDesmarca == 1
            oMSNewGet:aCols[nX][1] := oBmpOK
        ELSEIF nMarcaDesmarca == 2
            oMSNewGet:aCols[nX][1] := oBmpNo
        ENDIF
    NEXT
RETURN

//Função para ação do botão da InputBox de pesquisa
Static Function fPesquisa(oMSNewGet, nOpc, c_ChavIden, aCols)

    Local nNome    := aScan(aCols,{|X|UPPER(AllTrim(c_ChavIden)) $ Alltrim(X[4])})
    Local nCod     := aScan(aCols,{|X|AllTrim(c_ChavIden) $ Alltrim(X[3])})

    oMSNewGet:oBrowse:nAt := 1

    IIF(nNome > 0, oMSNewGet:oBrowse:nAt := nNome, IIF(nCod > 0, oMSNewGet:oBrowse:nAt := nCod, 0))

    //Se o campo estiver vazio, posicionará no primeiro registro
    IIF(EMPTY(c_ChavIden),oMSNewGet:oBrowse:nAt := 1, )
    
    oMSNewGet:Refresh()
Return

//Função responsável pelas alterações de bloqueio, desbloqueio, limite de crédito e data de vencimento de limite de crédito dos clientes apresentados no grid.
// [1] Bloqueio
// [2] Desbloqueio
// [3] Alteração de limite de crédito
// [4] Alteração de vencimento do limite de crédito
Static Function fAltera(oMSNewGet, nOpc, aCols)

    Local nCont         := 0                    //Contador do laço
    Local nSelecao      := 0                    //Validação se algum registro foi selecionado
    Local nPergsLC      := 0                    //Variável criada para receber o MV_PAR01 de aPergsLC
    Local aPergsLC      := {}                   //Array contendo as perguntas de Limite de Crédito
    Local aPergsVenc    := {}                   //Array contendo as perguntas de Vencimento de Limite de crédito
    Local cPergsVenc    := FIRSTDATE(DATE())    //Variável que recebe o valor de MV_PAR01 de aPergsVenc
    Local lValidBlq     := .F.                  //Validação de informações - Bloqueio
    Local lValidDsblq   := .F.                  //Validação de informações - Desbloqueio
    Local lValidLC      := .F.                  //Validação de informações - Limite de crédito
    Local lValidVenc    := .F.                  //Validação de informações - Vencimento de limite de crédito

    //Alimentação dos arrays de perguntas de validações 
    aAdd(aPergsLC,   {1, "Limite de crédito: ",   nPergsLC,   "@E 9 999,999.99",  ".T.", "", ".T.", 80, .T.})
    aAdd(aPergsVenc, {1, "Data de Vencimento: ",  cPergsVenc, "",                 ".T.", "", ".T.", 50, .T.})

    dbSelectArea("SA1")
    dbSetOrder(1) // A1_FILIAL + A1_COD + A1_LOJA

    //Início do loop que percorre todos os registros do grid
    For nCont := 1 to Len(aCols)
        //Verifica se o registro posicionado está marcado 
        IF (oMSNewGet:aCols[nCont][1] = oBmpOK)
            nSelecao++
            dbSeek(xFilial("SA1") + aCols[nCont][3] + aCols[nCont][5])
            IF FOUND() 
                IF nOpc == 1 
                    WHILE lValidBlq = .F.
                        IF FWAlertNoYes("Confirma o <b>BLOQUEIO</b> de todos os clientes selecionados?", "Atenção!")
                            lValidBlq := .T.
                        ELSE
                            lValidBlq = .F.
                            RETURN
                        ENDIF
                    EndDo
                    RecLock("SA1", .F.)
                    SA1->A1_MSBLQL := "1"
                    SA1->(MsUnlock())
                    oMSNewGet:aCols[nCont][1] := oBmpNo
                    oMSNewGet:aCols[nCont][2] := "1"
                ELSEIF nOpc == 2
                    WHILE lValidDsBlq = .F.
                        IF FWAlertNoYes("Confirma o <b>DESBLOQUEIO</b> de todos os clientes selecionados?", "Atenção!")
                            lValidDsblq := .T.
                        ELSE
                            lValidDsblq := .F.
                            RETURN
                        ENDIF
                    ENDDO
                    RecLock("SA1", .F.)
                    SA1->A1_MSBLQL := "2"
                    SA1->(MsUnlock())
                    oMSNewGet:aCols[nCont][1] := oBmpNo
                    oMSNewGet:aCols[nCont][2] := "2"
                ELSEIF nOpc == 3
                    WHILE lValidLC = .F.
                        IF ParamBox(aPergsLC, "Alteração do limite de crédito")
                            IF FWAlertNoYes("Confirma a alteração do limite de crédito de todos os clientes selecionados?", "Atenção!")
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
                            IF FWAlertNoYes("Confirma a alteração da Data de Vencimento do limite de crédito de todos os clientes selecionados?", "Atenção!")
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
                ENDIF
            ENDIF
        EndIf
        SA1->(DbSkip())
    NEXT

    //Caso não tenha sido marcado nenhum registro, informar o usuário
    IF nSelecao = 0
        FWAlertInfo('Selecione ao menos um registro.')
    ENDIF

    SA1->(DbGoTop())
    oMSNewGet:oBrowse:nAt := 1
    oMSNewGet:oBrowse:Refresh()
Return
