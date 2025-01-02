import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import UIKit

//Wandrey
//Page created to show the idea of the ratings and comments by user. Need to polish and finish.

struct ReviewRateView: View {
    var park: Parklist? // Parque passado como parâmetro
    
    @State private var comment = ""
    @State private var reviews: [Review] = []
    @State private var userName = ""
    @State private var dogBreed = ""
    @State private var dogName = ""
    @State private var userAge = ""
    
    private var db = Firestore.firestore() // Instância do Firestore
    
    var body: some View {
       
            ScrollView {
                VStack {
                    
                    Image("DogPalLogo2")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 350, height: 150)
                    
                    Text("Park Reviews")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    ForEach(parks) { park in
                        VStack(alignment: .leading) {
                            Text(park.name)
                                .font(.headline)
                                .padding(.bottom, 5)
                            
                            Text("Rating: \(park.rating, specifier: "%.1f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 10)
                            
                            ForEach(park.reviews) { review in
                                ReviewCardView(review: review)
                            }
                            
                            Divider().padding(.vertical)
                        }
                    }
                }
                .padding()
            }

    }
}

struct ReviewCardView: View {
    var review: Review
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(review.userName)
                    .font(.headline)
                    .foregroundColor(Color.black)
                    .background(Color.white)
                
                Spacer()
                
                HStack {
                    ForEach(0..<5) { star in
                        Image(systemName: "star.fill")
                            .foregroundColor(star < review.rating ? .yellow : .gray)
                    }
                }
            }
            
            Text(review.comment)
                .font(.body)
                .padding(.top, 2)
                .foregroundColor(Color.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ParkReviewData: Identifiable {
    var id = UUID()
    var name: String
    var rating: Double
    var imageName: String
    var description: String
    var reviews: [Review]
}

struct Review: Identifiable, Codable {
    @DocumentID var id: String? // Identificador do documento do comentário
    var review: String
    var userName: String
    var dogBreed: String
    var dogName: String
    var userAge: String
    var timestamp: Timestamp
}


#Preview {
    ReviewRateView()
}
