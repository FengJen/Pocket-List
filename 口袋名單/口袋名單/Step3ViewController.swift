import UIKit
import Firebase
import FirebaseDatabase

class Step3ViewController: UIViewController {
    @IBOutlet weak var website: UITextField!

    @IBAction func doneFillingInfo(_ sender: Any) {
        
            uploadData()
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController")
            self.present(vc, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func uploadData() {
        if let uid = constants.uid, let url = website.text {
            if title == "" {
                let allert = UIAlertController(title: "您還未輸入標題", message: "請輸入新增項目的標題", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                allert.addAction(action)
                self.present(allert, animated: true, completion: nil)
            } else {
                let ref = FIRDatabase.database().reference().child("user").child(uid)
                let refKey = ref.key
                let data = [refKey: ["url": url]]
                ref.setValue(data)
            }
        }
    }
}
