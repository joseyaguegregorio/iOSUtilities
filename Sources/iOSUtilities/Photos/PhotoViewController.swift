//
//  VisualeoViewController.swift
//  tasadores
//
//  Created by STIdea on 13/9/21.
//  Copyright © 2021 Sociedad de tasacion. All rights reserved.
//


import UIKit
import CoreLocation
import AVFoundation

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //    Se encarga de gestionar la seleccion de imagen de la galeria o la toma de fotos de la galeria
    let imagePicker: UIImagePickerController = UIImagePickerController()
    @IBOutlet var imagenVista: UIImageView!
    
    @IBOutlet var botonHacerFoto: UIButton!
    @IBOutlet var botonEnviarFoto: UIButton!
    @IBOutlet var botonCerrarVista: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var completion: (() -> Void)?
    var mensajes = ["Subiendo","Ya queda menos","En proceso"]
    var terminaAnimacion = false
    @IBOutlet var texto: UILabel!
    @IBOutlet var vistaProgreso: UIView!

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        //        El boton enviar se hace visible cuando se cumplen las condiciones de ubicacion y de haber realizado una foto
        botonEnviarFoto.isHidden = true
        vistaProgreso.isHidden = true

    }
    

    
    @IBAction func hacerFoto(_ sender: Any) {
        
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized, .notDetermined:
            //            Comprueba que esta disponible la camara del sistema y la camara trasera
            if UIImagePickerController.isSourceTypeAvailable(.camera) && UIImagePickerController.availableCaptureModes(for: .rear) != nil{
                let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                            self.imagePicker.allowsEditing = false
                            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                            self.imagePicker.cameraCaptureMode = .photo
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }))

                        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                            self.imagePicker.allowsEditing = false
                            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }))

                        alert.addAction(UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil))
                        self.present(alert, animated: true, completion: nil)
               
            }else{
                Utilities.presentarModalMensajeUnico(vista: self, titulo: "Cámara", mensaje: "Algo salió mal al intentar acceder a la cámara", mensajeBoton: "Ok") {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        case .restricted, .denied:
            //                        Mandar a ajustes del sistema iOS
            Utilities.presentarModalMensajeMultiple(
                vista: self,
                titulo: "Cámara sin permisos",
                mensaje: "Por favor para poder usar la camara es necesario tener los permisos de la cámara activados en los ajustes de su teléfono.",
                mensajeBoton1: "Ok",
                funcion1: {
                    self.dismiss(animated: true, completion: nil)
                },
                mensajeBoton2: "Ajustes",
                funcion2:{
                    if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
                       let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            )
        }
        
        
    }
    
    
    
    //    Este metodo es llamado cuando se ha realizado la foto
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagenVista.image = imagenSeleccionada
            //            Guarda la foto tomada en la libreria, ahora peta
            //            UIImageWriteToSavedPhotosAlbum(imagenSeleccionada, nil, nil, nil)
            //            botonHacerFoto.setTitle("Repetir", for: .normal)
            
            botonEnviarFoto.isHidden = false
            botonHacerFoto.isHidden = true
        }
        //        Cierra la vista de la camara o galeria
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    
    @IBAction func enviarFoto(_ sender: Any) {
        
    }
    
    
    
    
    
    @IBAction func cerrarVista(_ sender: Any) {
        dismiss(animated: true, completion: {
            if let completion = self.completion{
                completion()
            }
        })
    }
    
    
    
    

    
    func cargarAnimacion(){
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.vistaProgreso.isHidden = false
            self.botonEnviarFoto.isHidden = true
        }
        var contador = 0
        DispatchQueue.global(qos: .background).async {
            while (!self.terminaAnimacion){
                DispatchQueue.main.async {
                    self.texto.textWithAnimation(text: self.mensajes[contador % self.mensajes.count], duration: 1.0)
                    contador += 1
                }
                sleep(7)
                DispatchQueue.main.async {
                    self.texto.textWithAnimation(text: "  ", duration: 1.0)
                }
                sleep(2)
            }
            DispatchQueue.main.async {
                //                self.vistaProgreso.isHidden = true
                //                self.texto.textWithAnimation(text: "SUBIDA", duration: 1.0)
            }
        }
    }
    
    func ocultarAnimacionProrgeso(){
        DispatchQueue.main.async {
            self.vistaProgreso.isHidden = true
            self.botonEnviarFoto.isHidden = false
        }
    }
    
    
    func compresionImagen(image: UIImage, maxSize: Int) -> Data? {
        print("Comprimiendo")
        var calidadActual = 1.0
        while(calidadActual >= 0.0){
            let imagenComprimida = self.imagenVista.image!.jpegData(compressionQuality: calidadActual)
            //            print("log: Tamaño actual \(imagenComprimida?.count) con compresion \(calidadActual)")
            if((imagenComprimida?.count)! <= maxSize){
                return imagenComprimida
            }
            calidadActual -= 0.1
        }
        return nil
    }
    
    
    
}









//For text animations
extension UILabel{
    
    func animation(typing value:String,duration: Double){
        let characters = value.map { $0 }
        var index = 0
        Timer.scheduledTimer(withTimeInterval: duration, repeats: true, block: { [weak self] timer in
            if index < value.count {
                let char = characters[index]
                self?.text! += "\(char)"
                index += 1
            } else {
                timer.invalidate()
            }
        })
    }
    
    
    func textWithAnimation(text:String,duration:CFTimeInterval){
        fadeTransition(duration)
        self.text = text
    }
    
    //followed from @Chris and @winnie-ru
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
                                                            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
}



