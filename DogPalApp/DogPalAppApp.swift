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
import GoogleMaps

@main
struct DogPalAppApp: App {
    init(){
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyDhgtpFCPJ-1XcBpq7csfMwsFquwGs7EOI")     }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
