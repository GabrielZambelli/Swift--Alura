//
//  RefeicaoDao.swift
//  Projeto_Alura
//
//  Created by Gabriel Zambelli on 01/02/20.
//  Copyright © 2020 Gabriel Zambelli. All rights reserved.
//

import Foundation


class RefeicaoDao{
    
    func save(_ refeicoes: [Refeicao]){
        guard let caminho = recuperaCaminho() else{return}
        
        //do: tentar executar, tentar fazer
        do{
            //metodo para armazenar arquivos no IOS, todo metodo que for throws deve se utilizar "do/try" pois se caso ele não conseguir
            //executar devemos tratar o erro no catch
            let dados = try NSKeyedArchiver.archivedData(withRootObject: refeicoes, requiringSecureCoding: false)
            //escrevao arquivo no caminho
            try dados.write(to: caminho)
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func recuperaCaminho() -> URL? {
        //FileManager gerenciador de diretorios do IOS, resgatando diretorio
        guard let diretorio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        //adicionando pasta, caminho ao diretorio, ao Path
        let caminho = diretorio.appendingPathComponent("refeicao")
        
        return caminho
    }
    
    func recupera() -> [Refeicao]{
        guard let caminho = recuperaCaminho() else { return [] }
        do{
            //regatar os dados do path
            let dados = try Data(contentsOf: caminho)
            //recuperar os dados salvos
            guard let refeicoesSalvas = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dados) as? [Refeicao] else {return [] }
            
            return refeicoesSalvas
        }
        catch{
            print(error.localizedDescription)
            return []
        }
    }
}
