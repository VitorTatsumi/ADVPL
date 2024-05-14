#INCLUDE 'protheus.ch'

User Function DoCase()
	//DAY() para extrair o dia de uma data
	Local cDia := DAY(DATE())
	//MONTH() para extrair o mês de uma data
	Local cMes := MONTH(DATE())
	//YEAR() para extrair o ano de uma data
	LOCAL cAno := YEAR(DATE())
	//DATE() para retornar uma data
	LOCAL cDataCompleta := DATE()
	//MESEXTENSO() para retornar o mês por extenso da data atual
	LOCAL cDataMesExtenso := MESEXTENSO()

	//CHR(13) + CHR(10) para efetuar a quebra de linha 
	MsgAlert( "Dia: " + cValToChar(cDia) + Chr(13) + Chr(10) + "Mês: " + cValToChar(cMes) + Chr(13) + Chr(10) + "Ano: " + cValToChar(cAno))

	DO CASE
		CASE cDia = 9 .AND. cMes = 12
			Alert('Seu aniversário é hoje!')
		CASE cDia = 25 .AND. cMes = 12
			Alert('Então é Natal!')
		CASE cDia = 1 .AND. cMes = 1
			Alert('Feliz ano novo!')
		OTHERWISE
			Alert('Tente novamente em outra data... ' + CHR(13) + CHR(10) + "Hoje é dia: " + cValToChar(cDataCompleta) + CHR(13) + CHR(10) + "Mês atual: " + cValToChar(cDataMesExtenso))
	ENDCASE
Return
