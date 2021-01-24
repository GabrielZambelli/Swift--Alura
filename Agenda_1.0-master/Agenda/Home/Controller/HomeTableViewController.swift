//
//  HomeTableViewController.swift
//  Agenda
//
//  Created by Ândriu Coelho on 24/11/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class HomeTableViewController: UITableViewController, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: - Variáveis
    
    let searchController = UISearchController(searchResultsController: nil)
    var gerenciadorDeResultados:NSFetchedResultsController<Aluno>?
    
    var contexto:NSManagedObjectContext{
        //acessando o AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var alunoViewController:AlunoViewController?
    var mensagem = Mensagem()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuraSearch()
        self.recuperaAluno()
    }
    
    //MARK: - IBAction
    
    @IBAction func buttonCalculaMedia(_ sender: UIBarButtonItem) {
        guard let listaDeAlunos = gerenciadorDeResultados?.fetchedObjects else {return}
        CalculaMediaApi().calculaMediaGeralDosAlunos(alunos: listaDeAlunos, sucess: { (dicionario) in
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
    
    func configuraSearch() {
        self.searchController.searchBar.delegate = self
        //dimsBackgroundDuringPresentation = apartir do IOS 12 foi substituido por:
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func recuperaAluno(filtro: String = ""){
        //retorna um dicionarios de dados da entidade no caso Aluno
        let pesquisaAluno:NSFetchRequest<Aluno> = Aluno.fetchRequest()
        //iremos implementar uma ordenação para a consulta
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        //adicionando a ordenação ao FetchResquest
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        //verificar se o filtro esta vazio
        if verificaFiltro(filtro){
            pesquisaAluno.predicate = filtraAluno(filtro)
           }
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        gerenciadorDeResultados?.delegate = self
       
        //depois de configurar o FetchedResultsController iremos executar a consuta.
        do{
            try gerenciadorDeResultados?.performFetch()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    //metodo responsavel por montar um filtro utilizando o NSPredicate
    func filtraAluno(_ filtro:String) -> NSPredicate{
        
        //iremos colocar o atributo conforme o schema do CoreData no caso: nome
        return NSPredicate(format: "nome CONTAINS %@", filtro)
    }
    
    func verificaFiltro(_ filtro: String) -> Bool{
        if filtro.isEmpty{
            return false
        }
        return true
    }
    
    @objc func abrirActionSheet(_ longPress: UILongPressGestureRecognizer){
        //verifica se o estado no começo
        if longPress.state == .began{
            guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects?[(longPress.view?.tag)!] else { return }
    
            let menu = MenuOpcoesAluno().configuraMenuOpcaoDoAluno { (opcao) in
                switch opcao{
                case .SMS:
                    if let componenteMensagem = self.mensagem.configuraSMS(alunoSelecionado){
                        componenteMensagem.messageComposeDelegate = self.mensagem
                        self.present(componenteMensagem, animated: true, completion: nil)
                    }
                    break
                case .LIGACAO:
                    guard let numeroDoAluno = alunoSelecionado.telefone else { return  }
                    //url para acessar aplicativos pela UIAplication e verificar se é possivel fazer ligação
                    if let url = URL(string: "tel://\(numeroDoAluno)"), UIApplication.shared.canOpenURL(url){
                        //chamando a função de chamada telefonica
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    break
                case .WAZE:
                    if UIApplication.shared.canOpenURL(URL(string: "waze://")!){
                        guard let enderecoDoAluno = alunoSelecionado.endereco else { return  }
                        Localizacao().converteEnderecoEmCoordenada(endereco: enderecoDoAluno) { (localizacaoEncontrada) in
                            //acessar longitude e latitude apartir do endereco
                            
                            //converter latitude e longitude oara String
                            let latitude = String(describing:localizacaoEncontrada.location!.coordinate.latitude)
                            let longitude = String(describing:localizacaoEncontrada.location!.coordinate.longitude)
                            //URL para acessar o Waze
                            let url:String = "waze://?ll=\(latitude),\(longitude)&navigation=yes"
                            //Passa a URL para UIAplication, responsavel por abrir o app pelo deepLink.
                            /*Documentação https://developers.google.com/waze/deeplinks#exemplo-do-ios*/
                            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                        }
                    }
                    break
                case .MAPA:
                    //Instanciado o ViewController da tela Mapa
                    let mapa = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mapa") as! MapaViewController
                    mapa.aluno = alunoSelecionado
                    self.navigationController?.pushViewController(mapa, animated: true)
                    
                    break
                case .PAGINAWEB:
                    //recupera o site do aluno
                    if let urlDoAluno = alunoSelecionado.site{
                        
                        var urlFormatada = urlDoAluno
                        //verifics se inicia com http caso não, adiciona
                        if !urlFormatada.hasPrefix("http://"){
                            urlFormatada = String(format: "http://%@", urlFormatada)
                        }
                        //convert string em URL
                        guard let url = URL(string: urlFormatada) else { return }
                        
                        let safariViewController = SFSafariViewController(url: url)
                        self.present(safariViewController, animated: true, completion: nil)
                       // UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    break
                }
            }
            self.present(menu, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let contadorListaDeAluno = gerenciadorDeResultados?.fetchedObjects?.count else { return 0 }
        return contadorListaDeAluno
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula-aluno", for: indexPath) as! HomeTableViewCell
        
        //cada celula deve ter um tag diferente
        celula.tag = indexPath.row
        
        //implementar o GestureRecognizer para abrir o menu de opções
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(abrirActionSheet(_:)))
        
        //resgatando o valor da consulta conforme o indexPath
        guard let aluno = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return celula }
       
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
                        guard let alunoSelecionado = self.gerenciadorDeResultados?.fetchedObjects![indexPath.row] else {return}
                        self.contexto.delete(alunoSelecionado)
                        //sempre que utilizamos a func delete temos que salvar a alteração para que seja efetiva
                        
                        do{
                            try self.contexto.save()
                        }
                        catch{
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alunoSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return  }
        alunoViewController?.aluno = alunoSelecionado
    }
    
    //MARK: FetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return  }
            tableView.deleteRows(at: [indexPath], with: .fade)
            break
        default:
            tableView.reloadData()
        }
    }
    
    
    //MARK: - SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let nomeDoAluno = searchBar.text else { return }
        recuperaAluno(filtro: nomeDoAluno)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        recuperaAluno()
        tableView.reloadData()
    }

}
