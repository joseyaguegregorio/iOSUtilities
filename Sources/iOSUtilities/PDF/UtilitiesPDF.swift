//
//  File.swift
//  
//
//  Created by STIdea on 14/11/21.
//

import Foundation

public class UtilitiesPDF{
    
    public static func loadPDFController(urlNetwork: String){
        let vc = PdfViewController(nibName: "PdfViewController",bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.urlPdf = urlNetwork
        self.present(vc, animated: true, completion: nil)
    }
}
