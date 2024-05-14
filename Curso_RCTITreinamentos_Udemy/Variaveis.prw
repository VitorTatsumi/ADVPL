#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

User Function Variavel()
    //Para variáveis locais, geralmente utiliza-se a inicial em minúsculo referente ao tipo de dado no inicio do nome da variável
    Local nVar := 1
    //Variáveis públicas podem ser visíveis em qualquer local do fonte em que foram declaradas
    Public cVar := 'Vitor'
    //Variáveis privadas
	//Caso não seja atribuído o identificador de variável, o ADVPL atribuirá automaticamente o Private. Ex: cVar := 66.
	//Variáveis Private podem ser utilizadas por todo o programa, até que sejam destruídas. Para se destruir uma variável, deve-se atribuir outro valor à variável de mesmo nome ou ao término da execução do programa em que foi criada.
    Private __cVar := 'Tatsumi'
	//Funções Static podem ser declaradas dentro da Função, fazendo com que seja somente possível utiliza-la dentro da função em que foi declarada. Caso seja declarada fora da função, poderá ser utilizada em qualquer função do Fonte.
	Static nNumero := 66
RETURN
