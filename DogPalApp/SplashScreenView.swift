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
    
    var body: some View {
        if isActive{
            LoginView()
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
//                        .scaleEffect(size)
                        .opacity(opacity)
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self.isActive = true
                    }
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    SplashScreenView()
}
