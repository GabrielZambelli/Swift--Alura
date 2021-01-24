//
//  ImagePicker.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 25/02/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

enum MenuOpcoes{
    case biblioteca
    case camera
}

//criando um protocolo para passar a imagem selecionada
protocol ImagePickerFotoSelecionada{
    func imagePickerFotoSelecionad(_ foto:UIImage )
}

//importar o protocolo UIImageDelegate para ter acesso aos metodos.
class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Atributos
    
    var delegate:ImagePickerFotoSelecionada?
    
    //MARK: - Métodos
    
    //metodo para capturar a midia apos a escolha
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //dentro do dicionario Info, selecionamos OriginalImage(imagem selecionada pelo usuario)
        let foto =  info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.imagePickerFotoSelecionad(foto)
        
        //fechar o a tela de captura de imagem
        picker.dismiss(animated: true, completion: nil)
    }
    
    //criando menu para seleção das opções de source do ImagePick
    func menuOpcoes(completion:@escaping(_ opcao:MenuOpcoes) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "Atenção", message: "Escolha uma das opções abaixo: ", preferredStyle: .actionSheet)
        
        //criando a opção camera:
        let camera = UIAlertAction(title: "Tirar foto", style: .default) { (acao) in
            // Closure: ação apos o usuario selecionar a opção
            completion(.camera)
        }
        
        let biblioteca = UIAlertAction(title: "Biblioteca", style: .default) { (acao) in
            // Closure: ação apos o usuario selecionar a opção
            completion(.biblioteca)
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
       
        menu.addAction(camera)
        menu.addAction(biblioteca)
        menu.addAction(cancelar)
        
        return menu
        
    }

}



//MARK: - Comentários

/*
 Criamos a classe ImagePicker para gerenciar os metodos de acesso a camera para desacoplar
 do controller principal
 
 Criamos o Protocolo para ter acesso a imagem selecionada
 
 */
