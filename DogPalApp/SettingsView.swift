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
    private var ref: DatabaseReference = Database.database().reference()
    
    @State private var userImage: UIImage?
    @State private var showingImagePicker: Bool = false
    
    @State private var notificationsEnabled: Bool = true
    @State private var locationEnabled: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")
    @State private var shouldNavigateToLogin: Bool = false

    var body: some View {
        VStack(alignment: .center) {
            Image("DogPalLogo2")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 350, height: 150)
            List {
                Section(header: Text("Edit Profile")) {
                    VStack {
                        if let userImage = userImage {
                            Image(uiImage: userImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 100, height: 100)
                        }
                        
                        Button("Upload Profile Image") {
                            showingImagePicker = true
                        }
                        .padding()
                        
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
                }
                
                Section(header: Text("Notifications")) {
                    Toggle("Push Notifications", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { value in
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
            .preferredColorScheme(isDarkMode ? .dark : .light)
            
            NavigationLink(destination: LoginView(), isActive: $shouldNavigateToLogin) {
                EmptyView()
            }
        }
        .onAppear {
            loadUserProfile()
            loadUserImage()
        }
        .onDisappear {
            if let user = Auth.auth().currentUser {
                ref.child("users").child(user.uid).removeAllObservers()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            UserImagePicker(image: $userImage)
        }
    }
    
    func loadUserProfile() {
        guard let user = Auth.auth().currentUser else {
            print("Usuário não autenticado.")
            return
        }

        let userId = user.uid // Certifique-se de que este UID corresponde ao nó no Firebase

        ref.child("users").child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Nenhum dado encontrado para o usuário.")
                return
            }

            // Mapeando os dados corretamente com base nas chaves do Firebase
            DispatchQueue.main.async {
                userName = value["userName"] as? String ?? "Nome não encontrado"
                userEmail = value["userEmail"] as? String ?? "Email não encontrado"
                userAge = value["userAge"] as? String ?? "Idade não encontrada"
                dogName = value["dogName"] as? String ?? "Nome do cachorro não encontrado"
                dogBreed = value["dogBreed"] as? String ?? "Raça do cachorro não encontrada"
            }
        } withCancel: { error in
            print("Erro ao carregar os dados do usuário: \(error.localizedDescription)")
        }
    }

    func loadUserImage() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            ref.child("users").child(userId).child("profileImageUrl").observeSingleEvent(of: .value) { snapshot in
                if let imageUrl = snapshot.value as? String, let url = URL(string: imageUrl) {
                    URLSession.shared.dataTask(with: url) { data, _, error in
                        if let data = data, error == nil {
                            DispatchQueue.main.async {
                                userImage = UIImage(data: data)
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    func saveProfileData() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let ageValue = Int(userAge) ?? 0
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
