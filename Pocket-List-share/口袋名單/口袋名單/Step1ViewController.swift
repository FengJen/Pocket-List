import UIKit
import Firebase
import FirebaseDatabase

protocol Step1ViewControllerDelegete: class {
    func isUploaded()
}



class Step1ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    let foodTypes: [String] = ["請選擇", "美式料理", "義式料理", "日式料理", "中式料理", "韓式料理", "泰式料理", "甜點", "其他"]
    var some: String = ""
    
    let defaultImagePicker = UIPickerView()
    let doneButtonInPicker = UIButton()
    let classPicker = UIPickerView()
    let gradientLayer = CAGradientLayer()
    let skyBlue = UIColor(red: 82/255, green: 128/255, blue: 242/255, alpha: 1)
    weak var delegate: Step1ViewControllerDelegete?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var temperaryTitle: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var imageView: UIImageView!    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var classSegment: UISegmentedControl!
    let ref = FIRDatabase.database().reference().child("pocketList")
    
    let image = #imageLiteral(resourceName: "images-icon").withRenderingMode(.alwaysTemplate)
    
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
        doneButtonSetUp()
        label.textColor = skyBlue
        
        imageView.contentMode = .scaleAspectFit
        defaultImagePicker.delegate = self
        defaultImagePicker.dataSource = self
