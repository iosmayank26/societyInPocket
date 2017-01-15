//
//  ExpandedPost_VC.swift
//  sip
//
//  Created by Mayank Gupta on 01/12/16.
//  Copyright © 2016 Mayank. All rights reserved.
//

import Foundation
import UIKit


class ExpandedPost_VC : UIViewController {
    
       var nameIs = (String)()
    var dateTimeIs = (String)()
    var noticeIs = (String)()
    var profileImageIs = (UIImage)()
    
    @IBOutlet var imageView: UIImageView!
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
   
    
    
    @IBOutlet var detail: UITextView!
    @IBOutlet var name: UILabel!
    
    @IBOutlet var dateTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPosts()
        
        
    }
    
    func loadPosts(){
        
        self.name.text = nameIs
        self.dateTime.text = dateTimeIs
        self.detail.text = noticeIs
        self.imageView.image = profileImageIs
        
    }
}
