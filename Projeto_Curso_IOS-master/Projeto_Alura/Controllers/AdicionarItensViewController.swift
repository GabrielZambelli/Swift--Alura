//
//  AdicionarItensViewController.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 24/01/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit


protocol AdicionarItensDelegate{
    func add(_ item: Item)
}

class AdicionarItensViewController: UIViewController {
    
    //MARK: - Init Construtor
    
    init(delegate: AdicionarItensDelegate){
        super.init(nibName: "AdicionarItensViewController", bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var caloriasTextField: UITextField!
    
    //MARK: - Atributos
    
    var delegate:AdicionarItensDelegate?
    
    //MARK: - IBAction
    
    @IBAction func adicionarItem(_ sender: Any) {
        guard let nome = nomeTextField.text, let calorias = caloriasTextField.text, let numeroDeCalorias = Double(calorias) else{ return }
        
        let item = Item(nome: nome, calorias: numeroDeCalorias)
        delegate?.add(item)
        navigationController?.popViewController(animated: true)
        
    }
}
