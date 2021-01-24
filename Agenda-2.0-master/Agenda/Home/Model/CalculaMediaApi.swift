//
//  CalculaMediaApi.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 08/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class CalculaMediaApi: NSObject {
    
    func calculaMediaGeralDosAlunos(alunos:[Aluno], sucess: @escaping(_ dicionariosDeMedias:Dictionary<String, Any>)-> Void, falha: @escaping(_ error:Error)->Void){
        
        //URL da api
        guard let url = URL(string: "https://www.caelum.com.br/mobile") else {return }
        
        //criando uma lista de Dictionary
        var listaAluno:Array<Dictionary<String, Any>> = []
        var json:Dictionary<String, Any> = [:]
        
        for aluno in alunos{
            
            guard let nome = aluno.nome else {break}
            guard let endereco = aluno.endereco else {break}
            guard let telefone = aluno.telefone else {break}
            guard let site = aluno.site else { break}
            
            let dicionarioAluno = ["id":"\(aluno.objectID)",
                                   "nome":nome,
                                   "endereco":endereco,
                                   "telefone":telefone,
                                   "site":site,
                                   "nota":String(aluno.nota)]
            
            listaAluno.append(dicionarioAluno as [String:Any])
        }
        
        
        
        json = ["list":[["aluno": listaAluno]]]
        
        //requiscao dos dados para API
        var requisicao = URLRequest(url: url)
        
        do{
         let data = try JSONSerialization.data(withJSONObject: json, options: [])
            requisicao.httpBody = data
            requisicao.httpMethod = "POST"
            requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: requisicao) { (data, response, error) in
                if error == nil{
                    do{
                        let dicionario = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                        
                        sucess(dicionario)
                    }
                    catch{
                        falha(error)
                    }
                    
                }
            }
            task.resume()
        }
        catch{
            print(error.localizedDescription)
        }
    }

}
