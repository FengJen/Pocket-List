import Foundation
import Firebase
import FirebaseDatabase

class CellDataManager {
    static let shared = CellDataManager()
    
    var cellArray: [CellModel] = []
    let ref = FIRDatabase.database().reference()
        //var user: User?
    
    //typealias editData = (_ value: String) -> Void
    
    func getCellData(whatClass: String, completion: @escaping (_ value: [CellModel]?, _ exist: Bool) -> Void) {
        var value: [CellModel] = [] //?
        let uid = FIRAuth.auth()?.currentUser?.uid
        //.queryOrdered(byChild: "order")
        self.ref.child("pocketList").child(uid!).queryOrdered(byChild: "class").queryEqual(toValue: whatClass).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                guard let taskSnapshot = child as? FIRDataSnapshot else { return }
                let autoID = taskSnapshot.key
            
                guard let children = taskSnapshot.value as? [String: AnyObject] else { return }
                guard let title = children["title"] as? String,
                      let order = children["order"] as? Int,
                      let content = children["content"] as? String,
                      let downloadURL = children["image"] as? String,
                      //let imageID = children["imageID"] as? String,
                      let url = children["url"] as? String else { return }
                
                let storageRef = FIRStorage.storage().reference(forURL: downloadURL)
                
//                storageRef.downloadURL(completion: { (imageurl, error) in
//                    if error != nil {
//                        print(error?.localizedDescription ?? "")
//                    }
//                    guard let data = NSData(contentsOf: imageurl!) as? Data else { return }
//                    let image = UIImage(data: data)
//                    let cellModel = CellModel(autoID: autoID, title: title, url: url, order: order, content: content, image: image)
//                    value.append(cellModel)
//
//                })
                    storageRef.data(withMaxSize: (1 * 1024 * 1024), completion: { (data, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }
                        
                        guard let imageData = data else { return }
                        guard let picture = UIImage(data: imageData) else { return }
                        let resizePic = self.resizeImage(image: picture, targetSize: CGSize(width: 200, height: 200))
                        let cellModel = CellModel(autoID: autoID, title: title, url: url, order: order, content: content, image: resizePic)
                        value.append(cellModel)
                         completion(value, true)
                    })
            }
            if snapshot.exists() == false {
                completion([], false)
            }
        })
    }
    
    /*
     }
     func fetchUsers() {
     let reference = FIRDatabase.database().reference()
     reference.child("pocketList").child(uid!).queryOrdered(byChild: "title").queryEqual(toValue: "1").observeSingleEvent(of: .value, with: { (snapshot) in
     })
     (of: .value, with: { snapshot in
     print(snapshot.value)
     print(snapshot.key)
     self.collectionView?.reloadData()
     })
     */
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
