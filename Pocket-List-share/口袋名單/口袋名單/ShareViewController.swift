//
//  ShareViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/21.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

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
        let parentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController")
        FIRDatabase.database().reference().child("userEmail").child(uid!).observeSingleEvent(of: .value, with: { (emailSnapshot) in
            
            
            guard let email = emailSnapshot.value as? [String: Any] else { return }
            guard let myEmail = email["email"] as? String else { return }
            FIRDatabase.database().reference().child("package").queryOrdered(byChild: "receiverEmail").queryEqual(toValue: myEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                var packageKey = ""
                for child in snapshot.children {
                    
                    guard let item = child as? FIRDataSnapshot else { return }
                    packageKey = item.key
                    guard let value = item.value as? [String: Any] else { return }
                    guard let email = value["senderEmail"] as? String else { return }
                    self.senderEmail = email
                }
                
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
                            // todo deletepackage after reload & move to parent
                            self.deletePackage(packageKey: packageKey)
                            self.tabBarController?.selectedIndex = 0
                        })
                        
                    }
                    
                }
                let decline = UIAlertAction(title: "拒絕", style: .destructive, handler: { (_) in
                    self.deletePackage(packageKey: packageKey)
                })
                
                
                alertController.addAction(accept)
                alertController.addAction(decline)
                self.present(alertController, animated: true, completion: nil)
                } else {
                    let altercontroller = UIAlertController(title: "錯誤", message: "請在傳送方送出後再按接收按鈕，或確認傳送email正確", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                    altercontroller.addAction(okAction)
                    self.present(altercontroller, animated: true, completion: nil)
                }
            })
        })
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
        //
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//        button.setTitle("Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(button)

    }
    
//    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//        Crashlytics.sharedInstance().crash()
//    }
    
    func setUp() {
        logoutButton.layer.cornerRadius = 18
        receiveButton.layer.cornerRadius = 18
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deletePackage(packageKey: String) {
        FIRDatabase.database().reference().child("package").child(packageKey).removeValue()
    }
}
