//
//  Login_VC.swift
//  sip
//
//  Created by Mayank Gupta on 03/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Login_VC : UIViewController{
    
    @IBOutlet var societyImageView: UIImageView!
    
    
    @IBOutlet var emailTextField: UITextField!
    
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

   
    @IBAction func loginAction(_ sender: Any) {
        
        
        guard let email = emailTextField.text,let password = passwordTextField.text else{
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user,error) in
           
            let admin = (FIRAuth.auth()?.currentUser?.uid)! as String
            if admin == "IDCuFb3jQlO6CWeHjJV3a8Ca7VH2" {
                
                
                self.performSegue(withIdentifier: "ifAdmin", sender: nil)
                
            }
                
            else {
                
            
            
            
            if let user = FIRAuth.auth()?.currentUser {
                if !user.isEmailVerified {
                   
                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(self.emailTextField.text!).", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                        (_) in
                        user.sendEmailVerification(completion: nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                } else {
                    print ("Email verified. Signing in...")
                     if (user.isEmailVerified){
                        print("successfully logged in")
                        self.performSegue(withIdentifier: "loginToHome", sender: nil)
                    }

                    
                    
                }
                
                
            }
            else if error != nil{
//                print(error)
                
                let alertVC = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
                let alertActionRetry = UIAlertAction(title: "Retry", style: .default) {
                    (_) in
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }
                alertVC.addAction(alertActionRetry)
                self.present(alertVC, animated: true, completion: nil)
            return
                
                
            }


            else if (user?.isEmailVerified)!{
            print("successfully logged in")
            self.performSegue(withIdentifier: "loginToHome", sender: nil)
            }
            }
            
        })
        

    }
    
    @IBAction func forgottenPassword(_ sender: Any) {
        performSegue(withIdentifier: "forgottenPassword", sender: nil)
        
        
    }
    
    
    
}
