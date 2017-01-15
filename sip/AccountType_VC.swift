//
//  AccountType_VC.swift
//  sip
//
//  Created by Mayank Gupta on 23/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class AccountType_VC : UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet var textBox: UITextField!
    
    
    
    @IBOutlet var dropDown: UIPickerView!
    
      var list = ["Society Resident", "Society Admin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.delegate = self
        dropDown.dataSource = self
        textBox.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(FIRAuth.auth()?.currentUser)
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth : FIRAuth, user : FIRUser?) in
           
            
                if user != nil && (user?.isEmailVerified)!{
                let admin = try? (FIRAuth.auth()?.currentUser?.uid)! as String
                if admin == "K2xf0pu19XceWw3hS5VQOFCmGdl1" {
                    print(user) 
                   self.switchAd()
                    
                }else{
                
                print(user)
                self.switchTo()
                }
            }else{
                print("Unauthorised")
            }
            
        })
    }
    func switchTo(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
        
    }
    func switchAd(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "AdminNavigation") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.textBox.text = self.list[row]
        self.textBox.isEnabled = false
       // self.dropDown.isHidden = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textBox {
            self.dropDown.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
    }
    
    
    @IBAction func getStartedAction(_ sender: Any) {
        if textBox.text == "Society Resident"{
             performSegue(withIdentifier: "accountToRegister" , sender: nil)
        }
        else if textBox.text == ""{
            
            let alertVC = UIAlertController(title: "Alert", message: "Please select your account type", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default , handler : nil)
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)

        }
            
            
            
        else {
//            performSegue(withIdentifier: "accountToServerRegister", sender: nil)
            let alertVC = UIAlertController(title: "Alert", message: "Not a supported type yet,Sorry!", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default , handler : nil)
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if segue.identifier == "accountToRegister"{
        let destination = segue.destination as! Register_VC
            
            destination.accountType = "Resident"
            
            
            
            
            
        }
       else if segue.identifier == "alreadyUser" {
                  
        let destination = segue.destination as! Login_VC
        
        
        
        
        }

        
    }

    
}
