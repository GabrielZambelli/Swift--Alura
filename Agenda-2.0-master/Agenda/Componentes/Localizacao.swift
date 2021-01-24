//
//  Localizacao.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 02/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
//import CoreLocation //responsavel por converter endereço por coordenada
import MapKit // ao importar o MapKit o CoreLocation é importado junto

class Localizacao: NSObject, MKMapViewDelegate {

    
    //funcao vai receber uma closure
    func converteEnderecoEmCoordenada(endereco : String, local:@escaping(_ local: CLPlacemark) -> Void){
        
        let conversor = CLGeocoder()
        conversor.geocodeAddressString(endereco) { (listaDeLocalizacao, error) in
            
            if let localizacao = listaDeLocalizacao?.first{
               //passando a localizacao(PlaceMark) para a closure.
                local(localizacao)
            }
        }
    }
    
    //criar pino no mapa
    func configuraPino(titulo:String, localizacao:CLPlacemark, cor: UIColor?, icone: UIImage?) -> Pino{
        let pino = Pino(coordenada: localizacao.location!.coordinate)
        pino.title = titulo
        pino.color = cor
        pino.icon = icone
        
        return pino
    }
    
    //cria o botão de localizaçao atual no mapa
    func configuraBotaoLocalizacaoAtual(mapa: MKMapView) -> MKUserTrackingButton
    {
        let botao = MKUserTrackingButton(mapView: mapa)
        
        //localizacao do botao
        botao.frame.origin.x = 10
        botao.frame.origin.y = 10
        
        return botao
    }
    
    //MARK: - MKMAPView Delegate
    
    //metodo responsável por alterar a view do icone no mapa
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //verifica se o annotation é do tipo Pino
        if annotation is Pino{
            //iremos converter a annotation para o tipo Model Pino
            let annotationView = annotation as! Pino
            
            //pega a AnnotationView do MapView para reutilizarmos.
            var pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationView.title!) as? MKMarkerAnnotationView
            
            //Criamos uma nova visualização do pino
            pinoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationView.title!)
            
            pinoView?.annotation = annotationView
            pinoView?.glyphImage = annotationView.icon
            pinoView?.markerTintColor = annotationView.color
            
            return pinoView
            
        }
        return nil
    }
    
    func localizaAlunoNoWaze(_ alunoSelecionado: Aluno){
        
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!){
            guard let enderecoDoAluno = alunoSelecionado.endereco else { return  }
            
            //acessar longitude e latitude apartir do endereco
            Localizacao().converteEnderecoEmCoordenada(endereco: enderecoDoAluno) { (localizacaoEncontrada) in
                
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
    }
    
}
