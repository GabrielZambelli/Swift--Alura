//
//  PacoteViagemCollectionViewCell.swift
//  Alura Viagens
//
//  Created by Gabriel Zambelli on 08/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit

class PacoteViagemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagemViagem: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelQuantidadeDias: UILabel!
    @IBOutlet weak var labelPreco: UILabel!
    
    
    func configuraCelula(_ pacote:PacoteViagem){
        labelTitulo.text = pacote.viagem.titulo
        imagemViagem.image = UIImage(named:pacote.viagem.caminhoDaImagem)
        labelQuantidadeDias.text = pacote.viagem.quantidadeDeDias == 1 ? "1 dia" : "\(pacote.viagem.quantidadeDeDias) dias"
        labelPreco.text = "R$ \(pacote.viagem.preco)"
        
        //Borda
        layer.borderWidth = 0.5
        layer.borderColor = CGColor(srgbRed: 85.0/255.0, green: 85.0/255.0, blue: 85.0/255.0, alpha: 1)
        layer.cornerRadius = 8
    }
    
    
    
}
