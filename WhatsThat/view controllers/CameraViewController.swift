//
//  CameraViewController.swift
//  WhatsThat
//
//  Created by Kai Sun on 11/22/17.
//  Copyright © 2017 Kai Sun. All rights reserved.
//  camera screen, can get picture from camera and photoLibrary using UIImagePickerController

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
// take picture
    @IBAction func takePhoto(_ sender: UIButton) {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) // check whether the camera is available
        {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }else{                                                                                  // if not available, give a alert view
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
//  get picture from album
    @IBAction func openAlbum(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
// prepare data for google vision
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destView = segue.destination as? VisionViewController {
            destView.imageStr = imageStr    //the imagestr encoded by base64
            destView.image = imageFound     //picture selected
            destView.directory = directory  //the file name of image
        }
    }
//  save image to the app sliced documents storage
    func saveImageDocumentDirectory(name: String, imageData: Data){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(name).png")
        directory = "\(name).png"
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
}


extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//  if picture choosed, callback following function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageFound = (info["UIImagePickerControllerEditedImage"] as? UIImage)!
        imageView.image = imageFound
        imagePicker.dismiss(animated: true, completion: nil)
        
        let date :NSDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"
        dateFormatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone

        self.saveImageDocumentDirectory(name: "\(dateFormatter.string(from: date as Date))", imageData: UIImagePNGRepresentation(imageFound)!)
// encode image with base64
        imageStr = base64EncodeImage(imageFound)

    }
// if picture cancelled, callback following function
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
// check the size of image, if bigger than API limit, resize; else, encode
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
// the resize image into a new image with width 800 and respect to width/height rate
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
