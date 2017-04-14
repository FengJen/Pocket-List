//
//  LoginViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/21.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var pocketView: UIView!
    @IBOutlet weak var signinButton: UIButton!
    @IBAction func login(_ sender: Any) {
        if email.text == "" || password.text == "" {
            let alertController = UIAlertController(title: "error", message: "Please enter password and email", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if let email = email.text, let password = password.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion:
                    { (user, error) in
                        if error == nil {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
                            UIApplication.shared.keyWindow?.rootViewController = tabBarController
                        } else {
                            let alerController = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                            alerController.addAction(action)
                            self.present(alerController, animated: true, completion: nil)
                        }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setUp() {
        
        signinButton.setImage(#imageLiteral(resourceName: "button-with-cross-stitch-icon"), for: .normal)
        
        signinButton.setTitle("Login", for: .normal)
        signinButton.layer.shadowColor = UIColor.white.cgColor
        signinButton.layer.shadowOpacity = 1
        signinButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        signinButton.layer.shadowRadius = 5
        
        //signinButton.layer.cornerRadius = signinButton.frame.width/2
        
        
        
        
        //signinButton.layer.shadowColor = UIColor.white.cgColor
        //signinButton.layer.shadowRadius = 3
        //signinButton.layer.
        
        pocketView.layer.cornerRadius = 20
        pocketView.layer.shadowColor = UIColor.black.cgColor
        pocketView.layer.shadowOpacity = 1
        pocketView.layer.shadowOffset = CGSize.zero
        pocketView.layer.shadowRadius = 10
    }

}
