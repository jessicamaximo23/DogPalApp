//
//  SettingsView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-11-08.

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct SettingsView: View {
    
    
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var userAge: String = ""
    @State private var dogName: String = ""
    @State private var dogBreed: String = ""
    @State private var profileCreated = true
    @State private var ageError: String? = nil  // To display an error message

    private var ref: DatabaseReference = Database.database().reference()
    
    @State private var userImage: UIImage?
    @State private var showingImagePicker: Bool = false
    
    @State private var notificationsEnabled: Bool = true
    @State private var locationEnabled: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @State private var shouldNavigateToLogin: Bool = false



    var body: some View {
    
            VStack(alignment: .center){
                
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                List {
                    
                    Section(header: Text("Edit Profile")) {
                        VStack{
                            
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                        .frame(width: 100, height: 100)
                            
                            TextField("Name", text: $userName)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            
                            TextField("Email", text: $userEmail)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            
                            TextField("Your Age", text: $userAge)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.numberPad) // Ensure the keyboard only shows numbers
                                .onChange(of: userAge) { newValue in
                                    // Remove any non-digit characters to ensure the age is only numeric
                                    let filteredValue = newValue.filter { $0.isNumber }
                                    
                                    // Update the text field with the filtered value
                                    if filteredValue != newValue {
                                        userAge = filteredValue
                                    }
                                    
                                    // Check if the value is a valid non-negative number
                                    if let age = Int(filteredValue), age >= 0 {
                                        ageError = nil
                                    } else {
                                        ageError = "Please enter a valid non-negative age."
                                    }
                                }

                            if let error = ageError {
                                Text(error)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                            
                            TextField("Dog Name", text: $dogName)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            
                            TextField("Dog Breed", text: $dogBreed)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        Button("Save Changes") {
                            saveProfileData()
                            
                        }
                        .foregroundColor(Color.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(50)
                        .padding(.top, 20)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                           
                    
                    Section(header: Text("Notifications")) {
                        Toggle("Push Notifications", isOn: $notificationsEnabled).onChange(of: notificationsEnabled)
                        { value in
                            
                            handleNotificationsToggle(value)
                        }
                    }
                    Section(header: Text("Location Preferences")) {
                        Toggle("Enable Location", isOn: $locationEnabled)
                    }
                    
                    Section(header: Text("Theme")) {
                        Toggle("Dark Mode", isOn: $isDarkMode)
                            .onChange(of: isDarkMode) { value in
                                
                                setAppTheme(darkMode: value)
                            }
                    }
            
                        Button("Reset Password") {
                            resetPassword()
                        }
                        .foregroundColor(Color.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(50)
                        .padding(.top, 20)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, alignment: .center)

                    }
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
                
                NavigationLink(destination: LoginView(), isActive: $shouldNavigateToLogin) {
                    EmptyView()
                }
            }
            .onAppear {
                    loadUserProfile()
                }
        }
       
    
    func loadUserProfile() {
        
        if let user = Auth.auth().currentUser {
                let userId = user.uid
                ref.child("users").child(userId).observe(.value) { snapshot in
                    if let value = snapshot.value as? [String: Any] {
                        
                        DispatchQueue.main.async {
                            userName = value["name"] as? String ?? ""
                            userEmail = value["email"] as? String ?? ""
                            userAge = (value["age"] as? Int).map(String.init) ?? ""
                            dogName = value["dogName"] as? String ?? ""
                            dogBreed = value["dogBreed"] as? String ?? ""
                            profileCreated = true
                        }
                    }
                }
            }
        }
    


func saveProfileData() {
    
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            
            let ageValue = Int(userAge) ?? 0 // convert string to int
            
            ref.child("users").child(userId).setValue([
                "name": userName,
                "email": userEmail,
                "age": ageValue,
                "dogName": dogName,
                "dogBreed": dogBreed,
                "profileCreated": true
                
            ]) { error, _ in
                if let error = error {
                    print("Error saving data: \(error.localizedDescription)")
                } else {
                    print("Profile updated successfully")
                }
            }
        }
    }

    func resetPassword() {

        if let email = Auth.auth().currentUser?.email {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("Error sending password reset email: \(error.localizedDescription)")
                } else {
                    print("Password reset email sent successfully.")
                }
            }
        }
    }
    
    func handleNotificationsToggle(_ isEnabled: Bool) {
        print("Notifications toggled: \(isEnabled)")
    
        if isEnabled {
               enableNotifications()
           } else {
               disableNotifications()
           }
        
    }
    func enableNotifications() {
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Push notifications are enabled.")
                
            } else {
                print("Permission for push notifications denied.")
               
            }
        }
    }

    func disableNotifications() {
      
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UIApplication.shared.unregisterForRemoteNotifications()
        print("Push notifications are disabled.")
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("Logout successful.")
            shouldNavigateToLogin = true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }


    private func setAppTheme(darkMode: Bool) {
        isDarkMode = darkMode
        
        print(darkMode ? "Dark Mode activated." : "Light Mode activated.")
        }
    }
   

struct UserImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: UserImagePicker

        init(_ parent: UserImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
#Preview {
    SettingsView()
}
