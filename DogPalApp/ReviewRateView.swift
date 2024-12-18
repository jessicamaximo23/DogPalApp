import SwiftUI
import Firebase
import FirebaseAuth
import UIKit

//Wandrey
//Page created to show the idea of the ratings and comments by user. Need to polish and finish.

struct ReviewRateView: View {
    @State private var parks = [
        ParkReviewData(name: "Park Lafontaine", rating: 4.8, imageName: "parclafontaine", description: "One of the most popular parks in Montreal, ideal for picnics and walks.", reviews: [
            ParkReview(userName: "John", rating: 5, comment: "Incredible!"),
            ParkReview(userName: "Alice", rating: 4, comment: "Great place to relax."),
            ParkReview(userName: "Bob", rating: 4, comment: "Very beautiful!")
        ]),
        
        ParkReviewData(name: "Park Jean-Drapeau", rating: 4.7, imageName: "parcjeandrapeau", description: "A park with a view of the river and various outdoor activities.", reviews: [
            ParkReview(userName: "David", rating: 4, comment: "I love running here."),
            ParkReview(userName: "Emily", rating: 5, comment: "A perfect place for a family day.")
        ]),
        
        ParkReviewData(name: "Park Angrignon", rating: 4.6, imageName: "parcangrignon", description: "A peaceful park with large green areas and lakes.", reviews: [
            ParkReview(userName: "Eve", rating: 4, comment: "Excellent for walks."),
            ParkReview(userName: "Jack", rating: 5, comment: "Very well maintained.")
        ])
    ]
    
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
    var review: ParkReview
    
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
    var reviews: [ParkReview]
}

struct ParkReview: Identifiable {
    var id = UUID()
    var userName: String
    var rating: Int
    var comment: String
}

#Preview {
    ReviewRateView()
}
