//
//  LoginView.swift
//  DogPalApp
//
//  Created by Julien Villanti on 2024-10-20.
//


import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUpPresented: Bool = false
    
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
                
                HStack{
                    Text("No account yet? Sign-up")
                    //                Need to put the logic for the here in this spot
                    NavigationLink(destination: SignUpView(
                        isPresented: $isSignUpPresented,
                        email: $email,
                        password: $password)){
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
                    Button(action: {
                        print("Sign In Pressed")
                        
                    }) {
                        Text("Sign-In")
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
    
    private func signIn() {}
}

#Preview {
    LoginView()
}



