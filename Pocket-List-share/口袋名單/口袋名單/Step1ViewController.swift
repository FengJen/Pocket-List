import UIKit
import Firebase
import FirebaseDatabase

protocol Step1ViewControllerDelegete: class {
    func isUploaded()
}

enum FoodType {
    case america
    case japaness
    case dessert
    case italy
    case chinese
    case other
}

class Step1ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let foodTypes: [FoodType] = [.america, .dessert, .italy, .japaness, .chinese, .other]
    var some: String = ""
    
    let defaultImagePicker = UIPickerView()
    weak var delegate: Step1ViewControllerDelegete?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var temperaryTitle: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!    
    @IBOutlet weak var doneButton: UIButton!
    let ref = FIRDatabase.database().reference().child("pocketList")
    //let image = #imageLiteral(resourceName: "images-icon").withRenderingMode(.alwaysTemplate)
    let image = #imageLiteral(resourceName: "tray-icon")
    
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
        } else if UIApplication.shared.canOpenURL(URL(string: website.text!)!) == false {
            let allert = UIAlertController(title: "請檢查您的網址", message: "此網址非“https://”連線，將無法打開網頁", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else {
   
            self.uploadData() // upload to firebase
            let button = sender as? UIButton
            button?.isEnabled = false

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageView()
        doneButton.layer.cornerRadius = 20
        imageView.contentMode = .center
        defaultImagePicker.delegate = self
        defaultImagePicker.dataSource = self
//        self.contentView.delegate = self
//        self.website.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
 
    //MARK: pick image
    func pickImage() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
        imagePicker.sourceType = .photoLibrary
        
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setImageView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(alertSheet))
        
        imageView.addGestureRecognizer(tap)
        
        imageView.isUserInteractionEnabled = true
        
        imageView.image = image
        
        imageView.tintColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFit
    }
    
    func defaultImage() {
        let fullScreenSize  = UIScreen.main.bounds.size
        defaultImagePicker.frame = (frame: CGRect(x: 0, y: fullScreenSize.height - 400, width: fullScreenSize.width, height: 250))
        
        self.view.addSubview(defaultImagePicker)
        defaultImagePicker.backgroundColor = UIColor(red: 70/255, green: 195/255, blue: 219/255, alpha: 1)
        defaultImagePicker.delegate = self
        defaultImagePicker.dataSource = self

    }
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var rowString = String()
        
        switch row {
        case 0:
            rowString = "美式料理"
            
        case 1:
            rowString = "義式料理"
            
        case 2:
            rowString = "日式料理"
            
        case 3:
            rowString = "甜點"
            
        case 4:
            rowString = "中式料理"

        case 5:
            rowString = "其他"
        
        default:
            print("out of range")
            
        }
        return rowString

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        FIRDatabase.database().reference().child("defaultImage").child("food").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let downLoadUrl = snapshot.value as? [String: Any] else { return }
                guard let dessert = downLoadUrl["dessert"] as? String,
                      let italy = downLoadUrl["italy"] as? String,
                      let japan = downLoadUrl["Japan"] as? String,
                      let america = downLoadUrl["america"] as? String,
                      let chinese = downLoadUrl["Chinese"] as? String,
                      let other = downLoadUrl["other"] as? String else { return }
    
                switch row {
                case 0:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: america)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    guard let americaData = data else { return }
                    let americaPic = UIImage(data: americaData)
                    self.imageView.image = americaPic
                    }
    
                case 1:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: italy)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        guard let italyData = data else { return }
                        let italyPic = UIImage(data: italyData)
                        self.imageView.image = italyPic
                    }
    
                case 2:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: japan)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        guard let japanData = data else { return }
                        let japanPic = UIImage(data: japanData)
                        self.imageView.image = japanPic
                    }
    
                case 3:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: dessert)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        guard let dessertData = data else { return }
                        let dessertPic = UIImage(data: dessertData)
                        self.imageView.image = dessertPic
                    }
                    
                case 4:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: chinese)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        guard let chineseData = data else { return }
                        let chinesePic = UIImage(data: chineseData)
                        self.imageView.image = chinesePic
                    }

    
                case 5:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: other)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        guard let otherData = data else { return }
                        let otherPic = UIImage(data: otherData)
                        self.imageView.image = otherPic
                    }
                default:
                    print("default error")
                }
            
                pickerView.removeFromSuperview()
            })

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return foodTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func alertSheet() {
        let alterController = UIAlertController(title: "選擇圖片", message: "選擇圖片來源", preferredStyle: .actionSheet)
        let fromPhoto = UIAlertAction(title: "從相簿選取", style: .default) { (UIAlertAction) in
            self.pickImage()
        }
        let fromDefault = UIAlertAction(title: "選擇內建圖片", style: .default) { (UIAlertAction) in
            self.defaultImage()
        }

        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alterController.addAction(fromPhoto)
        alterController.addAction(fromDefault)
        alterController.addAction(cancel)
        self.present(alterController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            //imageView.frame = CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height)
            
            imageView.image = pickedImage
            // default image picker
            imageView.contentMode = .scaleAspectFit
        }
            dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    func uploadData() {
        //let filePath = "\(FIRAuth.auth()?.currentUser?.uid)/\("userPhoto")"
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("\(imageName).jpg")
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        if let uploadData = UIImageJPEGRepresentation(imageView.image!, 0.1) {
        storageRef.put(uploadData, metadata: nil, completion: { (storeMetaData, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "")
                    return
                }
            if let uid = FIRAuth.auth()?.currentUser?.uid,
               let url = self.website.text,
               let title = self.temperaryTitle.text,
               let content = self.contentView.text,
               let imageURL = storeMetaData?.downloadURL()?.absoluteString {
               let userRef = self.ref.child(uid).childByAutoId()
               let value = ["title": title, "url": url, "order": CellDataManager.shared.cellArray.count, "content": content, "image": imageURL, "cellID": userRef.key] as [String : Any]
                    userRef.setValue(value)
              
                    //let foodController = self.navigationController?.childViewControllers[0].childViewControllers[0] as? FoodCollectionViewController
                
                   // foodController?.collectionView?.reloadData()
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
//                _ = self.navigationController?.popToRootViewController(animated: true)
                //self.navigationController?.popViewController(animated: true)
//                  print(self.navigationController?.childViewControllers[0].childViewControllers[0])
//                    self.delegate = foodController
//                    self.delegate?.isUploaded()
                }
            })
         
        }

    }
    
    // MARK: handle keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//extension Step1ViewController: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }

//    func textViewDidBeginEditing(_ textView: UITextView) {
//        contentView = textView
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        contentView = nil
//
//    }
//    
//    func keyboardWasShown(notification: NSNotification){
//        //Need to calculate keyboard exact size due to Apple suggestions
//        self.scrollView.isScrollEnabled = true
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
//        
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//        
//        var aRect : CGRect = self.view.frame
//        aRect.size.height -= keyboardSize!.height
//        if let activeField = self.contentView {
//            if (!aRect.contains(activeField.frame.origin)){
//                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
//            }
//        }
//    }
//    
//    func keyboardWillBeHidden(notification: NSNotification){
//        //Once keyboard disappears, restore original positions
//        var info = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
//        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
//        self.scrollView.contentInset = contentInsets
//        self.scrollView.scrollIndicatorInsets = contentInsets
//        self.view.endEditing(true)
//        self.scrollView.isScrollEnabled = false
//    }
    
//}
