//
//  ViewController.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/14.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.signUpButton.layer.cornerRadius = 10
        self.loginButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpAction(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else { return }
        
        LoginManager.shared.create(withEmail: email, password: password, firstName: firstName, lastName: lastName, success: { (user) in
            self.nextVC()
        }) { (error) in
            if error.localizedDescription == "The email address is already in use by another account." {
                let alertController = UIAlertController(title: "Email already registered.", message: "Please use other email or login directly.", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                let alertController = UIAlertController(title: "Unknown error.", message: "Please try again.", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)

            }
            print(error)
        }
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        LoginManager.shared.login(withEmail: email, password: password, success: { (email, uid) in
            self.nextVC()
        }) { (error) in
            if error.localizedDescription == "The password is invalid or the user does not have a password." {
                let alertController = UIAlertController(title: "Incorrect Password", message: "Please enter again.", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            print(error)
        }
    }
    
    func nextVC() {
        let articleVC = self.storyboard?.instantiateViewController(withIdentifier: "ArticleTableViewController") as! ArticleTableViewController
        self.navigationController?.pushViewController(articleVC, animated: true)
    }
}

