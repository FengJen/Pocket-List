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
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func creatUser(_ sender: Any) {
        if email.text == "" || password.text == "" {
            let alertController = UIAlertController(title: "error", message: "Please enter password and email", preferredStyle: .alert)
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
                        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
