//
//  AlunoViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit

class AlunoViewController: UIViewController, ImagePickerFotoSelecionada{
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var viewImagemAluno: UIView!
    @IBOutlet weak var imageAluno: UIImageView!
    @IBOutlet weak var buttonFoto: UIButton!
    @IBOutlet weak var scrollViewPrincipal: UIScrollView!
    
    @IBOutlet weak var textFieldNome: UITextField!
    @IBOutlet weak var textFieldEndereco: UITextField!
    @IBOutlet weak var textFieldTelefone: UITextField!
    @IBOutlet weak var textFieldSite: UITextField!
    @IBOutlet weak var textFieldNota: UITextField!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.arredondaView()
        self.setUp()
        NotificationCenter.default.addObserver(self, selector: #selector(aumentarScrollView(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Atributos
    
    let imagePicker = ImagePicker()
    var aluno: Aluno?
    
    
    // MARK: - Métodos
    
    func setUp(){
        imagePicker.delegate = self
        guard let alunoSeleciona = aluno else { return  }
        
        textFieldNome.text = alunoSeleciona.nome
        textFieldEndereco.text = alunoSeleciona.endereco
        textFieldTelefone.text = alunoSeleciona.telefone
        textFieldSite.text = alunoSeleciona.site
        textFieldNota.text = "\(alunoSeleciona.nota)"
        imageAluno.image = alunoSeleciona.foto as? UIImage
        
    }
    
    func arredondaView() {
        self.viewImagemAluno.layer.cornerRadius = self.viewImagemAluno.frame.width / 2
        self.viewImagemAluno.layer.borderWidth = 1
        self.viewImagemAluno.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func aumentarScrollView(_ notification:Notification) {
        self.scrollViewPrincipal.contentSize = CGSize(width: self.scrollViewPrincipal.frame.width, height: self.scrollViewPrincipal.frame.height + self.scrollViewPrincipal.frame.height/2)
    }
    
    //ação que sera passado por parametro(Closure) para os botoes do menu
    func mostrarMultimidia(_ opcao: MenuOpcoes){
        //instanciando a classe responsavel por controle de midia do IOS
        let multimidia = UIImagePickerController()
        
        //setando quem é o responsavel por implementar o delegate do UIImagePickerController
        multimidia.delegate = imagePicker
        
         //verfifica a opcao selecionada e se o device atual possui o recurso indicado pelo source
        if opcao == .camera && UIImagePickerController.isSourceTypeAvailable(.camera){
            // setando qual a fonte da midia: camera
            multimidia.sourceType = .camera
        }else{
            multimidia.sourceType = .photoLibrary
        }
        //apresentando a interface do ImagePickerController
        self.present(multimidia, animated: true, completion: nil)
    }
    
    func montaDicionarioDeParametros() -> Dictionary<String, String>{
        var id = ""
        
        //verificando se o ID existem, caso nao inserção ele gera um novo UUID caso sim ele utiliza.
        if aluno?.id == nil{
            id = String(describing: UUID()) //Gerando um ID Aleatório e convertendo para String
         }
        else{
            guard let idDoAlunoExistente = aluno?.id else { return [:] }
            id = String(describing: idDoAlunoExistente)
        }
        
        guard let nome  = textFieldNome.text else { return [:] }
        guard let endereco = textFieldEndereco.text else { return [:] }
        guard let telefone  = textFieldTelefone.text else { return [:] }
        guard let site = textFieldSite.text else { return [:] }
        guard let nota = textFieldNota.text else { return [:] }
        
        let dicionario: Dictionary<String, String> = [
            "id": id.lowercased(),
            "nome": nome,
            "endereco": endereco,
            "telefone": telefone,
            "site": site,
            "nota": nota
        ]
        
        return dicionario
    }
    
    //MARK: - Delegate
    
    func imagePickerFotoSelecionad(_ foto: UIImage) {
        self.imageAluno.image = foto
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonFoto(_ sender: UIButton) {
        //Chamando a funcao que cria o menu de opcao e passa o metodo via closure
        let menu = ImagePicker().menuOpcoes { (opcao) in
            self.mostrarMultimidia(opcao)
        }
        //apresentando o menu
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func stepperNota(_ sender: UIStepper) {
        self.textFieldNota.text = "\(sender.value)"
    }
    
    
    @IBAction func buttonSalvar(_ sender: UIButton) {
        
        //monta json com os dados do aluno e salva
        let json = montaDicionarioDeParametros()
        Repositorio().salvaAluno(aluno: json)
        
        //retorna para tela anterior
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Comentários
/*
 
 Sempre que utilizarmos o acesso a recursos do nativos do IOS, devemos
 solicitar permissões no arquivo: Info.plist
 
 
 */
