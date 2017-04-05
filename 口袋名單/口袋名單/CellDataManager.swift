import Foundation
import Firebase
import FirebaseDatabase

class CellDetaManager {
    static let shared = CellDetaManager()
    
    let ref = FIRDatabase.database().reference()
    //var user: User?
    
    typealias editData = (_ value: String) -> Void
    
    func getCellData(completion: @escaping (_ value: [CellModel]?) -> Void) {
        var value: [CellModel] = []
        let uid = FIRAuth.auth()?.currentUser?.uid
        //guard let unwrapUid = uid else { return }
        self.ref.child("user").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                guard let taskSnapshot = child as? FIRDataSnapshot else { return }
                let autoID = taskSnapshot.key
                guard let children = taskSnapshot.value as? [String: AnyObject] else { return }
                guard let title = children["title"] as? String,
                      let url = children["url"] as? String else { return }
                    
                let cellModel = CellModel(autoID: autoID, title: title, url: url)
                value.append(cellModel)
            }
                completion(value)
            
            //print(self.uid!)
        })
    }
    
    /*
     }
     func fetchUsers() {
     let reference = FIRDatabase.database().reference()
     reference.child("user").child(uid!).queryOrdered(byChild: "title").queryEqual(toValue: "1").observeSingleEvent(of: .value, with: { (snapshot) in
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
        
        //self.ref.child("user").child(unwrapUid)
        }
    
}