//        self.view.backgroundColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
        website.layer.borderColor = skyBlue.cgColor
        website.layer.borderWidth = 2
        website.attributedPlaceholder = NSAttributedString(string: "請輸入網址", attributes: [NSForegroundColorAttributeName: skyBlue])
        temperaryTitle.layer.borderColor = skyBlue.cgColor
        temperaryTitle.layer.borderWidth = 2
        temperaryTitle.attributedPlaceholder = NSAttributedString(string: "請輸入標題", attributes: [NSForegroundColorAttributeName: skyBlue])
        classSegment.tintColor = skyBlue
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hidePickerView))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.cornerRadius = 20
    }
   
    func doneButtonSetUp() {
                
        gradientLayer.frame = self.doneButton.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor(red: 117/255, green: 203/255, blue: 223/255, alpha: 1).cgColor, UIColor(red: 90/255, green: 120/255, blue: 191/255, alpha: 1).cgColor]
        
        self.doneButton.layer.addSublayer(gradientLayer)
    }
    // MARK: pick image
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
        //todo dismiss pickerview
        let fullScreenSize  = UIScreen.main.bounds.size
        defaultImagePicker.frame = CGRect(x: 0, y: fullScreenSize.height - 250, width: fullScreenSize.width, height: 250)
        
        defaultImagePicker.backgroundColor = UIColor(red: 220/255, green: 223/255, blue: 225/255, alpha: 1)
        defaultImagePicker.delegate = self
        defaultImagePicker.dataSource = self
        
        self.view.addSubview(defaultImagePicker)
  
        

    }
    
    func hidePickerView() {
        //self.view.endEditing(true)
        defaultImagePicker.removeFromSuperview()
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var rowString = String()
        if pickerView == defaultImagePicker {
            rowString = foodTypes[row]

        } else if pickerView == classPicker {
            switch row {
                
            case 0:
                rowString = "請選擇"
            case 1:
                rowString = "美食"
            case 2:
                rowString = "景點"
            default: break
                //print(123)
            }
        }
        return rowString

    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == defaultImagePicker {
            
            FIRDatabase.database().reference().child("defaultImage").child("food").observeSingleEvent(of: .value, with: { (snapshot) in
                guard let downLoadUrl = snapshot.value as? [String: Any] else { return }
                guard let dessert = downLoadUrl["dessert"] as? String,
                      let italy = downLoadUrl["italy"] as? String,
                      let japan = downLoadUrl["Japan"] as? String,
                      let america = downLoadUrl["america"] as? String,
                      let korea = downLoadUrl["korea"] as? String,
                      let chinese = downLoadUrl["Chinese"] as? String,
                      let thai = downLoadUrl["thai"] as? String,
                      let other = downLoadUrl["other"] as? String else { return }
    
                switch row {
                case 1:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: america)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                    guard let americaData = data else { return }
                    let americaPic = UIImage(data: americaData)
                    self.imageView.image = americaPic
                    self.imageView.contentMode = .scaleAspectFit
                    }
    
                case 2:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: italy)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                        guard let italyData = data else { return }
                        let italyPic = UIImage(data: italyData)
                        self.imageView.image = italyPic
                    }
    
                case 3:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: japan)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                        guard let japanData = data else { return }
                        let japanPic = UIImage(data: japanData)
                        self.imageView.image = japanPic
                    }
    
                case 4:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: chinese)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                        guard let chineseData = data else { return }
                        let chinesePic = UIImage(data: chineseData)
                        self.imageView.image = chinesePic
                    }
    
                case 5:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: korea)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                        guard let koreaData = data else { return }
                        let koreaPic = UIImage(data: koreaData)
                        self.imageView.image = koreaPic
                    }
                    
                case 6:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: thai)
                    print(thai)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                        guard let thaiData = data else { return }
                        let thaiPic = UIImage(data: thaiData)
                        self.imageView.image = thaiPic
                    }
                    
                case 7:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: dessert)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                        guard let dessertData = data else { return }
                        let dessertPic = UIImage(data: dessertData)
                        self.imageView.image = dessertPic
                    }
                    
                case 8:
                    
                    let storageRef = FIRStorage.storage().reference(forURL: other)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                        guard let otherData = data else { return }
                        let otherPic = UIImage(data: otherData)
                        self.imageView.image = otherPic
                    }
                    
                default:
                    let storageRef = FIRStorage.storage().reference(forURL: other)
                    storageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, _) -> Void in
                        guard let otherData = data else { return }
                        let otherPic = UIImage(data: otherData)
                        self.imageView.image = otherPic
                    }
                }
            
            })
            
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == defaultImagePicker {
        return foodTypes.count
        } else if pickerView == classPicker {
        return 3
        } else {
        return 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func alertSheet() {
        let alterController = UIAlertController(title: "選擇圖片", message: "選擇圖片來源", preferredStyle: .actionSheet)
        let fromPhoto = UIAlertAction(title: "從相簿選取", style: .default) { (_) in
            self.pickImage()
        }
        let fromDefault = UIAlertAction(title: "選擇內建圖片", style: .default) { (_) in
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
            
            imageView.image = pickedImage
            
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
               let whatClass = self.classSegment.titleForSegment(at: self.classSegment.selectedSegmentIndex),
               let url = self.website.text,
               let title = self.temperaryTitle.text,
               let content = self.contentView.text,
               
               let imageURL = storeMetaData?.downloadURL()?.absoluteString {
               let userRef = self.ref.child(uid).childByAutoId()
               let value = ["class": whatClass, "title": title, "url": url, "order": CellDataManager.shared.cellArray.count, "content": content, "image": imageURL, "cellID": userRef.key, "imageUuid": imageName] as [String : Any]
               //let value = ["title": title, "url": url, "order": CellDataManager.shared.cellArray.count, "content": content, "image": imageURL, "cellID": userRef.key] as [String : Any]
                    userRef.setValue(value)
              
                //guard let parentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController") as? ParentViewController else { return }
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentViewController")
                self.navigationController?.pushViewController(vc, animated: true)
                //self.navigationController?.popToRootViewController(animated: true)


//                let foodVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoodCollectionViewController")
//                let siteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SitesCollectionViewController")
//                    if self.chooseClassField.text == "美食" {
//                        self.navigationController?.popToRootViewController(animated: true)
//                        //self.show(foodVC, sender: self)
//                        
//                    } else if self.chooseClassField.text == "景點" {
//                        
//                        self.navigationController?.pushViewController(siteVC, animated: true)
//                }
                }
            })
         
        }

    }
        
}
