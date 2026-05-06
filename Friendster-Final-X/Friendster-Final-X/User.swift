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
    
    var username: String = "Ider"
    var password: String = "1234"
    
    private init() {}
}
