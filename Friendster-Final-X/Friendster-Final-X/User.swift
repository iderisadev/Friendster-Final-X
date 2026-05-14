//
//  User.swift
//  TestFinalProject
//
//  Created by Mobile on 5/1/26.
//

import Foundation
import Combine
class User: ObservableObject {
    static let shared = User()
    static var loggedIn = true
    var username: String = "ider"
    var password: String = "1234"
    
    
    private init() {}
}
