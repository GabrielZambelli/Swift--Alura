//
//  Notificacoes.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 22/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {
    
    func exibinotificacaoDeMediasDosAlunos(dicionarioDeMedia: Dictionary<String, Any>) -> UIAlertController? {
        if let media = dicionarioDeMedia["medias"] as? String{
            let alerta = UIAlertController(title: "Atenção", message: "a média geral dos alunos é \(media)", preferredStyle: .alert)
            
            let botao = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(botao)
            return alerta
        }
        return nil
    }

}
