//
//  SettingsView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-11-08.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SettingsView: View {
    
    @State private var userImage: UIImage?
    @State private var showingImagePicker: Bool = false
    @State private var userName: String = Auth.auth().currentUser?.displayName ?? ""
    @State private var isDarkMode: Bool = false
    @State private var notificationsEnabled: Bool = true
    @State private var language: String = "English"
    @State private var locationEnabled: Bool = true
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
               
                Section(header: Text("User Profile")) {
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

                    Button("Reset Password") {
                        resetPassword()
                    }
                }

               
                Section(header: Text("Notifications")) {
                    Toggle("Push Notifications", isOn: $notificationsEnabled)
                }

               
                Section(header: Text("Location Preferences")) {
                    Toggle("Enable Location", isOn: $locationEnabled)
                }

    
                Section(header: Text("Language and Theme")) {
                    Picker("Language", selection: $language) {
                        Text("English").tag("English")
                        Text("Français").tag("Français")
                    }
                    .pickerStyle(MenuPickerStyle())

                    Toggle("Dark Mode", isOn: $isDarkMode)
                }

              
                Section(header: Text("Dados e Armazenamento")) {
                    Button("Limpar Cache") {
                        clearCache()
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
        }
        .onAppear {
            loadUserProfile()
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

    func clearCache() {
        // Código para limpar cache, se necessário
        print("Cache limpo.")
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            print("Logout bem-sucedido.")
        } catch {
            print("Erro ao fazer logout: \(error.localizedDescription)")
        }
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

