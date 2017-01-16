//
//  Ad_Home_VC.swift
//  sip
//
//  Created by Mayank Gupta on 12/01/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Ad_Home_VC : UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate {
    
    
    var userName = String()
    var imageUrl = String()
    var loadingView = UIView()
    var container = UIView()
    let activityIndicator = UIActivityIndicatorView()
    var posts = [Post]()


    
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var postTextView: UITextView!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var postBoxView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        checkIfUserIsLoggedIn()

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        postBoxView.addGestureRecognizer(tap)
        
        
//        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(longPressGesture:)))
//        longPressGesture.minimumPressDuration = 1.0 // 1 second press
//        longPressGesture.delegate = self
//        self.tableView.addGestureRecognizer(longPressGesture)
        
//        
        tableView.delegate = self
        tableView.dataSource = self
        postTextView.delegate = self
        postTextView.text = ""
        postTextView.textColor = UIColor.lightGray

        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        }else {
            
            loadUserInfo()
            fetchNotices()
        }
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
        
        
    }
    func switchTo(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "ChooseSociety") as! UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = newVC
        
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
    
    func loadUserInfo(){
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        print( "the uid is \(uid)")
        
        FIRDatabase.database().reference().child("vvipAddresses").child("users").child(uid!).observeSingleEvent(of: .value,with: { (snapshot) in
            
            //                print (snapshot.value as! [String:AnyObject]!)
            
            let dictionary = snapshot.value as? [String: AnyObject]
            
            let society = dictionary?["societyName"] as? String
            
            print ( "here \(society)")
            
            if society == "VVIP Addresses" {
                
                
                
                
                self.userName = (dictionary?["name"] as? String)!
                
                self.imageUrl = (dictionary?["profileImageUrl"] as? String)!
                let url = NSURL(string: self.imageUrl)
                
                
                let data = NSData(contentsOf: url as! URL)
                
                self.imageView.image = UIImage(data : data as! Data)
                
                
                
            }
            else{
                let uid = FIRAuth.auth()?.currentUser?.uid
                
                FIRDatabase.database().reference().child("gaurCascades").child("users").child(uid!).observeSingleEvent(of: .value,with: { (snapshot) in
                    
                    let dictionary = snapshot.value as? [String: AnyObject]
//                    self.navBarItem.topItem?.title  = "Notice Board"
                    
                    self.userName = (dictionary?["name"] as? String)!
                    
                    self.imageUrl = (dictionary?["profileImageUrl"] as? String)!
                    let url = NSURL(string: self.imageUrl)
                    
                    
                    let data = NSData(contentsOf: url as! URL)
                    
                    self.imageView.image = UIImage(data : data as! Data)
                    
                    
                    
                    
                },withCancel: nil)
                
                
            }
            
            
            
            
            
            
        },withCancel: nil)
        
        
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
                    FIRDatabase.database().reference().child("vvipAddresses").child("publishedNotices").observe(.childAdded,with: { (snapshot) in
                        if  let dictionary = snapshot.value as? [String: AnyObject] {
                            
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
                    
                    FIRDatabase.database().reference().child("gaurCascades").child("publishedNotices").observe( .childAdded,with: { (snapshot) in
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
        let cell = Bundle.main.loadNibNamed("adminNotice", owner: self, options: nil)?.first as! adminNotice
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
            
            cell.noticeImageView.image = UIImage(data : data as! Data)
            
        },withCancel : nil)
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        print("xtz")
        
        
        //        cell.deleteActionIs = { (sender) in
        //
        //
        //
        //
        //            let alertController = UIAlertController(title: "Warning", message: "Do you want to delete the post?", preferredStyle: .alert)
        //
        //            // Create the actions
        //
        //            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
        //                UIAlertAction in
        //                NSLog("OK Pressed")
        //                self.index = indexPath as NSIndexPath!
        //                print("yeh le \(self.index.section)")
        //                print("yeh le \(self.index.row)")
        //                self.images.remove(at: self.index.section)
        //
        //                self.names.remove(at: self.index.section)
        //                self.messages.remove(at: self.index.section)
        //                               self.tableView.reloadData()
        //            }
        //            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
        //                UIAlertAction in
        //                NSLog("Cancel Pressed")
        //            }
        //
        //            // Add the actions
        //            alertController.addAction(okAction)
        //            alertController.addAction(cancelAction)
        //
        //            // Present the controller
        //            self.present(alertController, animated: true, completion: nil)
        //
        //        }
        
        
        return cell
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expandPost" {
            let indexPath : IndexPath = self.tableView.indexPathForSelectedRow!
            let post = posts[(indexPath as NSIndexPath).section]
            
            let destination = segue.destination as! ExpandedPost_VC
            
            let uid = post.uid! as String
            let ref = FIRDatabase.database().reference(fromURL: "https://sipindia-cd004.firebaseio.com/vvipAddresses/users/\(uid)")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let dictionary = snapshot.value as? [String: AnyObject]
                let imageURL = (dictionary?["profileImageUrl"] as? String)!

           // let imageURL = post.imageUrl! as String
            let url = NSURL(string: imageURL)
            
            
            let data = NSData(contentsOf: url as! URL)
            destination.profileImageIs = UIImage(data : data as! Data)!
            destination.nameIs = post.name!
            destination.dateTimeIs = "\(post.date!)  \(post.time!)"
            destination.noticeIs = post.message!
            
                
            })
        }
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("asdasasd")
//        print(indexPath)
//        self.index = indexPath as NSIndexPath!
//        performSegue(withIdentifier: "expandPost", sender: nil)
//    }
//    
    

    
    
    
    
    
    @IBAction func postAction(_ sender: Any) {
        
       
            
            if postTextView.text == "" {
                
                print("no text available")
                return
                
            }
            
            showLoading()
            dismissKeyboard()
            
            
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
            
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            //        var societyIs = String()
            let userRef = FIRDatabase.database().reference().child("vvipAddresses").child("users").child(uid!).observeSingleEvent(of: .value,with: { (snapshot) in
                let dictionary = snapshot.value as? [String: AnyObject]
                
                let societyIs = dictionary?["societyName"] as? String
                print("the society is \(societyIs)")
                //    var timestamp = [String : AnyObject]()
                //        timestamp = [".sv": "timestamp" as AnyObject]
                //
                if societyIs == "VVIP Addresses" {
                    let ref = FIRDatabase.database().reference(fromURL: "https://sipindia-cd004.firebaseio.com/")
                    let noticeRef = ref.child("vvipAddresses").child("notices").childByAutoId()
                    let values = ["name": self.userName ,"message": self.postTextView.text,"date": date,"time": convertedDate,"uid": uid,"imageUrl": self.imageUrl] as [String : Any]
                    noticeRef.updateChildValues(values,withCompletionBlock: {(err,ref)in
                        if err != nil{
                            print(err)
                            return
                        }
                        
                    })
                    
                }
                    
                    
                    
                else {
                    
                    let ref = FIRDatabase.database().reference(fromURL: "https://sipindia-cd004.firebaseio.com/")
                    let noticeRef = ref.child("gaurCascades").child("notices").childByAutoId()
                    let values = ["name": self.userName ,"message": self.postTextView.text,"date": date,"time": convertedDate,"uid": uid,"imageUrl": self.imageUrl] as [String : Any]
                    noticeRef.updateChildValues(values,withCompletionBlock: {(err,ref)in
                        if err != nil{
                            print(err)
                            return
                        }
                        
                    })
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.tableView.reloadData()
                        self.hideLoading()
                    })
                    
                    
                }
                
                
                
            },withCancel: nil)
            
            
            
            
            DispatchQueue.main.async(execute: {
                
                self.tableView.reloadData()
                self.hideLoading()
            })
            
            
       
        

        
    }

    
    
}
