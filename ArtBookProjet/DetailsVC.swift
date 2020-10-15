//
//  DetailsVC.swift
//  ArtBookProjet
//
//  Created by Kevin Landry on 6/28/20.
//  Copyright © 2020 Kevin Landry. All rights reserved.
//

import UIKit
// ** HAS TO BE IMPORTED TO LINK TO A WHOLE GANG OF FUNCTIONS IN SAVING DATA
import CoreData

// added UIImagePickerControllerDelegate, UINavigationControllerDelegate due to picker function below; allows going between newly presented picker controller and back
class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // going to handle the keyboard - pt 1
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        // adding touch capability to "select image" image
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        //adding the above capability to imageview
        imageView.addGestureRecognizer(imageTapRecognizer)
        
    }
    
    @objc func selectImage(){
        // this command reaches the photo library
        let picker = UIImagePickerController()
        picker.delegate = self
        // go ahead and try the other options instead of photolibrary by putting just the period
        picker.sourceType = .photoLibrary
        // if user picks an image, they can edit it; not mandatory can set to false if desired
        picker.allowsEditing = true
        // presents picker as seen in alert message style
        present(picker, animated: true, completion: nil)
    }
    // REQUIRED with picker; gives a dictionary after picked; returns an object with "any" type, "info" comes from picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // have to cast (AKA --- as? is casting) or else error
        imageView.image = info[.originalImage] as? UIImage
        // dismisses picker controller once picked/done
        self.dismiss(animated: true, completion: nil)
    }
    
    //this hides the keyboard - pt 2
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func saveButtonClicked(_ sender: AnyObject) {
        // no idea what this does at all (something to do with core data) BUT the shared part makes it accessible all across the app
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // persistentcontainer is where core data is stored
        let context = appDelegate.persistentContainer.viewContext
        
        // writing data into database
        
        // is using context as called above as the container for new paintings
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        // Attributes
        
        // taking these values from ArtBookProjet.xcdatamodeld; notice force unwrap (!) as we knowthere will be values
        newPainting.setValue(nameText.text!, forKey: "name")
        newPainting.setValue(artistText.text!, forKey: "artist")
        
        if let year = Int(yearText.text!) {
            // have to use the above code to convert year to integer priorto storage
            newPainting.setValue(year, forKey: "year")
        }
        //doing the parentheses creates a unique uuid each time saved
        newPainting.setValue(UUID(), forKey: "id")
        // 0.5 means its OK; i believe closer to 1 is better quaulity?
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        newPainting.setValue(data, forKey: "image")
        // this is to display an error on saving; do = works, catch = breaks
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
        
    }
    
}
