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


//@main
//struct DogPalAppApp: App {
//    init(){
//        FirebaseApp.configure()
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            SplashScreenView()
//        }
//    }
//}
@main
struct DogPalApp: App {
    // Create an AppDelegate to handle Firebase initialization
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

// Create a separate AppDelegate class to handle Firebase initialization
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
