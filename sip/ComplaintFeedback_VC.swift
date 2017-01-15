//
//  ComplaintFeedback_VC.swift
//  sip
//
//  Created by Mayank Gupta on 22/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class ComplaintFeedback_VC : UIViewController,UITextViewDelegate {
    
    @IBOutlet var complaintFeedType: UITextField!
    @IBOutlet var departmentConcerned: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        complaintFeedType.isEnabled = false
        departmentConcerned.isEnabled = false
        
        compFeedBox.delegate = self
        compFeedBox.text = "Write something here..."
        compFeedBox.textColor = UIColor.lightGray
        compFeedBox.layer.borderWidth = 1.0
        compFeedBox.layer.borderColor = UIColor.lightGray.cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        

        
    }
    
    // to dismiss the keyboard by touching view
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        
        handleLogout()
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
    

    

    
    @IBOutlet var compFeedBox: UITextView!
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if compFeedBox.textColor == UIColor.lightGray {
            compFeedBox.text = nil
            compFeedBox.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if compFeedBox.text.isEmpty {
            compFeedBox.text = "Write something here..."
            compFeedBox.textColor = UIColor.lightGray
        }
    }

    
    
    @IBOutlet var textView: UITextView!
   
    
    
    @IBAction func selectTypeAction(_ sender: Any) {
        
        popUpType()
       
        
        
    }
    @IBAction func selectDepartment(_ sender: Any) {
        
        
        popUpDept()
        
        
    }
    
    
    func popUpType(){
        let alertController = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
        
        // Create the actions
        let complaintAction = UIAlertAction(title: "Complaint", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.complaintFeedType.text = "Complaint"
            print("complaint Pressed")
        }
        let feedbackAction = UIAlertAction(title: "Feedback", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.complaintFeedType.text = "Feedback"
            print("feedback Pressed")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        alertController.addAction(complaintAction)
        alertController.addAction(feedbackAction)
        
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    func popUpDept(){
        let alertController = UIAlertController(title: "Select an option", message: "", preferredStyle: .actionSheet)
        
        // Create the actions
        let electricityAction = UIAlertAction(title: "Electricity", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.departmentConcerned.text = "Electricity"
            print("Electricity Pressed")
        }
        let plumbingAction = UIAlertAction(title: "Plumbing", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.departmentConcerned.text = "Plumbing"
            print("Plumbing Pressed")
        }
        
        let sanitationAction = UIAlertAction(title: "Sanitation", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.departmentConcerned.text = "Sanitation"
            print("Sanitation Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        alertController.addAction(electricityAction)
        alertController.addAction(plumbingAction)
        alertController.addAction(sanitationAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    
    @IBAction func sendToMaintainance(_ sender: Any) {
    }
    
}

