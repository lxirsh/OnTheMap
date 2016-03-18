//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Lance Hirsch on 3/15/16.
//  Copyright © 2016 Lance Hirsch. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginButton.backgroundColor = UIColor(red: 1.0, green: 0.2, blue: 0.0, alpha: 0.5)
        usernameTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.80, alpha: 0.5)
        passwordTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.80, alpha: 0.5)
        facebookSignInButton.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func loginButtonTouch(sender: UIButton) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            print("empty")
        } else {
            UdacityClient.sharedInstance().getSessionID(userID: self.usernameTextField.text!, userPassword: self.passwordTextField.text!)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

