//
//  Home.swift
//  Friendster-Final-X
//
//  Created by Mobile on 5/5/26.
//

//
//  ContentView.swift
//  TestFinalProject
//
//  Created by Mobile on 5/1/26.
//

import SwiftUI
import MapKit

struct Community: View {
    var body: some View {
        if User.shared.loggedIn==true{
            Text("Friendster")
            Text("Hello, " + String(User.shared.username))
        }
        else{
            Text("Login")
        }
    }
}


#Preview {
    Community()
}
