//
//  Respositorio.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 25/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class Repositorio: NSObject {
    
    func salvaAluno(aluno: Dictionary<String,String>){
        
        //chamada da API responsável por salar os alunos no servidor
        AlunoAPI().salvaAlunoNoServidor(parametros: [aluno])
        //Chama a classe responsavel por salvar os alunos localmente
        AlunoDAO().salvaAluno(dicionarioDeAluno: aluno)
    }
    
    func recuperaAlunos(completion:@escaping(_ listaDeAlunos:[Aluno]) -> Void){
        var alunos = AlunoDAO().recuperaAluno()
        
        if alunos.count == 0{
            //Closure do AlunoApi sera executado apos a conclusao da solitacao ao servidor
            AlunoAPI().recuperaAluno {
                alunos = AlunoDAO().recuperaAluno()
                completion(alunos)
            }
        }else{
            completion(alunos)
        }
    }
    
    func deletaAluno(aluno: Aluno){
        guard let id = aluno.id else { return }
        AlunoAPI().deletaAluno(id: String(describing: id).lowercased())
        AlunoDAO().deletaAluno(aluno: aluno)
    }
    
    func sincronizaAlunos(){
        let alunos = AlunoDAO().recuperaAluno()
        var listaDeParametros:Array<Dictionary<String, String>> = []
        
        for aluno in alunos{
            guard let id = aluno.id else { return }
            let parametros:Dictionary<String, String> = [
                "id":String(describing: id).lowercased(),
                "nome":aluno.nome ?? "",
                "endereco":aluno.endereco ?? "",
                "telefone": aluno.telefone ?? "",
                "site": aluno.site ?? "",
                "nota": "\(aluno.nota)"
            ]
            listaDeParametros.append(parametros)
        }
        AlunoAPI().salvaAlunoNoServidor(parametros: listaDeParametros)
    }
}


//MARK: - Comentários

/*
 repositorio é responsavel por salvar os dados em seus locais: Server e/ou local
 */
