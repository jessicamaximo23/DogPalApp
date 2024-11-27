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
    @State private var navigateToLogin = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Logo
                    Image("DogPalLogo2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 100)
                        .padding(.top, 20)
                    
                    // User Image
                    if let image = userImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .frame(width: 120, height: 120)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                    
                    Text(userName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // User Details Section
                    VStack(alignment: .leading, spacing: 15) {
                        DetailRow(title: "Email", value: userEmail, color: .blue)
                        DetailRow(title: "Age", value: "\(userAge)", color: .green)
                        DetailRow(title: "Dog Name", value: dogName, color: .purple)
                        DetailRow(title: "Dog Breed", value: dogBreed, color: .orange)
                    }
                    .padding(15)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 5))
                    .padding(.horizontal)
                    
                    
                    
                    // Logout Button
                    Button(action: {
                        showingSignOutAlert = true
                    }) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: 150)
                            .padding()
                            .background(Color.textFields)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                    .padding(25)
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
            .alert("Sign Out", isPresented: $showingSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    signOutFirebase()
                }
            }
            .onAppear {
                fetchUserProfile()
            }
        }
    }
    
    func signOutFirebase() {
        do {
            try Auth.auth().signOut()
            navigateToLogin = true
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

// Reusable component for user details
struct DetailRow: View {
    var title: String
    var value: String
    var color: Color
    
    var body: some View {
        HStack {
            Text("\(title):")
                .fontWeight(.bold)
                .foregroundColor(color)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 5)
    }
}


#Preview {
    UserProfilePage()
}
