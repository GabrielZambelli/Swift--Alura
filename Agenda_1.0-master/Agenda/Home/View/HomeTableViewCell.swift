//
//  HomeTableViewCell.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var labelNomeDoAluno: UILabel!
    @IBOutlet weak var viewImage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configuraCelula(_ aluno: Aluno){
        labelNomeDoAluno.text = aluno.nome
        viewImage.layer.cornerRadius = imageAluno.frame.width / 2
        viewImage.layer.masksToBounds = true
        
        //convertendo do NSObject para UIImage, por que utilizamos o tipo transformable para persistir o dado
        if let imagemDoAluno = aluno.foto as? UIImage{
            imageAluno.image = imagemDoAluno
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
