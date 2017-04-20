import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase
import SafariServices


class FoodCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, IndicatorInfoProvider {
    
    let ref = FIRDatabase.database().reference()
    let uid = FIRAuth.auth()?.currentUser?.uid
    var cellList = [CellModel]()
    var longPressGesture = UILongPressGestureRecognizer()
    
    //var itemArray = NSMutableArray()
    
    let itemPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 76.0, left: 10.0, bottom: 50.0, right: 10.0)
    
    override func viewDidLoad() {
        
        headerStyle()
        super.viewDidLoad()
        getValue()
        setUp()
        
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        //getValue loadlist
        NotificationCenter.default.addObserver(self, selector: #selector(getValue), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "new"), object: nil, queue: nil) { (Notification) in
            self.loadEditValue()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "new"), object: nil)
    }
    func headerStyle() {
        /*
        settings.style.buttonBarBackgroundColor: UIColor?
        // buttonBar minimumInteritemSpacing value, note that button bar extends from UICollectionView
        settings.style.buttonBarMinimumInteritemSpacing: CGFloat?
        // buttonBar minimumLineSpacing value
        settings.style.buttonBarMinimumLineSpacing: CGFloat?
        // buttonBar flow layout left content inset value
        settings.style.buttonBarLeftContentInset: CGFloat?
        // buttonBar flow layout right content inset value
        settings.style.buttonBarRightContentInset: CGFloat?
        
        // selected bar view is created programmatically so it's important to set up the following 2 properties properly
        settings.style.selectedBarBackgroundColor = UIColor.blackColor()
        settings.style.selectedBarHeight: CGFloat = 5
        
        // each buttonBar item is a UICollectionView cell of type ButtonBarViewCell
        settings.style.buttonBarItemBackgroundColor: UIColor?
        settings.style.buttonBarItemFont = UIFont.systemFontOfSize(18)
        // helps to determine the cell width, it represent the space before and after the title label
        settings.style.buttonBarItemLeftRightMargin: CGFloat = 8
        settings.style.buttonBarItemTitleColor: UIColor?
        // in case the barView items do not fill the screen width this property stretch the cells to fill the screen
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        // only used if button bar is created programmatically and not using storyboards or nib files as recommended.
        public var buttonBarHeight: CGFloat?
 */
    }
    
    func setUp() {
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        self.collectionView?.addGestureRecognizer(longPressGesture)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    func getValue() {
        
        CellDataManager.shared.getCellData { (value) in
            guard let cellArray = value else { return }
            self.cellList = cellArray
            CellDataManager.shared.cellArray = cellArray
            
            self.collectionView?.reloadData()
        
            
        }

    }
    func loadEditValue() {
        
        CellDataManager.shared.getCellData { (value) in
            guard let newCell = value else { return }
            self.cellList = newCell
            
            self.collectionView?.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        /*
    ref.child("pocketList").child(uid!).child(cellList[sourceIndexPath.row].autoID!).setValue(cellList[destinationIndexPath.row].order!, forKey: "order")
        
        if sourceIndexPath > destinationIndexPath {
            ref.child("pocketList").child(uid!).queryStarting(atValue: cellList[destinationIndexPath.row].order, childKey: "order").queryStarting(atValue: cellList[sourceIndexPath.row - 1].order
                , childKey: "order").observeSingleEvent(of: .value, with: { (snapShot) in
                for child in snapShot.children {
                    guard let taskSnapShot = child as? FIRDataSnapshot else { return }
                    guard let queryValue = taskSnapShot.value as? [String: AnyObject] else { return }
                    guard var newOrder = queryValue["order"] as? Int else { return }
                    newOrder += 1
                }
            })
            //+= 1
        } else if sourceIndexPath < destinationIndexPath {
            ref.child("pocketList").child(uid!).queryStarting(atValue: cellList[sourceIndexPath.row + 1].order, childKey: "order").queryEnding(atValue: cellList[destinationIndexPath.row].order, childKey: "order").observeSingleEvent(of: .value, with: { (snapShot) in
                for child in snapShot.children {
                    guard let taskSnapShot = child as? FIRDataSnapshot else { return }
                    guard let queryValue = taskSnapShot.value as? [String: AnyObject] else { return }
                    guard var newOrder = queryValue["order"] as? Int else { return }
                    newOrder -= 1
                }
                
            })
            //-= 1
        }
        // todo: handle !  */
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
        return IndicatorInfo(title: "Food")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: UICollectionViewDataSource

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
            cell.cellTitle.addTarget(self, action: #selector(preformCellEditView), for: .touchUpInside)
            cell.myImageView.image = cellList[indexPath.row].image
            return cell
            }
        
        return UICollectionViewCell()
    }
    // todo cellback
    func preformCellEditView(sender: UIButton) {
        let button = sender
        if isEditing == false {
            if let cell = button.superview?.superview as? ItemCollectionViewCell,
               let indexPath = collectionView?.indexPath(for: cell) {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CellDetailViewController") as? CellDetailViewController else { return }
                vc.cell = self.cellList[(indexPath.row)]
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    var selectedAutoIDs: [String] = []
    var selectedIndexPaths: [IndexPath] = []
            //todo delete image storage
    func deleteItems(at autoID: [String]) {
        
        for autoID in selectedAutoIDs {
            ref.child("pocketList").child(uid!).child(autoID).removeValue(completionBlock: { (error, newRef) in
                if error != nil {
                    print(error ?? "")
                }
            })
            
            CellDataManager.shared.getCellData { (valew) in
                guard let cellArray = valew else { return }
                CellDataManager.shared.cellArray = cellArray
                self.cellList = cellArray
                
            }
            
                self.collectionView!.reloadData()
                self.isEditing = false
        }

        //cellList = CellDataManager.shared.cellArray
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
    @IBAction func unwindToVC1(segue: UIStoryboardSegue) { }
    
}

// MARK: FlowLayout
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

extension Array where Element:Equatable {
    public mutating func remove(_ item:Element ) {
        var index = 0
        while index < self.count {
            if self[index] == item {
                self.remove(at: index)
            } else {
                index += 1
            }
        }
    }
    
    public func array( removing item:Element ) -> [Element] {
        var result = self
        result.remove( item )
        return result
    }
}
