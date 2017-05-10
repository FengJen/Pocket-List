

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
        
        let receiverEmailtextField = alert.addTextField("請輸入接收對象的email")
        
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
                        self.showSendingSuccessAlert()
                    })
                } else {
                    self.showNoUserEmailAlert()
                }
            })
            }
        })
        alert.showInfo("分享您的口袋名單", subTitle: "")
    }
    
    func enterReceiverEmail() {
        
    }
    func showEmailFormateErrorAlert() {
        _ = SCLAlertView().showError("錯誤email格式", subTitle: "請輸入完整的email格式")
    }
    
    func showNoUserEmailAlert() {
        _ = SCLAlertView().showError("無此用戶", subTitle: "請檢查接收email是否正確")
    }

    func showSendingSuccessAlert() {
        _ = SCLAlertView().showSuccess("傳送成功", subTitle: "接收方進入接收頁面後，確認即可收到您的分享")
    }
    
    func isValidEmail(testStr: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
