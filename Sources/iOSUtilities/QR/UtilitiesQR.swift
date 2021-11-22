//
//  File.swift
//  
//
//  Created by STIdea on 22/11/21.
//

import Foundation
import UIKit


public class UtilitiesQR{
//    Important! You should have permission: Privacy - Camera Usage Description
    
    public static func loadQRViewController(view: UIViewController){
        let vc = QRViewController(nibName: "QRViewController",bundle: Bundle.module)
        vc.modalPresentationStyle = .fullScreen
//        Metodo que se ejecuta una vez que se va a cerrar el VisualeoViewController
//        vc.completion = {print("De vuelta")}
        view.present(vc, animated: true, completion: nil)
    }
    
}
