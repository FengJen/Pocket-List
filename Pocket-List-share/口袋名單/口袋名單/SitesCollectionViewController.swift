//
//  SitesCollectionViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/28.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import SafariServices

private let reuseIdentifier = "Cell"

class SitesCollectionViewController: UICollectionViewController, IndicatorInfoProvider {
    
    let ref = FIRDatabase.database().reference()
    let uid = FIRAuth.auth()?.currentUser?.uid
    var cellList = [CellModel]()
    var longPressGesture = UILongPressGestureRecognizer()
    
    let itemPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 76.0, left: 10.0, bottom: 50.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getValue()
        setUp()
        
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadEditValue), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
    
    func setUp() {
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        self.collectionView?.addGestureRecognizer(longPressGesture)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    func getValue() {
        
        CellDataManager.shared.getCellData(whatClass: "景點") { (value, _) in
            guard let cellArray = value else { return }
            self.cellList = cellArray
            CellDataManager.shared.cellArray = cellArray
            
            self.collectionView?.reloadData()
            
        }
        
    }
    func loadEditValue() {
        
        CellDataManager.shared.getCellData(whatClass: "景點") { (value, _) in
            guard let newCell = value else { return }
            self.cellList = newCell
            
            self.collectionView?.reloadData()
        }
    }

    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView?.endInteractiveMovement()
        default:
            collectionView?.cancelInteractiveMovement()
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "景點")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell {
            cell.myImageView.alpha = 1
            
            cell.cellTitle.setTitle(cellList[indexPath.row].title, for: .normal)
            cell.cellTitle.tintColor = UIColor.black
            cell.cellTitle.addTarget(self, action: #selector(preformCellEditView), for: .touchUpInside)
            cell.myImageView.image = cellList[indexPath.row].image
            cell.myImageView.layer.cornerRadius = 15
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    var selectedAutoIDs: [String] = []
    var selectedButtonIndexpath: [IndexPath] = []
    var selectedIndexPaths: [IndexPath] = []
    
    func preformCellEditView(sender: UIButton) {
        let button = sender
        if isEditing == false {
            if let cell = button.superview?.superview as? ItemCollectionViewCell,
                let indexPath = collectionView?.indexPath(for: cell) {
                selectedButtonIndexpath.append(indexPath)
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CellDetailViewController") as? CellDetailViewController else { return }
                vc.cell = self.cellList[(indexPath.row)]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func removeImageStorage(at autoID: [String], completion: (_ success: Bool) -> Void) {
        
        for autoID in selectedAutoIDs {
            ref.child("pocketList").child(uid!).child(autoID).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let value = snapshot.value as? [String: Any] else { return }

                guard let uuid = value["imageUuid"] as? String else {
                    print("castfail")
                    return }
                let storageRef = FIRStorage.storage().reference(withPath: "\(uuid).jpg")
                storageRef.delete(completion: { (error) in
                    if error != nil {
                        print("delete storage error")
                    }
                    print("delete success")
                })
            })
            
            
        }
        completion(true)
        
    }
    
    func deleteItem() {
        for autoID in selectedAutoIDs {
            removeImageStorage(at: selectedAutoIDs, completion: { (true) in
                ref.child("pocketList").child(uid!).child(autoID).removeValue(completionBlock: { (error, _) in
                    if error != nil {
                        print(error ?? "12345")
                    }
                    
                    CellDataManager.shared.getCellData(whatClass: "景點") { (value, _) in
                        
                        guard let cellArray = value else { return }
                        CellDataManager.shared.cellArray = cellArray
                        self.cellList = cellArray
                        self.collectionView!.reloadData()
                        self.isEditing = false
                    }
                    
                    CellDataManager.shared.getCellData(whatClass: "景點") { (_, _) in
                        self.collectionView?.reloadData()
                        self.isEditing = false
                    }
                    
                })
            })
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 10
        cell.layer.shadowOffset = CGSize.zero
        if self.isEditing == false {
            
            guard let url = cellList[indexPath.row].url else { return }
            if let getUrl = URL(string: url) {
                let safariViewController = SFSafariViewController(url: getUrl, entersReaderIfAvailable: true)
                self.present(safariViewController, animated: true, completion: nil)
                
            }
        } else if isEditing == true {
            
            collectionView.allowsMultipleSelection = true
            guard let autoID = cellList[indexPath.row].autoID else { return }
            selectedAutoIDs.append(autoID)
            selectedIndexPaths.append(indexPath)
            cell.myImageView.alpha = 0.3
            
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
        if isEditing == true {
            
            collectionView.allowsMultipleSelection = true
            cell.myImageView.alpha = 1
            
            selectedAutoIDs.remove(cellList[indexPath.row].autoID!)
            //selectedIndexPaths.remove(at: indexPath.row)
        }
    }

}

// MARK: FlowLayout
extension SitesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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

//extension Array where Element:Equatable {
//    public mutating func remove(_ item: Element ) {
//        var index = 0
//        while index < self.count {
//            if self[index] == item {
//                self.remove(at: index)
//            } else {
//                index += 1
//            }
//        }
//    }
//    
//    public func array( removing item: Element ) -> [Element] {
//        var result = self
//        result.remove( item )
//        return result
//    }
//}



