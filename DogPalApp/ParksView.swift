//
//  ParksView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-11-14.
//

import SwiftUI
import MapKit

struct ParksView: View {
    @State private var searchText = ""
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var location: ParkLocation?

    var body: some View {
        VStack {
           
            TextField("Find the best park next to you", text: $searchText, onCommit: {
                geocodeAddress(address: searchText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

          
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: location == nil ? [] : [location!]) { parkLocation in
                MapPin(coordinate: parkLocation.coordinate, tint: .blue)

            }
            .edgesIgnoringSafeArea(.all)
        }
        .padding()
    }

    
    func geocodeAddress(address: String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate {
                location = ParkLocation(coordinate: coordinate)
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
    }
}


struct ParkLocation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
}

#Preview {
    ParksView()
}
