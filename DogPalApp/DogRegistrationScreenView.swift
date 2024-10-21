//
//  DogRegistrationScreenView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-21.
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
    @State private var userType: UserType = .owner
    
    //Radio btn for both
    enum UserType: String, CaseIterable {
            case owner = "Dog Owner"
            case walker = "Dog Walker"
        }
    
    var body: some View {
        
            NavigationView{
                VStack {
                    
                    //Logo
                    Image("dogpal-high-resolution-logo-transparent")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
                        .colorMultiply(Color.brown)
                       
                    Text("Set up your account")
                        .font(.title)
                    
                    // Set up Informations
                    Form {
                        TextField("Your Name", text: $userName)
                        .padding(5)
                        TextField("Dog's Name", text: $dogName)
                        .padding(5)
                        TextField("Dog's Breed", text: $dogBreed)
                        .padding(5)
                        TextField("Dog's Age", text: $dogAge)
                        .padding(5)
                        TextField("Dog's Size", text: $dogSize)
                        .padding(5)
                            .keyboardType(.numberPad)
                        
                        Picker("User Type", selection: $userType) {
                            ForEach(UserType.allCases, id: \.self) { userType in
                                Text(userType.rawValue).tag(userType)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical)
                        
                        
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
                            //Submit dog
                            Section {
                                Button(action: {
                                    registerDog()
                                }) {
                                    Text("Submit your Dog")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.brown)
                                        .foregroundColor(.white)
                                        .cornerRadius(30)
                                }
                                .disabled(dogName.isEmpty || dogBreed.isEmpty || dogAge.isEmpty || dogPhoto == nil)
                            }
                        }
                    }
        
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $dogPhoto)
                    
                }
                .navigationTitle("")
                .navigationBarItems(
                    leading: Button(action: {
                        print("Back")
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            
                        }
                    },
                    trailing: Button("Cancel") {
                        print("Cancelled")
                    }
                )
            }
        }
    
               
  
    func registerDog() {
        
        print("Registered Dog: \(userName),\(dogName), \(dogBreed), \(dogAge), \(dogSize)")
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
