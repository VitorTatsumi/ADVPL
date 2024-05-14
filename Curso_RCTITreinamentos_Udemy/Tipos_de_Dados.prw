#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#Include "TOTVS.ch"

user function TipoDado()
    Local nNum := 66 //Suporta números com casas decimais e números maiores: 6.3, 2000, 240.24
    Local lLogic := .T. //Pode ser .T. ou .F.
    Local cCarac := "Texto" //Suporte para aspas simples ou duplas
    Local dData := DATE() //Retorna a data do sistema, com separações por barras. Ex: 09/12/1997
    Local aArray := {"João", "Maria", "Jose"}
	//Houveram tentativas de exibir o conteúdo do bloco de código através de MsgAlert, mas não foi possível, sendo necessário utilizar o Alert ao invés.
    Local bBloco := {|| nValor := 2, Alert("O número é: " + cValToChar(nValor))}
    //cValToChar(variável) é uma função para tratar o dado e transforma-lo em char, para que possa ser concatenado com uma string, entre outras opções.
    Alert(nNum)
    Alert(lLogic)
    Alert(cValToChar(cCarac))
    Alert(dData)
    Alert(aArray[1]) //Aqui, o retorno é referente ao primeiro índice do Array.
    //Para executar blocos de código, é necessário utilizar o EVAL
    Eval(bBloco)
return
