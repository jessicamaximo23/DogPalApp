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
    
    @State private var userImage: UIImage?
    @State private var showImagePicker = false
    @State private var navigateToHomeScreen = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                // Logo
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                
                Text("Set up your account")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
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
                    
                    // Foto opcional
                    Section(header: Text("Insert a picture of yourself! (optional)")) {
                        if let image = userImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        } else {
                            Button(action: {
                                showImagePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "camera")
                                        .font(.largeTitle)
                                        .foregroundColor(.brown)
                                    
                                    Text("Select a Photo")
                                        .font(.headline)
                                        .foregroundColor(.brown)
                                }
                            }
                        }
                    }
                    .sheet(isPresented: $showImagePicker) {
                        CustomImagePicker(selectedImage: $userImage)
                    }
                    
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
                    destination: HomeScreenView (),
                    isActive: $navigateToHomeScreen
                ) {
                    EmptyView()
                }
            }
          
        }
    }
    
    func updateUserProfileStatus() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Convertendo a imagem para Data (caso exista)
        let userImageData = userImage?.pngData()
        
        let userRef = Database.database().reference().child("users").child(uid)
        let userData: [String: Any] = [
            "profileCreated": true,
            "userName": userName,
            "userEmail": userEmail,
            "userAge": userAge,
            "dogName": dogName,
            "dogBreed": dogBreed,
            "userImage": userImageData as Any // Armazenando a imagem como Data
        ]
        
        userRef.updateChildValues(userData) { error, _ in
            if let error = error {
                print("Failed to update profile status: \(error.localizedDescription)")
            } else {
                print("Profile created successfully!")
                navigateToHomeScreen = true // Navegação após sucesso
            }
        }
    }
}



#Preview {
    UserProfileCreationView()
}
