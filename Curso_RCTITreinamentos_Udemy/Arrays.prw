#INCLUDE 'protheus.ch'


//Função para iniciar o Vetor
user function aVetor()

    //Variáveis locais
    Local dData := Date()
    //Array para armazenar diferentes tipos de dados
    Local aArray := {"Vitor Tatsumi", dData, 100}

    //Exibe o Array na sua determinada posição
    Alert(aArray[2])
return

//Manipulando um Vetor
user function aVetor1()

    //Criando um Vetor com 3 posições
    Local aArray := {10,20,30}
    //Criando um contador para o loop 
    Local cCont := 1

    //Loop WHILE para verificar se o valor do contador é menor ou igual ao valor do tamanho do Array    
    while cCont <= Len(aArray)
        //Enquanto for, será exibida uma mensagem informando a posição do Array atual 
        MsgAlert(aArray[cCont])
        //Soma +1 ao contador. 
        cCont++
    EndDo 
return

//Existem algumas funções de manipulação de Array em ADVPL

/**
AADD(nomeDoArray, valorParaAdicionar) 
Esta função adiciona o valor informado no Array determinado no parâmetro
**/
user function adiciona()
    //Cria um Vetor com 3 posições
    Local aArray := {10, 20, 30}
    //Adiciona ao Vetor aArray o valor de 40 à ultima posição
    aAdd(aArray, 40)
return

/**
AINS(nomeDoArray, posicaoDoArray)
nomeDoArray[posicaoDoArray] := valor
Esta função funciona juntamente com uma atribuição logo em seguida. Esta função insere um valor na posição do Array determinado no parâmetro. Caso não seja feita a atribuição logo em seguida, será atribuído o valor NIL/NULL à posição informada do Array.
**/
user function insere()
    //Cria Array com 3 posições
    Local aArray := {10, 20, 30}
    //Insere no aArray, na 4º posição
    aIns(aArray, 4)
    //Deve ser feita a atribuição também desta forma para informar o valor atribuído
    aArray[4] := 40
return

/**
ACLONE(NomeDoArray) 
Esta função clona o Array para outro Array. Deve ser utilizado quando for feita a atribuição ao Array.
**/
user function clona()
    //Cria o aArray com três posições
    Local aArray := {10, 20, 30}
    //Cria o aArray2 e clona o aArray para ele    
    aArray2 := aClone(aArray)
    //Exibe a posição 2 do aArray
    MSGALERT(aArray2[2])
RETURN

/**
ADEL(nomeDoArray, posicaoDoArray)
Esta função tem como objetivo deletar um elemento do Array de acordo com sua posição.
O Array não irá mudar de tamanho, o registro que for deletado será atribuído seu valor como NIL
**/
user function deleta()
    Local aArray := {10, 20, 30}
    //Executando comando para deletar do aArray a posição 2
    aDel(aArray, 2)
    //Exibe o terceiro registro do aArray
    MsgAlert(aArray[3])
RETURN



/**
ASIZE(nomeDoArray, posicaoDoArray)
Esta função manipula o tamanho do vetor, podendo excluir o seu último registro
**/
user function cSize()
    Local aArray := {10, 20, 30}
    //Muda o tamanho do aArray para um Array de 2 posições
    aSize(aArray, 2)
RETURN

/**
LEN(nomeDoArray)
Esta função retorna o tamaho do Array (quantidade de índices) parametrizado.
**/
user function comprimento()
    Local aArray := {10, 20, 30}
    //Exibe o tamanho do Array
    MSGALERT(Len(aArray))
RETURN
