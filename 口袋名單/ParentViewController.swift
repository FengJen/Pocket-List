import UIKit
import XLPagerTabStrip

class ParentViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var newBar: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    let foodCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoodCollectionViewController") as! FoodCollectionViewController
    let sitesCollectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SitesCollectionViewController") as! SitesCollectionViewController
    let editButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(setEdit))
    
    override func viewDidLoad() {
        setUp()
        
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
    
    
////    }
////    @IBAction func editMode(sender: AnyObject) {
////        self.setEditing(!self.editing, animated: true)
////        let newButton = UIBarButtonItem(barButtonSystemItem: (self.editing) ? .Done : .Edit, target: self, action: #selector(editMode(_:)))
////        self.navigationItem.setLeftBarButtonItem(newButton, animated: true)
////    }
//    
////    func pressSelectButton() {
////   
//    }
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
//            else {
//            navigationItem.rightBarButtonItem?.title = "Select"
//        }
    }
    
    //todo handle cancle action
    func cancel() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(setEdit))
        
        self.tabBarController?.tabBar.isHidden = false
        self.newBar.isHidden = true
        foodCollectionViewController.isEditing = false
        
    }
    
    func addNewBarButton() {
        shareButton.setImage(#imageLiteral(resourceName: "Upload-50"), for: .normal)
        deleteButton.setImage(#imageLiteral(resourceName: "Trash-50"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteItems), for: .touchUpInside)
    }
    
    func deleteItems() {
        
//        let selectedIndexPaths = foodCollectionViewController.selectedIndexPaths
        
//        for index in selectedIndexPaths {
//            foodCollectionViewController.cellList.remove(at: index.row)
//            foodCollectionViewController.collectionView?.deleteItems(at: selectedIndexPaths)
////            foodCollectionViewController.collectionView?.reloadItems(at: selectedIndexPaths)
////
    
        // deleted
        let deleteID = foodCollectionViewController.selectedAutoIDs
        foodCollectionViewController.deleteItems(at: deleteID)
        foodCollectionViewController.isEditing = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(setEdit))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
