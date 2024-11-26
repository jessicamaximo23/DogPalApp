
//
//  HomeScreenView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-10-30.



import SwiftUI
import Firebase
import FirebaseAuth
import UIKit


struct HomeScreenView: View {
       
    @State private var parks = [
        Park(name: "Park Lafontaine", rating: 4.8, imageName: "parclafontaine", description: "One of the most popular parks in Montreal, ideal for picnics and walks.", reviews: ["Incredible!", "Great place to relax.", "Very beautiful!"]),
        
        Park(name: "Park Jean-Drapeau", rating: 4.7, imageName: "parcjeandrapeau", description: "A park with a view of the river and various outdoor activities.", reviews: ["I love running here.", "A perfect place for a family day."]),
        
        Park(name: "Park Angrignon", rating: 4.6, imageName: "parcangrignon", description: "A peaceful park with large green areas and lakes.", reviews: ["Excellent for walks.", "Very well maintained."])
    ]
    
    @Environment(\.dismiss) var dismiss
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    @State private var userAge: String = ""
    @State private var dogName: String = ""
    @State private var dogBreed: String = ""
    @State private var userImage:  UIImage?
    @State private var showingImagePicker: Bool = false
    
    var body: some View {
        
        TabView {
            
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        

                        Button(action: {
                            showingImagePicker = true
                        }) {
                            if let image = userImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 250, height: 250)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.gray)
                                    .frame(width: 130, height: 130)
                                    .padding()

                            }
                        }
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePicker(image: $userImage)
                        }
                        
                        Text("Hello, \(userEmail)")
                            .font(.system(size: 20))
                            .padding()
                            .foregroundColor(Color.primary)
                        
                        Image("map")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: 350, height: 250)
                        
                        Text("Best Parks in Montreal")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(Color.primary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(parks) { park in
                                    ParkCardView(park: park)
                                }
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
                .onAppear {
                    if Auth.auth().currentUser != nil {
                        fetchUserName()
                    } else {
                        print("User not logged in")
                    }
                }
                
            }

        }
        .accentColor(.blue)
    }
    
    func fetchUserName() {
           guard let user = Auth.auth().currentUser else {
               print("User not authenticated")
               return
           }
           
        
           if let email = user.email {
               self.userName = email
           } else {
               print("No display name found for the user")
           }
       }
    
    struct ParkCardView: View {
        var park: Park
        
        var body: some View {
            VStack {
                Image(park.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 100)
                    .cornerRadius(10)
                
                Text(park.name)
                    .font(.headline)
                    .padding(.top, 5)
                    .foregroundColor(Color.primary)
                
                Text("Rating: \(park.rating, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                NavigationLink(destination: ParkDetailView(park: park)) {
                    Text("View Park")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding(.top, 5)
                }
            }
            .frame(width: 150)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}

struct Park: Identifiable {
    var id = UUID()
    var name: String
    var rating: Double
    var imageName: String
    var description: String
    var reviews: [String]
    
}

struct ParkDetailView: View {
    var park: Park
    
    var body: some View {
        VStack {
            
            Image(park.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 350, height: 350)
                .cornerRadius(15)
                .shadow(radius: 5)
            
            Text(park.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Text("Rating: \(park.rating, specifier: "%.1f")")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
            
            Text(park.description)
                .font(.body)
                .padding()
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading) {
                Text("Reviews")
                    .font(.headline)
                    .padding(.top, 10)
                
                ForEach(park.reviews, id: \.self) { review in
                    HStack {
                        
                        ForEach(0..<5) { star in
                            Image(systemName: "star.fill")
                                .foregroundColor(star < Int(park.rating.rounded()) ? .yellow : .gray)
                        }
                        Text(review)
                            .font(.subheadline)
                            .padding(.leading)
                    }
                }
            }
            .padding()
        }
        
    }
}



struct ImagePicker: UIViewControllerRepresentable {
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
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
    HomeScreenView()
}
