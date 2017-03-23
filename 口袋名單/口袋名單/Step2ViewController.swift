//
//  Step2ViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/22.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Step2ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var placeTitle: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func toPage3Button(_ sender: UIButton) {
        if placeTitle.text == "" {
            uploadData()
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "step3")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func presentStep3() {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func uploadData() {
        if let uid = constants.uid, let title = placeTitle.text {
            if title == "" {
                let allert = UIAlertController(title: "您還未輸入標題", message: "請輸入新增項目的標題", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                allert.addAction(action)
                self.present(allert, animated: true, completion: nil)
            } else {
        let ref = FIRDatabase.database().reference()
            ref.child("user").child(uid).child("cell").childByAutoId().child("title").setValue(title)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
