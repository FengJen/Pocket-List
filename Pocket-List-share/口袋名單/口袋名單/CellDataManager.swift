import Foundation
import Firebase
import FirebaseDatabase

class CellDataManager {
    static let shared = CellDataManager()
    
    var cellArray: [CellModel] = []
    let ref = FIRDatabase.database().reference()
        //var user: User?
    
    //typealias editData = (_ value: String) -> Void
    
    func getCellData(completion: @escaping (_ value: [CellModel]?, _ exist: Bool) -> Void) {
        var value: [CellModel] = [] //?
        let uid = FIRAuth.auth()?.currentUser?.uid
        //.queryOrdered(byChild: "order")
        self.ref.child("pocketList").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
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
                        let picture = UIImage(data: imageData)
                        let cellModel = CellModel(autoID: autoID, title: title, url: url, order: order, content: content, image: picture)
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
    func reorderCellData(completion: @escaping (_ value: [CellModel]) -> Void) {
        //guard let unwrapUid = uid else { return }
        //var value: [CellModel] = []
        
        //self.ref.child("pocketList").child(unwrapUid)
        }
    
}
