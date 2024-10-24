//
//  DogWalkingBookingView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-24.
//

import SwiftUI
import MapKit

struct DogWalkBookingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var region = MKCoordinateRegion(
        
           center: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673),
           span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
       )
    
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            
                   VStack() {
                       
                       Image("DogPalLogo2")
                           .resizable()
                           .scaledToFit()
                           .padding()
                           .frame(width: 350, height: 150)
                       
                       Text("Doggo Walker")
                           .font(.largeTitle)

                       Image("dogwalkerprofile")
                           .resizable()
                           .scaledToFit()
                           .clipShape(Circle())
                           .frame(width: 100, height: 100)
                           .padding()

                       VStack(alignment: .leading, spacing: 10) {
                           Text("About Me")
                               .font(.headline)

                           Text("I'm a passionate dog lover with over 3 years of experience in dog walking. I ensure your furry friend gets the best care during our walks!")
                               .font(.subheadline)
                               .padding(10)
                               .background(Color(.systemGray6))
                               .cornerRadius(8)
                       }
                       .padding(.horizontal)

                   
                       HStack {
                           VStack(alignment: .leading) {
                               Text("Price: $20 per walk")
                                   .font(.headline)

                               // Mapa pequeno
                               Map(coordinateRegion: $region, showsUserLocation: true)
                                   .frame(height: 100)
                                   .cornerRadius(10)
                                   .padding(.top, 10)
                           }
                           .padding()
                       }

                       // Reviews
                       VStack(alignment: .leading) {
                           Text("Reviews")
                               .font(.headline)
                               .padding(.top)

                           Text("⭐️⭐️⭐️⭐️⭐️ - \"Great experience! My dog loved the walk!\"")
                           Text("⭐️⭐️⭐️⭐️ - \"Very reliable and caring!\"")
                       }
                       .padding(.horizontal)

                       Spacer()

                       
                       Button(action: {
                         
                           print("Reserva realizada para \(selectedDate.formatted())!")
                       }) {
                           Text("Confirm Booking")
                               .font(.headline)
                               .foregroundColor(.white)
                               .padding()
                               .background(Color.brown)
                               .cornerRadius(10)
                       }
                       .padding(.bottom)
                   }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Back", systemImage: "arrow.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Cancel", systemImage: "xmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    DogWalkBookingView()
}

