//
//  File.swift
//  
//
//  Created by STIdea on 14/11/21.
//

import Foundation
import UIKit

public class UtilitiesPDF{
    
    public static func loadPDFViewController(view: UIViewController ,urlNetwork: String){
        let vc = PdfViewController(nibName: "PdfViewController",bundle: Bundle.module)
        vc.modalPresentationStyle = .fullScreen
        vc.urlPdf = urlNetwork
        view.present(vc, animated: true, completion: nil)
    }
}
