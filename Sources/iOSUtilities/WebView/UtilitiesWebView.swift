//
//  File.swift
//  
//
//  Created by STIdea on 16/11/21.
//

import Foundation
import UIKit


public class UtilitiesWebView{
    
    public static func loadWebViewController(view: UIViewController, url: String){
        let vc = WebViewController(nibName: "WebViewController",bundle: Bundle.module)
        vc.modalPresentationStyle = .fullScreen
        vc.url = url
        view.present(vc, animated: true, completion: nil)
        
    }
}
