//
//  RefeicoesTableViewController.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 21/01/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation
import UIKit


class RefeicoesTableViewController: UITableViewController, AdicionarRefeicaoDelegate{
    
    var refeicoes:[Refeicao] = []
    
    override func viewDidLoad() {
        refeicoes = RefeicaoDao().recupera()
    }
    
    //Números de linha de uma tableView, obrigatório!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refeicoes.count
    }
    
    //Criando e Preenchendo a Celula da tabela
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Criando uma Celula e adicionando um texto
        let celula = UITableViewCell(style: .default, reuseIdentifier: nil)
        let refeicao = refeicoes[indexPath.row]
        celula.textLabel?.text = refeicao.nome
        
        //criando um Gesture Recognizer do tipo LongPress e add a celula
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(mostrarDetalhes(_:)))
        celula.addGestureRecognizer(longPress)
        return celula
    }
    
    //Adicionando um refeição a lista
    func add(_ refeicao:Refeicao){
        refeicoes.append(refeicao)
        tableView.reloadData()
        
        RefeicaoDao().save(refeicoes)
    }
    
    //Ação do LongPress
    @objc func mostrarDetalhes(_ gesture: UILongPressGestureRecognizer){
        
        //verifica se o status do gestore é "começando"
        if gesture.state == .began{
            
            //pegando a view(genérica) do gesture, fazendo cast para view do tipo UITableViewCell
            let celula = gesture.view as! UITableViewCell
            
            //recuperar a posição da celula
            guard let indexPath = tableView.indexPath(for: celula) else {return}
            let refeicao = refeicoes[indexPath.row]
            
            RemoveRefeicaoViewController(controller: self).exibe(refeicao, handler: {alert in
                self.refeicoes.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
        }
    }
    
    //Definindo o delegate do destino do segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "adicionar"){
            if let adicionarRefeicaoViewController = segue.destination as? AdicionarRefeicaoViewController{
                adicionarRefeicaoViewController.delegate = self
            }
        }
    }
}

/*
Comentarios
 
Toda tabela deve possuir a funcao:
 numberOdSelections -> numero de linhas da tabela
 cellForRowAt -> retorna o que cada celular ira exibir no TableView

 
 Gesture Recognizer -> pode ser utilizado em qualquer objeto que herde de UIView
 
 UIAlertController -> no metodo present temos o podemos chamar um metodo quando ele acaba de exibir, utilize o completion
 */

