//
//  ViewController.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 20/01/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation
import UIKit

protocol AdicionarRefeicaoDelegate{
    func add(_ refeicao:Refeicao)
}

class AdicionarRefeicaoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdicionarItensDelegate {
    
    //MARK: - Atributos
    
    var delegate: AdicionarRefeicaoDelegate?
    var itens: [Item] = []
    var itensSelecionados:[Item] = []
    
    //MARK: - TableDataSource
    
    //metodo obrigatorio, quantidade de linhas da TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    //metodo obrigatorio, inseri dados a celula da tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: nil)
        celula.textLabel?.text = itens[indexPath.row].nome
        return celula
    }
    
    
    //MARK: - UiTableViewDelegate
    
    //Identifica qual celula foi selecionada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //resgatar celula
        guard let celula = tableView.cellForRow(at: indexPath) else { return }
        
        // marca ou desmarca celula
        if celula.accessoryType == .none {
            celula.accessoryType = .checkmark
            itensSelecionados.append(itens[indexPath.row])
        }else {
            celula.accessoryType = .none
            
            let item = itens[indexPath.row]
            if let position = itensSelecionados.firstIndex(of: item){
                itensSelecionados.remove(at: position)
            }
        }
    }
    
    //MARK: - IBOutlet
    @IBOutlet var nomeTextField: UITextField? //force Unwrapping
    @IBOutlet var felicidadeTextField: UITextField?
    @IBOutlet weak var itensTableView: UITableView?
    
    //MARK: - View life cycle
    //adicionando um botão programaticamente
    override func viewDidLoad(){
        let botaoAdicionarItem = UIBarButtonItem(title: "adicionar", style: .plain, target: self, action: #selector(adicionarItem))
        navigationItem.rightBarButtonItem = botaoAdicionarItem
        recuperaItens()
    }
    
    //MARK: - Metodos
    
    func recuperaItens(){
        itens=ItemDao().recupera()
    }
    
    @objc func adicionarItem(){
        let adicionarItensViewController = AdicionarItensViewController(delegate: self)
        navigationController?.pushViewController(adicionarItensViewController, animated: true)
    }
    
    func add(_ item: Item) {
        itens.append(item)
        ItemDao().save(itens)
        if let tableView = itensTableView{
            tableView.reloadData()
        }
        else{
            Alerta(controller: self).exibe(titulo: "Desculpe", mensagem: "Não foi possível atualizar a tabela")
        }
        //itensTableView?.reloadData()
    }
    
    func recuperarRefeicaoDoFormulario() -> Refeicao?{
        
        guard let nomeDaRefeicao = nomeTextField?.text else{ return nil}
        guard let felicidadeDaRefeicao = felicidadeTextField?.text, let felicidade = Int(felicidadeDaRefeicao) else{return nil}
        let refeicao = Refeicao(nome: nomeDaRefeicao, felicidade: felicidade, itens: itensSelecionados)
        return refeicao
    }
    
    //MARK: - IBAction
    @IBAction func adicionar(_ sender: Any) {
        if let refeicao = recuperarRefeicaoDoFormulario(){
            delegate?.add(refeicao)
            navigationController?.popViewController(animated: true)
        }else{
            Alerta(controller: self).exibe(mensagem: "Erro ao ler dados do formulário")
        }
    }
    
}

//Comentários Curso
/*

 @IBOutlet var nomeTextField: UITextField! //(!) = force Unwrapping
 
 Declarando variável:
 let nome = "churros"          -> emplicita
 let felicidade: String = "5"  -> explicita


 if let exemplo:
 
if let nomeDaRefeicao = nomeTextField?.text, let felicidadeDaRefeicao = felicidadeTextField?.text{

 if let felicidade = Int(felicidadeDaRefeicao){
   let refeicao = Refeicao(nome: nomeDaRefeicao, felicidade: felicidade)

     print("comi \(refeicao.nome) e fiquei com felicidade: \(refeicao.felicidade)")
 }
 else
 {
     print("Erro ao tentar criar a refeição")
 }
}
\*/

