//
//  AuthUtils.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AuthUtils: UIViewController {
    
    typealias FormValues = (
        email: String,
        password: String
    )
    
    func validate(_ values: FormValues) -> Bool {
        var errorMessage: String? = nil
        
        if values.email.isEmpty {
            errorMessage = "The email field cannot be blank"
        } else if values.password.isEmpty {
            errorMessage = "The password field cannot be blank"
        } else if !AuthUtils.isValid(email: values.email) {
            errorMessage = "The email address is not valid"
        } else if values.password.count < 8 {
            errorMessage = "The password must be at least 8 characters"
        }
        
        if let validErrorMessage = errorMessage {
            UIUtils.modalDialog(
                parent: self,
                title: "Error",
                message: validErrorMessage)
            return false
        }
        
        return true
    }
    
    func signInWith(values: FormValues) {
        if validate(values) {
            
            Auth.auth().signIn(
                withEmail: values.email,
                password: values.password) { (authResult, error) in
                    guard let user = authResult?.user, error == nil else {
                        UIUtils.modalDialog(
                            parent: self,
                            title: "Error",
                            message: error!.localizedDescription)
                        return
                    }
                    
                    print("User signed in: " +
                        "\(Auth.auth().currentUser?.email ?? "<no email in current user>")" +
                        " (\(user.email ?? "<no email>")")
                    
                    // Success
                    self.continueToMainUI()
                    
            }
        }
    }
    
    func signUpWith(values: FormValues) {
        if validate(values) {
            Auth.auth().createUser(
                withEmail: values.email,
                password: values.password) { (authResult, error) in
                    
                    guard let user = authResult?.user, error == nil else {
                        UIUtils.modalDialog(
                            parent: self,
                            title: "Error",
                            message: error!.localizedDescription)
                        return
                    }
                    
                    print("User signed up: " +
                        "\(user.displayName ?? "<no display name>")" +
                        " (\(user.email ?? "<no email>")")
                    
                    // Success
                    
                    self.continueToMainUI()
            }
        }
    }
    
    func resetPassword(withEmail: String,
                       completionHandler: @escaping (Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: withEmail) { (error) in
            DispatchQueue.main.async {
                if error == nil {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
    func promptResetPassword(withEmail: String,
                             completionHandler: @escaping (Bool) -> Void) {
        
        UIUtils.modalConfirm(
            parent: self,
            title: "Password Recovery Email",
            message: "Send a password recovery email to \(withEmail)?") { (ok) in
                DispatchQueue.main.async {
                    if ok {
                        self.resetPassword(
                            withEmail: withEmail,
                            completionHandler: completionHandler)
                    }
                }
        }
    }
    
    func continueToMainUI() {
        performSegue(withIdentifier: "newsFeedController", sender: self)
    }
    
    public static func isValid(email: String) -> Bool {
        let rfc5322 = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        do {
            let regex = try NSRegularExpression(pattern: rfc5322, options: .caseInsensitive)
            
            return regex.firstMatch(
                in: email,
                options: .init(),
                range: NSRange(location: 0, length: email.count)) != nil
        } catch {
            return false
        }
    }
}
