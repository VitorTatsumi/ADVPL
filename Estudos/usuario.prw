#INCLUDE 'protheus.ch'

user function usuario()
    //Local usuID := __cUserID
    //cUserName para verificar o nome do usuário corrente
    Local usuNome := cUserName
    Local tst := FWGrpAcess(cGrpID)	

    If ! usuNome == "vrosa"
        MSGALERT( usuID, usuNome )
        MSGALERT( tst )
    else 
        MSGALERT( "Você não está autenticado")
        
    endif
return
