//
//  LeiloesViewControllerTests.swift
//  LeilaoTests
//
//  Created by Gabriel Zambelli on 20/04/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import XCTest
@testable import Leilao

class LeiloesViewControllerTests: XCTestCase {

    private var sut:LeiloesViewController!
    private var tableView: UITableView!
    
    override func setUpWithError() throws {
        //instacia do view controller no storyboard
        //sut =  system under test
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? LeiloesViewController
        
        //inicializar o ViewController
        _ = sut.view
        
        tableView = sut.tableView
        tableView.dataSource = sut
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTableViewNaoDeveEstarNilAposViewDidLoad(){
       
        XCTAssertNotNil(sut.tableView)
    }
    
    func testeDataSourceDaTableViewNaoDeveSerNil(){
        
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertNotNil(sut.tableView.dataSource is LeiloesViewController)
    }
    
    func testNumberOfRowInsectionDeveSerQuantidadeDeLeiloesDaLista(){
      
        sut.addLeilao(Leilao(descricao: "Playstation 4"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.addLeilao(Leilao(descricao: "Iphone X"))
        
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
        
    }
    
    func testCellForRowDeveRetornarLeilaoTableViewCell(){
        
        sut.addLeilao(Leilao(descricao: "Tv Led"))
        tableView.reloadData()
        
        let celula = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(celula is LeilaoTableViewCell)
    }
    
    func testCellForRowDeveChamarDequeueReusableCell(){
        let mockTableView = MockTableView()
        mockTableView.dataSource = sut
        
        mockTableView.register(LeilaoTableViewCell.self, forCellReuseIdentifier: "LeilaoTableViewCell")
        
        sut.addLeilao(Leilao(descricao: "Macbook"))
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mockTableView.celulaFoiReutilizada)
    }
}

extension LeiloesViewControllerTests{
    
    class MockTableView: UITableView{
        var celulaFoiReutilizada = false
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            celulaFoiReutilizada = true
            
            return super.dequeueReusableCell(withIdentifier: "LeilaoTableViewCell", for: indexPath)
        }
    }
}
