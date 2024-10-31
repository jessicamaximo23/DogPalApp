//
//  HomeScreenView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-30.

import SwiftUI

struct HomeScreenView: View {
    
    @State private var parks = [
        Park(name: "Parque Lafontaine", rating: 4.8, imageName: "park1"),
        Park(name: "Parque Jean-Drapeau", rating: 4.7, imageName: "park2"),
        Park(name: "Parque Angrignon", rating: 4.6, imageName: "park3")
    ]
    
    @Environment(\.dismiss) var dismiss
    @State private var userName: String = ""
    @State private var userImage: String = "userImage"
    
    var body: some View {
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false){
                VStack {
                    HStack{
                        Spacer()
                        
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .font(.title)
                        }
                    }
                    
                    Image("profilledoggo")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 130, height: 130)
                        .padding()
                    
                    Text("Welcome, \(userName)!")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack {
                        Text("Let's take a walk, woof")
                        Image(systemName: "pawprint.fill")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                    }
                    
                    Image("map")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 350, height: 250)
                    
                    Text("Best Parks in Montreal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 15) {
                        ForEach(parks) { park in
                        ParkCardView(park: park)
                            }
                        }
                        .padding()
                            }                }
                .padding()
                
            }
        }
    }
    
    struct SettingsView: View {
        
        var body: some View {
            
            Text("Settings Screen")
                .font(.largeTitle)
                .padding()
        }
    }
    
    struct ParkCardView: View {
        var park: Park
        
        var body: some View {
            VStack {
                Image(park.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 100)
                    .cornerRadius(10)
                
                Text(park.name)
                    .font(.headline)
                    .padding(.top, 5)
                
                Text("Rating: \(park.rating, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                NavigationLink(destination: ParkDetailView(park: park)) {
                    Text("View Park")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.top, 5)
                }
            }
            .frame(width: 150)
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}

struct Park: Identifiable {
    var id = UUID()
    var name: String
    var rating: Double
    var imageName: String
}

struct ParkDetailView: View {
    var park: Park
    
    var body: some View {
        VStack {
            Text(park.name)
                .font(.largeTitle)
                .padding()
            // Adicione mais detalhes sobre o parque aqui
            Text("Rating: \(park.rating, specifier: "%.1f")")
                .font(.headline)
                .padding()
            Spacer()
        }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Screen")
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    HomeScreenView()
}
