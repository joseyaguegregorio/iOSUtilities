//
//  File.swift
//  
//
//  Created by STIdea on 16/11/21.
//

import Foundation
import CoreLocation
import UIKit
public class UtilitiesLocation: NSObject, CLLocationManagerDelegate{
//    Permissions requeriments
//    Privacy - Location Always and When In Use Usage Description
//    Privacy - Location When In Use Usage Description
    
    public var manager:CLLocationManager = CLLocationManager()
    public var localizacionValidada:CLLocation?
    public static var almacen = UtilitiesLocation()
    
    public override init(){
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        print("init")
    }
    
    public func startLocation(){
        manager.startUpdatingLocation()
    }
    public func stopLocation(){
        manager.stopUpdatingLocation()
    }
    
    //    Se llama cada vez que se cambian los permisos, se manejan las diferentes opciones del usuario
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print( "log:Check de permisos" )
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            print("log:Acceso permitido a la ubicacion")
            
            
        case .restricted, .denied:
            print("log:Acceso denegado a la ubicacion")
            //            Mensaje avisando que para usar visualeo tienes que tener la ubicacion activada
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "Ubicación desactivada", message: "Por favor para poder usar la funcionalidad de Visualeo es necesario tener la ubicación activada en los ajustes de su teléfono.", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: { action in
//                    self.dismiss(animated: true, completion: nil)
//                }))
//                alert.addAction(UIAlertAction(title: "Ajustes", style: UIAlertAction.Style.default,handler: { action in
//                    if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
//                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
        case .notDetermined:
            print("log:El usuario aun no ha dicho nada sobre los permisos")
            manager.requestAlwaysAuthorization()
        default:
            print("log:Acceso ubicacion default")
        }
    }
    
    //    Se ejecuta cada vez que cambia la ubicacion, filtra las ubicaciones que tienen cierta precision
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        Filtro de metros,guarda la ubicacion validada
        DispatchQueue.global(qos: .userInteractive).async{
            //            print("log:loc2 \(manager.location)")
//            if locations.last!.horizontalAccuracy <= 70{
                self.localizacionValidada = locations.last
                                print("log:localizacion. \(self.localizacionValidada)")
//            }
        }
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    deinit
    {
        print("deinit")
    }

    
}
