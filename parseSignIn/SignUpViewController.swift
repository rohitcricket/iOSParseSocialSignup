//
//  SignUpViewController.swift
//  parseSignIn
//
//  Created by ROHIT GUPTA on 11/30/15.
//  Copyright © 2015 ROHIT GUPTA. All rights reserved.
//

import UIKit
import Parse
import Bolts

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userRepeatPassword: UITextField!
    @IBOutlet weak var userFirstName: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectProfilePhotoBtn(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        let userName = userEmail.text
        let userPass = userPassword.text
        let userPassRepeat = userRepeatPassword.text
        let firstName = userFirstName.text
        let lastName = userLastName.text
        
        if (userName!.isEmpty || userPass!.isEmpty || userPassRepeat!.isEmpty || firstName!.isEmpty || lastName!.isEmpty) {
            
            var myAlert = UIAlertController(title: "Alert", message: "All fields are required", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
        
        if (userPass != userPassRepeat){
            
            var myAlert = UIAlertController(title: "Alert", message: "Passwords do not match. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
        }
        
        // create object to send to Parse
        
        let myUser:PFUser = PFUser()
        myUser.username = userName
        myUser.password = userPass
        myUser.email = userName
        
        myUser.setObject(userFirstName, forKey: "first_name")
        myUser.setObject(userLastName, forKey: "last_name")
        
        let profileImageData = UIImageJPEGRepresentation(profileImg.image!, 1)
       
        if (profileImageData != nil) {
            
            let profileImageFile = PFFile(data: profileImageData!)
            myUser.setObject(profileImageFile!, forKey: "profile_picture")
            
        }
        
        myUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            var userMessage = "Registration is successful. Thank you!"
            
            if (!success) {
               // userMessage = "Could not register at this time. Please try later"
                userMessage = error!.localizedDescription
            }
            
            var myAlert = UIAlertController(title: "Alert", message: "Passwords do not match. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ action in
                
                if(success) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            return
            
        }
        
        
    }
    
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        profileImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    


}
