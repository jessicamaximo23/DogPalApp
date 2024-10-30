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
                
              
                NavigationLink(destination: DogWalkBookingView(
                    walkerName: "Doggo Walker",
                    walkerAge: 28,
                    walkerExperience: "I have over 3 years of experience in dog walking, ensuring your furry friend gets the best care during our walks!",
                    walkValue: 20
                )) {
                    Text("I want to be a Dog Walker")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
           
                NavigationLink(destination: BecomeAWalkerView()) {
                    Text("Book a Dog Walker")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
          
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

// Placeholder para a view de se tornar um passeador
struct BecomeAWalkerView: View {
    var body: some View {
        VStack {
            Text("Seja um Passeador!")
                .font(.largeTitle)
                .padding()
            // Aqui você pode adicionar mais elementos, como um formulário para se inscrever como passeador
            Text("Formulário de inscrição em breve.")
                .padding()
        }
        .navigationTitle("Seja um Passeador")
    }
}

#Preview {
    HomeScreenView()
}
