//
//  EncerradorDeLeilaoTests.swift
//  LeilaoTests
//
//  Created by Gabriel Zambelli on 15/04/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao
import Cuckoo

class EncerradorDeLeilaoTests: XCTestCase {
    
    var formatador:DateFormatter!
    var encerradorDeLeilao:EncerradorDeLeilao!
    var daoFalso:MockLeilaoDao!
    var carteiroFalso: MockCarteiro!

    override func setUpWithError() throws {
        formatador = DateFormatter()
        formatador.dateFormat = "yyyy/MM/dd"
        
        //withEnabledSuperclassSpy(): caso não ensine o mock a responder pelo metodo ele ira executar o metodo da classe verdadeira
        daoFalso = MockLeilaoDao().withEnabledSuperclassSpy()
        carteiroFalso = MockCarteiro().withEnabledSuperclassSpy()
        encerradorDeLeilao = EncerradorDeLeilao(daoFalso, carteiroFalso)
    }

    override func tearDownWithError() throws {
       
    }
    
    func testDeveEncerrarLeiloesQueComecaramUmaSemanaAntes(){
        
        guard let dataAntiga = formatador.date(from: "2018/05/09") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        
        let leilaoAntigo = [tvLed, geladeira]
        
        //ensinando o mock a responder pelos metodos da classe
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.correntes()).thenReturn(leilaoAntigo)
        }
        
        encerradorDeLeilao.encerra()
        
        //let leiloesEncerrados = dao.encerrados()
        
        guard let statusTvLed = tvLed.isEncerrado() else { return }
        guard let statusGeladeira = geladeira.isEncerrado() else { return }
        
        XCTAssertEqual(2, encerradorDeLeilao.getTotalEncerrados())
        XCTAssertTrue(statusTvLed)
        XCTAssertTrue(statusGeladeira)
    }
    
    func testDeveAtualizarLeiloesEncerrados(){
        guard let dataAntiga = formatador.date(from: "2018/05/19") else { return }
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
           
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.correntes()).thenReturn([tvLed])
        }
        
        encerradorDeLeilao.encerra()
                
        //verifica se o metodo foi chamado
        verify(daoFalso).atualiza(leilao: tvLed)
        
    }
    
    func testDeveContinuarExecucaoMesmoQuandoDaoFalhar(){
        guard let dataAntiga = formatador.date(from: "2018/05/19") else { return }
        
        let tvLed = CriadorDeLeilao().para(descricao: "TV Led").naData(data: dataAntiga).constroi()
        let geladeira = CriadorDeLeilao().para(descricao: "Geladeira").naData(data: dataAntiga).constroi()
        let error = NSError(domain: "Erro", code: 0, userInfo: nil)
        
        stub(daoFalso) { (daoFalso) in
            when(daoFalso.correntes()).thenReturn([tvLed, geladeira])
            when(daoFalso.atualiza(leilao: tvLed)).thenThrow(error)
        }
        
        encerradorDeLeilao.encerra()
        
        verify(daoFalso).atualiza(leilao: geladeira)
        verify(carteiroFalso).envia(geladeira)
    }
}

//para o Cuckoo reconhecer o tipo Leilao, verifique a documentação
extension Leilao: Matchable{
    public var matcher: ParameterMatcher<Leilao>{
        return equal(to: self)
    }
}
