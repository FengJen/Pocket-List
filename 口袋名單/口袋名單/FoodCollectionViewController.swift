//
//  FoodCollectionViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/28.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class FoodCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, IndicatorInfoProvider {
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var cellList = [CellModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        fetchUsers()
        setLayout()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ItemCollectionViewCell")

        // Do any additional setup after loading the view.
    }
  
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Food")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchUsers() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        print("==========")
        print(uid!)
        print("==========")
        let reference = FIRDatabase.database().reference()
        reference.child("user").child(uid!).queryOrdered(byChild: "title").queryEqual(toValue: "1").observeSingleEvent(of: .value, with: { (snapshot) in
            
        })
        
        
        /*
        
        (of: .value, with: { snapshot in
            print("==========")
            print(snapshot.value)
            print(snapshot.key)
            print("==========")
            self.collectionView?.reloadData()
        })
        let customCell = ref.child(uid!).childByAutoId()
        let customCellID = customCell.key
        refHandle = ref.child("user").child(uid!).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let cellModel = CellModel()
                cellModel.setValuesForKeys(dictionary)
                self.cellList.append(cellModel)
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        })
 */
 }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cellList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell {
        cell.cellTitle.setTitle(cellList[indexPath.row].title, for: .normal)
        
        return cell
        }
        return UICollectionViewCell()
    }

    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        layout.minimumLineSpacing = 14
        layout.itemSize = CGSize(width: 166, height: 166)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
