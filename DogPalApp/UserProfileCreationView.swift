//
//  DogWalkerProfileCreationView.swift
//  DogPalApp
//
//  Created by User on 2024-10-29.
//


import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct UserProfileCreationView: View {
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var userAge: String = ""
    @State private var dogName: String = ""
    @State private var dogBreed: String = ""
    @State private var navigateToUserProfilePage = false
   
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                
                Text("Set up your account")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                // Campos de entrada de dados
                Section {
                    TextField("Your Name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Your Email", text: $userEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Your Age", text: $userAge)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                    
                    TextField("Dog Name", text: $dogName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Dog Breed", text: $dogBreed)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                
                // Botão de envio
                Button(action: {
                    updateUserProfileStatus()
                }) {
                    Text("Submit your Info")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(20)
                }
                .disabled(userEmail.isEmpty || userName.isEmpty || userAge.isEmpty || dogName.isEmpty || dogBreed.isEmpty)
                
                NavigationLink(
                    destination: UserProfilePage(
                        userName: userName,
                        userAge: Int(userAge) ?? 0,
                        dogBreed: dogBreed,
                        dogName: dogName
                    ),
                    isActive: $navigateToUserProfilePage
                ) {
                    EmptyView()
                }
                
            }
        }
    }
        
        func updateUserProfileStatus() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let userRef = Database.database().reference().child("users").child(uid)
            let userData: [String: Any] = [
                "profileCreated": true,
                "userName": userName,
                "userEmail": userEmail,
                "userAge": userAge,
                "dogName": dogName,
                "dogBreed": dogBreed
            ]
            
            userRef.updateChildValues(userData) { error, _ in
                if let error = error {
                    print("Failed to update profile status: \(error.localizedDescription)")
                } else {
                    navigateToUserProfilePage = true
                }
        
        }
    }
}


#Preview {
    UserProfileCreationView()
}
