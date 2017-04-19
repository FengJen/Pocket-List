//
//  ShareViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/21.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import Firebase

class ShareViewController: UIViewController {
    
    @IBOutlet weak var senderEmail: UITextField!
    
    @IBOutlet weak var sharingKey: UILabel!
    @IBAction func receive(_ sender: Any) {
            let uid = Constants.uid
        FIRDatabase.database().reference().child("userEmail").child(uid!).observeSingleEvent(of: .value, with: { (emailSnapshot) in
            guard let email = emailSnapshot.value as? [String: Any] else { return }
            guard let receiver = email["email"] as? String else { return }
            //if senderEmail.text =
        })
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Receive", message: "Please enter the email of sender", preferredStyle: .alert)
        alertController.addTextField { (textFeild) in
            textFeild.placeholder = "Enter sender email here"
        }
        let accept = UIAlertAction(title: "Accept", style: .default) { (action) in
            let senderEmail = alertController.textFields?[0].text
            
            //add accept & decline
        
        }
        let decline = UIAlertAction(title: "Decline", style: .destructive, handler: nil)
        alertController.addAction(accept)
        alertController.addAction(decline)
        self.present(alertController, animated: true, completion: nil)
    
    }
    @IBAction func logOut(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
                UIApplication.shared.keyWindow?.rootViewController = loginViewController
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    NotificationCenter.default.addObserver(self, selector: #selector(showSharingKey), name: NSNotification.Name(rawValue: "passKey"), object: nil)
        
    }
    func showSharingKey(_ notification: NSNotification) {
        sharingKey.text = notification.userInfo?["key"] as? String
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "passKey"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
