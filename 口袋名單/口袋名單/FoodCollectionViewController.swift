import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase
import SafariServices


class FoodCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, IndicatorInfoProvider {
    
    //var isSelecting = false
    
    
    let ref = FIRDatabase.database().reference()
    let uid = FIRAuth.auth()?.currentUser?.uid
    var cellList = [CellModel]()
    var longPressGesture = UILongPressGestureRecognizer()
   
    
    
    //var itemArray = NSMutableArray()
    
    let itemPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 76.0, left: 10.0, bottom: 50.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getValue()
        setUp()
        
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        //todo remove observer
        
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
//            self.cellList.append(contentsOf: cellArray)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
        }

    }


    func deleteSelectedItemAction(sender: UIBarButtonItem) {
        //let selectedIndexPaths: [NSIndexPath] = self.collectionView?.indexPathsForVisibleItems
        
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
        // todo: handle !
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
    
    func loadList() {
        
        CellDataManager.shared.getCellData { (value) in
            guard let newCell = value else { return }
            self.cellList = newCell
        
        self.collectionView?.reloadData()
        }
    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        
//        if editing {
//            
//            self.collectionView?.allowsMultipleSelection = true
//            
//        } else {
//            self.editButtonItem.title = "Cancel"
//        }
//        
//    }
    
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
        if isEditing == false {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell {
            cell.cellTitle.setTitle(cellList[indexPath.row].title, for: .normal)
            cell.cellTitle.addTarget(self, action: #selector(preformCellEditView), for: .touchUpInside)
            return cell
            }
        }
        return UICollectionViewCell()
    }
    
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
    
    var selectedIndexPaths: [IndexPath] = []
    
    func deleteItems(at indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
        
            //let item = cellList[indexPath.row]
          
            CellDataManager.shared.cellArray.remove(at: indexPath.row)

            
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isEditing == false {
            guard let url = cellList[indexPath.row].url else { return }
            if let getUrl = URL(string: url) {
                let safariViewController = SFSafariViewController(url: getUrl, entersReaderIfAvailable: true)
                self.present(safariViewController, animated: true, completion: nil)
                
            }
        } else if isEditing == true {
//            guard let selectedCells = collectionView.indexPathsForSelectedItems else { return }
            
            selectedIndexPaths.append(indexPath)
            
//            self.deleteItems(at: selectedCells)
            //highlight selected
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
