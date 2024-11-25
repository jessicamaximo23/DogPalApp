//
//  SettingsView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-11-08.

import SwiftUI
import Firebase
import FirebaseAuth

struct SettingsView: View {
    
   
    @State private var selectedProfileImage: String = ""
    @State private var userName: String = Auth.auth().currentUser?.displayName ?? ""
    @State private var notificationsEnabled: Bool = true
    @State private var locationEnabled: Bool = true
    @Environment(\.presentationMode) var presentationMode
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @State private var shouldNavigateToLogin: Bool = false
    @State private var showLocationAlert: Bool = false
    @State private var showNotificationAlert: Bool = false
    @State private var showPicker: Bool = false
    
    @AppStorage("selectedProfileImage") var storedProfileImage: String = ""
    // Ícon
    let profileIcons = ["star.fill", "heart.fill", "moon.fill", "cloud.fill"]

    var body: some View {
        NavigationView {
            VStack(alignment: .center){
                List {
                    
                Section(header: Text("Edit Profile")) {
                    VStack{
                            //User can choose 4 icons for show in profile

                        Button(action: {
                            showPicker.toggle()}) {
                                Text("Choose the image")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding()
                                   }
                                                       
                                                       
                                    if showPicker {
                                        Picker("Escolha um ícone", selection: $selectedProfileImage) {
                                            ForEach(profileIcons, id: \.self) { icon in
                                Image(systemName: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .tag(icon)
                                            }
                                    }
                                        .pickerStyle(WheelPickerStyle())
                                        .padding()
                                        .onChange(of: selectedProfileImage) { newValue in
                                                               storedProfileImage = newValue
                                                           }
                                                       }
                                                       
                                        if !selectedProfileImage.isEmpty {
                                        Image(systemName: selectedProfileImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .padding()
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
                            
                            UserDefaults.standard.set(value, forKey: "notificationsEnabled")
                            
                            if !showLocationAlert {
                                    showNotificationAlert = true
                                }
                                handleNotificationsToggle(value)
                        }
                    }
                    Section(header: Text("Location Preferences")) {
                        Toggle("Enable Location", isOn: $locationEnabled)
                            .onChange(of: locationEnabled) { value in
                     
                     UserDefaults.standard.set(value, forKey: "locationEnabled")
                     
                     showLocationAlert = true
                    
                        }
                    }
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
            .alert(isPresented: $showLocationAlert) {
                Alert(
                    title: Text("Location Settings Changed"),
                    message: Text(locationEnabled ? "Location services have been enabled." : "Location services have been disabled."),
                    primaryButton: .default(Text("OK")),
                    secondaryButton: .cancel()
                )
            }
            .alert(isPresented: $showNotificationAlert) {
                Alert(
                    title: Text("Notifications Settings Changed"),
                    message: Text(notificationsEnabled ? "Push notifications have been enabled." : "Push notifications have been disabled."),
                    primaryButton: .default(Text("OK")),
                    secondaryButton: .cancel()
                )
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
        
            UserDefaults.standard.set(darkMode, forKey: "isDarkMode")
        
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

