import UIKit
import XLPagerTabStrip
import Firebase
import FirebaseDatabase
import SafariServices


class FoodCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, IndicatorInfoProvider {
    
    let ref = FIRDatabase.database().reference()
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
        
        
    }
    func setUp() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        self.collectionView?.addGestureRecognizer(longPressGesture)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    func getValue() {
        
        CellDetaManager.shared.getCellData { (value) in
            guard let cellArray = value else { return }
            self.cellList = cellArray
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func loadList() {
        
        CellDetaManager.shared.getCellData { (value) in
            guard let newCell = value else { return }
            self.cellList = newCell
        
        self.collectionView?.reloadData()
        }
    }
    @IBAction func unwindToVC1(segue: UIStoryboardSegue) { }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Food")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    }
    func fetchUsers() {
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
*/
    
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
