import SwiftUI
import MapKit

struct UserProfilePage: View {
    
    var userName: String
    var userAge: Int
    var dogBreed: String
    var dogName: String
    var userImage: Data?
    @State private var showHomeScreen = false
    @State private var showProfileView = false // Estado para navegação para HomeScreenView
    
    @Environment(\.dismiss) var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("DogPalLogo2")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 350, height: 150)
                    
                    Text(userName)
                        .font(.largeTitle)
                    
                    if let imageData = userImage, let image = UIImage(data: imageData) {
                                   Image(uiImage: image)
                                       .resizable()
                                       .scaledToFit()
                                       .clipShape(Circle())
                                       .shadow(radius: 10)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About Me")
                            .font(.headline)
                        
                        Text(dogBreed)
                            .font(.subheadline)
                            .padding(5)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: 380)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("User Age: \(userAge)")
                            .font(.headline)
                        
                        Text("Dog Name: \(dogName)")
                            .font(.headline)
                        
                        Text("Dog Breed: \(dogBreed)")
                            .font(.headline)
                        
                        Map(coordinateRegion: $region, showsUserLocation: true)
                            .frame(height: 150)
                            .cornerRadius(10)
                            .padding(.top, 10)
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Reviews")
                            .font(.headline)
                        
                        Text("⭐️⭐️⭐️⭐️⭐️ - \"Great experience! My dog loved the walk!\"")
                        Text("⭐️⭐️⭐️⭐️ - \"Very reliable and caring!\"")
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        showHomeScreen = true
                    }) {
                        Text("Go to Home Screen")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.brown)
                            .cornerRadius(10)
                    }
                    .padding(20)
                    
                    NavigationLink(
                        destination: HomeScreenView(),  // Substitua por sua HomeScreenView
                        isActive: $showHomeScreen
                    ) {
                        EmptyView()
                    }
                    
                    .navigationBarItems(trailing: Button(action: {
                                    showProfileView = true
                                }) {
                                    Image(systemName: "gearshape")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                })
                                .background(
                                    NavigationLink(
                                        destination: SettingsView(
                                            userEmail: userName
                                        ),
                                        isActive: $showProfileView
                                    ) {
                                        EmptyView()
                                    }
                                )
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
            }
        }
    }
}

#Preview {
    UserProfilePage(userName: "",
                    userAge: 0,
                    dogBreed: "",
                    dogName: "")
}
