#INCLUDE 'protheus.ch'

User Function DoCase()

    LOCAL cData := '00/09/2023'

    //Para efetuar uma condicional com o método CASE é necessário iniciar o comando com DO CASE e ao final encerrar o comando com ENDCASE. O comando OTHERWISE é utilizado para definiri um padrão caso nenhum dos cases seja verdadeiro.

    DO CASE
        CASE cData == '11/09/2023'
            alert( 'Primeiro dia de trabalho em Promex!' )
        CASE cData == '12/09/2023'
            MSGINFO( 'Segundo dia de trabalho em Promex!' )
        CASE cData == '13/09/2023'
            MSGINFO( 'Terceiro dia de trabalho e Promex!' )
        OTHERWISE
            MSGALERT( 'Que dia é hoje? Não consegui localizar!' )
    ENDCASE
RETURN


