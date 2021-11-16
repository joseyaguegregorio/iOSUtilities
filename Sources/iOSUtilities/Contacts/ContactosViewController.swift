//
//  ContactosViewController.swift
//  tasadores
//
//  Created by Sociedad de Tasación, S.A on 6/7/21.
//  Copyright © 2021 Sociedad de tasacion. All rights reserved.
//

import UIKit
import Contacts

class ContactosViewController: UIViewController {
    var nombre = ""
    var numero = ""
    
    @IBOutlet weak var textfielNumero: UITextField!
    @IBOutlet weak var texfieldNombre: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Reconocimiento de gesto que permite que el usuario pueda hacer click y desapareza el teclano, necesario para dispositivos con patalla pequeña
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        texfieldNombre.text = nombre
        textfielNumero.text = numero
        
//        Al cargar la vista si los permisos ya se denegaron aparece un mensaje avisando de eso, en futuro implementar que lleve a ajustes directamente
        let store = CNContactStore()
        store.requestAccess(for: .contacts) {aceptar, error in
            if !aceptar{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Permiso denegado", message: "Por favor vaya a ajustes y permita el acceso a contactos", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

    }
    
//    func cerrarModal(){
//        dismiss(animated: true, completion: nil)
//    }
    @IBAction func guardarContacto(_ sender: Any) {
        let store = CNContactStore()
//        Solicita permisos
        store.requestAccess(for: .contacts) { aceptar, error in
            if aceptar{
                let contact = CNMutableContact()
                let image = UIImage(named: "logo.png", in: nil, compatibleWith: nil)
                        contact.imageData = image?.jpegData(compressionQuality: 1.0)

                contact.givenName = self.texfieldNombre.text!
                contact.phoneNumbers = [CNLabeledValue(
                    label: CNLabelPhoneNumberiPhone,
                    value: CNPhoneNumber(stringValue: self.textfielNumero.text!))]
                let saveRequest = CNSaveRequest()
                saveRequest.add(contact, toContainerWithIdentifier: nil)

                do {
                    try store.execute(saveRequest)
                    print("log: Contacto guardado")
                } catch {
                    print("log: Error guardar contacto \(error)")
                    self.showUIAlert(title: "Error", message: "Error guardar contacto")
                }
            }
            else{
                print("log: Acceso denegado a los contactos")
            }
            if let error = error{
                print("log: Error guardar contacto", error)
                self.showUIAlert(title: "Error", message: "Error guardar contacto")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelarModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showUIAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
//        Oculta el teclado
        view.endEditing(true)
    }

}
