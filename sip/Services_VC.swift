//
//  Services_VC.swift
//  sip
//
//  Created by Mayank Gupta on 22/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Services_VC : UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
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
    

    
    
    
}

