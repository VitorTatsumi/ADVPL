#INCLUDE "Protheus.ch"
/*/
{Protheus.doc} Confesto
Relatorio de conferencia de estoque
@type function ...
@version  Sem versão
@author Cledison RIbeiro
@since 02/03/09
/*/
User Function CONFESTO(_cVem)
	Private cArq,cInd
	Private cString     := "SB1"
	Private cDesc1      := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2      := "de acordo com os parametros informados pelo usuario."
	Private cDesc3      := "Relatório de Conferência de Estoque"
	Private cPict       := ""
	Private imprime     := .T.
	Private aOrd        := {}
	Private aRegs       := {}
	Private nLin        := 80
	Private titulo       := "RELATÓRIO DE CONFERÊNCIA DE ESTOQUE"
	Private Cabec1      := ""
	Private Cabec2      := ""
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite       := 132
	Private tamanho      := "M"
//Private nomeprog     := "CONFESTO" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nomeprog     := "CONFESTO_" + __cuserid // Alterado Por Cledison Ribeiro em 30.09.09
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cPerg        := "CONFES"
// Private cbtxt      	:= Space(10) // Alterado por Cledison Ribeiro em 24.02.21
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "CONFESTO" // Coloque aqui o nome do arquivo usado para impressao em disco
//Private aOrd		:= {'Produto','Etiqueta','Coleção'}
	Private nOrdem 		:= 1
	Private nValTot     := 0
// Variaveis para a funcao GerArqXls
	Private aCmpTexto	:= {}
	Private aDados		:= {}
	Private aDados2		:= {}
	Private ctitulo		:= "RELATÓRIO DE CONFERÊNCIA DE ESTOQUE"
