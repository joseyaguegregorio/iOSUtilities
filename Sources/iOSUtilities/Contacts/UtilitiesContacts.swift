//
//  File.swift
//  
//
//  Created by STIdea on 16/11/21.
//

import Foundation
import UIKit

public class UtilitiesContacts{
    //Necesario tener activos los permisos: Privacy - Contacts Usage Description
    public static func loadContactViewController(view: UIViewController, name: String, number: String){
        let vc = ContactosViewController(nibName: "ContactosViewController", bundle: Bundle.module)
        vc.nombre = name
        vc.numero = number
        view.present(vc, animated: true, completion: nil)
    }
    
}
