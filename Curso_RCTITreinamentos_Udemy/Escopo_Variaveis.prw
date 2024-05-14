#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#Include "TOTVS.ch"

//Variáveis Static
Static cStat := ''

User function Principal()

	//Variáveis Locais
	Local nVar0 := 1
	Local nVar1 := 20
	//Variáveis Private
	Private cPriv := 'Private'
	//Variáveis Public
	Public __cPublic := 'Tatsumi'
	//Chamando a função Static e referenciando as variáveis
	//A referência à variável dá-se pelo '@'
	testeEscopo(@nVar0, @nVar1)

Return

Static function testeEscopo(nValor0, nValor1)
	//Alterando o valor da variável Public
	Local __cPublic := 'Alterado!'
	//Valor Default atribuído à variável, caso não seja atribuído nenhum valor a ela nesta função
	Default nValor0 := 0

	//Alterando o conteúdo da variável local
	nValor1 := 10

	//Mostrando conteúdo das variáveis Private, Public e Static
	Alert("Private: " + cPriv)
	Alert("Public: " + __cPublic)
	MsgAlert(nValor1)
	Alert("Static: " + cStat)
 
Return
