//
//  Alerta.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 27/01/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation
import UIKit

class Alerta{
    
    let controller: UIViewController
    
    init(controller:UIViewController){
        self.controller = controller
    }
    
    func exibe(titulo: String = "Atenção", mensagem:String){
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(buttonOk)
        self.controller.present(alert, animated: true, completion: nil)
    }
}
