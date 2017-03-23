import UIKit
import Firebase
import FirebaseDatabase

class Step3ViewController: UIViewController {
    @IBOutlet weak var website: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        storeData()
    }
    
    //test button
    func storeData() {
        let button = UIButton(frame: CGRect(x: 20, y: 550, width: 40, height: 40))
        view.addSubview(button)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(uploadData), for: .touchUpInside)
        button.titleLabel?.text = "test"
        
    }
    
    func uploadData() {
        if let uid = constants.uid, let url = website.text {
            if title == "" {
                let allert = UIAlertController(title: "您還未輸入標題", message: "請輸入新增項目的標題", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                allert.addAction(action)
                self.present(allert, animated: true, completion: nil)
            } else {
                let ref = FIRDatabase.database().reference()
                ref.child("user").child(uid).child("cell").childByAutoId().child("url").setValue(url)
            }
        }
    }
    
}
