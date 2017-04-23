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
}

class Step1ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let foodTypes: [FoodType] = [.america, .dessert, .italy, .japaness]
    var some: String = ""
    weak var delegate: Step1ViewControllerDelegete?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var temperaryTitle: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    let ref = FIRDatabase.database().reference().child("pocketList")
    let image = #imageLiteral(resourceName: "images-icon").withRenderingMode(.alwaysTemplate)
    //let defaultImageRef =
    
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
   
            self.uploadData() // upload to firebase
            
//            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController")
//            navigationController?.pushViewController(vc, animated: true)

        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageView()
        
        imageView.contentMode = .center
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(alertSheet))
        
        imageView.addGestureRecognizer(tap)
        
        imageView.isUserInteractionEnabled = true
        
        imageView.image = image
        
        imageView.tintColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFit
    }
    
    func defaultImage() {
        
        let fullScreenSize  = UIScreen.main.bounds.size
        let defaultImagePicker = UIPickerView(frame: CGRect(x: 0, y: fullScreenSize.height * 0.3, width: fullScreenSize.width * 0.8, height: 200))
        self.view.addSubview(defaultImagePicker)
        defaultImagePicker.delegate = self
        defaultImagePicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker)
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
//        
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        
//        imageView.inputAccessoryView = toolBar
        
//        textField1.inputView = picker
//        textField1.inputAccessoryView = toolBar
        
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

        default:
            rowString = "其他"

        
            
            
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
    
                default:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: other)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        guard let otherData = data else { return }
                        let otherPic = UIImage(data: otherData)
                        self.imageView.image = otherPic
                    }
                    
                }
//                let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
                
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
