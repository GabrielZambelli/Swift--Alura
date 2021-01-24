//
//  Mensagem.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 01/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    
    
    //MARK: - Metodos
    
    func configuraSMS(_ aluno:Aluno) -> MFMessageComposeViewController?{
        
        //Verificação se o aparelho pode enviar sms
        if MFMessageComposeViewController.canSendText(){
            //iniciando o componente
            let componenteMensagem = MFMessageComposeViewController()
            
            //resgatando o numero do aluno
            guard let numeroAluno = aluno.telefone else { return componenteMensagem }
            
            //numeros para envio [String]
            componenteMensagem.recipients = [numeroAluno]
            //setando o delegate do componente
            componenteMensagem.messageComposeDelegate = self
            
            return componenteMensagem
        }
        
        //caso o componente não possa ser instanciado
        return nil
        
    }
    
    //MARK: - MessageComposeDelegate
    
    //apos terminar o envio do sms fechar
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
