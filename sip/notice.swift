//
//  notice.swift
//  sip
//
//  Created by Mayank Gupta on 01/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit


class notice : UITableViewCell{
    var deleteActionIs: ((_ sender: AnyObject) -> Void)?
    
    @IBOutlet var nameOfPostCreater: UILabel!
    
    @IBOutlet var detailOfPost: UILabel!
    
    @IBOutlet var imageViewOfPost: UIImageView!
    
    @IBOutlet var deleteOut: UIButton!
    
    @IBOutlet var dateAndTime: UILabel!

    
    @IBAction func deleteAction(_ sender: Any) {
        
        
        self.deleteActionIs?(sender as AnyObject)
    }
    
}
