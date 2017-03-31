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
import SafariServices


class FoodCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, IndicatorInfoProvider {
    
    var ref: FIRDatabaseReference!
    //var refHandle: UInt!
    var cellList = [CellModel]()
   
    let itemPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 76.0, left: 10.0, bottom: 50.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        self.navigationController?.navigationBar.isTranslucent = false //check
        
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        
        //collectionView?.cellForItem(at: 1)?.topAnchor.constraint(equalTo: navigationController?.navigationBar.bottomAnchor, constant: 74)
        
        CellDetaManager.shared.getCellData { (value) in
            guard let cellArray = value else { return }
            print("--------\(value)-----")
            self.cellList = cellArray
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
        }

        
    }
  
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Food")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    /*
    }
    func fetchUsers() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        print("==========")
        print(uid!)
        print("==========")
        let reference = FIRDatabase.database().reference()
        reference.child("user").child(uid!).queryOrdered(byChild: "title").queryEqual(toValue: "1").observeSingleEvent(of: .value, with: { (snapshot) in
            
        })
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cellList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell {
        cell.cellTitle.setTitle(cellList[indexPath.row].title, for: .normal)
        cell.cellTitle.addTarget(self, action: #selector(preformCellEditView), for: .touchUpInside)
        return cell
        }
        return UICollectionViewCell()
    }
    
    func preformCellEditView(sender: UIButton) {
        let button = sender
        if let cell = button.superview?.superview as? ItemCollectionViewCell,
           let indexPath = collectionView?.indexPath(for: cell) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CellDetailViewController") as? CellDetailViewController else { return }
            vc.cell = self.cellList[(indexPath.row)]
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = cellList[indexPath.row].url else { return }
        if let getUrl = URL(string: url) {
        //if let url = URL(string: cellList[indexPath.item].url!) {
            let safariViewController = SFSafariViewController(url: getUrl, entersReaderIfAvailable: true)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }

}

extension FoodCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth/itemPerRow
        let heightPerItem = widthPerItem - 20
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
