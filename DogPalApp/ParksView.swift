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
    @State private var directions: [MKRoute] = []
    @State private var parkInfo: String = "Park Information: Beautiful park to walk your dog."
    
    // Lista de parques em Montreal
      let parks = [
          ParkLocation(coordinate: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673)),
          ParkLocation(coordinate: CLLocationCoordinate2D(latitude: 45.5088, longitude: -73.5530)),
          ParkLocation(coordinate: CLLocationCoordinate2D(latitude: 45.5200, longitude: -73.6167)),
          ParkLocation(coordinate: CLLocationCoordinate2D(latitude: 45.4230, longitude: -73.6032)),
          ParkLocation(coordinate: CLLocationCoordinate2D(latitude: 45.4710, longitude: -73.5590))
      ]

    var body: some View {
        VStack {
            
            Image("DogPalLogo2")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 350, height: 150)
            
            TextField("Find the best park next to you", text: $searchText, onCommit: {
                geocodeAddress(address: searchText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .frame(height: 50)

            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: parks) { park in
                               MapPin(coordinate: park.coordinate, tint: .red) // Pin RED
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
