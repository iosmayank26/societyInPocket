//
//  ResetPassword_VC.swift
//  sip
//
//  Created by Mayank Gupta on 19/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Alamofire

class ResetPassword_VC : UIViewController{
    var email = String()
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
    }
    
    
    func generateRandomNumber()->String{
        let randomNum:UInt32 = arc4random_uniform(8000)+5678 // range is 5678 to 13678
        let someString:String = String(randomNum) //string works too
        return someString
    }
    
    
    let headers: HTTPHeaders = [
        "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
        "Accept": "application/json"
    ]
    

    
    @IBAction func sendAction(_ sender: Any) {
        
        
        
        let randomNumberForOTP = generateRandomNumber()
        //Saving the OTP
        let preferences = UserDefaults.standard
        
        let smsOTP = "sms_otp"
        
        preferences.set(randomNumberForOTP, forKey: smsOTP)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            //  Couldn't save (I've never seen this happen in real world testing)
        }
        else{
            print("OTP Saved !")
            let smsMessageText = "Welcome to Nofe your college Noticeboard , your OTP is \(randomNumberForOTP). For more detail visit our website nofe.space.in"
            
            guard let number = emailTextField.text else{
                    print("Please enter all details!")
                    return
            }
            //MSG91 Api
            //MSG91 Api
            let urlForSms = "https://control.msg91.com/api/sendhttp.php?authkey=136570AkpFkoC0587226fa&mobiles=\(number)&message=\(smsMessageText)&sender=VALEPK&route=4&country=91&response=json"
            print("URL without encoding - \(urlForSms)")
            let urlEncoded = urlForSms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            print("URL encoded \(urlEncoded)")
            Alamofire.request(urlEncoded, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON{
                response in
                switch response.result{
                case .success:
                    let json = response.result.value as! [String:String]
                    guard
                        let smsResponseStatus = json["type"] as? String? ,
                        let smsResponseMessage = json["message"] as? String?
                        else{
                            //Failure
                            print("Something bad happened - don't know much about it")
                            return
                    }
                    if((smsResponseStatus != nil) && (smsResponseMessage != nil)){
                        print("Status - \(smsResponseStatus!) , Message -\(smsResponseMessage!)")
                        //AlertView
                    }
                    else{
                        //Failure
                        print("Something bad happened - don't know much about it ")
                    }
                    break
                case .failure: //Failure
                    print("Error in network");
                    break
                default:print("Noting exciting");
                    break
                }
                //  let json = response.result.value as! [String:String]
                //  print("SMS RESPONCE - \(json)")
                
                // print("Request responce - \(response.response?.statusCode)")
            }
            // print("\(name) , \(email) ,\(phone) ,\(password)")
            //  print("\()")
        }
        
        

        
        
        
        
//        email = emailTextField.text!
//        print("pressed")
//        
//        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
//            
//            
//          
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            self.performSegue(withIdentifier: "loginVC", sender: nil)
// 
//            
//        }
//
//        
        
        
        
    }
    
}
