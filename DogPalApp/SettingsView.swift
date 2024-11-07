//
//  ProfileView.swift
//  DogPalApp
//
//  Created by Julien Villanti on 2024-10-22.
//

import SwiftUI

struct SettingsView: View {
    let userEmail: String
    @StateObject private var userManager = UserManager()
    @State private var showingSignOutAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding()
            
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Logged in as: \(userEmail)")
                .font(.title2)
            
            // Add some example profile sections
            List {
                Section("Account Settings") {
                    NavigationLink("Edit Profile") {
                        Text("Edit Profile View")
                    }
                    NavigationLink("Privacy Settings") {
                        Text("Privacy Settings View")
                    }
                    NavigationLink("Notifications") {
                        Text("Notifications View")
                    }
                }
                
                Section("App Settings") {
                    NavigationLink("Preferences") {
                        Text("Preferences View")
                    }
                    NavigationLink("Help & Support") {
                        Text("Help & Support View")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingSignOutAlert = true
                    } label: {
                        Text("Sign Out")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                userManager.signOut()
                // Handle navigation back to login screen
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            SettingsView(userEmail: "test@example.com")
        }
    }
}
