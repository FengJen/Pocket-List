//
//  ReceiveAlertViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/5/4.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase



class ReceiveAlertViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func showReceiveAlert(senderEmail: String, newCells: [String: Any]) {
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
                    
                })
                
            }
        }
        
        alert.addButton("拒絕", backgroundColor: UIColor.blue, textColor: UIColor.red, showDurationStatus: false) {
            
        }
        
        alert.showInfo("確認傳送來源", subTitle: "\(senderEmail)想要和你分享他的口袋名單")

        
    }
    
//    FIRDatabase.database().reference().child("userEmail").child(uid!).observeSingleEvent(of: .value, with: { (emailSnapshot) in
//    
//    
//    guard let email = emailSnapshot.value as? [String: Any] else { return }
//    guard let myEmail = email["email"] as? String else { return }
//    FIRDatabase.database().reference().child("package").queryOrdered(byChild: "receiverEmail").queryEqual(toValue: myEmail).observeSingleEvent(of: .value, with: { (snapshot) in
//    if snapshot.exists() {
//    var packageKey = ""
//    for child in snapshot.children {
//    
//    guard let item = child as? FIRDataSnapshot else { return }
//    packageKey = item.key
//    guard let value = item.value as? [String: Any] else { return }
//    guard let email = value["senderEmail"] as? String else { return }
//    self.senderEmail = email
//    }
//    
//    guard let newCells = snapshot.value as? [String: Any] else { return }
//    
//    let alert = SCLAlertView()
//    alert.showInfo("確認傳送來源", subTitle: "\(self.senderEmail)想要和你分享他的口袋名單")
//    alert.addButton("同意") {
//    for newCell in newCells {
//    let uid = FIRAuth.auth()?.currentUser?.uid
//    guard let value = newCell.value as? [String: AnyObject] else { continue }
//    
//    guard let cellList = value["cellList"] as? Array<Dictionary<String, Any>> else { continue }
//    
//    FIRDatabase.database().reference().child("pocketList").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
//    if snapshot.exists() {
//    
//    for cell in cellList {
//    FIRDatabase.database().reference().child("pocketList").child(uid!).updateChildValues(cell)
//    
//    }
//    
//    } else {
//    
//    for cell in cellList {
//    FIRDatabase.database().reference().child("pocketList").child(uid!).updateChildValues(cell)
//    }
//    }
//    self.delegate?.didReceive(shareVC: self, uploadSuccess: true)
//    // todo deletepackage after reload & move to parent
//    self.deletePackage(packageKey: packageKey)
//    self.tabBarController?.selectedIndex = 0
//    })
//    
//    }
//    }
//    
//    alert.addButton("拒絕", action: {
//    self.deletePackage(packageKey: packageKey)
//    })
//    
//    } else {
//    self.alertController.showErrorAlert()
//    }
//    })
//    })

    
    func showNoPackageAlert() {
        _ = SCLAlertView().showError("沒有傳給您的口袋名單", subTitle: "請在傳送方送出後再按接收按鈕，或確認傳送email正確")
    }
    
}
