//
//  Filtro.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 30/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class Filtro: NSObject {
    
    func filtraAluno(listaDeAlunos:[Aluno], texto:String) -> Array<Aluno>{
        
        let alunosEncontrados = listaDeAlunos.filter { (aluno) -> Bool in
            if let nome = aluno.nome{
                return nome.contains(texto)
            }
            return false
        }
        return alunosEncontrados
    }

}
