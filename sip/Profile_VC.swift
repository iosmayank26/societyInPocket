//
//  Home_VC.swift
//  sip
//
//  Created by Mayank Gupta on 01/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Profile_VC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var loadingView = UIView()
    var container = UIView()
    let activityIndicator = UIActivityIndicatorView()
    @IBOutlet var navigationBarItem: UINavigationBar!
    
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var nameOfUser: UILabel!
    
    @IBOutlet var flatNumber: UILabel!
  
    @IBOutlet var open: UIBarButtonItem!
    
    @IBOutlet var emailOfUser: UILabel!
    
    @IBOutlet var phoneNumberOfUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Profile_VC.imageTapped(_:)))
        userImage.addGestureRecognizer(tap)
        userImage.isUserInteractionEnabled = true
        
             
    
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    override func viewDidAppear(_ animated: Bool) {

      
       
      
        
    }
    @IBAction func editProfilePic(_ sender: Any) {
        
        popUpEdit()
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        userImage.image = image
        updateProfile()
        print("finished")
        self.dismiss(animated: true, completion: nil);
        
    }
    
    // alert function
    func popUpAction(){
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
    func popUpEdit(){
        let alertController = UIAlertController(title: "Edit profile photo", message: "", preferredStyle: .alert)
        
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
    

    
    
    @IBAction func logoutButton(_ sender: Any) {
        
        handleLogout()
        
    }
    func showLoading() {
        
        let win:UIWindow = UIApplication.shared.delegate!.window!!
        self.loadingView = UIView(frame: win.frame)
        self.loadingView.tag = 1
        self.loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        win.addSubview(self.loadingView)
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: win.frame.width/3, height: win.frame.width/3))
        container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        container.layer.cornerRadius = 10.0
        container.layer.borderColor = UIColor.gray.cgColor
        container.layer.borderWidth = 0.5
        container.clipsToBounds = true
        container.center = self.loadingView.center
        
        
       //activityIndicator.frame = CGRectEdge(0, 0, win.frame.width/5, win.frame.width/5)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = self.loadingView.center
        
        
        self.loadingView.addSubview(container)
        self.loadingView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    func hideLoading(){
        UIView.animate(withDuration: 0.0, delay: 1.0, options: .curveEaseOut, animations: {
            self.container.alpha = 0.0
            self.loadingView.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }, completion: { finished in
            self.activityIndicator.removeFromSuperview()
            self.container.removeFromSuperview()
            self.loadingView.removeFromSuperview()
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            let removeView  = win.viewWithTag(1)
            removeView?.removeFromSuperview()
        })
    }
    func handleLogout(){
        
        do{
            try FIRAuth.auth()?.signOut()
            print ("logged out successfully")
            switchTo()
            
        }
        catch let logoutError{
            print(logoutError)
        }
        
//        let loginController = ChooseSociety()
//        present(loginController,animated: true,completion:nil)
            }

    func switchTo(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "ChooseSociety") as! UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
        
    }

    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        }else {
            showLoading()
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("vvipAddresses").child("users").child(uid!).observeSingleEvent(of: .value,with: { (snapshot) in
                let dictionary = snapshot.value as? [String: AnyObject]
                
                let society = dictionary?["societyName"] as? String
                print("the society is \(society)")
                
                
                
                if society == "VVIP Addresses" {
                    FIRDatabase.database().reference().child("vvipAddresses").child("users").child(uid!).observeSingleEvent(of: .value,with: { (snapshot) in

                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.navigationBarItem.topItem?.title = "Welcome"
                    self.nameOfUser.text = dictionary["name"] as? String
                    self.emailOfUser.text = dictionary["email"] as? String
                    self.flatNumber.text = dictionary["flatNo"] as? String
                    let imageUrl = dictionary["profileImageUrl"] as? String
                    let url = NSURL(string: imageUrl!)
                    let data = NSData(contentsOf: url as! URL)
                
                    self.userImage.image = UIImage(data : data as! Data)
                }
            self.hideLoading()
                
            },withCancel: nil)
            
            
        }
                else{
                    
                    FIRDatabase.database().reference().child("gaurCascades").child("users").child(uid!).observeSingleEvent(of: .value,with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            self.navigationBarItem.topItem?.title = "Welcome"
                            self.nameOfUser.text = dictionary["name"] as? String
                            self.emailOfUser.text = dictionary["email"] as? String
                            self.flatNumber.text = dictionary["flatNo"] as? String
                            let imageUrl = dictionary["profileImageUrl"] as? String
                            let url = NSURL(string: imageUrl!)
                            let data = NSData(contentsOf: url as! URL)
                            
                            self.userImage.image = UIImage(data : data as! Data)
                        }
                        self.hideLoading()
                        
                    },withCancel: nil)
                    

                    
                }
                
                
    },withCancel: nil)
        }



}
    func updateProfile(){
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference(fromURL: "https://sippro-2176c.firebaseio.com/vvipAddresses/users/\(uid!)")
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let profleImageIs = self.userImage.image, let uploadData = UIImageJPEGRepresentation(self.userImage.image!, 0.1)
        {
            
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
        let childUpdates = ["profileImageUrl": profileImageUrl]
        ref.updateChildValues(childUpdates, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            
            
        })
            }
        })
    }
    
        
    }
    
    
}
