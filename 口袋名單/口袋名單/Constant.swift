import Foundation
import Firebase

struct constants {
    static let uid = FIRAuth.auth()?.currentUser?.uid 
}
