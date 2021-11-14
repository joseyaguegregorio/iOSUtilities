import Foundation
import UIKit

public class Utilities{
//    De esta manera estas obligado a pasar un parametro, no se puede pasar nil, aunque se ponga void?
//    static func presentarModalMensajeUnico(vista: UIViewController, titulo: String, mensaje: String,mensajeBoton: String, funcion: @escaping () -> Void){
    public static func presentarModalMensajeUnico(vista: UIViewController, titulo: String, mensaje: String,mensajeBoton: String, funcion: (() -> Void)?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: mensajeBoton, style: UIAlertAction.Style.default,handler: { action in
                if let _funcion = funcion{
                    _funcion()
                }
            }))
            vista.present(alert, animated: true, completion: nil)
        }
    }
    
    public static func presentarModalMensajeMultiple(vista: UIViewController, titulo: String, mensaje: String, mensajeBoton1: String, funcion1: (() -> Void)?, mensajeBoton2: String, funcion2: (() -> Void)?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: mensajeBoton1, style: UIAlertAction.Style.default,handler: { action in
                if let _funcion = funcion1{
                    _funcion()
                }
            }))
            
            alert.addAction(UIAlertAction(title: mensajeBoton2, style: UIAlertAction.Style.default,handler: { action in
                if let _funcion = funcion2{
                    _funcion()
                }
            }))
            vista.present(alert, animated: true, completion: nil)
        }
    }
    

}
