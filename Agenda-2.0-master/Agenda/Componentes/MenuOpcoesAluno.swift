//
//  MenuOpcoesAluno.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 01/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class MenuOpcoesAluno: NSObject {
    
    func configuraMenuOpcaoDoAluno(navigation: UINavigationController, alunoSelecionado: Aluno) -> UIAlertController{
        //criando o menu
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma das opções abaixo", preferredStyle: .actionSheet)
       
        //extraindo o ViwController do navigation
        guard let viewController = navigation.viewControllers.last else { return menu }
        
        //criando as opções
        let sms = UIAlertAction(title: "Enviar SMS", style: .default) { (acao) in
            Mensagem().enviaSMS(alunoSelecionado, controller: viewController)
        }
        
        let ligacao = UIAlertAction(title: "Ligar", style: .default) { (acao) in
            LigacaoTelefonica().fazLigacao(alunoSelecionado)
        }
        let waze = UIAlertAction(title: "Licalizar no Waze", style: .default) { (acao) in
            Localizacao().localizaAlunoNoWaze(alunoSelecionado)
        }
        
        let mapa = UIAlertAction(title: "Localizar no Mapa", style: .default) { (acao) in
           //Instanciado o ViewController da tela Mapa
           let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mapa") as! MapaViewController
           mapa.aluno = alunoSelecionado
            navigation.pushViewController(mapa, animated: true)
        }
        
        let paginaWeb = UIAlertAction(title: "Abrir página", style: .default) { (acao) in
            Safari().abrePaginaWeb(alunoSelecionado, controller: viewController)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style:.cancel, handler: nil)
        
        menu.addAction(sms)
        menu.addAction(cancelar)
        menu.addAction(ligacao)
        menu.addAction(waze)
        menu.addAction(mapa)
        menu.addAction(paginaWeb)
        
        return menu
    }

}
