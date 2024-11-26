//
//  SettingsView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-11-08.

import SwiftUI
import Firebase
import FirebaseAuth

struct SettingsView: View {
    
    @State private var userImage: UIImage?
    @State private var showingImagePicker: Bool = false
    @State private var userName: String = Auth.auth().currentUser?.displayName ?? ""
    @State private var notificationsEnabled: Bool = true
    @State private var locationEnabled: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @State private var shouldNavigateToLogin: Bool = false



    var body: some View {
        NavigationView {
            VStack(alignment: .center){
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
                        }
                            Button("Reset Password") {
                                resetPassword()
                            }
                        }
                    
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
                      
                    Section {
                        Button("Logout") {
                            logout()
                        }
                        .foregroundColor(.red)
                    }
                }
                .navigationTitle("Settings")
                .navigationBarItems(trailing: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                })
                .preferredColorScheme(isDarkMode ? .dark : .light)
                
                NavigationLink(destination: LoginView(), isActive: $shouldNavigateToLogin) {
                               EmptyView()
                           }
            }
            .onAppear {

                loadUserProfile()

            }

        }
    }
    
    func loadUserProfile() {
        if let user = Auth.auth().currentUser {
            userName = user.displayName ?? ""
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

