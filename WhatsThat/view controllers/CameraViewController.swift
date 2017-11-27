//
//  CameraViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/22/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var imageStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func takePhoto(_ sender: UIButton) {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func openAlbum(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
   
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destView = segue.destination as? VisionViewController {
            destView.imageStr = imageStr
            destView.showImage.image = imageView.image
        }
    }
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info["UIImagePickerControllerEditedImage"] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        
        let imageData:NSData = UIImageJPEGRepresentation(imageView.image!, 0.9)! as NSData
        imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(imageStr)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
