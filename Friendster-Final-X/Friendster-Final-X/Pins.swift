import Foundation
import CoreLocation
import Combine

class Pin: Identifiable, ObservableObject {
    let id: UUID
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var username: String
    var date: Date
    @Published var attendees: [String]
    
    static var currentUsername: String {
        PinStore.shared.pins.first?.username ?? ""
    }
    
    init(
        id: UUID = UUID(),
        coordinate: CLLocationCoordinate2D,
        title: String = "New Pin",
        subtitle: String = "",
        username: String = "",
        date: Date,
        attendees: [String] = []
    ) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.username = username
        self.date = date
        self.attendees = attendees
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
                username: "Joseph Tinkerbell",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 12, hour: 10, minute: 30))!,
                attendees: ["Harvey","Judge Holden"]
            ),
            Pin(
                coordinate: CLLocationCoordinate2D(latitude: 34.4140, longitude: -119.8489),
                title: "Lecture",
                subtitle: "Random lecture at UCSB at whatever time",
                username: "Joseph Tinkerbell",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 12, hour: 10, minute: 30))!,
                attendees: ["Giovanni Vigna"]
            ),
            Pin(
                coordinate: CLLocationCoordinate2D(latitude: 34.4101, longitude: -119.6853),
                title: "Matt's Work",
                subtitle: "Matthew Works Here",
                username: "Joseph Tinkerbell",
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 12, hour: 9, minute: 0))!,
                attendees: ["Matthew"]
            ),
            Pin(
                coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                title: "My Rebirth",
                subtitle: "I will be done and then undone.",
                username: "Ider Kawabata",
                date: Calendar.current.date(from: DateComponents(year: 3000, month: 1, day: 1, hour: 0, minute: 0))!,
                attendees: ["Ider"]
            )
        ]
    }
    
    func addPin(coordinate: CLLocationCoordinate2D, title: String = "New Pin", subtitle: String = "", username: String = "", Date1: Date) {
        let pin = Pin(coordinate: coordinate, title: title, subtitle: subtitle, username: username, date: Date1, attendees: [username])
        pins.append(pin)
    }
    
    func removeAll() {
        pins = pins.filter { $0.username != User.shared.username }
    }
    
    func refresh() {
        objectWillChange.send()
    }
}
