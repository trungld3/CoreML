//
//  ViewController.swift
//  CoreMLSeeFood
//
//  Created by TrungLD on 4/29/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if  let userPickerimage  = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageView.image = userPickerimage
            guard let ciimage = CIImage(image: userPickerimage) else {
            fatalError("loi CIImage")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    func detect ( image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("loi detect")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to process image")
            }
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                }else {
                    self.navigationItem.title = " not hotdog!"
                }
            }
        }
        let handler = VNImageRequestHandler( ciImage: image)
        do {
            try handler.perform([request])
        } catch {
            print("loi handler\(error)")
        }
        
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker ,animated: true, completion: nil)
    }
}

