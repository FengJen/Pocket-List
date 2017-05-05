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
import SCLAlertView

protocol DidReceivePackage: class {
    func didReceive(shareVC: ShareViewController, uploadSuccess: Bool)
}

class ShareViewController: UIViewController {
    
    let alertController = ReceiveAlertViewController()
    @IBOutlet weak var receiveButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    let gradientLayer = CAGradientLayer()
    let logoutButtonLayer = CAGradientLayer()
    
    let skyBlue = UIColor(red: 117/255, green: 203/255, blue: 223/255, alpha: 1)
    
    weak var delegate: DidReceivePackage?
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    var senderEmail = ""
    @IBAction func receive(_ sender: Any) {
        
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
                
                guard let newCells = snapshot.value as? [String: Any] else { return }
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alert = SCLAlertView(appearance: appearance)
                
                alert.addButton("同意") {
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
                            self.deletePackage(packageKey: packageKey)
                            self.tabBarController?.selectedIndex = 0
                            
                        })
                        
                    }
                }
                
                    alert.addButton("拒絕", backgroundColor: UIColor(red: 58/255, green: 101/255, blue: 185/255, alpha: 1), textColor: UIColor(red: 215/255, green: 97/255, blue: 86/255, alpha: 1), showDurationStatus: false, action: {
                        self.deletePackage(packageKey: packageKey)

                    })
                
                alert.showInfo("確認傳送來源", subTitle: "\(self.senderEmail)想要和你分享他的口袋名單")
                
                } else {
                
                    self.alertController.showNoPackageAlert()
                
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
        
        gradientLayer.frame = self.receiveButton.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor(red: 117/255, green: 203/255, blue: 223/255, alpha: 1).cgColor, UIColor(red: 90/255, green: 120/255, blue: 191/255, alpha: 1).cgColor]
        
        self.receiveButton.layer.addSublayer(gradientLayer)
        
       
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.cornerRadius = 16
        logoutButtonLayer.cornerRadius = 16
    }
    
    func setUp() {
       
        logoutButtonLayer.frame = self.logoutButton.bounds
        logoutButtonLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        logoutButtonLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        logoutButtonLayer.colors = [UIColor(red: 117/255, green: 203/255, blue: 223/255, alpha: 1).cgColor, UIColor(red: 90/255, green: 120/255, blue: 191/255, alpha: 1).cgColor]
        
        self.logoutButton.layer.addSublayer(logoutButtonLayer)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deletePackage(packageKey: String) {
        FIRDatabase.database().reference().child("package").child(packageKey).removeValue()
    }
}
