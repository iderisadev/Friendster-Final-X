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
            Pin(coordinate: CLLocationCoordinate2D(latitude: 34.4208, longitude: -119.6982), title: "Harvey Lynching", subtitle: "We are killing Harvey", username: "Joseph Tinkerbell"),
            Pin(coordinate: CLLocationCoordinate2D(latitude: 34.4140, longitude: -119.8489), title: "Lecture", subtitle: "Random lecture at UCSB at whatever time", username: "Joseph Tinkerbell"),
        ]
    }

    func addPin(coordinate: CLLocationCoordinate2D, title: String = "New Pin", subtitle: String = "", username: String = "") {
        let pin = Pin(coordinate: coordinate, title: title, subtitle: subtitle, username: username)
        pins.append(pin)
    }

    func removeAll() {
        pins.removeAll()
    }
}
