//  DogWalkBookingView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-22.
//

import SwiftUI

struct DogWalkBookingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)

                VStack(alignment: .leading) {
                    Text("Book a Walk")
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                }

                Spacer()
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

