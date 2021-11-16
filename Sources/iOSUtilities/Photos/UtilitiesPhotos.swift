//
//  File.swift
//  
//
//  Created by STIdea on 16/11/21.
//

import Foundation
import UIKit

public class UtilitiesPhotos{
//    Important! You should have permission: Privacy - Camera Usage Description
    
    public static func loadPhotViewController(view: UIViewController){
        let vc = PhotoViewController(nibName: "PhotoViewController",bundle: Bundle.module)
        vc.modalPresentationStyle = .fullScreen
//        Metodo que se ejecuta una vez que se va a cerrar el VisualeoViewController
        vc.completion = {print("De vuelta")}
        view.present(vc, animated: true, completion: nil)
    }
    
}
