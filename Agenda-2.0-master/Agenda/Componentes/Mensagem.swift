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
    
    var delegate: MFMessageComposeViewControllerDelegate?
    
    //MARK: - Metodos
    
    func setaDelegate() -> MFMessageComposeViewControllerDelegate?{
        delegate = self
        return delegate
    }
    
    func enviaSMS(_ aluno:Aluno, controller: UIViewController){
        
        //Verificação se o aparelho pode enviar sms
        if MFMessageComposeViewController.canSendText(){
            //iniciando o componente
            let componenteMensagem = MFMessageComposeViewController()
            
            //resgatando o numero do aluno
            guard let numeroAluno = aluno.telefone else { return }
            
            //numeros para envio [String]
            componenteMensagem.recipients = [numeroAluno]
            
            guard let delegate = setaDelegate() else { return }
            //setando o delegate do componente
            componenteMensagem.messageComposeDelegate = delegate
            
            controller.present(componenteMensagem, animated: true, completion: nil)
                        
        }
    }
    
    //MARK: - MessageComposeDelegate
    
    //apos terminar o envio do sms fechar
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
