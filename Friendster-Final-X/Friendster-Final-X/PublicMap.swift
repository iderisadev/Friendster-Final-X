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
    @State private var selectedPin: Pin? = nil
    @State private var newDate = Date()
    @State private var refresh = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { proxy in
                    Map(position: $position) {
                        ForEach(store.pins) { pin in
                            Annotation("", coordinate: pin.coordinate) {
                                Button {
                                    selectedPin = pin
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(pin.attendees.contains(User.shared.username) ? .purple : .red)
                                            .frame(
                                                width: pin.attendees.contains(User.shared.username) ? 35 : 30,
                                                height: pin.attendees.contains(User.shared.username) ? 35 : 30
                                            )
                                        Image(systemName: "mappin")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                }
                            }
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
                                        store.addPin(coordinate: coord, title: newTitle.isEmpty ? "New Pin" : newTitle, subtitle: newSubtitle, username: User.shared.username, Date1: newDate)
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
                        Button("") {
                            position = .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 34.4208, longitude: -119.6982),
                                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                            ))
                        }
                        .buttonStyle(.borderedProminent)
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
                            DatePicker("Date", selection: $newDate, displayedComponents: [.date, .hourAndMinute])
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
            .sheet(item: $selectedPin) { pin in
                NavigationStack {
                    Form {
                        Section("Pin Info") {
                            LabeledContent("Title", value: pin.title)
                            LabeledContent("Date", value: pin.date.formatted(date: .abbreviated, time: .shortened))
                            LabeledContent("Information", value: pin.subtitle)
                            LabeledContent("Posted By", value: pin.username)
                            LabeledContent("Attending", value: pin.attendees.isEmpty ? "None" : pin.attendees.joined(separator: ", "))
                        }
                        Section {
                            if pin.username == User.shared.username {
                                Button("Delete Event") {
                                    store.pins.removeAll { $0.id == pin.id }
                                    selectedPin = nil
                                }
                                .foregroundStyle(.red)
                            } else {
                                Button(pin.attendees.contains(User.shared.username) ? "Leave Event" : "Join Event") {
                                    if pin.attendees.contains(User.shared.username) {
                                        pin.attendees.removeAll { $0 == User.shared.username }
                                    } else {
                                        pin.attendees.append(User.shared.username)
                                    }
                                    refresh.toggle()
                                }
                                .foregroundStyle(pin.attendees.contains(User.shared.username) ? .red : .blue)
                            }
                        }
                    }
                    .id(refresh)
                    .navigationTitle(pin.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                selectedPin = nil
                            }
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
