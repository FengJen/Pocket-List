import UIKit
import Firebase
import FirebaseDatabase

class Step1ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var temperaryTitle: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    let ref = FIRDatabase.database().reference().child("pocketList")
    @IBAction func doneButton(_ sender: Any) {
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
        setImageView()
    }
    
    //MARK: pick image
    func pickImage() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setImageView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        
        imageView.addGestureRecognizer(tap)
        
        imageView.isUserInteractionEnabled = true
        
        let image = #imageLiteral(resourceName: "images-icon").withRenderingMode(.alwaysTemplate)
        
        imageView.image = image
        
        imageView.tintColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFit
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageView.frame = CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height)
            
            imageView.image = pickedImage
            
            imageView.contentMode = .scaleAspectFit
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: upload to firebase
    func uploadData() {
        if let uid = Constants.uid, let url = website.text, let title = temperaryTitle.text, let content = contentView.text {
                let cell = ref.child(uid).childByAutoId()
            let value = ["title": title, "url": url, "order": CellDataManager.shared.cellArray.count, "content": content] as [String : Any]
            cell.setValue(value)
        }
    }
    
    // MARK: handle keyboard
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
}
