//
//  DogRegistrationScreenView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-24.
//

import SwiftUI

struct DogRegistrationScreenView: View {
    
    @State private var userName: String = ""
    @State private var dogName: String = ""
    @State private var dogBreed: String = ""
    @State private var dogAge: String = ""
    @State private var dogPhoto: UIImage? = nil
    @State private var dogSize: String = ""
    @State private var showImagePicker = false
    
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
                       // Set up Informations
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
                           
                            TextField("Dog's Size", text: $dogSize)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                           
                           Section(header: Text("Introduce your best buddy to the community with a picture")) {
                               
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
                                               .foregroundColor(.brown)
                                           
                                           Text("Select a Photo")
                                               .font(.headline)
                                               .foregroundColor(.brown)
                                       }
                                   }
                               }
                           }
                           
                           //Submit dog
                           Section {
                               Button(action: {
                                   let age = Int(dogAge) ?? 0
                                   let size = Int(dogSize) ?? 0
                                   
                                   let newDog = Dog(name: dogName, breed: dogBreed, age: age, size: size)
                                   
                                   newDog.registerDog()
                                   
                                   
                               }) {
                                   Text("Submit your Dog")
                                       .frame(maxWidth: .infinity)
                                       .padding()
                                       .background(Color.brown)
                                       .foregroundColor(.white)
                                       .cornerRadius(30)
                                       .padding(20)
                               }
                               .disabled(dogName.isEmpty || dogBreed.isEmpty || dogAge.isEmpty || dogPhoto == nil)
                           }
                       }
                       
                   
               }
               .toolbar {
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
    var dogSize: Int

    init(name: String, breed: String, age: Int, size: Int) {
        self.dogName = name
        self.dogBreed = breed
        self.dogAge = age
        self.dogSize = size
    }
    
func registerDog() {
    
           print("Registered Dog: \(dogName), \(dogBreed), \(dogAge), Size: \(dogSize)")
       }
}
   
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

#Preview {
    DogRegistrationScreenView()
}






