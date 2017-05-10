import UIKit
import XLPagerTabStrip
import Firebase

class ParentViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var newBar: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    let foodCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoodCollectionViewController") as? FoodCollectionViewController
    let sitesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SitesCollectionViewController") as? SitesCollectionViewController
    let editButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(setEdit))
    
    override func viewDidLoad() {
        
        setUp()
        headerStyle()
        super.viewDidLoad()
        newButton()
        addNewBarButton()
        let editButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(setEdit))
        self.navigationItem.rightBarButtonItem = editButton
        
        self.title = "口袋名單"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 51/255, green: 118/255, blue: 242/255, alpha: 1)]
    }
    func setEdit() {
        self.isEditing = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.newBar.isHidden = true
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        return [foodCollectionViewController!, sitesCollectionViewController! ]
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
        foodCollectionViewController?.isEditing = true
        sitesCollectionViewController?.isEditing = true

        if editing == true {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancel))
        }
        
    }
    //todo cancel after share
    func cancel() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(setEdit))
        foodCollectionViewController?.isEditing = false
        sitesCollectionViewController?.isEditing = false
        self.tabBarController?.tabBar.isHidden = false
        self.newBar.isHidden = true
        for indexPath in (foodCollectionViewController?.selectedIndexPaths)! {
        guard let cell = foodCollectionViewController?.collectionView?.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
            foodCollectionViewController?.collectionView?.deselectItem(at: indexPath, animated: true)
            cell.myImageView.alpha = 1
        }
        for cellID in (foodCollectionViewController?.selectedAutoIDs)! {
        foodCollectionViewController?.selectedAutoIDs.remove(cellID)
        }
        
        
        for indexPath in (sitesCollectionViewController?.selectedIndexPaths)! {
            guard let cell = sitesCollectionViewController?.collectionView?.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
            sitesCollectionViewController?.collectionView?.deselectItem(at: indexPath, animated: true)
            cell.myImageView.alpha = 1
        }
        for cellID in (sitesCollectionViewController?.selectedAutoIDs)! {
            sitesCollectionViewController?.selectedAutoIDs.remove(cellID)
        }

    }
    
    func addNewBarButton() {
        newBar.backgroundColor = UIColor(red: 70/255, green: 195/255, blue: 219/255, alpha: 1)
        shareButton.setImage(#imageLiteral(resourceName: "Upload-50"), for: .normal)
        
        shareButton.addTarget(self, action: #selector(shareItems), for: .touchUpInside)
        deleteButton.setImage(#imageLiteral(resourceName: "Trash-50"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteItems), for: .touchUpInside)
    }
    
    func deleteItems() {

        guard let deleteID = foodCollectionViewController?.selectedAutoIDs else { return }
        foodCollectionViewController?.removeImageStorage(at: deleteID, completion: { (true) in
            foodCollectionViewController?.deleteItem()
        })
        foodCollectionViewController?.isEditing = false
        
        guard let siteDeleteID = sitesCollectionViewController?.selectedAutoIDs else { return }
        sitesCollectionViewController?.removeImageStorage(at: siteDeleteID, completion: { (true) in
            sitesCollectionViewController?.deleteItem()
        })
        sitesCollectionViewController?.isEditing = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(setEdit))
        newBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    func shareItems() {
        guard let foodShareIDs = foodCollectionViewController?.selectedAutoIDs, let siteShareIDs = sitesCollectionViewController?.selectedAutoIDs else { return }
        let shareIDs = foodShareIDs + siteShareIDs
        let shareAlert = ShareAlertViewController()
       
        shareAlert.showShareAlert(shareIDs: shareIDs)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func isValidEmail(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func headerStyle() {
 
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
        
    }

}

extension ParentViewController: DidReceivePackage {
    func didReceive(shareVC: ShareViewController, uploadSuccess: Bool) {
        
//        shareVC.delegate = self
        if uploadSuccess == true {
            CellDataManager.shared.getCellData(whatClass: "美食", completion: { (value, _) in
                guard let newCells = value else { return }
                self.foodCollectionViewController?.cellList = newCells
                self.foodCollectionViewController?.collectionView?.reloadData()
                self.tabBarController?.selectedIndex = 0
            })
            
            CellDataManager.shared.getCellData(whatClass: "景點", completion: { (value, _) in
                guard let newCells = value else { return }
                self.sitesCollectionViewController?.cellList = newCells
                self.sitesCollectionViewController?.collectionView?.reloadData()
                self.tabBarController?.selectedIndex = 0
            })


        }
    }
}
