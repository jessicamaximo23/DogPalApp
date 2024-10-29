import SwiftUI
import MapKit

struct DogWalkerProfilePage: View {
    
    var walkerName: String
    var walkerAge: Int
    var walkerExperience: String
    var walkValue: Int
    var walkerPhoto: UIImage?
    
    @Environment(\.dismiss) var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedDate = Date()
    
    var body: some View {
        
        
        NavigationView {
            ScrollView{
                VStack {
                    Image("DogPalLogo2")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 350, height: 150)
                    
                    Text(walkerName)
                        .font(.largeTitle)
                    
                    if let photo = walkerPhoto {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundColor(.gray)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 10) { // Ajuste o espaçamento para 10 ou outro valor que você prefira
                        Text("About Me")
                            .font(.headline)
                        
                        Text(walkerExperience) // Exibe toda a experiência
                            .font(.subheadline)
                            .padding(5) // Adiciona um espaçamento interno ao redor do texto
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .frame(width: 380) // Apenas define a largura, a altura se ajusta ao conteúdo
                    }
                    .padding(.horizontal)
                    
                    
                    //                HStack {
                    VStack(alignment: .leading) {
                        Text("Age: \(walkerAge)")
                            .font(.headline)
                        
                        Text("Price: $\(walkValue) per hour")
                            .font(.headline)
                        
                        Map(coordinateRegion: $region, showsUserLocation: true)
                            .frame(height: 150)
                            .cornerRadius(10)
                            .padding(.top, 10)
                    }
                    .padding()
                    //                }
                    
                    VStack(alignment: .leading) {
                        Text("Reviews")
                            .font(.headline)
                        
                        
                        Text("⭐️⭐️⭐️⭐️⭐️ - \"Great experience! My dog loved the walk!\"")
                        Text("⭐️⭐️⭐️⭐️ - \"Very reliable and caring!\"")
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Reserva realizada para \(selectedDate.formatted())!")
                    }) {
                        Text("Confirm Booking")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.brown)
                            .cornerRadius(10)
                    }
                    .padding(20)
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
    DogWalkerProfilePage(walkerName: "aaaa",
                         walkerAge: 0,
                         walkerExperience: "I have over 3 years of experience in dog walking, ensuring your furry friend gets the best care during our walks!",
                         walkValue: 20)
}
