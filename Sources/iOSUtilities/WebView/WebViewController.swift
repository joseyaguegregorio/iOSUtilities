import Foundation
import UIKit
import WebKit
import AVFoundation
import MapKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, CLLocationManagerDelegate{
    
    var manager: CLLocationManager!
    @IBOutlet var webView: WKWebView!
    var urlConnection :NSURLConnection!
    var request :URLRequest!
    var myURL: URL!
    var url: String = ""
    var urlSession :URLSession!
    var response :URLResponse!
    var lastUrl: String!
    var refreshedToken: String!
    let userDefaults = UserDefaults.standard

    

    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
//        IMPORTANTE PARA DESACTIVAR EL REVOTE EN DISPOSITIVOS CON PANTALLA MODERNA
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        loadUrlInWebview(url: url)
    }

        
    
//    Cargar url en webview
    func loadUrlInWebview(url:String){
        myURL = URL(string: url);
        request = URLRequest(url: myURL!)
        webView.load(request)
    }

    
//    Enviar javascript webview
    func javascript(codigo: String){
//        print("log:javascrip\(codigo)")
        DispatchQueue.global(qos: .background).async{
            DispatchQueue.main.async{
                self.webView.evaluateJavaScript(codigo)
            }
        }
    }
    
    

    //    Cada cambio de url se llama a este metodo
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
            var urlString = navigationAction.request.url!.absoluteString
            let url = URL(string: urlString)
//            print("log:Cambia \(urlString)")
////            Comprueba si hay red, en Utils.swift se extiende NSOBject, por lo que currentReachabilityStatus es una variable de alcance global
//            if(currentReachabilityStatus == .notReachable){
//                showSecurityHandlerController(title: "Error de conexión", message: "No hay conexión a internet", retry: true);
//            }
            
            
            if !url!.absoluteString.hasPrefix("http://") && !url!.absoluteString.hasPrefix("https://"){
                if ((urlString.contains("mailto:"))) {
                    if(UIApplication.shared.canOpenURL(url!)){
                        UIApplication.shared.open(URL(string: urlString.replacingOccurrences(of: "://", with: ":"))!)
                    }
                    decisionHandler(.cancel)
                    return
                }

                else if ((urlString.contains("tel:"))) {
                    let alert = UIAlertController(title: "Numero de telefono", message: "¿Que deseas hacer con el numero de telefono?", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Telefono", style: .default, handler: { action in
                        if(UIApplication.shared.canOpenURL(url!)){
                            UIApplication.shared.open(url!)
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Whatsapp", style: .default, handler: {action in
                        var phoneNumber = ""
                        if urlString.contains("tel:+34"){
                            phoneNumber = urlString.replacingOccurrences(of: "tel:", with: "")
                        }
                        else{
                            phoneNumber = urlString.replacingOccurrences(of: "tel:", with: "+34")
                        }
                        
                         let texto = ""
                         let whatsappURL = NSURL(string:"https://api.whatsapp.com/send?phone="+phoneNumber+"&text="+texto)
                         if(UIApplication.shared.canOpenURL(whatsappURL! as URL)){
                         UIApplication.shared.open(whatsappURL! as URL)
                         }else{
                            print("log:No existe el teléfono")
                         }
                    }))
                    alert.addAction(UIAlertAction(title: "Contactos", style: .default, handler: {action in
                        let phoneNumber = urlString.replacingOccurrences(of: "tel:", with: "")
                        UtilitiesContacts.loadContactViewController(view: self, name: "Contacto", number: phoneNumber)
                        
                         
                    }))
                    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                                
                    decisionHandler(.cancel)
                    return
                }
                else if ((urlString.contains("geo:"))) {
                    let latitud = urlString.replacingOccurrences(of: "geo:0,0?q=", with: "").components(separatedBy: ",")[0]
                    let longitud = urlString.replacingOccurrences(of: "geo:0,0?q=", with: "").components(separatedBy: ",")[1]
                    manager = CLLocationManager()
                    manager?.delegate = self
                    manager?.requestAlwaysAuthorization()
    //                Primero se intenta usar googleMaps, sino se usa maps de apple
                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                        UIApplication.shared.open(URL(string:"comgooglemaps://?q=\(latitud),\(longitud)")!)
                    } else {
                        let coordinate = CLLocationCoordinate2DMake(Double(latitud)!, Double(longitud)!)
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
                        mapItem.name = "Location"
                        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                    }
                    decisionHandler(.cancel)
                    return
                }
                
                decisionHandler(.cancel)
                return
            }
            else{
                if url!.absoluteString.contains("PDF") || url!.absoluteString.contains("pdf")  {
                    UtilitiesPDF.loadPDFViewController(view: self, urlNetwork: navigationAction.request.url!.absoluteString)
                    decisionHandler(.cancel)
                    return
                }
                decisionHandler(.allow)
            }
        }
    

    
//     Se ejecuta cuando la pagina ha terminado de cargarse
    func webView(_ myWebView: WKWebView, didFinish navigation: WKNavigation!) {
        print("log:Web cargada \(myWebView.url!)")
//        Desactiva el gris al pulsar un boton, click, clic del link
        webView.evaluateJavaScript("document.body.style.webkitTapHighlightColor='transparent';")
        
        //Borrar cache
        let webSiteDataTypes = NSSet(array:[WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = NSDate(timeIntervalSinceReferenceDate: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: webSiteDataTypes as! Set<String>,modifiedSince: date as Date, completionHandler:{ })
        
        let yourTargetUrl = myWebView.url?.absoluteString
        lastUrl = yourTargetUrl
    }
    

} //end class WebViewController


extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
