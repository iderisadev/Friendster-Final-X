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

    var body: some View {
        ZStack(alignment: .bottom) {
            MapReader { proxy in
                Map(position: $position) {
                    ForEach(store.pins) { pin in
                        Marker(pin.title, coordinate: pin.coordinate)
                    }
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                        .onEnded { value in
                            switch value {
                            case .second(true, let drag):
                                if let location = drag?.location,
                                   let coord = proxy.convert(location, from: .local) {
                                    store.addPin(coordinate: coord)
                                }
                            default:
                                break
                            }
                        }
                )
                .ignoresSafeArea()
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

                    if !store.pins.isEmpty {
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
    }
}

#Preview {
    PublicMap()
}
