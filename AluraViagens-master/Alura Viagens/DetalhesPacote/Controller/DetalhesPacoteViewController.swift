//
//  DetalhesPacoteViewController.swift
//  Alura Viagens
//
//  Created by Gabriel Zambelli on 15/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit


class DetalhesPacoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cria um observador de estado, sempre que o keyboard aparecer sera executado um metodo
        NotificationCenter.default.addObserver(self, selector: #selector(aumentarScroll(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        
        if let pacote = pacoteviagem{
            self.capaPacote.image = UIImage(named: pacote.viagem.caminhoDaImagem)
            self.labelDescricao.text = pacote.descricao
            self.labelPreco.text = pacote.viagem.preco
            self.labelTitulo.text = pacote.viagem.titulo
            self.labelDuracaoViagem.text = pacote.dataViagem
        }

    }
    
    //MARK: ATRIBUTOS
    
    var pacoteviagem: PacoteViagem? = nil
    
    //MARK: IBOUTLETS
    
    @IBOutlet weak var capaPacote: UIImageView!
    @IBOutlet weak var labelDuracaoViagem: UILabel!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var labelDescricao: UILabel!
    @IBOutlet weak var scrollPrincipal: UIScrollView!
    
    @IBOutlet weak var textFieldData: UITextField!
    //MARK: IBActions
    
    @IBAction func buttonVoltar(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    //Alterar o teclado para um DatePicker
    @IBAction func textFieldDataFoco(_ sender: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        sender.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(exibeData(sender:)), for: .valueChanged)
    }
    
    @IBAction func buttonFinalizarCompra(_ sender: UIButton) {
    
        //Pega o StoryBoard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //instancia o viewController
        let controller = storyboard.instantiateViewController(identifier: "confirmacaoPagamento") as! FinalizarCompraViewController
        
        //passa o parametro para o outro controller
        controller.pacoteComprado = pacoteviagem
        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(controller, animated: true)
        
        //self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: METÓDOS
     
    @objc func aumentarScroll(notification:Notification){
        self.scrollPrincipal.contentSize = CGSize(width: self.scrollPrincipal.frame.width, height: self.scrollPrincipal.frame.height + 320)
        self.scrollPrincipal.contentOffset.y = 260
    }
    
    @objc func exibeData(sender: UIDatePicker){
        //Date formatter é utilizado para formtar data
        let dataFormatador = DateFormatter()
        dataFormatador.dateFormat = "dd/MM/yyyy"
        self.textFieldData.text = dataFormatador.string(from: sender.date)
    }
    
}
