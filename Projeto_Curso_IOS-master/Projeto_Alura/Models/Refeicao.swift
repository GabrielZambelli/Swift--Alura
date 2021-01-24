//
//  Refeicao.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 20/01/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//
import UIKit

class Refeicao: NSObject, NSCoding {
    
    
    // MARK: - Atributos
    
    let nome: String
    let felicidade: Int
    var itens: Array<Item> = []
    
    //MARK: - Contrutor
    init (nome: String, felicidade: Int, itens:[Item] = [] ){
        self.nome = nome
        self.felicidade = felicidade
        self.itens = itens
    }
    // MARK: - NSCoding
    
    //codificar atributos, tranformar os objetos em bytes para salvar em um arquivo
    func encode(with coder: NSCoder) {
        //forkey é uma palavra chave para conseguir recuperar o objeto, para fazer decoded
        coder.encode(nome,forKey: "nome")
        coder.encode(felicidade, forKey: "fecilidade")
        coder.encode(itens, forKey: "itens")
    }
    
    required init?(coder: NSCoder) {
        nome = coder.decodeObject(forKey: "nome") as! String //para String devemos fazer um cast
        felicidade = coder.decodeInteger(forKey: "felicidade")
        itens = coder.decodeObject(forKey: "itens") as! [Item]
    }
    
    // MARK: - Metodos
    
    func totalDeCalorias() -> Double{
        var total: Double = 0.0
        
        for item in itens{
            total += item.calorias
        }
        
        return total
    }
    
    func detalhes() -> String{
        
        var mensagem = "Felicidade: \(self.felicidade)"
        
        for item in self.itens{
            mensagem += ", \(item.nome) - calorias: \(item.calorias)"
        }
        return mensagem
    }
}
