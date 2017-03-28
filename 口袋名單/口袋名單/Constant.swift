import Foundation
import Firebase
import FirebaseDatabase

struct Constants {
    let ref = FIRDatabase.database().reference()
    
    let uid = FIRAuth.auth()?.currentUser?.uid
}
