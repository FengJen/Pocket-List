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

class SignUPViewController: UIViewController {
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
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
                        let userReference = ref.child("user").child(uid)
                        let values = ["email": email]
                        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err ?? "")
                                return
                            }
                        })
                        print("user created")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let itemTableViewController = storyBoard.instantiateViewController(withIdentifier: "ItemsTableViewController") 
                        UIApplication.shared.keyWindow?.rootViewController = itemTableViewController
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
