import SwiftUI
import MapKit

struct Home: View {
    @ObservedObject private var user = User.shared
    @ObservedObject private var store = PinStore.shared
    
    @State private var usernameInput: String = ""
    @State private var passwordInput: String = ""
    @State private var loginError: String = ""
    
    var myEvents: [Pin] {
        store.pins.filter { $0.attendees.contains(user.username) }
    }
    
    var body: some View {
        if user.loggedIn {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Friendster")
                        .font(.largeTitle).bold()
                    Text("Hello, \(user.username)")
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
            VStack(spacing: 20) {
                Text("Friendster")
                    .font(.largeTitle).bold()
                
                Text("Sign In")
                    .font(.title2)
                
                TextField("Username", text: $usernameInput)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $passwordInput)
                    .textFieldStyle(.roundedBorder)
                
                if !loginError.isEmpty {
                    Text(loginError)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Button("Log In") {
                    handleLogin()
                }
                .buttonStyle(.borderedProminent)
                .disabled(usernameInput.isEmpty || passwordInput.isEmpty)
            }
            .padding(32)
        }
    }
    
    private func handleLogin() {
        // Replace with your real auth logic
        if !usernameInput.isEmpty && !passwordInput.isEmpty {
            user.username = usernameInput
            user.password = passwordInput
            user.loggedIn = true
            loginError = ""
        } else {
            loginError = "Please enter a username and password."
        }
    }
}

#Preview {
    Home()
}
