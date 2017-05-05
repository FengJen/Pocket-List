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

    func showReceiveAlert(senderEmail: String) {
        
        let alert = SCLAlertView()
        
        alert.addButton("同意") { 
            
        }
        alert.showInfo("確認傳送來源", subTitle: "\(senderEmail)想要和你分享他的口袋名單")

        
    }
    
    func showErrorAlert() {
        _ = SCLAlertView().showError("沒有傳給您的口袋名單", subTitle: "請在傳送方送出後再按接收按鈕，或確認傳送email正確")
    }
    
    func aaaa() {
   

    }
}
