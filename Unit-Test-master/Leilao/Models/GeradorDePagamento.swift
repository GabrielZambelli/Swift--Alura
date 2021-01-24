//
//  GeradorDePagamento.swift
//  Leilao
//
//  Created by Gabriel Zambelli on 16/04/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import Foundation

class GeradorDePagamento{
    
    private var leiloes:LeilaoDao
    private var avaliador:Avaliador
    private var repositorioPagamento: RepositorioDePagamento
    private var data:Date
    
    init( _ leiloes: LeilaoDao, _ avaliador:Avaliador, _ repositorioDePagamento: RepositorioDePagamento, _ data:Date){
        
        self.leiloes = leiloes
        self.avaliador = avaliador
        self.repositorioPagamento = repositorioDePagamento
        self.data = data
    }
    
    convenience init(_ leiloes: LeilaoDao, _ avaliador:Avaliador, _ repositorioDePagamento: RepositorioDePagamento) {
        
        self.init(leiloes, avaliador, repositorioDePagamento, Date())
    }
    
    func gerar(){
        let leiloesEncerrados = self.leiloes.encerrados()
        
        for leilao in leiloesEncerrados{
            try? avaliador.avalia(leilao: leilao)
            
            let novoPagamento = Pagamento(avaliador.maiorLance(), proximoDiaUtil())
            repositorioPagamento.salva(novoPagamento)
        }
    }
    
    func proximoDiaUtil() -> Date{
        var dataAtual = self.data
        
        while Calendar.current.isDateInWeekend(dataAtual) {
            dataAtual = Calendar.current.date(byAdding: .day, value: 1, to: dataAtual)!  
        }
        
        return dataAtual
    }
}
