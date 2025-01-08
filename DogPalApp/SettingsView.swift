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
    private let ref = Database.database().reference()
    
    @State private var userImage: UIImage?
    @State private var showingImagePicker: Bool = false
    
    @State private var notificationsEnabled: Bool = true
    @State private var locationEnabled: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @State private var shouldNavigateToLogin: Bool = false



    var body: some View {
        
        
        NavigationStack {
            VStack(alignment: .center){
                
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 350, height: 150)
                List {
                    
                    Section(header: Text("Edit Profile")) {
                        VStack{
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                if let image = userImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 100, height: 100)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                        .frame(width: 100, height: 100)
                                }
                            }
                            .sheet(isPresented: $showingImagePicker) {
                                ImagePicker(image: $userImage)
                            }
                            
                            TextField("Name", text: $userName)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            
                            TextField("Email", text: $userEmail)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            
                            TextField("Age", text: $userAge)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            
                            TextField("Dog Name", text: $dogName)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                            
                            TextField("Dog Breed", text: $dogBreed)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(8)
                        }
                        Button("Reset Password") {
                            resetPassword()
                        }
                        .foregroundColor(.black)
                    }
                    
                    
                    
                    Button("Logout") {
                        logout()
                    }
                    .foregroundColor(Color.textFields)
                    
                    
                    Button("Save Changes") {
                        saveProfileData()
                    }
                    .padding()
                    .background(Color.textFields)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            onAppear{
                loadUserProfile()
            }
        }
    }


func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            ref.child("users").child(userId).observeSingleEvent(of: .value) { snapshot in
                if let value = snapshot.value as? [String: Any] {
                    // Update @State properties with fetched data
                    self.userName = value["name"] as? String ?? ""
                    self.userEmail = value["email"] as? String ?? ""
                    self.userAge = value["age"] as? String ?? ""
                    self.dogName = value["dogName"] as? String ?? ""
                    self.dogBreed = value["dogBreed"] as? String ?? ""
                    
                    print("User Profile Loaded: \(self.userName), \(self.userEmail), \(self.userAge), \(self.dogName), \(self.dogBreed)")
                }
            }
        } else {
            print("No user is currently logged in.")
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
