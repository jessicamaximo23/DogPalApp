//
//  ForgotPasswordView.swift
//  DogPalApp
//
//  Created by Julien Villanti on 2024-10-27.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var isEmailValid = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image("DogPalLogo2")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 350, height: 150)
                    
                    Text("Reset Password")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Please enter your email address to receive the instructions for resetting your password.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.none)
                            .onChange(of: email) { newValue in
                                isEmailValid = isValidEmail(newValue)
                            }
                        
                        if !email.isEmpty && !isEmailValid {
                            Text("Please enter a valid email address.")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: handleResetPassword) {
                        Text("Send reset link")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isEmailValid ? Color.green : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isEmailValid)
                    .padding(.horizontal)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Back to Sign-in")
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.vertical)
            }
            .alert("Password Reset", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func handleResetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email){
            error in
            if let error = error{
                switch error.localizedDescription{
                case let str where str.contains("no user record"):
                    alertMessage = "If an acocunt exist with this email, a password reset link will be sent."
                case let str where str.contains("invalid email"):
                    alertMessage = "Please enter a valid email address"
                default:
                    alertMessage = "Error: \(error.localizedDescription)"
                }
            }else{
                alertMessage = "If an acocunt exist with this email, a password reset link will be sent."
            }
            
        showAlert = true
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            alertMessage = "If an account exists with this email, a password reset link will be sent."
//            showAlert = true
        }
    }
}


#Preview {
    ForgotPasswordView()
}
