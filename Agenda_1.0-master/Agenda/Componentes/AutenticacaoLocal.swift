//
//  AutenticacaoLocal.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 22/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import LocalAuthentication  //devemos importar para utilizar os recursos de autenticação

class AutenticacaoLocal: NSObject {

    //autorizaUsuario receber uma closure para completar a operação
    func autorizaUsuario(completion: @escaping(_ autenticado: Bool) -> Void){
        
        var error: NSError?
        
        //Autenticação Local
        let context = LAContext()
        
        //iremos verificar se o recurso esta disponível
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            
            //chamada do metodo de autenticação
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "é necessario a autenticação para apagar um aluno") { (resposta, erro) in
                completion(resposta)
            }
        }
    }
}

//MARK: - Comentários
/*

 
 */
