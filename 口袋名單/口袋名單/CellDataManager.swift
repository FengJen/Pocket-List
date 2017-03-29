import Foundation
import Firebase
import FirebaseDatabase

class CellDetaManager {
    static let shared = CellDetaManager()
    let uid = FIRAuth.auth()?.currentUser?.uid
    let ref = FIRDatabase.database().reference()
    
    func getCellData(completion: @escaping (_ value: [CellModel]?) -> Void) {
        var value: [CellModel] = []
        self.ref.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                guard let taskSnapshot = child as? FIRDataSnapshot else { continue }
                guard let children = taskSnapshot.value as? [String: AnyObject] else { return }
                guard let title = children["title"] as? String,
                      let url = children["url"] as? String else { return }
                    
                let cellModel = CellModel(title: title, url: url)
                value.append(cellModel)
            }
                completion(value)
        })
    }
}
