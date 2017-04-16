//
//  CellDetailViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/28.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
//protocol ChangeCellDataDelegate {
//    func changeCell(newCell: CellModel)
//}
class CellDetailViewController: UIViewController, UITextFieldDelegate {
    var cell = CellModel()
   
    @IBOutlet weak var editTitle: UITextField!

    @IBOutlet weak var editUrl: UITextField!
    
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    //var delegate: ChangeCellDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    func setUp() {
        editTitle.text = cell.title
        editUrl.text = cell.url
        content.text = cell.content
        //imageView.image =
        
        
        doneButton.layer.cornerRadius = 22
    }
    
    @IBAction func editData(_ sender: UIButton) {
        guard let text = editTitle.text, let url = editUrl.text, let content = content.text else { return }
        
        //todo: check if data changed
        guard let cellAutoID = cell.autoID, let uid = Constants.uid else { return }
        Constants.ref.child("pocketList").child(uid).child(cellAutoID).updateChildValues(["title": text])
        Constants.ref.child("pocketList").child(uid).child(cellAutoID).updateChildValues(["url": url])
        Constants.ref.child("pocketList").child(uid).child(cellAutoID).updateChildValues(["content": content])
       
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        performSegue(withIdentifier: "unwindSegue", sender: sender)
        
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
