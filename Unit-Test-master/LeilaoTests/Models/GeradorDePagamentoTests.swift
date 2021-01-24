//
//  GeradorDePagamentoTests.swift
//  LeilaoTests
//
//  Created by Gabriel Zambelli on 16/04/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class GeradorDePagamentoTests: XCTestCase {

    var daoFalso: MockLeilaoDao!
    var avaliador:Avaliador!
    var repositorioPagamentos: MockRepositorioDePagamento!
    
    override func setUpWithError() throws {
        
        daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
        avaliador = Avaliador()
        repositorioPagamentos = MockRepositorioDePagamento().withEnabledSuperclassSpy()
    }

    override func tearDownWithError() throws {
        
    }

    func testDeveGerarPagamentoParaUmLeilaoEncerrado(){
        let playstatio = CriadorDeLeilao().para(descricao: "Playstation 4")
            .lance(Usuario(nome: "José"), 2000.0)
            .lance(Usuario(nome: "Maria"), 2500.0)
        .constroi()
        
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.encerrados()).thenReturn([playstatio])
        }
        
        let geradorDePagamento = GeradorDePagamento(daoFalso, avaliador, repositorioPagamentos)
        geradorDePagamento.gerar()
        
        //Capturando um argumento de um metodo
        let capturadorDeArgumento = ArgumentCaptor<Pagamento>()
        verify(repositorioPagamentos).salva(capturadorDeArgumento.capture())
        
        let pagamentoGerado = capturadorDeArgumento.value
        
        XCTAssertEqual(2500.0, pagamentoGerado?.getValor())
        
    }
    
    func testDeveEmpurrarParaProximoDiaUtil(){
        
        let iphone = CriadorDeLeilao().para(descricao: "Iphone")
            .lance(Usuario(nome: "Joao"), 2000.0)
            .lance(Usuario(nome: "Maria"),  2500.0)
        .constroi()
        
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.encerrados()).thenReturn([iphone])
        }
        
        let formatador = DateFormatter()
        formatador.dateFormat = "yyyy/MM/dd"

       guard let dataAntiga = formatador.date(from: "2018/05/19") else { return }
        
        let geradorDePagamento = GeradorDePagamento(daoFalso, avaliador, repositorioPagamentos, dataAntiga)
        geradorDePagamento.gerar()
        
        let capturadorDeArgumento = ArgumentCaptor<Pagamento>()
        verify(repositorioPagamentos).salva(capturadorDeArgumento.capture())
        
        let pagamentoGerado = capturadorDeArgumento.value
        
        let formatadorDeData = DateFormatter()
        formatadorDeData.dateFormat = "ccc"
        
        guard let dataDoPagamento = pagamentoGerado?.getData() else { return }
        let diaDaSemana = formatadorDeData.string(from: dataDoPagamento)
        
        XCTAssertEqual("Mon", diaDaSemana)
    }
}
