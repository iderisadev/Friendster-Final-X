import Foundation
import Combine

class User: ObservableObject {
    static let shared = User()
    
    @Published var loggedIn = false
    @Published var username: String = ""
    var password: String = ""
    
    private init() {}
}
