//
//  FinalizarCompraViewController.swift
//  Alura Viagens
//
//  Created by Gabriel Zambelli on 24/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit

class FinalizarCompraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pacote = pacoteComprado{
            self.ImagemViagem.image = UIImage(named: pacote.viagem.caminhoDaImagem)
            self.labelTitulo.text = pacote.viagem.titulo
            self.labelDescricao.text = pacote.descricao
            self.labelDataViagem.text = pacote.dataViagem
            self.labelHotel.text = pacote.nomeDoHotel
        }
        
        self.ImagemViagem.layer.cornerRadius = 10
        self.ImagemViagem.layer.masksToBounds = true
        
        self.buttonVoltarHome.layer.cornerRadius = 8
    }
    
    //MARK: Atributos
    var pacoteComprado: PacoteViagem? = nil
    
    //MARK: IBOutlet
    @IBOutlet weak var ImagemViagem: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelDescricao: UILabel!
    @IBOutlet weak var labelDataViagem: UILabel!
    @IBOutlet weak var labelHotel: UILabel!
    @IBOutlet weak var buttonVoltarHome: UIButton!
    
    //MARK: IBActions
    
    @IBAction func buttonVoltarHome(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
