//
//  LeiloesViewController.swift
//  Leilao
//
//  Created by Gabriel Zambelli on 20/04/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class LeiloesViewController: UIViewController {

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Atributos
    
    private var listaDeLeiloes:[Leilao] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Metodos
    
    func addLeilao(_ leilao:Leilao){
        listaDeLeiloes.append(leilao)
    }
}

//MARK: - Table View Data Source

extension LeiloesViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaDeLeiloes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celulaLeilao = tableView.dequeueReusableCell(withIdentifier: "LeilaoTableViewCell", for: indexPath)
        
        return celulaLeilao
    }
    
    
    
}


