//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, UISearchBarDelegate{
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
       
    var alunoViewController:AlunoViewController?
    var mensagem = Mensagem()
    var alunos:Array<Aluno> = []
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
    }
    
    //Notifica o controlador de exibição(viewController) que sua exibição está prestes a ser adicionada a uma hierarquia de exibição
    override func viewWillAppear(_ animated: Bool) {
        recuperaAlunos()
    }
    
    //MARK: - IBAction
    
    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        CalculaMediaApi().calculaMediaGeralDosAlunos(alunos: alunos, sucess: { (dicionario) in
            if let alerta = Notificacoes().exibinotificacaoDeMediasDosAlunos(dicionarioDeMedia: dicionario){
                self.present(alerta, animated: true, completion: nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func buttonLocalizacaoGeral(_ sender: UIBarButtonItem) {
        //recuperar o view Controller do Mapa
        let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mapa") as! MapaViewController
        //abrir a tela do Mapa
        navigationController?.pushViewController(mapa, animated: true)
    }
    
    // MARK: - Métodos
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editar"{
            alunoViewController = segue.destination as? AlunoViewController
        }
    }
    
    func recuperaAlunos(){
        Repositorio().recuperaAlunos { (listaDeAlunos) in
            self.alunos = listaDeAlunos
            self.tableView.reloadData()
        }
    }
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        //dimsBackgroundDuringPresentation = apartir do IOS 12 foi substituido por:
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    @objc func abrirActionSheet(_ longPress: UILongPressGestureRecognizer){
        //verifica se o estado no começo
        if longPress.state == .began{
            let alunoSelecionado = alunos[(longPress.view?.tag)!]
            
            guard let navigation = navigationController else { return }
            let menu = MenuOpcoesAluno().configuraMenuOpcaoDoAluno(navigation: navigation, alunoSelecionado: alunoSelecionado)
            present(menu, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alunos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        
        //cada celula deve ter um tag diferente
        celula.tag = indexPath.row
        
        //implementar o GestureRecognizer para abrir o menu de opções
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_:)))
        
        //resgatando o aluno conforme o indexPath
         let aluno = alunos[indexPath.row]
       
        celula.configuraCelula(aluno)
        
        //adicionando o gesture a celula
        celula.addGestureRecognizer(longPress)
        return celula
    }
    
    //metodo para setar o tamanho da celular, alem do StoryBoard
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 85
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //envio o metodo para a classe Autenticacao via closure para executar apos verificar se o recurso esta disponivel
            AutenticacaoLocal().autorizaUsuario { (autenticado) in
                if autenticado {
                    //quando trabalhamos com context, devemos executar o codigo na Thread principal
                    //Dispatch é um framework nativo que é responsavel por mandar a execução pra thread principal
                    DispatchQueue.main.async {
                        let alunoSelecionado = self.alunos[indexPath.row]
                        Repositorio().deletaAluno(aluno: alunoSelecionado)
                        
                        //deletando o aluno da lista de aluno
                        self.alunos.remove(at: indexPath.row)
                        //removendo uma linha da Table View
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        //deletando aluno
                        Repositorio().deletaAluno(aluno: alunoSelecionado)
                     
                    }
                }
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alunoSelecionado = alunos[indexPath.row]
        alunoViewController?.aluno = alunoSelecionado
    }
    
    //MARK: - SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let texto = searchBar.text{
           alunos = Filtro().filtraAluno(listaDeAlunos: alunos, texto: texto)
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        alunos = AlunoDAO().recuperaAluno()
        tableView.reloadData()
    }

}
