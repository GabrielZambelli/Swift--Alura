//
//  AlunoAPI.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 25/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AlunoAPI: NSObject{

    
    // MARK: - GET
     
    //o completion aqui server para executar uma ação somente apos a chamada ao servidor seja finalizada
    func recuperaAluno(completion:@escaping() -> Void){
        AF.request("http://localhost:8080/api/aluno", method: .get).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                //convertendo o retorno da api e pegando o array alunos.
                if let resposta = value as? Dictionary<String,Any>{
                    guard let listaDeAlunos = resposta["alunos"] as? Array<Dictionary<String, Any>> else { return }
                    
                    //percorrendo a lista e salvando localmente
                    for dicionarioDeAluno in listaDeAlunos{
                        AlunoDAO().salvaAluno(dicionarioDeAluno: dicionarioDeAluno)
                    }                    
                    completion()
                }
                break
            case .failure:
                print(response.error as Any)
                completion()
                break
            }
        }
    }
    
    // MARK: - PUT
    func salvaAlunoNoServidor(parametros: [Dictionary<String, String>]){
        
        //url da API
        guard let url = URL(string: "http://localhost:8080/api/aluno/lista") else { return }
        
        //Montando URLResquest
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        let json = try! JSONSerialization.data(withJSONObject: parametros, options: [])
        requisicao.httpBody = json
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Chamando Alamofire.
        AF.request(requisicao).response{response in print(response)}
       
    }
    
    //MARK: -DELETE
    
    func deletaAluno(id: String){
        AF.request("http://localhost:8080/api/aluno/\(id)", method: .delete ).responseJSON { (resposta) in
            switch resposta.result{
            case .failure(let erro):
                print(erro.localizedDescription)
                break
            default:
                break
            }
        }
    }
}



//MARK: - Comentários
/*
 Classe responsavel por salvar os alunos no servidor.
 
 
 */
