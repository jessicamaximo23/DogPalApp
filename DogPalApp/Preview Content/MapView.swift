//
//  MapView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-11-13.
//

import SwiftUI
import GoogleMaps

struct MapView: View {
    var body: some View {
        MapViewRepresentable()
            .edgesIgnoringSafeArea(.all)
    }
}

struct MapViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 10)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}
}
