//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/15/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.backgroundColor = UIColor(red: 1.0, green: 0.2, blue: 0.0, alpha: 0.5)
        usernameTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.80, alpha: 0.5)
        passwordTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.80, alpha: 0.5)
        facebookSignInButton.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        if !usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            loginToUdacity()
        } else {
            let ac = UIAlertController(title: "", message: "Email or Password empty", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func loginToUdacity() {
        UdacityClient.sharedInstance().getSessionID(loginID: self.usernameTextField.text!, userPassword: self.passwordTextField.text!) { (success, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    print("success")
                    self.performSegueWithIdentifier("OnTheMap", sender: nil)
                } else {
                    if let error = error {
                        print(error)
                    }
                    let ac = UIAlertController(title: "Login failed", message: error, preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                    
                }
            })
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Text Field Delegates
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }



}

