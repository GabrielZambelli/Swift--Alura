//
//  MenuOpcoesAluno.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 01/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

enum MenuActionSheetAluno{
    case SMS
    case LIGACAO
    case WAZE
    case MAPA
    case PAGINAWEB
}

class MenuOpcoesAluno: NSObject {
    
    func configuraMenuOpcaoDoAluno(completion:@escaping(_ opcao:MenuActionSheetAluno)-> Void) -> UIAlertController{
        //criando o menu
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma das opções abaixo", preferredStyle: .actionSheet)
        
        //criando as opções
        let sms = UIAlertAction(title: "Enviar SMS", style: .default) { (acao) in
            completion(.SMS)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style:.cancel, handler: nil)
        
        let ligacao = UIAlertAction(title: "Ligar", style: .default) { (acao) in
            completion(.LIGACAO)
        }
        let waze = UIAlertAction(title: "Licalizar no Waze", style: .default) { (acao) in
            completion(.WAZE)
        }
        
        let mapa = UIAlertAction(title: "Localizar no Mapa", style: .default) { (acao) in
            completion(.MAPA)
        }
        
        let paginaWeb = UIAlertAction(title: "Abrir página", style: .default) { (acao) in
            completion(.PAGINAWEB)
        }
        
        menu.addAction(sms)
        menu.addAction(cancelar)
        menu.addAction(ligacao)
        menu.addAction(waze)
        menu.addAction(mapa)
        menu.addAction(paginaWeb)
        
        return menu
    }

}