//Private caba		:= "CONFESTO"
	Private caba		:= ""

	Aadd( aRegs, { cPerg, "01","Da Data de Nascimento        ?","Da Data de Nascimento        ?","Da Data de Nascimento        ?","MV_CH1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd( aRegs, { cPerg, "02","Ate a Data de Nascimento     ?","Ate a Data de Nascimento     ?","Ate a Data de Nascimento     ?","MV_CH2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd( aRegs, { cPerg, "03","Do Produto                   ?","Do Produto                   ?","Do Produto                   ?","MV_CH3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd( aRegs, { cPerg, "04","Ate o Produto                ?","Ate o Produto                ?","Ate o Produto                ?","MV_CH4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd( aRegs, { cPerg, "05","Da Coleção                   ?","Da Coleção                   ?","Da Coleção                   ?","MV_CH5","C",2,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd( aRegs, { cPerg, "06","Ate a Coleção                ?","Ate a Coleção                ?","Ate a Coleção                ?","MV_CH6","C",2,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd( aRegs, { cPerg, "07","Da Etiqueta                  ?","Da Etiqueta                  ?","Da Etiqueta                  ?","MV_CH7","C",10,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd( aRegs, { cPerg, "08","Ate a Etiqueta               ?","Ate a Etiqueta               ?","Ate a Etiqueta               ?","MV_CH8","C",10,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd( aRegs, { cPerg, "09","Exporta para EXCEL           ?","Exporta para EXCEL           ?","Exporta para EXCEL           ?","MV_CH9","N",1,0,0,"C","","MV_PAR09","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","" })
	Aadd( aRegs, { cPerg, "10","Tipo do Relatório            ?","Tipo do Relatório            ?","Tipo do Relatório            ?","MV_CHA","N",1,0,0,"C","","MV_PAR10","Sintético","Sintético","Sintético","","","Analitíco","Analitíco","Analitíco","","","","","","","","","","","","","","","","","","","","" })

	ValidPerg( aRegs, cPerg )


	If _cVem=nil .or. _cVem='S'

		Pergunte(cPerg,.f.)
		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

		If nLastKey == 27
			Return
		Endif
		SetDefault(aReturn,cString)
		nTipo := If(aReturn[4]==1,15,18)
	Endif
	if _cVem<>nil
		MV_PAR09 := 2 // NAO E EXCELL
		MV_PAR10 := 1 //  SINTÉTICO
	Endif
// Processamento. RPTSTATUS monta janela com a regua de processamento.

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,_cVem) },Titulo)
Return

/*/
{Protheus.doc} RUNREPORT
Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS monta a janela com a regua de processamento.
@type function ...
@version  Sem versão
@author Cledison RIbeiro
@since 06/12/03
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,_cVem2)
	Local cQuery	:= ''
	Local nRegs		:= 0
	Local cLinha	:= Chr(13)+Chr(10)

// Se for gerar o relatório em excel
	If MV_PAR09 == 1

		aCmpTexto:= "{'Filial', 'Produto', 'Descricao', 'Colecao'"
		If MV_PAR10 == 2 // Se for Analitico
			aCmpTexto+=  ", 'Etiqueta', 'Nascimento', 'DI', 'Usuario'"
			If cFilAnt $ '02*05' // Se for Atilio Pifer e Bom Retiro | Alterado por Cledison Ribeiro em 11.06.2020
				aCmpTexto+=  ", 'Inventario'"
			Endif
		Endif
		aCmpTexto+=  ", 'Qtde'"
		If MV_PAR10 == 1 // Se for Sintetico
			// Alterado por Cledison Ribeiro em 03.04.23
			aCmpTexto+=  ", 'Reserva'"
			aCmpTexto+=  ", 'Dispo'"

			aCmpTexto+=  ", 'Unidades'"
		Endif
		aCmpTexto+=  ", 'Um'}"
		aCmpTexto	:= &aCmpTexto

	Endif

	nOrdem := aReturn[8]
	caba := iif(MV_PAR10 == 1,"SINTETICO","ANALITICO")

	If MV_PAR10 == 1 // Se for Sintetico

		cQuery:= " SELECT '  ' AS B1_OK, CB0.CB0_FILIAL, CB0.CB0_CODPRO, SB1.B1_DESC, SB1.B1_UM, CB0.CB0_LOCAL, " + cLinha
		// Alterado por Cledison Ribeiro em 03.04.23
//	cQuery+= "		SUM(CB0.CB0_QTDE) 'CB0_QTDE', COUNT(*) 'UNIDADES' " + cLinha
		cQuery+= " MAX(SB2.B2_QATU) 'CB0_QTDE', MAX(SB2.B2_RESERVA) 'RESERVA', (MAX(SB2.B2_QATU) - MAX(SB2.B2_RESERVA)) 'DISPO', COUNT(*) 'UNIDADES' " + cLinha
		cQuery+= "	FROM " + RetSqlName("CB0") + " CB0 WITH (NOLOCK) INNER JOIN " + RetSqlName("SB1") + " SB1 WITH (NOLOCK) ON CB0.CB0_FILIAL = SB1.B1_FILIAL " + cLinha
		cQuery+= "							AND CB0.CB0_CODPRO = SB1.B1_COD " + cLinha
		cQuery+= "							AND SB1.D_E_L_E_T_ = '' " + cLinha
		cQuery+= "					LEFT JOIN " + RetSqlName("CB9") + " CB9  WITH (NOLOCK) ON CB0.CB0_FILIAL = CB9.CB9_FILIAL " + cLinha
		cQuery+= "							AND CB0.CB0_CODPRO = CB9.CB9_PROD " + cLinha
		cQuery+= "							AND CB0.CB0_CODETI = CB9.CB9_CODETI " + cLinha
		cQuery+= "							AND CB9.D_E_L_E_T_ = '' " + cLinha

		cQuery+= "					LEFT JOIN " + RetSqlName("SB2") + " SB2 WITH (NOLOCK) ON SB2.B2_FILIAL = CB0.CB0_FILIAL " + cLinha
		cQuery+= "							AND SB2.B2_COD = CB0.CB0_CODPRO " + cLinha
		cQuery+= "							AND SB2.B2_LOCAL = CB0.CB0_LOCAL " + cLinha
		cQuery+= "							AND SB2.D_E_L_E_T_ = ''  " + cLinha

		cQuery+= "	WHERE CB0.CB0_FILIAL = '" + cFilAnt + "'" + cLinha
		cQuery+= "		AND CB0.CB0_TIPO = '01'" + cLinha
		cQuery+= "		AND CB0.CB0_LOCAL BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "'" + cLinha
		cQuery+= "		AND CB0.CB0_LOCAL NOT IN ('','00') " + cLinha
		cQuery+= "		AND CB0.CB0_CODPRO BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "'" + cLinha
		cQuery+= "		AND CB0.CB0_USUARI <> ''" + cLinha
		cQuery+= "		AND CB0.CB0_DTNASC BETWEEN '" + Dtos(Mv_Par01) + "' AND '" + Dtos(Mv_Par02) + "'" + cLinha
		cQuery+= "		AND CB0.CB0_CODETI BETWEEN '" + Mv_Par07 + "' AND '" + Mv_Par08 + "'" + cLinha
		cQuery+= "		AND CB9.CB9_CODETI IS NULL " + cLinha
		cQuery+= "      AND ( (CB0.CB0_FILIAL IN ('01','03','04','07') AND CB0.CB0_USUARI <> '' AND CB0.CB0_LOCALI <> '' )   OR  (CB0.CB0_FILIAL IN ('02','05') AND CB0.CB0_USUARI <> '' ) )" + cLinha
		cQuery += "		AND CB0.CB0_QTDE > 0 " + cLinha
		cQuery+= "	 	AND CB0.D_E_L_E_T_ = '' " + cLinha

		cQuery+= " GROUP BY CB0.CB0_FILIAL, CB0.CB0_CODPRO, SB1.B1_DESC, SB1.B1_UM, CB0.CB0_LOCAL " + cLinha
		cQuery+= " ORDER BY CB0.CB0_FILIAL, CB0.CB0_CODPRO, SB1.B1_DESC, SB1.B1_UM, CB0.CB0_LOCAL "


	Else

		cQuery := "SELECT CB0.CB0_FILIAL, CB0.CB0_CODPRO, SB1.B1_DESC, SB1.B1_UM, CB0.CB0_LOCAL, " + cLinha
		cQuery += "		CB0.CB0_QTDE, CB0.CB0_CODETI, CB0.CB0_DTNASC, CB0.CB0_DI_NUM, CB0.CB0_USERGI, CB0.CB0_INVENT   " + cLinha //Alterado por Cledison Ribeiro em 11.06.2020
		cQuery += "	FROM " + RetSqlName("CB0") + " CB0  WITH (NOLOCK) INNER JOIN " + RetSqlName("SB1") + " SB1  WITH (NOLOCK) ON CB0.CB0_FILIAL = SB1.B1_FILIAL " + cLinha
		cQuery += "							AND CB0.CB0_CODPRO = SB1.B1_COD " + cLinha
		cQuery += "							AND SB1.D_E_L_E_T_ = '' " + cLinha
		cQuery += "					LEFT JOIN " + RetSqlName("CB9") + " CB9  WITH (NOLOCK) ON CB0.CB0_FILIAL = CB9.CB9_FILIAL " + cLinha
		cQuery += "							AND CB0.CB0_CODPRO = CB9.CB9_PROD " + cLinha
		cQuery += "							AND CB0.CB0_CODETI = CB9.CB9_CODETI " + cLinha
		cQuery += "							AND CB9.D_E_L_E_T_ = '' " + cLinha
		cQuery += "	WHERE CB0.CB0_FILIAL = '" + cFilAnt + "'" + cLinha
		cQuery += "		AND CB0.CB0_TIPO = '01'" + cLinha
		cQuery += "		AND CB0.CB0_LOCAL BETWEEN '" + Mv_Par05 + "' AND '" + Mv_Par06 + "'" + cLinha
		cQuery += "		AND CB0.CB0_LOCAL NOT IN ('','00') " + cLinha
		cQuery += "		AND CB0.CB0_CODPRO BETWEEN '" + Mv_Par03 + "' AND '" + Mv_Par04 + "'" + cLinha
		cQuery += "		AND CB0.CB0_USUARI <> ''" + cLinha
		cQuery += "		AND CB0.CB0_DTNASC BETWEEN '" + Dtos(Mv_Par01) + "' AND '" + Dtos(Mv_Par02) + "'" + cLinha
		cQuery += "		AND CB0.CB0_CODETI BETWEEN '" + Mv_Par07 + "' AND '" + Mv_Par08 + "'" + cLinha
		cQuery += "		AND CB9.CB9_CODETI IS NULL " + cLinha
		// Alterado por Cledison Ribeiro em 20.09.2019
		//   	cQuery+= "      AND ( (CB0.CB0_FILIAL IN ('01','03') AND CB0.CB0_USUARI <> '' AND CB0.CB0_LOCALI <> '' )   OR  (CB0.CB0_FILIAL IN ('02','04','05') AND CB0.CB0_USUARI <> '' ) )" + cLinha
		cQuery+= "      AND ( (CB0.CB0_FILIAL IN ('01','03','04','07') AND CB0.CB0_USUARI <> '' AND CB0.CB0_LOCALI <> '' )   OR  (CB0.CB0_FILIAL IN ('02','05') AND CB0.CB0_USUARI <> '' ) )" + cLinha
		// Alterado por Cledison RIbeiro em 06.04.2022
		cQuery += "		AND CB0.CB0_QTDE > 0 " + cLinha
		cQuery += "		AND CB0.D_E_L_E_T_ = '' " + cLinha

		// Atendendo a solicitacao dos seapradores da equipe do David. Alterado em 14.12.11 ³
		cQuery += " ORDER BY CB0.CB0_FILIAL, CB0.CB0_CODETI "

	Endif

	MemoWrite("confesto.sql",cQuery) // Gravo o conteudo da Query para analisar possiveis erros
	If SELECT('PLANEST')>0
		PLANEST->(DbCloseArea())
	Endif

	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), 'PLANEST', .T., .T.)
	ajustecpo('PLANEST')
	PLANEST->( dbGoTop() )
	While !PLANEST->( Eof() )

		If MV_PAR09 == 1

			aDados2:= "{PLANEST->CB0_FILIAL, PLANEST->CB0_CODPRO, PLANEST->B1_DESC, PLANEST->CB0_LOCAL"
			If MV_PAR10 == 2 // Se for Analitico
				aDados2+= ", PLANEST->CB0_CODETI, PLANEST->CB0_DTNASC, PLANEST->CB0_DI_NUM, '' "
				If cFilAnt $ '02*05' // Se for Atilio Pifer e Bom Retiro
// 				Alterado por Cledison Ribeiro em 11.03.21
//				aDados2+= ", sTod(Alltrim(PLANEST->CB0_INVENT)) " // Se for Atilio Pifer e Bom Retiro | Alterado por Cledison Ribeiro em 11.06.2020
					aDados2+= ", PLANEST->CB0_INVENT " // Se for Atilio Pifer e Bom Retiro | Alterado por Cledison Ribeiro em 11.06.2020
				Endif
			Endif
			aDados2+= ", PLANEST->CB0_QTDE "
			If MV_PAR10 == 1 // Se for Sintetico
				// Alterado por Cledison Ribeiro em 03.04.23
				aDados2+= ", PLANEST->RESERVA "
				aDados2+= ", PLANEST->DISPO "

				aDados2+= ", PLANEST->UNIDADES "
			Endif
			aDados2+= ", PLANEST->B1_UM} "
			aadd(aDados, &aDados2 )

		Endif
		nRegs++

		PLANEST->( dbSkip() )

	EndDo

	SetRegua( nRegs )

	If nRegs > 0

		// Se for nao gerar o relatório em excel
		If MV_PAR09 == 2
			If _cVem2=nil .or. _cVem2='S'
				ImpPlan()
			Endif
		Else
			U_GerArqXls(ctitulo,caba,aCmpTexto,aDados)
		Endif

	Endif

	If _cVem2= nil
		PLANEST->( dbCloseArea() )
	Endif

// Se impressao em disco, chama o gerenciador de impressao...

// Se for gerar o relatório em excel
	IF (_cVem2=nil .or._cVem2='S') .and. MV_PAR09 != 1
		If aReturn[5]==1
			dbCommitAll()
			SET PRINTER TO
			OurSpool(wnrel)
		Endif
	Endif

	MS_FLUSH()

Return


/*/
{Protheus.doc} ImpDetCan
..
@type function ...
@version  Sem versão
@author Cledison RIbeiro
@since 25/09/2003
/*/
Static Function ImpPlan()
	Local cMaskVal	:= "@E 999,999,999.9999"
//Local cMaskVal	:= "@E 9,999,999,999.99"
//Local cMaskVal	:= "@E 999,999.99"
	Local aCabec	:= {}
	Local cLinha	:= ''
// Local nPos		:= 0 // Alterado por Cledison Ribeiro em 24.02.21
	Local nAjusTam	:= 0
	Local aFields	:= {}
	Local aTotPar	:= {}
	Local aTotGer	:= {}
	local nRegPar	:= 0
	local nRegTot	:= 0
// Local nQtdNat	:= 0 // Alterado por Cledison Ribeiro em 24.02.21
// Local cCampo	:= '' // Alterado por Cledison Ribeiro em 24.02.21
	Local cAlias	:= 'PLANEST'
// Local cNomCli	:= '' // Alterado por Cledison Ribeiro em 24.02.21

	Local _nC:=0 // Alterado por Cledison Ribeiro em 24.02.21
	Local _nG:=0 // Alterado por Cledison Ribeiro em 24.02.21
	Local _nF:=0 // Alterado por Cledison Ribeiro em 24.02.21
	Local _nA:=0 // Alterado por Cledison Ribeiro em 24.02.21


	cFilterUser := aReturn[7]
	Cabec1       := "RELATÓRIO DE CONFERÊNCIA DE ESTOQUE "
	Cabec2       := ""

// ESTRUTURA DA MATRIZ (aFields)
// 1 = Campo
// 2 = Titulo
// 3 = Tipo
// 4 = Picture
// 5 = Tamanho
// 6 = Decimal
// 7 = Alias
// 8 = Totaliza

	Aadd( aFields, {'CB0_FILIAL','FILIAL','C', '@!', 2, 0, cAlias, .F. })
	Aadd( aFields, {'CB0_CODPRO','PRODUTO','C', '@!', 15, 0, cAlias, .F. })
	Aadd( aFields, {'B1_DESC','DESCRIÇÃO','C', '@!',30, 0, cAlias, .F. })
	Aadd( aFields, {'CB0_LOCAL','COLEÇÃO','C', '@!',2,0, cAlias, .F. })
	If MV_PAR10 == 2 // Se for Analitico
		Aadd( aFields, {'CB0_CODETI','ETIQUETA','C', '@!', 10, 0, cAlias, .F. })
		Aadd( aFields, {'CB0_DTNASC','DT. NASC.','D', '@!',	8, 0, cAlias, .F. })
		Aadd( aFields, {'CB0_DI_NUM','DI','C', '@!',	17, 0, cAlias, .F. })
		//	Aadd( aFields, {'CB0_USERGI','USUARIO','C', '@!',	10, 0, cAlias, .F. })
		//	Aadd( aFields, {"(IF(Empty(Alltrim(CB0_USERGI)),'',Left(Embaralha(CB0_USERGI,1),15)))",'USUARIO','C', '@!',	10, 0, cAlias, .F. })
		Aadd( aFields, {"(IF(Empty(Alltrim(CB0_USERGI)),'',(IF(GetMv('MV_NEWMCSG'),Alltrim(FWLeUserlg('CB0_USERGI')),Left(Embaralha(CB0_USERGI,1),15) )) ))",'USUARIO','C', '@!',	10, 0, cAlias, .F. })

	Endif
	Aadd( aFields, {'CB0_QTDE',	'QTDE','N', cMaskVal, 14, 4, cAlias, .T. })
	If MV_PAR10 == 1 // Se for Sintetico
		Aadd( aFields, {'UNIDADES','UNIDADES','N', cMaskVal, 14, 4, cAlias, .T. })
	Endif
	Aadd( aFields, {'B1_UM',' UM ','C', '@!', 2, 0, cAlias, .F. })


	For _nA := 1 To len( aFields )
		Aadd( aTotPar, 0 )
		Aadd( aTotGer, 0 )
	Next _nA
	SX3->( dbSetOrder( 2 ) )
	For _nA := 1 To Len( aFields )
		If SX3->( dbSeek( aFields[_nA,1] ) )
			If Empty( aFields[_nA,2] ) // Titulo
				aFields[_nA,2] := Trim( SX3->X3_TITULO )
			EndIf
			If Empty( aFields[_nA,3] ) //Tipo do Campo
				aFields[_nA,3] := SX3->X3_TIPO
			EndIf
			If Empty( aFields[_nA,4] ) //Picture
				aFields[_nA,4] := SX3->X3_PICTURE
			EndIf
			If Empty( aFields[_nA,5] ) //Tamanho do Campo
				aFields[_nA,5] := SX3->X3_TAMANHO
			EndIf
			If Empty( aFields[_nA,6] ) //Tamanho Decimal
				aFields[_nA,6] := SX3->X3_DECIMAL
			EndIf
		EndIf
	Next _nA


	Aadd( aCabec, '' )
	Aadd( aCabec, '' )
	Aadd( aCabec, '' )


	For _nA := 1 To Len( aFields )
		If Len( aFields[ _nA, 2] ) < aFields[_nA, 5]
			aCabec[1] += Repl( '_' , aFields[_nA,5] ) + '_'
			If aFields[_nA, 3] = 'N'
				aCabec[2] += PadL( aFields[ _nA, 2], aFields[_nA,5], Space(1) ) + ' '
			Else
				aCabec[2] += PadC( aFields[ _nA, 2], aFields[_nA,5], Space(1) ) + ' '
			EndIf
			aCabec[3] += Repl( '_' , aFields[_nA,5] ) + '_'
		Else
			aCabec[1] += Repl( '_' , Len( aFields[ _nA, 2] ) ) + '_'
			If aFields[_nA, 3] = 'N'
				aCabec[2] += PadL( aFields[ _nA, 2], Len( aFields[ _nA, 2] ), Space(1) ) + ' '
			Else
				aCabec[2] += PadC( aFields[ _nA, 2], Len( aFields[ _nA, 2] ), Space(1) ) + ' '
			EndIf
			aCabec[3] += Repl( '_' , Len( aFields[ _nA, 2] ) ) + '_'
		EndIf
	Next _nA

	Cabec1 := PadC( AllTrim( Cabec1 ), Limite )
	Cabec2 := PadC( AllTrim( Cabec2 ), Limite )

	nLin := 80
	&(cAlias)->( dbGoTop() )


	cCodTes:=(cAlias)->CB0_CODPRO

	While !(cAlias)->( Eof() )
		cLinha	:= ''
		IncRegua()
		If !Empty(cFilterUser).and.!(&cFilterUser)
			(cAlias)->( dbSkip() )
			Loop
		Endif

		//Processa o Cabecalho
		If nLin+1 >= 68
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			For _nF := 1 To len( aCabec )
				@nLin++, 00 PSay PadC(aCabec[_nF], Limite)
			Next _nF
		EndIf


		For _nC := 1 To Len( aFields )
			If Len( aFields[ _nC, 2] ) < aFields[_nC, 5]
				nAjusTam := aFields[_nC, 5]
			Else
				nAjusTam := Len( aFields[ _nC, 2] )
			EndIf
			If aFields[_nC,3] == 'C'
				cLinha += PadC( &(cAlias+'->'+ aFields[_nC,1]) , nAjusTam ) + ' '
			ElseIf aFields[_nC,3] == 'D'
				cLinha += PadC( DtoC(&(cAlias+'->'+ aFields[_nC,1])), nAjusTam ) + ' '
			ElseIf aFields[_nC,3] == 'N'
				cLinha += PadC( TransForm(&(cAlias+'->'+ aFields[_nC,1]),aFields[_nC,4]), nAjusTam, ' ' ) + ' '
			EndIf
			If aFields[_nC,8]
				aTotPar[_nC] += &( cAlias + '->' + aFields[_nC,1] )
				aTotGer[_nC] += &( cAlias + '->' + aFields[_nC,1] )
			EndIf
		Next _nC

		nRegPar++
		nRegTot++
		nValTot := nValTot + (cAlias)->CB0_QTDE

		cTit := ' TOTAL GERAL'
		&(cAlias)->( dbSkip() )
		//Imprime os dados
		@ nLin++, 00 PSay PadC( cLinha, Limite )

		If cCodTes <> (cAlias)->CB0_CODPRO .OR. (cAlias)->( Eof() )

			//		cTit := 'SUB-TOTAL'
			cTit := 'SUB-TOTAL ( ITENS LISTADOS ' + AllTrim(Str(nRegPar)) + ' )'
			@nLin++, 00 PSay PadC(aCabec[3], Limite)
			If nLin+3 > 68
				nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
			EndIf
			@nLin++, 00 PSay PadC(Repl('', Len(aCabec[3])), Limite)
			cLinha := ''
			For _nC := 1 To Len( aFields )
				If Len( aFields[ _nC, 2] ) < aFields[_nC, 5]
					nAjusTam := aFields[_nC, 5]
				Else
					nAjusTam := Len( aFields[ _nC, 2] )
				EndIf
				If aFields[_nC,8]
					cLinha := Substr( cLinha, 1, Len( cLinha )-1 ) + '' + PadL( TransForm( aTotPar[_nC], aFields[_nC,4] ), nAjusTam, ' ' ) + ''
				Else
					cLinha += Space( nAjusTam+1 )
				EndIf
			Next _nC
			cLinha :=  cTit + Subs( cLinha, Len( cTit )+1 )
			@nLin++, 00 Psay PadC(cLinha, Limite)
			@nLin++, 00 PSay PadC(Repl('', Len(aCabec[3])), Limite)
			//		@nLin++, 00 PSay PadC( PadR('QTDE DE ITENS LISTADOS: ' + AllTrim( TransForm( nRegPar, Subs(cMaskVal,1,len(cMaskVal)-3))), Len(aCabec[3])), Limite)
			nLin++
			If !(cAlias)->( Eof() )
				For _nF := 1 To len( aCabec )
					@nLin++, 00 PSay PadC(aCabec[_nF], Limite)
				Next _nF
			EndIf

			cCodTes := (cAlias)->CB0_CODPRO

			For _nG := 1 To len( aFields )
				aTotPar[_nG] := 0
			Next _nG
			nRegPar := 0
		EndIf


		//Fecha o quadro se precisar mudar de pagina
		If nLin+1 >= 68
			@nLin++, 00 PSay PadC(aCabec[3], Limite)
		EndIf
	EndDo

	cTit := ' TOTAL GERAL ( ITENS LISTADOS ' + AllTrim(Str(nRegTot)) + ' )'
//cTit := ' TOTAL GERAL'
	@nLin++, 00 PSay PadC(Repl(' ', Len(aCabec[3])), Limite)
	cLinha := ' '
	For _nC := 1 To Len( aFields )
		If Len( aFields[ _nC, 2] ) < aFields[_nC, 5]
			nAjusTam := aFields[_nC, 5]
		Else
			nAjusTam := Len( aFields[ _nC, 2] )
		EndIf
		If aFields[_nC,8]
			cLinha := Substr( cLinha, 1, Len( cLinha )-1 ) + ' ' + PadL( TransForm( aTotGer[_nC], aFields[_nC,4] ), nAjusTam, ' ' ) + ' '
		Else
			cLinha += Space( nAjusTam+1 )
		EndIf
	Next _nC

// cLinha := 'SUB-TOTAL ( ITENS LISTADOS ' + AllTrim(Str(nRegPar)) + ' )'
	cLinha := PADR('   TOTAL ',Limite/2," ") + PADL(Transform( nValTot, "@E 999,999,999.99" )+Space(4),Limite/2," ")


	@nLin++, 00 Psay PadR(cLinha, Limite)
	@nLin++, 00 PSay PadC(Repl(' ', Len(aCabec[3])), Limite)

Return

/*/
{Protheus.doc} AJUSTECPO
..
@type function ...
@version  Sem versão
@author Cledison RIbeiro
@since 02/07/04
/*/
Static Function AjusteCpo( cAlias )
	Local aStru := (cAlias)->( dbStruct() )
	Local _nX :=0 // Alterado por Cledison Ribeiro em 24.02.21

	SX3->( dbSetOrder( 2 ) )
	For _nX := 1 To Len( aStru )
		If SX3->( dbSeek( aStru[_nX, 1] ) )
			If SX3->X3_TIPO <> 'C'
				TcSetField( cAlias, aStru[_nX, 1], SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL )
			EndIf
		EndIf
	Next _nX
Return
