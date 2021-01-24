//
//  ViewController.swift
//  Alura Viagens
//
//  Created by Gabriel Zambelli on 03/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //-- MARK: - Atributos
    let listaViagens:[Viagem] = ViagemDAO().retornaTodasAsViagens()
    
    
    //-- MARK: - life view cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setar delegate da tabela
        self.tabelaViagens.delegate = self
        self.tabelaViagens.dataSource = self
        self.viewPacotes.layer.cornerRadius = 10
        self.viewHoteis.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    //-- MARK: - IBOutlet
    
    @IBOutlet weak var tabelaViagens: UITableView!
    @IBOutlet weak var viewHoteis: UIView!
    @IBOutlet weak var viewPacotes: UIView!
    
    //-- MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaViagens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //busca no storyboard a celula com Identifier = cell
        //cast para a class que criamos para controlar a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let viagemaAtual = listaViagens[indexPath.row]
        cell.configuraCelula(viagem: viagemaAtual)
        return cell
    }
    //Setando a altura da Linha
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom ==  UIUserInterfaceIdiom.phone ? 175: 250
    }
    

    
    


}

