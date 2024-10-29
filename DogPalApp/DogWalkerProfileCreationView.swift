//
//  DogWalkerProfileCreationView.swift
//  DogPalApp
//
//  Created by User on 2024-10-29.
//

import SwiftUI

struct DogWalkerProfileCreationView: View {
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var userAge: String = ""
    @State private var userPhoto: UIImage? = nil
    @State private var walkValue: String = ""
    @State private var experience: String = ""
    @State private var showImagePicker = false
    @State private var navigateToBooking = false // Controla a navegação para DogWalkBookingView

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                
                VStack(alignment: .leading) {
                    Text("Set up your walker account")
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                }
                
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
                    
                    TextField("Walk value ($/h)", text: $walkValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                    
                    TextField("Experience", text: $experience)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Section(header: Text("Insert a picture of yourself! (optional)")) {
                        
                        if let image = userPhoto {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
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
                        
                        Section {
                            Button(action: {
                                navigateToBooking = true
                            }) {
                                Text("Submit your Info")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.brown)
                                    .foregroundColor(.white)
                                    .cornerRadius(30)
                                    .padding(20)
                            }
                            .disabled(userEmail.isEmpty || userName.isEmpty || userAge.isEmpty || walkValue.isEmpty || experience.isEmpty)
                        }
                    }
                }
                
                NavigationLink(
                    destination: DogWalkBookingView(
                        walkerName: userName,
                        walkerAge: Int(userAge) ?? 0,
                        walkerExperience: experience,
                        walkValue: Int(walkValue) ?? 0
                    ),
                    isActive: $navigateToBooking
                ) {
                    EmptyView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Back", systemImage: "arrow.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Cancel", systemImage: "xmark")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $userPhoto)
            }
        }
    }
}

#Preview {
    DogWalkerProfileCreationView()
}
