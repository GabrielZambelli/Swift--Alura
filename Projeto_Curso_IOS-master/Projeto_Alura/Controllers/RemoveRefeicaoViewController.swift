//
//  RemoveRefeicaoViewController.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 30/01/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation
import UIKit


class RemoveRefeicaoViewController{
    
    let controller: UIViewController
    
    init(controller: UIViewController){
        self.controller = controller
    }
    
    func exibe(_ refeicao: Refeicao, handler: @escaping (UIAlertAction) -> Void){
        
        //cria o Modal (UIAlertController)
        let alert = UIAlertController(title: refeicao.nome, message: refeicao.detalhes(), preferredStyle: .alert)
        
        //Adicionando um botão no Modal UIAlertController
        let botaoCancelar = UIAlertAction(title: "ok", style:.cancel)
        alert.addAction(botaoCancelar)
        
        //adicionando o botão remover ao modal, utilizando um closure("lambda)" no manipulador Handler
        let botaoRemover = UIAlertAction(title: "remover", style: .destructive, handler: handler)
        
        alert.addAction(botaoRemover)
        
        // exibir o UiAlertController
        self.controller.present(alert, animated: true, completion: nil)
    }
}

/*
 Comentarios
 
 Exemplo de Closures:
 usado para passar funcoes como parametros
 
 handler: {alert in
     self.refeicoes.remove(at: indexPath.row)
     self.tableView.reloadData()
 })
 *******************
 
 @escaping guarada a referencia da closure para utilizar apenas depois de ação de um botao por exemplo, clouse não fica salva na memoria a menos que utilize o @escaping
 
 */
