//
//  ShareViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/21.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import Firebase

class ShareViewController: UIViewController {
    var receiveCells: [CellModel] = []
    
    @IBOutlet weak var sharingKey: UITextField!
    
    
    
    @IBAction func receive(_ sender: Any) {
        guard let text = sharingKey.text else { return }
        FIRDatabase.database().reference().child("package").queryOrdered(byChild: "packageID").queryEqual(toValue: text).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let newCells = snapshot.value as? [String: Any] else { return }
            for newCell in newCells {
                
//                guard let task = newCell as? [String: Any] else { return }
                guard let value = newCell.value as? [String: AnyObject] else { continue }
                
                guard let cellList = value["cellList"] as? Array<Dictionary<String, Any>> else { continue }
                print(cellList)
                FIRDatabase.database().reference().child("pocketList").child(Constants.uid!).updateChildValues([Constants.uid!: cellList])
                //guard let cellList = value["cellList"] as? FIRDataSnapshot else { continue }
                for some in cellList {
                    guard let cellSnap = some as? FIRDataSnapshot else { return }
                    guard let cellValue = cellSnap.value as? [String: Any] else { return }
                    guard let title = cellValue["title"] as? String,
                          let order = cellValue["order"] as? Int,
                          let content = cellValue["content"] as? String,
                          let downloadURL = cellValue["image"] as? String,
                          let url = cellValue["url"] as? String else { return }
                    let storageRef = FIRStorage.storage().reference(forURL: downloadURL)
                    
                    storageRef.data(withMaxSize: (1 * 1024 * 1024), completion: { (data, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }
                        
                        guard let imageData = data else { return }
                        let picture = UIImage(data: imageData)
                        let cellModel = CellModel(autoID: "", title: title, url: url, order: order, content: content, image: picture)
                        self.receiveCells.append(cellModel)
                        
                    })

                }
       
            print(self.receiveCells.count)
                    

            }
        })
        
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Check receive items", message: "\("someone") wants to send \("") to you", preferredStyle: .alert)
        alertController.addTextField { (textFeild) in
            textFeild.placeholder = "Enter sharing key from your friend here"
        }
        let accept = UIAlertAction(title: "Accept", style: .default) { (action) in
            
            
            
        
        }
        let decline = UIAlertAction(title: "Decline", style: .destructive, handler: nil)
        //todo delete package in 5mins?
        alertController.addAction(accept)
        alertController.addAction(decline)
        self.present(alertController, animated: true, completion: nil)
    
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

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
