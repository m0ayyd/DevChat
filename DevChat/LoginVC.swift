//
//  LoginVC.swift
//  DevChat
//
//  Created by the Luckiest on 7/4/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: RoundTextField!
    @IBOutlet weak var passwordField: RoundTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logginTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text, (email.characters.count > 0 && password.characters.count > 0) {
            
            // Call login service
            AuthService.instance.login(email: email, password: password, onComplete: { (errMsg, data) in
                guard errMsg == nil else {
                    let alert = UIAlertController(title: "Error Authenticating", message: errMsg!, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
            
        } else {
            let alert = UIAlertController(title: "Email and Password Required", message: "You must both a email and a password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
