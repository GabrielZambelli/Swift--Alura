//
//  Pagamento.swift
//  Leilao
//
//  Created by Gabriel Zambelli on 16/04/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import Foundation


class Pagamento{
    
    private var valor:Double
    private var data: Date
    
    init(_ valor: Double, _ data:Date){
        self.valor = valor
        self.data = data
    }
    
    func getValor() -> Double{
        return self.valor
    }
    
    func getData() -> Date{
        return self.data
    }
    
}
