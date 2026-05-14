import SwiftUI
import MapKit

struct Home: View {
    @ObservedObject private var user = User.shared
    @ObservedObject private var store = PinStore.shared
    
    var myEvents: [Pin] {
        store.pins.filter { $0.attendees.contains(User.shared.username) }
    }

    var body: some View {
        if User.loggedIn == true {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Friendster")
                        .font(.largeTitle).bold()
                    Text("Hello, \(User.shared.username)")
                        .font(.subheadline)

                    ForEach(myEvents) { pin in
                        VStack(alignment: .leading) {
                            Text(pin.title)
                                .font(.headline)
                            Text(pin.date, style: .date)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                store.refresh()
            }
        } else {
            Text("Login")
        }
    }
}

#Preview {
    Home()
}
