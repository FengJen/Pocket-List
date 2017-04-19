//
//  NewArticleViewController.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/16.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import Firebase

protocol NewArticleViewControllerDelegate: class {
    func sendArticle(article: Article)
}

class NewArticleViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var articleTextView: UITextView!
    weak var delegate: NewArticleViewControllerDelegate!
    let auth = FIRAuth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func submitAction(_ sender: Any) {
        
        ArticleManager.shared.getCurrentUserName { (firstName, lastName) in
            guard let title = self.titleTextField.text, let article = self.articleTextView.text else {
                let alertController = UIAlertController(title: "Incorrect Format", message: "Title and article can not be empty.", preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
                
                alertController.addAction(doneAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let uid = self.auth?.currentUser?.uid
            let currentMilli = (Date().timeIntervalSince1970 * 1000).rounded()
            
            let alertController = UIAlertController(title: "Ready to Submit?", message: nil, preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) in
                ArticleManager.shared.uploadArticle(uid: uid!, title: title, article: article, firstName: firstName, lastName: lastName, date: Int(currentMilli), success: { (databaseRef) in
                    let newArticle = Article(title: title, article: article, date: Int(currentMilli), author: "\(firstName) \(lastName)", likes: 0, uid: uid!, key: databaseRef.key)
                    self.dismiss(animated: true, completion: {
                        self.delegate.sendArticle(article: newArticle)
                    })
                }, fail: { (error) in
                    let alertController = UIAlertController(title: "Oops!", message: "Something went wrong, please try again.", preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
                    
                    alertController.addAction(doneAction)
                    self.present(alertController, animated: true, completion: nil)
                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            

        }
        
        
    }

    @IBAction func cancelAction(_ sender: Any) {
        let alertController = UIAlertController(title: "This action will delete all content you have typed in.", message: "Are you sure you want to leave?", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

    }

}

