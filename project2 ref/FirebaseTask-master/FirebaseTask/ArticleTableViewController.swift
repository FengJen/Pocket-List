//
//  ArticleTableViewController.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/15.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import UIKit
import Firebase

class ArticleTableViewController: UITableViewController {
    
    var articleArray: [Article] = []
    let databaseRef = FIRDatabase.database().reference()
    let auth = FIRAuth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Articles"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addArticle(_:)))
        
        ArticleManager.shared.getArticles { (value) in
            self.articleArray = value!
            self.articleArray.sort(by: { $0.date > $1.date })
            self.tableView.reloadData()
        }
        
        self.tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 144
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.articleArray.sort(by: { $0.date > $1.date })
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articleArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as! ArticleTableViewCell

        // Configure the cell...
        let index = articleArray[indexPath.row]
        
        cell.titleLabel.text = index.title
        cell.authorLabel.text = index.author
        cell.likesLabel.text = String(index.likes)
        cell.articleLabel.text = index.article
        cell.timeLabel.text = String(describing: Date(timeIntervalSince1970: Double(index.date / 1000)))
        cell.likeButton.addTarget(self, action: #selector(like(_:)), for: .touchUpInside)

        return cell
    }
    
    func like(_ sender: UIButton) {
        let cell = sender.superview?.superview as! ArticleTableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        
        let selectedArticle = articleArray[(indexPath?.row)!]
        selectedArticle.likes = selectedArticle.likes + 1

        self.databaseRef.child("Article").child(selectedArticle.key).updateChildValues(["Likes": selectedArticle.likes])
        print(articleArray.count)
        self.tableView.reloadData()
    }
    
    func addArticle(_ sender: UIBarButtonItem) {
        let newArticleVC = self.storyboard?.instantiateViewController(withIdentifier: "NewArticleViewController") as! NewArticleViewController
        newArticleVC.delegate = self
        self.navigationController?.present(newArticleVC, animated: true, completion: nil)
    }
}

extension ArticleTableViewController: NewArticleViewControllerDelegate {
    func sendArticle(article: Article) {
        self.articleArray.insert(article, at: 0)
        self.tableView.reloadData()
    }
}



