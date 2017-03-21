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

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
