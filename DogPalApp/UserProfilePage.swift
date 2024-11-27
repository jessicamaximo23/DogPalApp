//
//  SignUpView.swift
//  DogPalApp
//
//  Created by Wandrey Haagensen on 2024-11-06.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct UserProfilePage: View {
    
    @State private var userName: String = ""
    @State private var userAge: Int = 0
    @State private var userEmail: String = ""
    @State private var dogBreed: String = ""
    @State private var dogName: String = ""
    @State private var userImage: UIImage?
    
    @State private var showingSignOutAlert = false
    @State private var navigateToLogin = false  // Controla a navegação para LoginView
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                
                Text(userName)
                    .font(.title)
                
                if let image = userImage {
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
            .alert("Sign Out", isPresented: $showingSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    signOutFirebase()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            // Navegação para LoginView
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
            .onAppear {
                fetchUserProfile()
            }
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
    
    func fetchUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Database.database().reference().child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                self.userName = userData["userName"] as? String ?? "Unknown User"
                self.userEmail = userData["userEmail"] as? String ?? "No Email"
                self.userAge = Int(userData["userAge"] as? String ?? "0") ?? 0
                self.dogName = userData["dogName"] as? String ?? "No Dog Name"
                self.dogBreed = userData["dogBreed"] as? String ?? "No Breed"
                
                if let imageData = userData["userImage"] as? Data {
                    self.userImage = UIImage(data: imageData)
                }
            }
        } withCancel: { error in
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    UserProfilePage()
}
