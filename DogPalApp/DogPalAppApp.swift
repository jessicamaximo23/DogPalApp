//
//  DogPalAppApp.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-17.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

@main
struct DogPalAppApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
            WindowGroup {
                SplashScreenView()
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)  
            }
        }
}
