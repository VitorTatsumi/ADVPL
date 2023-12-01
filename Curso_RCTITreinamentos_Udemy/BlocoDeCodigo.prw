#INCLUDE 'protheus.ch'

/**
Um bloco de dados pode armazenar um valor de variável ou comando a ser executado.
Para executar o bloco, é utilizado o EVAL(nomeDoBloco)
**/
user function bloco()
    // Os caracteres || são utilizados para parâmetros, mas podem ficar em branco também, em seguida vem seu comando 
    Local bBloco := {|| Alert("Olá mundo")}
    //Comando EVAL para executar o bloco de comando
    eVal(bBloco)
RETURN

/**
O bloco pode conter parâmetros dentro dos caracteres "||", caso haja, seu valor deverá ser passado através do EVAL(nomeDoBloco, "Texto da variável de parâmetro")
**/
user function blocoParam()
    //Bloco de código com parâmetro
    Local bBloco := {|cVar| Alert(cVar)}
    //Eval com o valor do texto de código
    eVal(bBloco, "Texto de cVar")
RETURN

