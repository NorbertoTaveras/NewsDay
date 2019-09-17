//
//  SignInViewController.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: AuthUtils {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        email.text = ""
        password.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func formValues() -> FormValues {
        return (email.text ?? "", password.text ?? "")
    }
    
    @IBAction func signIn(_ sender: Any) {
        let values = formValues()
        signInWith(values: values)
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        guard let email = email.text else {return}
        
        if email.isEmpty || !AuthUtils.isValid(email: email) {
            UIUtils.modalDialog(
                parent: self,
                title: "Invalid email",
                message: "Enter an email account to" +
                "recover in the email field")
            return
        }
        
        UIUtils.modalConfirm(
            parent: self,
            title: "Password Recovery",
            message: "Send password recovery email to \(email)?",
            completionHandler: { (yes) in
                if !yes {return}
                self.resetPassword(withEmail: email) { success in
                    let message = success ?
                        "Password recovery mail was sent. Check your" +
                            " email and follow the instructions there" +
                        " to recover your password" :
                        "There was a problem sending the password" +
                        " recovery email. Check the email address" +
                    " and try again"
                    
                    UIUtils.modalDialog(
                        parent: self,
                        title: "Password Recovery",
                        message: message)
                }
        })
    }
    
    @IBAction func skip(_ sender: Any) {
        continueToMainUI()
    }
    
    @IBAction func backToSignIn(segue: UIStoryboardSegue) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("Error signing out: %@", error)
        }
    }
    
}
