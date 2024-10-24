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
            ScrollView {
            
                VStack() {
                
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                    .padding(.bottom)
                
                Text("Doggo Walker")
                    .font(.largeTitle)
                
                Image("profilledoggo")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 200, height: 100)
                    .padding()
                
                VStack(alignment: .leading, spacing: 8) {
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
                        
                      
                        Map(coordinateRegion: $region, showsUserLocation: true)
                            .frame(width: 300, height: 100)
                            .cornerRadius(10)
                            .padding(.top, 10)
                    }
                   
                }
                
                // Reviews
                VStack(alignment: .leading) {
                    Text("Reviews")
                        .font(.headline)
                        .padding()
                    
                    
                    Text("⭐️⭐️⭐️⭐️⭐️ - \"Great experience! My dog loved the walk!\"")
                        .padding()
                    
                    Text("⭐️⭐️⭐️⭐️ - \"Very reliable and caring!\"")
                        .padding()
                    
                    Text("⭐️⭐️⭐️⭐️ - \"We love your caring!\"")
                        .padding()
                }
                .padding(.vertical)
                

                
                
                Button(action: {
                    
                    print("Reserve Confirmed \(selectedDate.formatted())!")
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
}

#Preview {
    DogWalkBookingView()
}

