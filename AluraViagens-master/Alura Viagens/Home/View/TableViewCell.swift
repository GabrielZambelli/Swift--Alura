//
//  TableViewCell.swift
//  Alura Viagens
//
//  Created by Gabriel Zambelli on 04/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

   
    @IBOutlet weak var imagemViagem: UIImageView!
    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var labelQuantidadeDias: UILabel!
    @IBOutlet weak var labelTitulo: UILabel!
    
    func configuraCelula(viagem:Viagem){
        labelTitulo.text = viagem.titulo
        labelQuantidadeDias.text = viagem.quantidadeDeDias == 1 ? "1 dia" : "\(viagem.quantidadeDeDias) dias"
        labelPreco.text = "R$ \(viagem.preco)"
        imagemViagem.image = UIImage(named: viagem.caminhoDaImagem)
        //arredonda a celula
        imagemViagem.layer.cornerRadius = 10
        //insere uma mascara na imagem fazedno com que fique com a borda arredonda da celula
        imagemViagem.layer.masksToBounds = true
    }
}
