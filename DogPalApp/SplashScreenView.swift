//
//  SplashScreenView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-17.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 1.2
    @State private var opacity = 0.9
    
    var body: some View {
        if isActive{
            HomeScreenView()
        }else {
            ZStack{
                Color("LaunchBackgroundColor")
                    .ignoresSafeArea()
                
                VStack{
                    Image("DogPalLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 275, height: 500)
                        .clipShape(Ellipse())
                    
                }
                .scaleEffect(size)
                .opacity(opacity)
                
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
