import UIKit
import XLPagerTabStrip
import Firebase

class ParentViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var newBar: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    let foodCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoodCollectionViewController") as! FoodCollectionViewController
    let sitesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SitesCollectionViewController") as! SitesCollectionViewController
    
    let editButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(setEdit))
    
    override func viewDidLoad() {
        setUp()
        headerStyle()
        super.viewDidLoad()
        newButton()
        addNewBarButton()
        let editButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(setEdit))
        self.navigationItem.rightBarButtonItem = editButton
        
    }
    func setEdit() {
        self.isEditing = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.newBar.isHidden = true
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        return [foodCollectionViewController, sitesCollectionViewController]
    }
    
    func setUp() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor(red: 0.13, green: 0.03, blue: 0.25, alpha: 1.0)
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = UIColor(red: 0.13, green: 0.03, blue: 0.25, alpha: 1.0)
        }
    }
    
    func newButton() {
        let newButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(pressPlusButton))
        self.navigationItem.setLeftBarButton(newButton, animated: true)
    }
    
    func pressPlusButton() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StepsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.newBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        foodCollectionViewController.isEditing = true

        if editing == true {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancel))
        }
        
    }
    
    func cancel() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(setEdit))
        foodCollectionViewController.isEditing = false
        self.tabBarController?.tabBar.isHidden = false
        self.newBar.isHidden = true
        for indexPath in foodCollectionViewController.selectedIndexPaths {
        guard let cell = foodCollectionViewController.collectionView?.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
            foodCollectionViewController.collectionView?.deselectItem(at: indexPath, animated: true)
            cell.myImageView.alpha = 1
        }
        for cellID in foodCollectionViewController.selectedAutoIDs {
        foodCollectionViewController.selectedAutoIDs.remove(cellID)
        }
    }
    
    func addNewBarButton() {
        shareButton.setImage(#imageLiteral(resourceName: "Upload-50"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareItems), for: .touchUpInside)
        deleteButton.setImage(#imageLiteral(resourceName: "Trash-50"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteItems), for: .touchUpInside)
    }
    
    func deleteItems() {

        let deleteID = foodCollectionViewController.selectedAutoIDs
        foodCollectionViewController.deleteItems(at: deleteID)
        foodCollectionViewController.isEditing = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(setEdit))
      
    }
    
    func shareItems() {
        let shareIDs = foodCollectionViewController.selectedAutoIDs
        var cellPackage: [Any] = []
        let uid = FIRAuth.auth()?.currentUser?.uid
        let packageRef = FIRDatabase.database().reference().child("package").childByAutoId()
        for cellID in shareIDs {
            FIRDatabase.database().reference().child("pocketList").child(uid!).queryOrdered(byChild: "cellID").queryEqual(toValue: cellID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                //print(snapshot.value)
                guard let snap = snapshot.value as? [String: Any] else { return }
                cellPackage.append(snap)
                                
            })
        }
        FIRDatabase.database().reference().child("userEmail").child(uid!).observeSingleEvent(of: .value, with: { (emailSnapshot) in
            guard let email = emailSnapshot.value as? [String: Any] else { return }
            guard let senderEmail = email["email"] as? String else { return }
            
            let value = [
                "senderEmail": senderEmail,
                //"receiverEmail": inputText,
                "cellList": cellPackage,
                "packageID": packageRef.key
                ] as [String : Any]
            packageRef.setValue(value)
        })
        
        let alertController = UIAlertController(title: "This is your sharing key", message: "Send the key to the receiver: \(packageRef.key)", preferredStyle: .alert)

        let sendAction = UIAlertAction(title: "Send", style: .default, handler: { action -> Void in
            
            // todo uiactivitycontroller
    
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(setEdit))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func headerStyle() {
        
        
         //settings.style.buttonBarItemBackgroundColor = UIColor.blue
        
         // buttonBar minimumInteritemSpacing value, note that button bar extends from UICollectionView
         //settings.style.buttonBarMinimumInteritemSpacing: CGFloat?
         // buttonBar minimumLineSpacing value
         //settings.style.buttonBarMinimumLineSpacing: CGFloat?
         // buttonBar flow layout left content inset value
         //settings.style.buttonBarLeftContentInset: CGFloat?
         // buttonBar flow layout right content inset value
         //settings.style.buttonBarRightContentInset: CGFloat?
         
         // selected bar view is created programmatically so it's important to set up the following 2 properties properly
         settings.style.selectedBarBackgroundColor = UIColor(red: 70/255, green: 195/255, blue: 219/255, alpha: 1)
         settings.style.selectedBarHeight = 5
         
         // each buttonBar item is a UICollectionView cell of type ButtonBarViewCell
         //settings.style.buttonBarItemBackgroundColor: UIColor?
         settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 18)
         // helps to determine the cell width, it represent the space before and after the title label
         settings.style.buttonBarItemLeftRightMargin = 8
         settings.style.buttonBarItemTitleColor = UIColor.blue
         // in case the barView items do not fill the screen width this property stretch the cells to fill the screen
         settings.style.buttonBarItemsShouldFillAvailiableWidth = true
         // only used if button bar is created programmatically and not using storyboards or nib files as recommended.
         //public var buttonBarHeight: CGFloat?
        
    }

}

extension ParentViewController: DidReceivePackage {
    func didReceive(shareVC: ShareViewController, uploadSuccess: Bool) {
        
//        shareVC.delegate = self
        if uploadSuccess == true {
            CellDataManager.shared.getCellData(completion: { (value) in
                guard let newCells = value else { return }
                self.foodCollectionViewController.cellList = newCells
                self.foodCollectionViewController.collectionView?.reloadData()
                self.tabBarController?.selectedIndex = 0
            })
        

        }
    }
}
