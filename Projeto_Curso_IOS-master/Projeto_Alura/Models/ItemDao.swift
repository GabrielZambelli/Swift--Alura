//
//  ItemDao.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 01/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation


class ItemDao{
    
    func save(_ itens:[Item]){
        do{
            //throw function
            let data = try NSKeyedArchiver.archivedData(withRootObject: itens, requiringSecureCoding: false)
            guard let caminho = recuperaDiretorio() else {return}
            try data.write(to: caminho)
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func recupera() -> [Item]{
        do{
            guard let diretorio = recuperaDiretorio() else {return[]}
            let dados = try Data(contentsOf: diretorio)
            //desarquivando os dados e fazendo cast para Item
            let itensSalvos = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dados) as! [Item]
            
            return itensSalvos
        }
        catch{
            print(error.localizedDescription)
            return []
        }
    }
    
    func recuperaDiretorio() -> URL?{
        //FileManager gerenciador de diretorios do IOS, resgatando diretorio
        guard let diretorio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        //adicionando pasta, caminho ao diretorio, ao Path
        let caminho = diretorio.appendingPathComponent("itens")
        
        return caminho
    }
    
}
