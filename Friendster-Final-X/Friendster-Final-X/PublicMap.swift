//
//  ContentView.swift
//  TestFinalProject
//
//  Created by Mobile on 5/1/26.
//

import SwiftUI
import MapKit

struct PublicMap: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.4208, longitude: -119.6982),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    @ObservedObject private var store = PinStore.shared
    @State private var isAddingPin = false
    @State private var showForm = false
    @State private var newTitle = ""
    @State private var newSubtitle = ""

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { proxy in
                    Map(position: $position) {
                        ForEach(store.pins) { pin in
                            Marker(pin.title, coordinate: pin.coordinate)
                        }
                    }
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.3)
                            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                            .onEnded { value in
                                guard isAddingPin else { return }
                                switch value {
                                case .second(true, let drag):
                                    if let location = drag?.location,
                                       let coord = proxy.convert(location, from: .local) {
                                        store.addPin(coordinate: coord, title: newTitle.isEmpty ? "New Pin" : newTitle, subtitle: newSubtitle, username: User.shared.username)
                                        isAddingPin = false
                                        newTitle = ""
                                        newSubtitle = ""
                                    }
                                default:
                                    break
                                }
                            }
                    )
                    .ignoresSafeArea()
                }

                if isAddingPin {
                    Text("Hold on the map to place your pin")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding(.bottom, 60)
                }

                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        Button("Santa Barbara") {
                            position = .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 34.4208, longitude: -119.6982),
                                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                            ))
                        }
                        .buttonStyle(.borderedProminent)

                        if !store.pins.isEmpty && store.pins.contains(where: { $0.username == User.shared.username }) {
                            Button("Clear Pins") {
                                store.removeAll()
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showForm = true
                    } label: {
                        Image(systemName: isAddingPin ? "xmark" : "plus")
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                NavigationStack {
                    Form {
                        Section("Pin Details") {
                            TextField("Title", text: $newTitle)
                            TextField("Subtitle", text: $newSubtitle)
                        }
                    }
                    .navigationTitle("New Pin")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showForm = false
                                newTitle = ""
                                newSubtitle = ""
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Next") {
                                showForm = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isAddingPin = true
                                }
                            }
                            .disabled(newTitle.isEmpty)
                        }
                    }
                }
                .presentationDetents([.fraction(0.35)])
            }
        }
    }
}

#Preview {
    PublicMap()
}
