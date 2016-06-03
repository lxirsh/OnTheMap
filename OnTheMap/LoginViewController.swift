//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/15/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let facebookLoginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.backgroundColor = UIColor(red: 1.0, green: 0.2, blue: 0.0, alpha: 0.5)
        usernameTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.80, alpha: 0.5)
        passwordTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.80, alpha: 0.5)
        
        view.addSubview(facebookLoginButton)
        
        // Position the Facebook login button bottom center
        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: facebookLoginButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: facebookLoginButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -75).active = true
        
        facebookLoginButton.delegate = self
        
        if let token = FBSDKAccessToken.currentAccessToken() {
            UdacityClient.sharedInstance().facebookAccessToken = token

            print("Facebook access token: \(UdacityClient.sharedInstance().facebookAccessToken)")
            loginViaFacebook()
        }

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
    
    func loginViaFacebook() {
        UdacityClient.sharedInstance().getSessionIDviaFacebookLogin() { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                if success {
                    print("success")
                    self.performSegueWithIdentifier("OnTheMap", sender: nil)
                } else {
                    if let errorString = errorString {
                        print(errorString)
                    }
                    let ac = UIAlertController(title: "Login failed", message: errorString, preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                    
                }
            })
        }

    }
    
    // MARK: Delegate for Facebook login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("completed fb login")
        if let token = FBSDKAccessToken.currentAccessToken() {
//            print("token: \(token.tokenString)")
            UdacityClient.sharedInstance().facebookAccessToken = token
            print("Facebook access token: \(UdacityClient.sharedInstance().facebookAccessToken)")
            loginViaFacebook()
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Text Field Delegates
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Obscure the password
        if textField == passwordTextField {
           textField.secureTextEntry = true
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }



}

