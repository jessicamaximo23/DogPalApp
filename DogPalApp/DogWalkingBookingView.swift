//
//  DogWalkingBookingView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-24.
//

import SwiftUI
import MapKit

struct DogWalkBookingView: View {
    
    var walkerName: String
    var walkerAge: Int
    var walkerExperience: String
    var walkValue: Int
    
    @Environment(\.dismiss) var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
<<<<<<< HEAD
            ScrollView {
            
                VStack() {
                
=======
            VStack {
>>>>>>> main
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
<<<<<<< HEAD
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
=======
                
                Text(walkerName)
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
                    
                    ScrollView {
                        Text(walkerExperience) // Exibe toda a experiência
                            .font(.subheadline)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .frame(maxHeight: 150) // Limite de altura para o campo de descrição
                }
                .padding(.horizontal)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Age: \(walkerAge)")
                            .font(.headline)
                        
                        Text("Price: $\(walkValue) per hour")
                            .font(.headline)
                        
                        Map(coordinateRegion: $region, showsUserLocation: true)
                            .frame(height: 100)
                            .cornerRadius(10)
                            .padding(.top, 10)
                    }
                    .padding()
                }
                
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
>>>>>>> main
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
    DogWalkBookingView(
        walkerName: "Doggo Walker",
        walkerAge: 28,
        walkerExperience: "I have over 3 years of experience in dog walking, ensuring your furry friend gets the best care during our walks!",
        walkValue: 20
    )
}
