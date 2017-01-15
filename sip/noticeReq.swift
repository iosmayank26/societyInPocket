//
//  noticeReq.swift
//  sip
//
//  Created by Mayank Gupta on 14/01/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation
import UIKit

class noticeReq : UITableViewCell{

var buttonAction: ((_ sender: AnyObject) -> Void)?
    
    
    @IBOutlet var reqImageView: UIImageView!
    
    @IBOutlet var name: UILabel!
    
    
    @IBOutlet var dateTime: UILabel!
    
    
    @IBOutlet var message: UILabel!
    


    @IBAction func confirm(_ sender: Any) {
        self.buttonAction?(sender as AnyObject)
        
        
    }
    @IBAction func deletePost(_ sender: Any) {
    }
   
}
