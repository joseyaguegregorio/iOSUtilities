//
//  WebViewController.swift
//  tasadores
//
//  Modified by Jose Yague Gregorio on 2/6/21.
//  Copyright © 2021 Sociedad de Tasacion S.A All rights reserved.
//



import Foundation
import UIKit
import PDFKit
import MapKit

class PdfViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var lastUrl: String!
    var urlPdf: String!
    var request :URLRequest!
    @IBOutlet var bottonCerrar: UIButton!
    @IBOutlet var botonOtros: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    var urlPdfLocal:URL?
    var pdfView = CustomPDFView()
    @IBOutlet var vistaPdfUIView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        self.ocultarBotonOtros()
        descargarPDF(ficheroURL: urlPdf)
    }
    

    

    
//    Se llama antes de aparecer la pagina
    override func viewWillAppear(_ animated: Bool){
        print("viewWillAppear(")
        super.viewWillAppear(animated)
    }
    


    
//    Se cierrra la vista
     @IBAction func botonCerrar(_ sender: Any) {
         dismiss(animated: true, completion: nil)
     }
    
    
    @IBAction func botonExtra(_ sender: Any) {
        compartirPDF(ubicacionFicheroURL: self.urlPdfLocal!)
        
    }
    

    
}

extension PdfViewController{
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("log:Ruta fichero temporal: \(location)")
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
//        El directorio de cache lo gestiona el sistema, el sitema en ocasiones borra los ficheros cuando no se usan
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.urlPdfLocal = documentsPath.appendingPathComponent("\(url.lastPathComponent).pdf")
        // delete original copy
        try? FileManager.default.removeItem(at: urlPdfLocal!)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: urlPdfLocal!)
            print("log:Ruta fichero en cache: \(self.urlPdfLocal)")
            DispatchQueue.main.async {
                if let document = PDFDocument(url: self.urlPdfLocal!) {
                    self.ocultarAnimacion()
                    self.mostrarBotonOtros()
                    self.pdfView.document = document
                    self.pdfView.autoScales = true
                    self.pdfView.setValue(true, forKey: "forcesTopAlignment")
                    self.pdfView.frame = self.view.frame
                    self.vistaPdfUIView.addSubview(self.pdfView)
                }
                
            }
        } catch let error {
            print("log:Copy Error: \(error.localizedDescription)")
        }
    }
    
    func descargarPDF(ficheroURL: String){
        guard let url = URL(string: ficheroURL) else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
//    El fichero de primeras se guarda en un fichero temporal que hay que copiar y guardar en un pdf
    func compartirPDF(ubicacionFicheroURL: URL){
        DispatchQueue.main.async {
            var filesToShare = [Any]()// Create the Array which includes the files you want to share
            filesToShare.append(ubicacionFicheroURL)
            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    func ocultarAnimacion(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func mostrarBotonOtros(){
        botonOtros.isHidden = false
    }
    
    func ocultarBotonOtros(){
        botonOtros.isHidden = true
    }
}

//this custom class provide a pdfview which enables zoomout, the native PDFView not allow disable zoomOut
final class CustomPDFView: PDFView {

    init() {
        super.init(frame: .zero)
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(update),
                name: .PDFViewDocumentChanged,
                object: nil
            )
    }

    deinit {
        // If your app targets iOS 9.0 and later the following line can be omitted
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func update() {
        // PDF can be zoomed in but not zoomed out
        DispatchQueue.main.async {
            self.autoScales = true
            self.maxScaleFactor = 4.0
            self.minScaleFactor = self.scaleFactorForSizeToFit
        }
    }

}
