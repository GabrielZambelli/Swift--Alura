//
//  PacotesViagemViewController.swift
//  Alura Viagens
//
//  Created by Gabriel Zambelli on 08/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import UIKit

class PacotesViagemViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        listaPacoteViagem = listaTodosPacotesViagem
        self.pacoteViagemCollection.dataSource = self
        self.pacoteViagemCollection.delegate = self
        self.pesquisarViagem.delegate = self
        self.labelContadorDePacotes.text = atualizaContadorDePacotes()
     
        // Do any additional setup after loading the view.
    }
    //MARK: - Atributos
    let listaTodosPacotesViagem:[PacoteViagem] = PacoteViagemDAO().retornaTodasAsViagens()
    var listaPacoteViagem:[PacoteViagem] = []
    
    //MARK: - IBOutlet
    @IBOutlet weak var pacoteViagemCollection: UICollectionView!
    @IBOutlet weak var pesquisarViagem: UISearchBar!
    @IBOutlet weak var labelContadorDePacotes: UILabel!
    
    //MARK: - Collection DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaPacoteViagem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cellPacoteViagem = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPacoteViagem", for: indexPath) as! PacoteViagemCollectionViewCell
        let pacote = listaPacoteViagem[indexPath.item]
        cellPacoteViagem.configuraCelula(pacote)
        return cellPacoteViagem
    }
    
    //setando o tamanho da celula
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //bounds acessa tamanho,largura,localização,
        return UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: collectionView.bounds.width/2 - 20, height: 160) : CGSize(width: collectionView.bounds.width/3 - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       //recuperando item selecionado
        let pacote = listaPacoteViagem[indexPath.item]
        
        //Instanciando o storyboard para resgatar o ViewController de detalhes
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        //pega o controller com referencia ao IDIdentifier
        let controller = storyboard.instantiateViewController(identifier: "detalhesPacote") as! DetalhesPacoteViewController
        controller.modalPresentationStyle = .fullScreen
        
        //passar parametro para o DetalhesPacote
        controller.pacoteviagem = pacote
        
        //chama o controller
        self.navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
    }
    
    //Filtra obejto na memória usando NSPredicate, %@ = argumento
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        listaPacoteViagem = listaTodosPacotesViagem
        if(searchText != ""){
            let filtroListaViagem = NSPredicate(format: "viagem.titulo contains [cd] %@", searchText)
            
            //NSArray pertence a objective C - Bridging
            let listaPacoteViagemFitrada: Array<PacoteViagem> = (listaPacoteViagem as NSArray).filtered(using: filtroListaViagem) as! Array
            
            listaPacoteViagem = listaPacoteViagemFitrada
        }
        pacoteViagemCollection.reloadData()
        self.labelContadorDePacotes.text = atualizaContadorDePacotes()
    }
    
    func atualizaContadorDePacotes() ->  String {
        let quantidadeDePacotes = listaPacoteViagem.count
        return quantidadeDePacotes == 1 ? "1 pacote encontrado": "\(quantidadeDePacotes) pacotes encontrados"
    }
}

