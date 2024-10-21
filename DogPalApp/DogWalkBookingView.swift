//
//  DogWalkBookingView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-21.
//

import SwiftUI

struct DogWalkBookingView: View {
    var body: some View {
       
        NavigationView{
            VStack {
                
                //Logo
                Image("dogpal-high-resolution-logo-transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .colorMultiply(Color.brown)
                
                Text("Book a Walk")
                    .font(.title)
            }
                      .navigationBarItems(
                          leading: Button(action: {
                              print("Back")
                          }) {
                              HStack {
                                  Image(systemName: "chevron.left")
                              }
                          },
                          trailing: Button("Cancel") {
                              print("Cancelled")
                          }
                      )
                  }
              }
          }
#Preview {
    DogWalkBookingView()
}
