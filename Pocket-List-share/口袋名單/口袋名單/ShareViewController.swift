//
//  ShareViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/21.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import Firebase

protocol DidReceivePackage: class {
    func didReceive(shareVC: ShareViewController, uploadSuccess: Bool)
}

class ShareViewController: UIViewController {
    
    @IBOutlet weak var receiveButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    weak var delegate: DidReceivePackage?
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    var senderEmail = ""
    @IBAction func receive(_ sender: Any) {
        FIRDatabase.database().reference().child("userEmail").child(uid!).observeSingleEvent(of: .value, with: { (emailSnapshot) in
            guard let email = emailSnapshot.value as? [String: Any] else { return }
            guard let myEmail = email["email"] as? String else { return }
            print(myEmail)
            //guard let text = sharingKey.text else { return }
            FIRDatabase.database().reference().child("package").queryOrdered(byChild: "receiverEmail").queryEqual(toValue: myEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                    
                    guard let item = child as? FIRDataSnapshot else { return }
                    
                    guard let value = item.value as? [String: Any] else { return }
                    guard let email = value["senderEmail"] as? String else { return }
                    self.senderEmail = email
                }
                print(self.senderEmail)
                let alertController = UIAlertController(title: "確認傳送來源", message: "\(self.senderEmail)想要和你分享他的口袋名單", preferredStyle: .alert)
                guard let newCells = snapshot.value as? [String: Any] else { return }
                let accept = UIAlertAction(title: "同意", style: .default) { (action) in
                    for newCell in newCells {
                        let uid = FIRAuth.auth()?.currentUser?.uid
                        guard let value = newCell.value as? [String: AnyObject] else { continue }
                        
                        guard let cellList = value["cellList"] as? Array<Dictionary<String, Any>> else { continue }
                        
                        FIRDatabase.database().reference().child("pocketList").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.exists() {
                                
                                for cell in cellList {
                                    FIRDatabase.database().reference().child("pocketList").child(uid!).updateChildValues(cell)
                                    
                                }
                                
                            } else {
                                
                                for cell in cellList {
                                    FIRDatabase.database().reference().child("pocketList").child(uid!).updateChildValues(cell)
                                }
                            }
                            self.delegate?.didReceive(shareVC: self, uploadSuccess: true)
                        })
                    }
                }
                let decline = UIAlertAction(title: "拒絕", style: .destructive, handler: nil)
                //todo delete package in 5mins?
                alertController.addAction(accept)
                alertController.addAction(decline)
                self.present(alertController, animated: true, completion: nil)
   
            })
        })
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
        setUp()
        guard let controller = tabBarController?.viewControllers?[0] as? ItemsNavigationController else { return }
        
        guard let parentViewController = controller.viewControllers[0] as? ParentViewController else { return }
        
        self.delegate = parentViewController

    }
    
    func setUp() {
        logoutButton.layer.cornerRadius = 20
        receiveButton.layer.cornerRadius = 20
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// let vc = StoryBoard
// vc.delegate = self
// self.show(vc, animation: true)
