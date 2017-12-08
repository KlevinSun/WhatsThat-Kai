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
    var imageFound: UIImage = UIImage()
    var imageStr: String = ""
    var directory: String = ""
    
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
            destView.image = imageFound
            destView.directory = directory
        }
    }
    
    func saveImageDocumentDirectory(name: String, imageData: Data){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(name).jpg")
        directory = paths
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageFound = (info["UIImagePickerControllerEditedImage"] as? UIImage)!
        imageView.image = imageFound
        imagePicker.dismiss(animated: true, completion: nil)
        if(picker.sourceType == .photoLibrary){
            directory = String(describing: info["UIImagePickerControllerReferenceURL"] as! NSURL)
            print("this is the directory: \(directory)")
        }else{
            let date :NSDate = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
            dateFormatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone

            self.saveImageDocumentDirectory(name: "\(dateFormatter.string(from: date as Date))", imageData: UIImagePNGRepresentation(imageFound)!)
        }
        
        //let imageData:NSData = UIImageJPEGRepresentation(imageView.image!, 0.9)! as NSData
        imageStr = base64EncodeImage(imageFound)
        //print(imageStr)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        let imdata : NSData = NSData(data: imagedata!)
        
        // Resize the image if it exceeds the 2MB API limit
        if ((imdata.length / 1024) > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
