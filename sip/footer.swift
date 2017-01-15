//
//  footer.swift
//  sip
//
//  Created by Mayank Gupta on 11/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit


class footer : UITableViewCell{

var deleteActionIs: ((_ sender: AnyObject) -> Void)?
    @IBAction func shareButton(_ sender: Any) {
    }

    
    @IBAction func deleteButton(_ sender: Any) {
        
        self.deleteActionIs?(sender as AnyObject)
    }
    
    
}
