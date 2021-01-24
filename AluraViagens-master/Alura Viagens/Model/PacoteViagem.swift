//
//  PacoteViagem.swift
//  Alura Viagens
//
//  Created by Gabriel Zambelli on 15/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit

class PacoteViagem: NSObject {

    let nomeDoHotel: String
    let descricao: String
    let dataViagem:String
    @objc let viagem: Viagem
    
    
    init(nomeDoHotel: String, descricao:String, dataViagem: String, viagem:Viagem) {
        self.nomeDoHotel = nomeDoHotel
        self.descricao = descricao
        self.dataViagem = dataViagem
        self.viagem = viagem
       }
}
