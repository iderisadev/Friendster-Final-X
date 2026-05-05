//
//  ContentView.swift
//  TestFinalProject
//
//  Created by Mobile on 5/1/26.
//

import SwiftUI
import MapKit

struct ContentView: View {
   
    var body: some View {
        TabView {
            Tab("Home", systemImage:"house"){
                Home()
            }
            Tab("Public Map", systemImage:"globe.americas"){
                PublicMap()
            }

        }
            

    }
}

#Preview {
    ContentView()
}
