//
//  ArticleManager.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/14.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation
import Firebase

class ArticleManager {
    
    static let shared = ArticleManager()
    let databaseRef = FIRDatabase.database().reference()
    let auth = FIRAuth.auth()
    var value: [Dictionary<String, AnyObject>] = []
    
    func getCurrentUserName(completionHandler: @escaping (_ firstName: String, _ lastName: String) -> Void) {
        self.databaseRef.child("Users").child((self.auth?.currentUser?.uid)!).observe(FIRDataEventType.value, with: { (snapshot) in
            let data = snapshot.value
            let dictionary = data as! [String: AnyObject]
            let firstName = dictionary["First Name"] as! String
            let lastName = dictionary["Last Name"] as! String
            
            completionHandler(firstName, lastName)
        })
    }
    
    typealias UploadSuccess = (FIRDatabaseReference) -> Void
    typealias UploadError = (Error) -> Void
    
    func uploadArticle(uid: String, title: String, article: String, firstName: String, lastName: String, date: Int, success: UploadSuccess?, fail: UploadError? = nil) {
        
        self.databaseRef.child("Article").childByAutoId().setValue(["uid": uid,"Title": title,"Article": article, "Author": "\(firstName) \(lastName)", "Date": date, "Likes": 0]) { (error, databaseReference) in
            if error != nil {
                fail?(error!)
            }
            
            success?(databaseReference)
        }
        
    }
    
    func getArticles(completionHandler: @escaping (_ value: [Article]?) -> Void) {
        
        var values: [Article] = []
                
        self.databaseRef.child("Article").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            for child in snapshot.children {
                guard let taskSnapshot = child as? FIRDataSnapshot else {
                    continue
                }

                let children = taskSnapshot.value! as! [String: AnyObject]
                let title = children["Title"] as! String
                let article = children["Article"] as! String
                let author = children["Author"] as! String
                let date = children["Date"] as! Int
                let likes = children["Likes"] as! Int
                let uid = children["uid"] as! String
                let key = taskSnapshot.key
                
                let articles = Article(title: title, article: article, date: date, author: author, likes: likes, uid: uid, key: key)
                
                values.append(articles)
            }
            completionHandler(values)
        })
        
    }
    
}
