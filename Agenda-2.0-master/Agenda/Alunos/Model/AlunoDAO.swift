//
//  AlunoDAO.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 25/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoDAO: NSObject {
    
    // MARK: - Atributos
    
    //variavel computada do context utilizado no core data
    var contexto:NSManagedObjectContext{
        //acessando o AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var gerenciadorDeResultados:NSFetchedResultsController<Aluno>?
    
    //MARK: - Metodos
    
    func salvaAluno(dicionarioDeAluno: Dictionary<String,Any>){
        var aluno: NSManagedObject?
        
        //let aluno = Aluno(context: contexto)
        
        //convertendo o Id para UUID
        guard let id = UUID(uuidString: dicionarioDeAluno["id"] as! String) else{ return }
        
        //Filtrando os alunos com id igual ao id passado
        let alunos = recuperaAluno().filter(){ $0.id == id }
        
        //verificando se foi encontrado algum aluno
        if alunos.count > 0{
            //setando o aluno encontrado na variavel aluno
            guard let alunoEncontrado = alunos.first else { return }
            aluno = alunoEncontrado
        }
        //NÃo possui o aluno, iremos criar um entidade que o representa
        else{
            //criando a entidade aluno
            let entidade = NSEntityDescription.entity(forEntityName: "Aluno", in: contexto)
            aluno = NSManagedObject(entity: entidade!, insertInto: contexto)
        }
        
        //setando os atributos do schema(forkey)
        aluno?.setValue(id, forKey: "id")
        aluno?.setValue(dicionarioDeAluno["nome"] as? String, forKey: "nome")
        aluno?.setValue(dicionarioDeAluno["endereco"] as? String, forKey: "endereco")
        aluno?.setValue(dicionarioDeAluno["telefone"], forKey: "telefone")
        aluno?.setValue(dicionarioDeAluno["site"], forKey: "site")
        
        guard let nota = dicionarioDeAluno["nota"] else { return }
        
        //verificando se a nota é String
        if (nota is String){
            aluno?.setValue(Double(nota as! String), forKey: "nota")
        }
        else{
            let conversaoDeNota = String(describing: nota)
            aluno?.setValue((conversaoDeNota as NSString).doubleValue, forKey: "nota") 
        }
        atualizaContexto()
        //aluno?.foto = imageAluno.image
    }
    
    func atualizaContexto(){
        //iremos tentar salvar contexto.save() é uma throw function
        do{
            try contexto.save()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func recuperaAluno() -> [Aluno]{
        
        //retorna um dicionarios de dados da entidade no caso Aluno
        let pesquisaAluno:NSFetchRequest<Aluno> = Aluno.fetchRequest()
        //iremos implementar uma ordenação para a consulta
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        //adicionando a ordenação ao FetchResquest
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        //depois de configurar o FetchedResultsController iremos executar a consulta.
        do{
            try gerenciadorDeResultados?.performFetch()
        }
        catch{
            print(error.localizedDescription)
        }
        
        guard let listaDeAlunos = gerenciadorDeResultados?.fetchedObjects else { return [] }
        return listaDeAlunos
    }
    
    func deletaAluno( aluno: Aluno){
        contexto.delete(aluno)
        atualizaContexto()
    }
    
}


//MARK: - Comentários
/*
 Classe responsavel por salvar os alunos local.
  
 
 
 //convertendo String para Double utilizando o Objective C
 //aluno.nota = (textFieldNota.text! as NSString).doubleValue

 */
