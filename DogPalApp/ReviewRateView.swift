import SwiftUI
import Firebase
import FirebaseAuth

struct ReviewRateView: View {
    @State private var commentText: String = ""
    @State private var rating: Int = 0
    @State private var userName: String = ""
    @State private var dogBreed: String = ""
    @State private var selection = 0
    @State private var parks: [ParkReviewData] = []
    @State private var userReviews: [ParkReview] = []
    
    let ref = Database.database().reference()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image("DogPalLogo2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 150)
                    .padding(.bottom, 10)
                
                Text("Park Reviews")
                                   .font(.title)
                                   .fontWeight(.bold)
                                   .foregroundColor(Color.black)
                                   .multilineTextAlignment(.center)  // Centralizando o texto
                               
                               Text("Name: \(userName)")
                                   .font(.title3)
                                   .bold()
                                   .foregroundColor(.primary)  // Usando a cor padrão do texto
                               
                               Text("Dog Breed: \(dogBreed)")
                                   .font(.title3)
                                   .bold()
                                   .foregroundColor(.primary)
                               
                Picker("Choose Park for Review:", selection: $selection) {
                    ForEach(parkNames.indices, id: \.self) { index in
                        Text(parkNames[index]).tag(index)
                    }
                }

                .pickerStyle(MenuPickerStyle()) // Estilo do Picker

                  
                TextEditor(text: $commentText)
                    .frame(height: 100)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                HStack {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(star <= rating ? .yellow : .gray)
                            .onTapGesture {
                                rating = star
                            }
                    }
                }
                
                Button(action: saveComment) {
                    Text("Save Comment")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Text("Your Reviews")
                    .font(.headline)
                    .padding(.top, 20)
                
                ForEach(userReviews) { review in
                    ReviewCardView(review: review)
                }
                
                Divider().padding(.vertical)
                
                // Exibindo as avaliações de parques
                ForEach(parks) { park in
                    VStack(alignment: .leading, spacing: 20) {
                        Text(park.name)
                            .font(.headline)
                        
                        Text("Average Rating: \(park.rating, specifier: "%.1f")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        LazyVStack(alignment: .leading, spacing: 15) {
                            ForEach(park.reviews) { review in
                                VStack(alignment: .leading) {
                                    Text("Park: \(park.name)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    ReviewCardView(review: review)
                                }
                            }
                        }
                        
                        Divider().padding(.vertical)
                    }
                }
            }
            .padding()
            .onAppear {
                fetchUserDetails()
                fetchParksReviews { reviews in
                    self.parks = reviews
                }
                fetchUserReviews()
            }
        }
    }
    
    func saveComment() {
        guard let user = Auth.auth().currentUser else { return }
        let userId = user.uid
        let commentData: [String: Any] = [
            "userName": userName,
            "dogBreed": dogBreed,
            "commentText": commentText,
            "rating": rating,
            "selectedPark": selection,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        ref.child("comments").child(userId).childByAutoId().setValue(commentData) { error, _ in
            if let error = error {
                print("Error saving comment: \(error.localizedDescription)")
            } else {
                print("Comment saved successfully!")
                commentText = ""
                rating = 0
                selection = 0
                reloadParksData()
                fetchUserReviews() // Atualizar as avaliações do usuário após salvar um novo comentário
            }
        }
    }
    
    func fetchUserDetails() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Database.database().reference().child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any] {
                self.userName = userData["name"] as? String ?? "Unknown User"
                self.dogBreed = userData["dogBreed"] as? String ?? "No Breed"
            }
        }
    }
    
    func fetchParksReviews(completion: @escaping ([ParkReviewData]) -> Void) {
        ref.child("comments").observe(.value) { snapshot in
            var parksDict: [String: [ParkReview]] = [:]
            var parkRatings: [String: [Int]] = [:]
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let userComments = childSnapshot.value as? [String: Any] {
                    for (_, commentData) in userComments {
                        if let data = commentData as? [String: Any],
                           let parkNameIndex = data["selectedPark"] as? Int, parkNameIndex < parkNames.count,
                           let userName = data["userName"] as? String,
                           let rating = data["rating"] as? Int,
                           let comment = data["commentText"] as? String {
                            
                            let parkName = parkNames[parkNameIndex]
                            let review = ParkReview(userName: userName, rating: rating, comment: comment)
                            
                            parksDict[parkName, default: []].append(review)
                            parkRatings[parkName, default: []].append(rating)
                        }
                    }
                }
            }
            
            let updatedParks = parksDict.map { (parkName, reviews) -> ParkReviewData in
                let avgRating = Double(parkRatings[parkName]?.reduce(0, +) ?? 0) / Double(reviews.count)
                return ParkReviewData(name: parkName, rating: avgRating, reviews: reviews)
            }
            
            DispatchQueue.main.async {
                completion(updatedParks)
            }
        }
    }
    
    func fetchUserReviews() {
        guard let user = Auth.auth().currentUser else { return }
        let userId = user.uid
        
        ref.child("comments").child(userId).observe(.value) { snapshot in
            var reviews: [ParkReview] = []
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let reviewData = childSnapshot.value as? [String: Any],
                   let userName = reviewData["userName"] as? String,
                   let rating = reviewData["rating"] as? Int,
                   let comment = reviewData["commentText"] as? String {
                    
                    let review = ParkReview(userName: userName, rating: rating, comment: comment)
                    reviews.append(review)
                }
            }
            
            DispatchQueue.main.async {
                self.userReviews = reviews
            }
        }
    }
    
    func reloadParksData() {
        fetchParksReviews { reviews in
            self.parks = reviews
        }
    }
}

struct ReviewCardView: View {
    var review: ParkReview

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(review.userName)
                    .font(.headline)
                Spacer()
                HStack {
                    ForEach(0..<review.rating) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            Text(review.comment.prefix(100) + (review.comment.count > 100 ? "..." : ""))
                .font(.body)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ParkReviewData: Identifiable {
    let id = UUID()
    var name: String
    var rating: Double
    var reviews: [ParkReview]
}

struct ParkReview: Identifiable {
    let id = UUID()
    var userName: String
    var rating: Int
    var comment: String
}

let parkNames = [
    "Mount Royal Park", "Jean-Drapeau Park", "La Fontaine Park", "Jarry Park",
    "Berri Park", "Lachine Canal Park", "Parc des Rapides", "Parc Angrignon",
    "Parc Maisonneuve", "Parc de la Visitation", "Dorchester Square",
    "Parc du Mont-Saint-Bruno", "Biodome and Botanical Garden", "Parc de la Fontaine",
    "Park Avenue Green Alley", "Parc Mont-Royal Summit", "Beaver Lake",
    "Parc Jeanne-Mance", "Westmount Park", "Parc Outremont", "Parc du Bois-de-Liesse",
    "Parc des Iles-de-Boucherville", "Parc Beaudet",
    "Parc Nature de l'Île-de-la-Visitation", "Parc du Millénaire",
    "Parc des Moulins", "Parc de la Rivière-des-Prairies", "Parc Léon-Provancher",
    "Parc de l'Anse-à-l'Orme"
]
