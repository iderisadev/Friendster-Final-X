//
//  Pins.swift
//  TestFinalProject
//
//  Created by Mobile on 5/1/26.
//

import Foundation
import CoreLocation
import Combine

class Pin: Identifiable {
    let id: UUID
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var username: String
    
    static var currentUsername: String {
        PinStore.shared.pins.first?.username ?? ""
    }
    
    init(
        id: UUID = UUID(),
        coordinate: CLLocationCoordinate2D,
        title: String = "New Pin",
        subtitle: String = "",
        username: String = ""
    ) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.username = username
    }
}

class PinStore: ObservableObject {
    static let shared = PinStore()
    
    @Published var pins: [Pin] = []
    
    private init() {
        pins = [
            Pin(
                coordinate: CLLocationCoordinate2D(latitude: 34.45330, longitude: -119.70295),
                title: "Harvey Execution",
                subtitle: "We are killing Harvey",
                username: "Joseph Tinkerbell"
            ),
            Pin(coordinate: CLLocationCoordinate2D(latitude: 34.4140, longitude: -119.8489), title: "Lecture", subtitle: "Random lecture at UCSB at whatever time", username: "Joseph Tinkerbell"),
            Pin(coordinate: CLLocationCoordinate2D(latitude: 34.4101, longitude: -119.6853), title: "Matt's Work", subtitle: "Matthew Works Here", username: "Joseph Tinkerbell"),
        ]
    }
    
    func addPin(coordinate: CLLocationCoordinate2D, title: String = "New Pin", subtitle: String = "", username: String = "") {
        let pin = Pin(coordinate: coordinate, title: title, subtitle: subtitle, username: username)
        pins.append(pin)
    }
    
    func removeAll() {
        //        for pin in pins{
        //            if pin.username == User.shared.username{
        //                pin.remove()
        //            }
        //        }
        pins = pins.filter { $0.username != User.shared.username }
        
        //pins.removeAll()
    }
}
