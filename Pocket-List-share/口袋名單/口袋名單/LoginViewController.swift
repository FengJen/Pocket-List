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
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var signinButton: UIButton!
    @IBAction func login(_ sender: Any) {
        if email.text == "" || password.text == "" {
            let alertController = UIAlertController(title: "error", message: "Please enter password and email", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if let email = email.text, let password = password.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (_, error) in
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
        iconView.image = #imageLiteral(resourceName: "loginImage")
        iconView.layer.shadowColor = UIColor.gray.cgColor
        iconView.layer.shadowOpacity = 1
        iconView.layer.shadowOffset = CGSize(width: 0, height: 0)
        iconView.layer.shadowRadius = 4
        iconView.layer.cornerRadius = 5
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
        //let buttonImage = #imageLiteral(resourceName: "button-with-cross-stitch-icon")
        //signinButton.setImage(buttonImage, for: .normal)
//        buttonImage
        
        signinButton.layer.masksToBounds = false
        signinButton.setTitle("登 入", for: .normal)
        signinButton.layer.shadowColor = UIColor.gray.cgColor
        signinButton.layer.shadowOpacity = 1
        signinButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        signinButton.layer.shadowRadius = 4
        signinButton.layer.cornerRadius = 5
        //signinButton.backgroundColor = UIColor(red: 117/255, green: 203/255, blue: 223/255, alpha: 1)
        signinButton.layer.cornerRadius = 20
     
        
        }

}
