//
//  DogWalkerSelectionView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-30.
//

import SwiftUI

struct DogWalkerSelectionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack {
            
            Image("DogPalLogo2")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 350, height: 150)
            
            VStack(alignment: .leading) {
                Text("Available Dog Walkers")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
            }
            
            
            // Aqui você pode adicionar uma lista de dog walkers e sua localização
            // Esta parte deve ser implementada com a lógica para pegar os walkers via Mappls API
            
            
            
            List {
                ForEach(0..<10) { index in
                    Text("Dog Walker \(index + 1)") 
                }
            }
            
            Spacer()
        }
        .navigationBarTitle("Dog Walkers", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Label("Back", systemImage: "arrow.left")
                }
            }
        }
    }
}

#Preview {
    DogWalkerSelectionView()
}
