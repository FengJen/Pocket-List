import UIKit
import Firebase
import FirebaseDatabase

class Step1ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var temperaryTitle: UITextField!
    @IBOutlet weak var website: UITextField!
    let ref = FIRDatabase.database().reference().child("pocketList")
    
//    @IBAction func doneFillingInfo(_ sender: Any) {
        
//        if temperaryTitle.text == "" {
//            let allert = UIAlertController(title: "您還未輸入標題", message: "請在輸入新增項目的標題", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            allert.addAction(action)
//            self.present(allert, animated: true, completion: nil)
//        } else if website.text == "" {
//            let allert = UIAlertController(title: "您還未輸入網址", message: "請複製貼上想儲存的網址（例如google map網址）", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            allert.addAction(action)
//            self.present(allert, animated: true, completion: nil)
//        } else {
//            uploadData()
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController")
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == website {
        let move = CGPoint(x: 0, y: 250)
        scrollView.setContentOffset(move, animated: true)
        } 
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let move = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(move, animated: true)
    }
//    func uploadData() {
//        if let uid = Constants.uid, let url = website.text, let title = temperaryTitle.text {
//                let cell = ref.child(uid).childByAutoId()
//            cell.setValue(["title": title, "url": url, "order": CellDataManager.shared.cellArray.count])
//        }
//    }
}
