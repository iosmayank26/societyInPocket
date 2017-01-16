//
//  Notice_Req_VC.swift
//  sip
//
//  Created by Mayank Gupta on 13/01/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Notice_Req_VC : UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    var posts = [Post]()
    var loadingView = UIView()
    var container = UIView()
    let activityIndicator = UIActivityIndicatorView()

    
       @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchNotices()
        
        
        
    }
    func showLoading() {
        
        let win:UIWindow = UIApplication.shared.delegate!.window!!
        self.loadingView = UIView(frame: win.frame)
        self.loadingView.tag = 1
        self.loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        
        win.addSubview(self.loadingView)
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: win.frame.width/3, height: win.frame.width/3))
        container.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        container.layer.cornerRadius = 10.0
        container.layer.borderColor = UIColor.gray.cgColor
        container.layer.borderWidth = 0.5
        container.clipsToBounds = true
        container.center = self.loadingView.center
        
        
        //activityIndicator.frame = CGRectEdge(0, 0, win.frame.width/5, win.frame.width/5)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = self.loadingView.center
        
        
        self.loadingView.addSubview(container)
        self.loadingView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    func hideLoading(){
        UIView.animate(withDuration: 0.0, delay: 1.0, options: .curveEaseOut, animations: {
            self.container.alpha = 0.0
            self.loadingView.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }, completion: { finished in
            self.activityIndicator.removeFromSuperview()
            self.container.removeFromSuperview()
            self.loadingView.removeFromSuperview()
            let win:UIWindow = UIApplication.shared.delegate!.window!!
            let removeView  = win.viewWithTag(1)
            removeView?.removeFromSuperview()
        })
    }

    func fetchNotices() {
        showLoading()
        let uid = FIRAuth.auth()?.currentUser?.uid
        do {
            try FIRDatabase.database().reference().child("vvipAddresses").child("users").child(uid!).observeSingleEvent(of: .value,with: { (snapshot) in
                let dictionary = snapshot.value as? [String: AnyObject]
                let societyIs = dictionary?["societyName"] as? String
                print("the society is \(societyIs!)")
                
                
                if societyIs == "VVIP Addresses" {
                    FIRDatabase.database().reference().child("vvipAddresses").child("reqNotices").observe(.childAdded,with: { (snapshot) in
                        if  let dictionary = snapshot.value as? [String: AnyObject] {
                            
                            
                            
                            print("\(snapshot.children)")
                            
                            let post = Post()
                            
                            
                            post.setValuesForKeys(dictionary)
                            self.posts.append(post)
                            
                            print("posts are \(self.posts)")
                            
                            
                            
                            self.posts = self.posts.reversed()
                            DispatchQueue.main.async(execute: {
                                self.tableView.reloadData()
                                self.hideLoading()
                            })
                            
                        }
                        
                        
                        
                        
                    },withCancel: nil)
                    
                    
                    
                }
                    
                    
                    
                else{
                    
                    FIRDatabase.database().reference().child("gaurCascades").child("reqNotices").observe( .childAdded,with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            
                            
                            let post = Post()
                            
                            
                            post.setValuesForKeys(dictionary)
                            self.posts.append(post)
                            
                            print("posts are \(self.posts)")
                            
                            
                            
                            self.posts = self.posts.reversed()
                            
                            DispatchQueue.main.async(execute: {
                                self.tableView.reloadData()
                                self.hideLoading()
                            })
                            
                        }
                        
                    },withCancel: nil)
                    
                    
                    
                }
                
                
                
            },withCancel: nil)
            
        }
        catch let Error{
            print(Error)
            
        }
        
    }
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 155
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("noticeReq", owner: self, options: nil)?.first as! noticeReq
        //let cell1 = Bundle.main.loadNibNamed("noticeImageView", owner: self, options: nil)?.first as! noticeImageView
        let post = posts[(indexPath as NSIndexPath).section]
        cell.name.text = post.name
        cell.message.text = post.message
        cell.dateTime.text = "\(post.date!)  \(post.time!)"
        let uid = post.uid! as String
        let ref = FIRDatabase.database().reference(fromURL: "https://sipindia-cd004.firebaseio.com/vvipAddresses/users/\(uid)")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? [String: AnyObject]
            let imageURL = (dictionary?["profileImageUrl"] as? String)!
            let url = NSURL(string: imageURL)
            
            
            let data = NSData(contentsOf: url as! URL)
            
            cell.reqImageView.image = UIImage(data : data as! Data)
            
        },withCancel : nil)
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        
                cell.buttonAction = { (sender) in
              let post = self.posts[(indexPath as NSIndexPath).section]
                    let name = post.name
                    let message = post.message
                    let uid = post.uid
                    
                    var convertedDate = String()
                    let currentDateTime = Date()
                    let format = DateFormatter()
                    format.dateFormat = "HH:mm:ss"
                    convertedDate = format.string(from: currentDateTime)
                    let calendar = NSCalendar.current
                    let day = calendar.component(.day, from: currentDateTime)
                    let month = calendar.component(.month, from: currentDateTime)
                    let year = calendar.component(.year, from: currentDateTime)
                    let date = "\(day)/\(month)/\(year)"
                    
                    
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                    let defaultTimeZoneStr = formatter.string(from: currentDateTime)
                    formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
                    let utcTimeZoneStr = formatter.string(from: currentDateTime)

                    
                    
                    let ref = FIRDatabase.database().reference()
                    let noticeRef = ref.child("vvipAddresses").child("publishedNotices").childByAutoId()
                    let values = ["name": name ,"message": message,"date": date,"time": convertedDate,"uid": uid] as [String : Any]
                    noticeRef.updateChildValues(values,withCompletionBlock: {(err,ref)in
                        if err != nil{
                            print(err)
                            return
                        }
                        
                    })

        
        
                }
        
        
        return cell
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
}
