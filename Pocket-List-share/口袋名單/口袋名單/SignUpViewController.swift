//
//  ViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/20.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func creatUser(_ sender: Any) {
        if email.text == "" || password.text == "" {
            let alertController = UIAlertController(title: "錯誤", message: "請輸入帳號密碼", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else if confirmPassword.text != password.text {
            let alertController = UIAlertController(title: "請再次確認密碼", message: "兩次輸入密碼不同", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            if let email = email.text, let password = password.text {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        guard let uid = user?.uid else { return }
                        let ref = FIRDatabase.database().reference()
                        let userReference = ref.child("userEmail").child(uid)
                        let values = ["email": email]
                        userReference.updateChildValues(values, withCompletionBlock: { (err, _) in
                            if err != nil {
                                print(err ?? "")
                                return
                            }
                        })
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
        registerButton.layer.cornerRadius = 22
        registerButton.layer.masksToBounds = false
        
        registerButton.layer.shadowColor = UIColor.gray.cgColor
        registerButton.layer.shadowOpacity = 1
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        registerButton.layer.shadowRadius = 4
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    private func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView == password {
            
            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
        }
        
        return true
        
    }
    
    private func textViewDidEndEditing(_ textView: UITextView) {
        
        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
