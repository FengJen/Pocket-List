//
//  CellDetailViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/28.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit

class CellDetailViewController: UIViewController, UITextFieldDelegate {
    var cell = CellModel()
    
    @IBOutlet weak var editTitle: UITextField!

    @IBOutlet weak var editUrl: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        // Do any additional setup after loading the view.
    }
    
    func setUp() {
        editTitle.text = cell.title
        editUrl.text = cell.url
    }
    
    @IBAction func editData(_ sender: Any) {
        guard let text = editTitle.text else { return }
        //Constants.ref.child("user").child(Constants.uid!).updateChildValues(["title": text])
        Constants.ref.child("user").child(Constants.uid!).updateChildValues(["title": text]) { (error, dataref) in
            
        }
    }
    func changeData() {
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
