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
    
    @IBOutlet weak var sharingKey: UITextField!
    
    @IBAction func receive(_ sender: Any) {
        guard let text = sharingKey.text else { return }
        FIRDatabase.database().reference().child("package").queryOrdered(byChild: "packageID").queryEqual(toValue: text).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let newCells = snapshot.value as? [String: Any] else { return }
            for newCell in newCells {
                let uid = FIRAuth.auth()?.currentUser?.uid
                guard let value = newCell.value as? [String: AnyObject] else { continue }
                
                guard let cellList = value["cellList"] as? Array<Dictionary<String, Any>> else { continue }
                
                for cell in cellList {
                    FIRDatabase.database().reference().child("pocketList").child(uid!).updateChildValues(cell)
                    //todo fix new user condition
                }
            }
        })
        
                self.tabBarController?.selectedIndex = 0
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Check receive items", message: "\("someone") wants to send \("") to you", preferredStyle: .alert)
        alertController.addTextField { (textFeild) in
            textFeild.placeholder = "Enter sharing key from your friend here"
        }
        let accept = UIAlertAction(title: "Accept", style: .default) { (action) in
            
        }
        let decline = UIAlertAction(title: "Decline", style: .destructive, handler: nil)
        //todo delete package in 5mins?
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

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
