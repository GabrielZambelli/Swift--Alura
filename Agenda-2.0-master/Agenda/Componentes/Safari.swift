//
//  Safari.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 30/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import SafariServices

class Safari: NSObject {

    
    func abrePaginaWeb(_ alunoSelecionado: Aluno, controller: UIViewController){
        //recupera o site do aluno
        if let urlDoAluno = alunoSelecionado.site{
            
            var urlFormatada = urlDoAluno
            //verifics se inicia com http caso não, adiciona
            if !urlFormatada.hasPrefix("http://"){
                urlFormatada = String(format: "http://%@", urlFormatada)
            }
            //convert string em URL
            guard let url = URL(string: urlFormatada) else { return }
            
            let safariViewController = SFSafariViewController(url: url)
            controller.present(safariViewController, animated: true, completion: nil)
           // UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
