//
//  CellDetailViewController.swift
//  口袋名單
//
//  Created by 謝豐任 on 2017/3/28.
//  Copyright © 2017年 appworks. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class CellDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var cell = CellModel()
   
    @IBOutlet weak var editTitle: UITextField!

    @IBOutlet weak var editUrl: UITextField!
    
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()

    }
    
    func setUp() {
        editTitle.text = cell.title
        editUrl.text = cell.url
        content.text = cell.content
        imageView.image = cell.image        
        
        doneButton.layer.cornerRadius = 22
    }
    // MARK: pick image
//    func pickImage() {
//        
//        let imagePicker = UIImagePickerController()
//        
//        imagePicker.delegate = self
//        
//        imagePicker.allowsEditing = true
//        
//        imagePicker.sourceType = .photoLibrary
//        
//        present(imagePicker, animated: true, completion: nil)
//    }
//    
//    func setImageView() {
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
//        
//        imageView.addGestureRecognizer(tap)
//        
//        imageView.isUserInteractionEnabled = true
//        
//        imageView.image = cell.image
//        
//        imageView.tintColor = UIColor.white
//        
//        imageView.contentMode = .scaleAspectFit
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            
//            //imageView.frame = CGRect(x: 0, y: 0, width: pickedImage.size.width, height: pickedImage.size.height)
//            
//            imageView.image = pickedImage
//            
//            imageView.contentMode = .scaleAspectFit
//        }
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        
//        dismiss(animated: true, completion: nil)
//    }
    @IBAction func editData(_ sender: UIButton) {
        guard let text = editTitle.text, let url = editUrl.text, let content = content.text else { return }
        if text == "" {
            
            let allert = UIAlertController(title: "您還未輸入標題", message: "請在輸入新增項目的標題", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else if url == "" {
            let allert = UIAlertController(title: "您還未輸入網址", message: "請複製貼上想儲存的網址（例如google map網址）", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else if UIApplication.shared.canOpenURL(URL(string: url)!) == false {
            let allert = UIAlertController(title: "請檢查您的網址", message: "此網址非“https://”連線，將無法打開網頁", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            allert.addAction(action)
            self.present(allert, animated: true, completion: nil)
        } else {
        guard let cellAutoID = self.cell.autoID, let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let editRef = FIRDatabase.database().reference().child("pocketList").child(uid).child(cellAutoID)
        
        editRef.updateChildValues(["title": text])
        editRef.updateChildValues(["url": url])
        editRef.updateChildValues(["content": content])
        //editRef.updateChildValues(["image": imageURL ?? ""])
//        let imageName = UUID().uuidString
//        let storageRef = FIRStorage.storage().reference().child("\(imageName).jpg")
//        let metaData = FIRStorageMetadata()
//        metaData.contentType = "image/jpg"
//        if let uploadData = UIImageJPEGRepresentation(imageView.image!, 0.1) {
//            storageRef.put(uploadData, metadata: nil, completion: { (storeMetaData, error) in
//                if error != nil {
//                    print(error?.localizedDescription ?? "")
//                    return
//                }
//                guard let cellAutoID = self.cell.autoID, let uid = Constants.uid else { return }
//                let editRef = Constants.ref.child("pocketList").child(uid).child(cellAutoID)
//                let imageURL = storeMetaData?.downloadURL()?.absoluteString
//                editRef.updateChildValues(["title": text])
//                editRef.updateChildValues(["url": url])
//                editRef.updateChildValues(["content": content])
//                editRef.updateChildValues(["image": imageURL ?? ""])
//                
//            })
        
//        }
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
//        
//        performSegue(withIdentifier: "unwindSegue", sender: sender)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView == content {
            
            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
        }
        
        return true
        
    }
    
    private func textViewDidEndEditing(_ textView: UITextView) {
        
        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
