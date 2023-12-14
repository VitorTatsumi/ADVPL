#include "protheus.ch"
#include 'parmtype.ch'
#include 'rwmake.ch'

/*
Um ponto de entrada é uma abertura num código padrão do Protheus para customização de rotinas. Ele pega uma rotina já pronta, e adapta para a necessidade do usuário de acordo com a programação feita. 
Deve ser criada como User Function e o mesmo nome do fonte padrão protheus, contendo as customizações na função.
O funcionamento do Ponto de Entrada depende totalmente de como o código fonte padrão Protheus está estruturado, então, há algumas variáveis que são necessárias retornar (como no caso do lExecuta).
*/
user function A010TOK()
    Local lExecuta := .T.
    /* 
    O "M" serve para indicar um dado que está armazenado na memória do campo informado. Ou seja, quando o campo for alimentado, será passado um valor para a memória, e a partir disto, será retornado o valor para a variável.
    */
    Local cTipo := ALLTRIM(M-> B1_TIPO)
    Local cConta := ALLTRIM(M->B1_CONTA)
        /*
        Aqui ocorre uma validação, onde ao salvar, verifica se os valores armazenados na memória e que foram salvos nas variáveis batem com os valores dispostos na condicional.
        Neste caso, verifica se o valor das variáveis de Tipo e Conta são as que foram informadas na condicional, caso seja, será anulada a solicitação de inclusão/salvar.
        */
        IF (cTipo = "PA" .AND. cConta = "11101000003")
            Alert("Não é possível cadastrar este tipo de produto com a conta informada.")
            //A variável lExecuta serve para validação da continuidade do programa.
            lExecuta := .F.
        ENDIF
//Retorna o resultado da varivel lExecuta para dar continuidade ou não do programa, e/ou, salvar as informações.
RETURN(lExecuta)
