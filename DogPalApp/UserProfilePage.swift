//
//  SignUpView.swift
//  DogPalApp
//
//  Created by Wandrey Haagensen on 2024-11-06.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct UserProfilePage: View {
    
    var userName: String
    var userAge: Int
    var userEmail: String
    var dogBreed: String
    var dogName: String
    var userImage: Data?
    @State private var showHomeScreen = false
    @State private var showProfileView = false
    @State private var showingSignOutAlert = false
    @State private var navigateToLogin = false
    
    @Environment(\.dismiss) var dismiss
 
    @State private var selectedDate = Date()
    
    var body: some View {
       
                VStack {
                    Image("DogPalLogo2")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 350, height: 150)
                    
                    Text(userName)
                        .font(.title)
                    
                    if let imageData = userImage, let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About Me")
                            .font(.title)
                            .padding()
                      
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Email: \(userEmail)")
                            .font(.headline)
                            .foregroundColor(.blue)

                        Text("Age: \(userAge)")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        Text("Dog Name: \(dogName)")
                            .font(.headline)
                            .foregroundColor(.purple)
                        
                        Text("Dog Breed: \(dogBreed)")
                            .font(.headline)
                            .foregroundColor(.orange)
                        
                        Spacer()
                    }
                    
                    Button(role: .destructive) {
                        showingSignOutAlert = true
                    } label: {
                        Text("Sign Out")
                            .font(.title)
                            .padding()
                    }
                }
            
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView()
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                    signOutFirebase()  // Chama a função de logout
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
            

        
    }
    func signOutFirebase() {
           do {
               try Auth.auth().signOut()  // Realiza o logout no Firebase
               navigateToLogin = true     // Atualiza o estado para navegar
           } catch {
               print("Error signing out: \(error.localizedDescription)")
        }
    }
}


#Preview {
    UserProfilePage(userName: "",
                    userAge: 0,
                    userEmail: "",
                    dogBreed: "",
                    dogName: "")
}
