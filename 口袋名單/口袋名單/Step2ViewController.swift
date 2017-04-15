import UIKit
import Firebase
import FirebaseDatabase

class Step2ViewController: UIViewController {
    
    let step1VC = Step1ViewController()
    let ref = FIRDatabase.database().reference().child("pocketList")
        //UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Step1ViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func doneButton(_ sender: Any) {
        
        if step1VC.temperaryTitle.text == "" {
            let allert = UIAlertController(title: "您還未輸入標題", message: "請在輸入新增項目的標題", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else if step1VC.website.text == "" {
            let allert = UIAlertController(title: "您還未輸入網址", message: "請複製貼上想儲存的網址（例如google map網址）", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else {
            uploadData()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController")
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    func uploadData() {
        if let uid = Constants.uid, let url = step1VC.website.text, let title = step1VC.temperaryTitle.text {
            let cell = ref.child(uid).childByAutoId()
            cell.setValue(["title": title, "url": url, "order": CellDataManager.shared.cellArray.count])
        }
    }
}
