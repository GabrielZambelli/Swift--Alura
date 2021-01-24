//
//  MapaViewController.swift
//  Agenda
//
//  Created by Gabriel Zambelli on 07/03/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import MapKit

class MapaViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Variavel
    
    var aluno: Aluno?
    lazy var localizacao = Localizacao()
    lazy var gerenciadorDeLocalizacao = CLLocationManager()
    
    // MARK: view Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = getTitulo()
        verificaAutorizacaoDoUsario()
        self.localizacaoInicial()
        //self.localizarAluno()
        mapa.delegate = localizacao
        gerenciadorDeLocalizacao.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: Metodos
    
    func getTitulo() -> String{
        return "Localizar Alunos"
    }
    
// criar o ponto no mapa
    /*func configuraPino(titulo: String, localizacao: CLPlacemark) -> MKPointAnnotation{
        let pino = MKPointAnnotation()
        pino.title = titulo
        pino.coordinate = localizacao.location!.coordinate
        return pino
    }*/
    
    func verificaAutorizacaoDoUsario(){
        //verifica se o recurso de gps esta disponivel no dispositivo
        if CLLocationManager.locationServicesEnabled(){
            //verifica qual o status da autorização de utilização do GPS
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
                //adiciona o botao no mapa
                mapa.addSubview(botao)
                //inicia a geração de atualizações que relatam a localização atual do usuário
                gerenciadorDeLocalizacao.startUpdatingLocation()
                break
            case .notDetermined:
                //solicita ao usuário a autorização para uso do GPS
                gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
                break
            case .denied:
                
                break
            default:
                break
            }
        }
    }
    
    
    func localizacaoInicial(){
        Localizacao().converteEnderecoEmCoordenada(endereco: "Caelum - São Paulo") { (localizacaoEncontrada) in
            //let pino = self.configuraPino(titulo: "Caelum", localizacao: localizacaoEncontrada)
            let pino = Localizacao().configuraPino(titulo: "Caelum", localizacao: localizacaoEncontrada, cor: .black, icone: UIImage(named: "icon_caelum"))
            let regiao = MKCoordinateRegionMakeWithDistance(pino.coordinate, 6000, 6000)
            self.mapa.setRegion(regiao, animated: true)
            self.mapa.addAnnotation(pino)
        }
    }
    
    func localizarAluno(){
        if let aluno = aluno{
            Localizacao().converteEnderecoEmCoordenada(endereco: aluno.endereco!) { (localizacaoEncontrada) in
                //let pino = self.configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada)
                let pino = Localizacao().configuraPino(titulo: aluno.nome!, localizacao: localizacaoEncontrada, cor: nil, icone: nil)
                self.mapa.addAnnotation(pino)
                //tenta exibir todos os pinos no mapa
                self.mapa.showAnnotations(self.mapa.annotations, animated: true)
                self.localizarAluno()
            }
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    
    //metodo na qual é chamado sempre que a autorização do GPS é alterada
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            let botao = Localizacao().configuraBotaoLocalizacaoAtual(mapa: mapa)
            //adiciona o botao no mapa
            mapa.addSubview(botao)
            //inicia a geração de atualizações que relatam a localização atual do usuário
            gerenciadorDeLocalizacao.startUpdatingLocation()
            break
        default:
            break
        }
    }
    
    //metodo é chamado sempre que a localição do usuários é alterada
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    //MARK: IBOutlet
    
    @IBOutlet weak var mapa: MKMapView!
    
}
