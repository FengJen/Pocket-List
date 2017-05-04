//
//  ShareAlert.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/5/4.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import SCLAlertView

class ShareAlert: UIView {
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let alertView = SCLAlertView()
        alertView.addTextField("1234")
    }
    
    //let txt = alert
    
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


}
