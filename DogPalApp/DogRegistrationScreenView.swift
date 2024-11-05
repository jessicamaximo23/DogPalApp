//
//  DogRegistrationScreenView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-24.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import UIKit

struct DogRegistrationScreenView: View {
    
    @State private var userName: String = ""
    @State private var dogName: String = ""
    @State private var dogBreed: String = ""
    @State private var dogAge: String = ""
    @State private var dogPhoto: UIImage? = nil
    @State private var dogWeight: String = ""
    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var errorMessage: String? = nil
    @State private var showDogWalkerSelection = false
    
    
    struct ImagePicker: UIViewControllerRepresentable {
           @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
               
               let picker = UIImagePickerController()
               picker.delegate = context.coordinator
               return picker
           }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

           class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
               var parent: ImagePicker
               
               init(parent: ImagePicker) {
                   self.parent = parent
               }
               
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                   
                   if let selectedImage = info[.originalImage] as? UIImage {
                       parent.image = selectedImage
                   }
                   picker.dismiss(animated: true)
               }
           }

    func makeCoordinator() -> Coordinator {
               Coordinator(parent: self)
        }
    }

    @Environment(\.dismiss) var dismiss
       
       var body: some View {
           NavigationView {
               VStack {
                   
                   Image("DogPalLogo2")
                       .resizable()
                       .scaledToFit()
                       .padding()
                       .frame(width: 350, height: 150)
                   
                   VStack(alignment: .leading) {
                       Text("Set up your account")
                           .font(.largeTitle)
                           .padding(.bottom, 20)
                   }
                   
                   Section {
                       TextField("Your Name", text: $userName)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .padding(.horizontal)
                       
                       TextField("Dog's Name", text: $dogName)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .padding(.horizontal)
                       
                       TextField("Dog's Breed", text: $dogBreed)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .padding(.horizontal)
                       
                       TextField("Dog's Age", text: $dogAge)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .padding(.horizontal)
                       
                       TextField("Dog's Weight", text: $dogWeight)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .keyboardType(.numberPad)
                           .padding(.horizontal)
                       
                       Section(header: Text("Introduce your best buddy to the community with a picture")
                        .padding(20)) {
                           
                           if let image = dogPhoto {
                               
                               Image(uiImage: image)
                                   .resizable()
                                   .scaledToFit()
                                   .frame(height: 200)
                                   .clipShape(Circle())
                                   .shadow(radius: 10)
                               
                           } else {
                               Button(action: {
                                   showImagePicker = true
                               }) {
                                   HStack {
                                       Image(systemName: "camera")
                                           .font(.largeTitle)
                                           .foregroundColor(.textFields)
                                       
                                       Text("Select a Photo")
                                           .font(.headline)
                                           .foregroundColor(.textFields)
                                   }
                               }
                           }
                       }
                       
                       //Submit dog
                       Section {
                           Button(action: {
                               guard let age = Int(dogAge), let size = Int(dogWeight), !dogName.isEmpty, !dogBreed.isEmpty else {
                                   errorMessage = "Please fill in all fields correctly."
                                   showAlert = true
                                   return
                               }
                               
                               let newDog = Dog(name: self.dogName, breed: self.dogBreed, age: age, size: size)
                               
                               newDog.registerDog { success in
                                   if success {
                                    
                                       self.dogName = ""
                                       self.dogBreed = ""
                                       self.dogAge = ""
                                       self.dogWeight = ""
                                       self.dogPhoto = nil
                                       errorMessage = nil
                                       
                                       showDogWalkerSelection = true
                                   } else {
                                       errorMessage = "Failed to register the dog."
                                       showAlert = true
                                   }
                               }
                           }) {
                               Text("Submit your Dog")
                                   .frame(maxWidth: .infinity)
                                   .padding()
                                   .background(Capsule().fill(Color.textFields))
                                   .foregroundColor(.white)
                                   .cornerRadius(30)
                                   .padding(.horizontal)
                           }
                           .disabled(dogName.isEmpty || dogBreed.isEmpty || dogAge.isEmpty || dogPhoto == nil)

                           
                       }
                       .alert(isPresented: $showAlert) { 
                                           Alert(title: Text("Error"),
                                                 message: Text(errorMessage ?? "Please fill in all fields."),
                                                 dismissButton: .default(Text("OK")))
                           
                                       }.sheet(isPresented: $showDogWalkerSelection) {
                               DogWalkerSelectionView() // Mostrar a nova view
                           
                       }
                   }
               }.toolbar {
                   ToolbarItem(placement: .navigationBarLeading) {
                       Button(action: {
                           dismiss()
                       }) {
                           Label("Back", systemImage: "arrow.left")
                       }
                   }
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Button(action: {
                           dismiss()
                       }) {
                           Label("Cancel", systemImage: "xmark")
                               .foregroundColor(.blue)
                       }
                   }
               }
               .sheet(isPresented: $showImagePicker) {
                   ImagePicker(image: $dogPhoto)
               }
                }
                  }
              }
          

class Dog {
    var dogName: String
    var dogBreed: String
    var dogAge: Int
    var dogWeight: Int
    
    var ref: DatabaseReference!
    
    init(name: String, breed: String, age: Int, size: Int) {
        self.dogName = name
        self.dogBreed = breed
        self.dogAge = age
        self.dogWeight = size
        
        self.ref = Database.database().reference()
    }
    
    func registerDog(completion: @escaping (Bool) -> Void) {
        
        let dogData: [String: Any] = [
            "name": dogName,
            "breed": dogBreed,
            "age": dogAge,
            "weight": dogWeight
        ]
        print("Registering dog data: \(dogData)")
        
        ref.child("dogs").childByAutoId().setValue(dogData) { error, _ in
                if let error = error {
                    print("Error adding dog: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Dog successfully registered: \(self.dogName)")
                    completion(true)
                }
        }
    }
}
    
   
   

#Preview {
    DogRegistrationScreenView()
}






