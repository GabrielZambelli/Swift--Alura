//
//  Item.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 20/01/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    
    //MARK: - Atributos
    var nome: String
    var calorias: Double
    
    //MARK: - Contrutor
    init(nome:String, calorias:Double){
        self.nome = nome
        self.calorias = calorias
    }
    
    //MARK: - NSCoding
    //converte os dados para byte
    func encode(with coder: NSCoder) {
        coder.encode(nome,forKey: "nome")
        coder.encode(calorias, forKey: "calorias")
    }
    //decode
    required init?(coder: NSCoder) {
        nome = coder.decodeObject(forKey: "nome") as! String
        calorias = coder.decodeDouble(forKey: "calorias")
    }
}
