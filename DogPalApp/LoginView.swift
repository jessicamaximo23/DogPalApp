//
//  LoginView.swift
//  DogPalApp
//
//  Created by Julien Villanti on 2024-10-20.
//

import SwiftUI

struct LoginView: View {
//    @Binding var isPresented: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    
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
                
                Text("No account yet? Sign-up here")
                //                Need to put the logic for the here in this spot
                
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
                
                SecureField("Confirm Password", text: $password)
                    .padding()
                    .autocapitalization(.none)
                    .tint(.red)
                    .frame(width: 340, height: 40)
                    .padding([.leading, .trailing])
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.textFields, lineWidth: 2))
                
                //                Button container
                VStack(spacing: 10) {
                    Button(action: {
                        print("Sign Up Pressed")
                        
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
                
                    //                Forgot password button
                    Button(action: {
                        print("Forgot Password Pressed")
                    }) {
                        Text("Forgot Password?")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.textFields)
                    }
                }
                .padding(.top, 30)
            
                Spacer()
            }
            .padding(.bottom, 100)
        }
    }
    
    private func signUp() {}
}

#Preview {
    LoginView()
}
