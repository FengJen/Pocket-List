import UIKit
import Firebase
import FirebaseDatabase

class Step3ViewController: UIViewController {
    
    @IBOutlet weak var temperaryTitle: UITextField!
    @IBOutlet weak var website: UITextField!
    let ref = FIRDatabase.database().reference().child("user")
    
    @IBAction func doneFillingInfo(_ sender: Any) {
        
        if temperaryTitle.text == "" {
            let allert = UIAlertController(title: "您還未輸入標題", message: "請在輸入新增項目的標題", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else if website.text == "" {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        //Step2ViewController.shared.delegate = self
    }
    
//    func passTitle(title: String) {
//        if title == "" {
//            let allert = UIAlertController(title: "您還未輸入標題", message: "請在step 2輸入新增項目的標題", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            allert.addAction(action)
//            self.present(allert, animated: true, completion: nil)
//        } else {
//        ref.childByAutoId().setValue(["title": title])
//        }
//    }
    func uploadData() {
        if let uid = constants.uid, let url = website.text, let title = temperaryTitle.text {
                let cell = ref.child(uid).childByAutoId()
            cell.setValue(["title": title, "url": url])
        }
    }
}
