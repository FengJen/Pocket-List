//
//  CellDetailViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/28.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
protocol ChangeCellDataDelegate {
    func changeCell(newCell: CellModel)
}
class CellDetailViewController: UIViewController, UITextFieldDelegate {
    var cell = CellModel()
   
    @IBOutlet weak var editTitle: UITextField!

    @IBOutlet weak var editUrl: UITextField!
    var delegate: ChangeCellDataDelegate?
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
    
    @IBAction func editData(_ sender: UIButton) {
        guard let text = editTitle.text else { return }
        
        //todo: check if data changed
            
    Constants.ref.child("user").child(Constants.uid!).child(cell.autoID!).updateChildValues(["title": text])
       
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        performSegue(withIdentifier: "unwindSegue", sender: sender)
        
    }
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  if segue.identifier == "unwindSegue" {
        //    let desVC = segue.destination as? FoodCollectionViewController
            //desVC?.cellList[]
        //}
    //}
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
