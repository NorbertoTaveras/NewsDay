//
//  SignUpViewController.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import UIKit

class SignUpViewController: AuthUtils {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    typealias FormValues = (email: String, password: String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func formValues() -> FormValues {
        return (email.text ?? "", password.text ?? "")
    }
    
    @IBAction func signUp(_ sender: Any) {
        let values = formValues()
        signUpWith(values: values)
    }
    
    @IBAction func skip(_ sender: Any) {
        continueToMainUI()
    }
}
