//
//  UserInfo_VC.swift
//  sip
//
//  Created by Mayank Gupta on 05/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit

class UserInfo_VC : UIViewController{
    
    
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var flatNoTextField: UITextField!
    @IBOutlet var ownerOrRenter: UITextField!
    @IBOutlet var carParkingSlotNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoToRegister" {
            
            let destination = segue.destination as! Register_VC
            destination.nameTextFieldIs = nameTextField.text!
            destination.flatNumberTextFieldIs = flatNoTextField.text!
            destination.ownerOrRenterField = ownerOrRenter.text!
            destination.carParkingSlotNumberIs = carParkingSlotNumber.text!
            
            
        }
    }

    @IBAction func nextButton(_ sender: Any) {
        
        performSegue(withIdentifier: "infoToRegister", sender: nil)
    }
    
    
}
