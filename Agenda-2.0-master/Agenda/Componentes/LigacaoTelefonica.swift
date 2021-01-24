//
//  LigacaoTelefonica.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 30/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class LigacaoTelefonica: NSObject {
    
    func fazLigacao(_ alunoSelecionado: Aluno){
        
        guard let numeroDoAluno = alunoSelecionado.telefone else { return  }
       
        //url para acessar aplicativos pela UIAplication e verificar se é possivel fazer ligação
        if let url = URL(string: "tel://\(numeroDoAluno)"), UIApplication.shared.canOpenURL(url){
            
            //chamando a função de chamada telefonica
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
