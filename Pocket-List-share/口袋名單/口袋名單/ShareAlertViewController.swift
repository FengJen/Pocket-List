

import UIKit
import SCLAlertView
import Firebase

class ShareAlertViewController: UIViewController {
    var cellPackage: [Any] = []
    let uid = FIRAuth.auth()?.currentUser?.uid
    let packageRef = FIRDatabase.database().reference().child("package").childByAutoId()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func showShareAlert(shareIDs: [String]) {
        
        let alert = SCLAlertView()
        
        let receiverEmailtextField = alert.addTextField("接收者email")
        
        
        
        //alert.addButton("送出", target: self, selector: #selector(enterReceiverEmail))
        
        alert.addButton("送出", action: {
        guard let receiverEmail = receiverEmailtextField.text else { return }
            if self.isValidEmail(testStr: receiverEmail) == false {
                self.showEmailFormateErrorAlert()
            } else if self.isValidEmail(testStr: receiverEmail) == true {
            FIRDatabase.database().reference().child("userEmail").queryOrdered(byChild: "email").queryEqual(toValue: receiverEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    for cellID in shareIDs {
                        FIRDatabase.database().reference().child("pocketList").child(self.uid!).queryOrdered(byChild: "cellID").queryEqual(toValue: cellID).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            guard let snap = snapshot.value as? [String: Any] else { return }
                            self.cellPackage.append(snap)
                            
                        })
                    }
                    FIRDatabase.database().reference().child("userEmail").child(self.uid!).observeSingleEvent(of: .value, with: { (emailSnapshot) in
                        guard let email = emailSnapshot.value as? [String: Any] else { return }
                        guard let senderEmail = email["email"] as? String else { return }
                        
                        let value = [
                            "senderEmail": senderEmail,
                            "receiverEmail": receiverEmail,
                            "cellList": self.cellPackage,
                            "packageID": self.packageRef.key
                            ] as [String : Any]
                        self.packageRef.setValue(value)
                        
                    })
                } else {
                    self.showNoUserEmailAlert()
                }
            })
            }
        })
        alert.showInfo("請輸入接收者email", subTitle: "分享後請接收方進入接收頁面下載")
    }
    
    func enterReceiverEmail() {
        
    }
    func showEmailFormateErrorAlert() {
        _ = SCLAlertView().showError("錯誤email格式", subTitle: "請輸入完整的email格式")
    }
    
    func showNoUserEmailAlert() {
        _ = SCLAlertView().showError("無此用戶", subTitle: "請檢查接收email是否正確")
    }
//    let uid = FIRAuth.auth()?.currentUser?.uid
//    let packageRef = FIRDatabase.database().reference().child("package").childByAutoId()
//    
//    
//    
//    let alertController = UIAlertController(title: "請輸入接收者email", message: "分享後請接收方進入接收頁面下載", preferredStyle: .alert)
//    
//    alertController.addTextField(configurationHandler: { (UITextField) in
//    UITextField.placeholder = "接收者email"
//    })
//    let sendAction = UIAlertAction(title: "Send", style: .default, handler: { _ -> Void in
//        guard let receiverEmail = alertController.textFields?[0].text else { return }
//        if self.isValidEmail(testStr: receiverEmail) == false {
//            let errorAlertController = UIAlertController(title: "錯誤", message: "email格式錯誤", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            errorAlertController.addAction(okAction)
//            self.present(errorAlertController, animated: true, completion: nil)
//        }
    
    
//        FIRDatabase.database().reference().child("userEmail").queryOrdered(byChild: "email").queryEqual(toValue: receiverEmail).observeSingleEvent(of: .value, with: { (snapshot) in
//            if snapshot.exists() {
//                for cellID in shareIDs {
//                    FIRDatabase.database().reference().child("pocketList").child(uid!).queryOrdered(byChild: "cellID").queryEqual(toValue: cellID).observeSingleEvent(of: .value, with: { (snapshot) in
//                        
//                        guard let snap = snapshot.value as? [String: Any] else { return }
//                        cellPackage.append(snap)
//                        
//                    })
//                }
//                FIRDatabase.database().reference().child("userEmail").child(uid!).observeSingleEvent(of: .value, with: { (emailSnapshot) in
//                    guard let email = emailSnapshot.value as? [String: Any] else { return }
//                    guard let senderEmail = email["email"] as? String else { return }
//                    
//                    let value = [
//                        "senderEmail": senderEmail,
//                        "receiverEmail": receiverEmail,
//                        "cellList": cellPackage,
//                        "packageID": packageRef.key
//                        ] as [String : Any]
//                    packageRef.setValue(value)
//                    
//                })
//            } else {
//                let alertController = UIAlertController(title: "無此用戶", message: "請檢查接收email是否正確", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion: nil)
//            }
//        })
    func isValidEmail(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
