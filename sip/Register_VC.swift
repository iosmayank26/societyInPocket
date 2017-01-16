//
//  login_VC.swift
//  sip
//
//  Created by Mayank Gupta on 03/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire


extension String {
    func matchPattern(patStr:String)->Bool {
        var isMatch:Bool = false
        do {
            let regex = try NSRegularExpression(pattern: patStr, options: [.caseInsensitive])
            let result = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count))
            
            if (result != nil)
            {
                isMatch = true
            }
        }
        catch {
            isMatch = false
        }
        return isMatch
    }
}



class Register_VC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    var nameTextFieldIs = String()
    var flatNumberTextFieldIs = String()
    var accountType = String()
    var carParkingSlotNumberIs = String()
    
    @IBOutlet var profileImage: UIImageView!
    
  
    @IBOutlet var nameOfUser: UITextField!
    
    @IBOutlet var societyName: UITextField!
    
    @IBOutlet var flatNumber: UITextField!
    
    @IBOutlet var contactNumber: UITextField!
    
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    @IBOutlet var repeatPasswordTextField: UITextField!
    
    
    @IBAction func selectSocietyAction(_ sender: Any) {
        
        popUpSociety()
        
    }
    
    
    
    
    
    @IBAction func selectImage(_ sender: Any) {
        
        popUpAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      societyName.isEnabled = false
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    // to dismiss the keyboard by touching view
        func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        profileImage.image = image
        
        self.dismiss(animated: true, completion: nil);
        
    }

    // alert function
    func popUpAlert(){
        let alertController = UIAlertController(title: "Choose a photo", message: "", preferredStyle: .alert)
        
        // Create the actions
        let cameraAction = UIAlertAction(title: "Take a Photo", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
            NSLog("OK Pressed")
        }
        let galleryAction = UIAlertAction(title: "Choose from Gallery", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openGallery()
            NSLog("Cancel Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        
        // Add the actions
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    // open the camera function
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("not working")
        }
    }
    //open the gallery function
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    
    
    func popUpSociety(){
        let alertController = UIAlertController(title: "Select your society", message: "", preferredStyle: .actionSheet)
        
        // Create the actions
        let vvipAction = UIAlertAction(title: "VVIP Addresses", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.societyName.text = "VVIP Addresses"
            print("VVIP Addresses pressed")
        }
//        let plumbingAction = UIAlertAction(title: "Gaur Cascades", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            self.societyName.text = "Gaur Cascades"
//            print("Gaur Cascades Pressed")
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
         UIAlertAction in
         print("Cancel Pressed")
            
        }
        alertController.addAction(vvipAction)
//        alertController.addAction(plumbingAction)
       
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    

    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
   
    
    @IBAction func loginAction(_ sender: Any) {
        
               
        
        
        
        
        
        
        
        
        
        
        
        
        guard let name = nameOfUser.text,let society = societyName.text,let flatNumber = flatNumber.text,let contactNumber = contactNumber.text,let email = emailTextField.text,let password = passwordTextField.text else{
            print("Form is not valid")
            return
        }
        
        
        
        if(name.isEmpty || society.isEmpty || flatNumber.isEmpty || contactNumber.isEmpty || email.isEmpty || password.isEmpty){
            
            let alertVC = UIAlertController(title: "Alert", message: "Fill all the required fields and try again" ,preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default , handler : nil)
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)
            

            return
            
        }
        if(contactNumber.characters.count < 10 || contactNumber.characters.count > 10){
            
            let alertVC = UIAlertController(title: "Alert", message: "Contact number is not valid" ,preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default , handler : nil)
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)
            
            return
            
        }
        
        
        if(email.matchPattern(patStr: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$")==false){
            let alertVC = UIAlertController(title: "Alert", message: "Invalid Email" ,preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default , handler : nil)
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)
            
            
            return
        }

        if (password != repeatPasswordTextField.text) {
            let alertVC = UIAlertController(title: "Alert", message: "Password mismatch ,please try again!" ,preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default , handler : nil)
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)
            
            
            return
            
            
        }
        
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user: FIRUser?,error) in
            
            user?.sendEmailVerification(completion: nil)
            let alertVC = UIAlertController(title: "Message", message: " An email has been send to your email address  \(self.emailTextField.text!) , Complete the verification to proceed.", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default , handler : nil)
              alertVC.addAction(alertActionOkay)
              self.present(alertVC, animated: true, completion: nil)
            
            
            
            
            if error != nil{
                print(error)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profleImageIs = self.profileImage.image, let uploadData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)
            {
            
            
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name,"societyName": society,"flatNo" : flatNumber,"contactNumber" : contactNumber,"residentType" : self.accountType,"carParkingSlotNumber": self.carParkingSlotNumberIs,"email": email, "profileImageUrl": profileImageUrl] as [String : Any]
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        if societyName.text == "VVIP Addresses"{
        let ref = FIRDatabase.database().reference(fromURL: "https://sipindia-cd004.firebaseio.com/")
        //let usersReference = ref.child("users").child(uid)
        
        let usersReference = ref.child("vvipAddresses").child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
           
            
            
            
        })}
        
       else if societyName.text == "Gaur Cascades"{
            let ref = FIRDatabase.database().reference(fromURL: "https://sipindia-cd004.firebaseio.com/")
            //let usersReference = ref.child("users").child(uid)
            
            let usersReference = ref.child("gaurCascades").child("users").child(uid)
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err)
                    return
                }
                
                
                
                
            })
            
        }
        else {
            let ref = FIRDatabase.database().reference(fromURL: "https://sipindia-cd004.firebaseio.com/")
            //let usersReference = ref.child("users").child(uid)
            
            let usersReference = ref.child("riverHeights").child("users").child(uid)
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err)
                    return
                }
                
                
                
                
            })
            
        }

        
            self.performSegue(withIdentifier: "loginHere", sender: nil)
        
           }
    
   

}

