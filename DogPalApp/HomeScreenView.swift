//
//  HomeScreenView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-30.
//

import SwiftUI

struct HomeScreenView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 20) {
                
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                
                Text("Welcome to DogPal!")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Text("Let's take a walk, woof")
                    Image(systemName: "pawprint.fill")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                }
                
                // Navegação para se tornar um Dog Walker
                NavigationLink(destination: DogWalkerProfileCreationView()) {
                    Text("Become a Dog Walker")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color.textFields)
                        )
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                
                NavigationLink(destination: DogRegistrationScreenView()) {
                    Text("Book a Dog Walker")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color.textFields)
                        )
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
            }
                .padding()
                
            }
        }
    }


#Preview {
    HomeScreenView()
}
