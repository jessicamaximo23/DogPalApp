//
//  SignUpView.swift
//  DogPalApp
//
//  Created by Julien Villanti on 2024-10-20.
//

import Firebase
import FirebaseAuth
import SwiftUI
                
struct SignUpView: View {
    @Binding var isPresented: Bool
    @Binding var email: String
    @Binding var password: String
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
                    
    var body: some View {
        // Removed extra NavigationView since this view is already pushed through NavigationLink
        VStack {
            Image("DogPalLogo2")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 350, height: 150)
                            
            VStack(alignment: .leading) {
                Text("Sign-Up") // Changed from Sign-In to Sign-Up
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
            }
                            
            Text("Create your account!") // Changed text to be more appropriate for sign-up
                .font(.title)
                .padding()
                            
            // Removed redundant HStack since this is the sign-up view
                            
            TextField("Email", text: $email)
                .padding()
                .autocapitalization(.none)
                .tint(.red)
                .frame(width: 340, height: 40)
                .padding([.leading, .trailing])
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.textFields, lineWidth: 2))
                .padding()
                            
            SecureField("Password", text: $password)
                .padding()
                .autocapitalization(.none)
                .tint(.red)
                .frame(width: 340, height: 40)
                .padding([.leading, .trailing])
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.textFields, lineWidth: 2))
                .padding()
                            
            VStack(spacing: 10) {
                Button(action: {
                    signUp()
                }) {
                    Text("Sign-Up")
                }
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 240, height: 40)
                .background(
                    Capsule()
                        .fill(Color.textFields)
                )
                .shadow(radius: 5)
                                
                Button(action: {
                    isPresented = false // This will dismiss the view
                }) {
                    Text("Already have an account? Sign in") // Changed from "Forgot Password?"
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.textFields)
                }
            }
            .padding(.top, 30)
                            
            Spacer()
        }
        .padding(.bottom, 100)
        .alert("Sign Up Status", isPresented: $isShowingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
                    
    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                alertMessage = error.localizedDescription
                isShowingAlert = true
            } else {
                // Successfully created user
                alertMessage = "Account created successfully!"
                isShowingAlert = true
                // Optional: Add a delay before dismissing
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isPresented = false
                }
            }
        }
    }
}

// Fixed preview provider
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(
            isPresented: .constant(true),
            email: .constant(""),
            password: .constant("")
        )
    }
}
                