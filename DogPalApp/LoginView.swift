//
//  LoginView.swift
//  DogPalApp
//
//  Created by Julien Villanti on 2024-10-20.
//

import Firebase
import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUpPresented: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var navigateToHome: Bool = false
    @StateObject private var authManager = AuthManager()
    
    @State private var isSignedIn: Bool = false 
    
    var body: some View {
        NavigationView {
            VStack {
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                
                VStack(alignment: .leading) {
                    Text("Sign-In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                }
                
                Text("Let's log you in!")
                    .font(.title)
                    .padding()
                
                HStack {
                    Text("No account yet? Sign-up")
                    //                Need to put the logic for the here in this spot
                    NavigationLink(destination: SignUpView(
                        isPresented: $isSignUpPresented,
                        email: $email,
                        password: $password
                    )) {
                        Text("here")
                            .foregroundStyle(.blue)
                            .fontWeight(.bold)
                    }
                }
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
                
                //                Button container
                VStack(spacing: 10) {
                    Button(action: signIn) {
                        ZStack {
                            Text("Sign-In")
                                .opacity(isLoading ? 0 : 1)
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 240, height: 40)
                    .background(
                        Capsule()
                            .fill(Color.textFields)
                    )
                    .shadow(radius: 5)
                    .disabled(isLoading)
                
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.textFields)
                    }
                }
                .padding(.top, 30)
                                   
                Spacer()
                
                //Sent for Dog registration
                NavigationLink(destination: DogRegistrationScreenView(), isActive: $isSignedIn) {
                    EmptyView()
                }
            }
            .padding(.bottom, 100)
            .alert("Sign In", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .fullScreenCover(isPresented: $navigateToHome) {
                           HomeScreenView()
            }
        }
    }
    
    private func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
          
        isLoading = true
          
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoading = false
              
            if let error = error {
                handleSignInError(error)
            } else {
                // Sign in successful
                navigateToHome = true
                UserDefaults.standard.set(email, forKey: "userEmail")
                               if let uid = Auth.auth().currentUser?.uid {
                                   UserDefaults.standard.set(uid, forKey: "userId")
                               }
                               navigateToHome = true
            
            }
        }
    }
    
    private func handleSignInError(_ error: Error) {
        let errorCode = AuthErrorCode(_bridgedNSError: error as NSError)?.code
            
        switch errorCode {
        case .wrongPassword:
            alertMessage = "Invalid email or password"
        case .invalidEmail:
            alertMessage = "Please enter a valid email address"
        case .userNotFound:
            alertMessage = "No account found with this email"
        case .userDisabled:
            alertMessage = "This account has been disabled"
        case .networkError:
            alertMessage = "Network error. Please check your connection"
        default:
            alertMessage = "An error occurred. Please try again"
        }
            
        showAlert = true
    }
}

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    
    init() {
        // Check if user is already signed in
        isAuthenticated = Auth.auth().currentUser != nil
    }
}

#Preview {
    LoginView()
}
