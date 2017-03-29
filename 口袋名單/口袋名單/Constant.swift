import Foundation
import Firebase
import FirebaseDatabase

struct Constants {
    static let ref = FIRDatabase.database().reference()
    
    static let uid = FIRAuth.auth()?.currentUser?.uid
}
