#INCLUDE 'protheus.ch'
#INCLUDE 'TopConn.ch'
#INCLUDE 'parmtype.ch'

user function AxCad()
    //Criação das variáveis
    Local cAlias := "SB6"
    Local cTitulo := "SALDO EM PODER DE TERCEIROS"
    Local cExc := ".T."
    Local cAlt := ".T."
    
    //AxCadastro é uma função para visualização de dados. Ele exibirá uma tela de cadastro já construída dentro do Protheus.
    //Os parâmetros são: AxCadastro(Alias, Titulo, Exclur, Alterar).
    AxCadastro(cAlias, cTitulo, cExc, cAlt)
RETURN
