//
//  SplashScreenView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-17.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.9
    @State private var isLoginPresented = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if isActive{
            LoginView()
        }else {
            ZStack{
                Color(colorScheme == .dark ? .black : .white)
                                   .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("DogPalLogo2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 275, height: 500)
                        .clipShape(Ellipse())
//                        .scaleEffect(size)
                        .opacity(opacity)
                    
                    HStack{
                        Text("Let's take a walk, woof")
                        Image(systemName: "pawprint.fill")
                            .font(.title)
                            .fontWeight(.bold)
                            
                        
                    }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                        self.isActive = true
                    }
                }
                
            }
            .padding()
            .preferredColorScheme(colorScheme)
        }
    }
}

#Preview {
    SplashScreenView()
}
