import SwiftUI
import Firebase
import FirebaseAuth
import UIKit

//Wandrey
//Page created to show the idea of the ratings and comments by user. Need to polish and finish.

struct ReviewRateView: View {
    
    @State private var text1 = "text here"
    @State private var commentText: String = ""
    @State private var rating: Int = 0
    @State private var userName: String = ""
    @State private var dogBreed: String = ""
    let ref = Database.database().reference()
    
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
                
                //testing textbox for response
                Text("Name: \(userName)")
                    .font(.title2)
                    .bold()
                Text("Dog Breed: \(dogBreed)")
                    .font(.title2)
                    .bold()
                
                // Caixa de texto para o comentário
                TextEditor(text: $commentText)
                    .frame(height: 100)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal)
                
                // Seletor de estrelas para avaliação
                HStack {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(star <= rating ? .yellow : .gray)
                            .onTapGesture {
                                rating = star // Atualiza a nota
                            }
                    }
                }
                .padding()
                
                // Botão para salvar comentário
                Button(action: saveComment) {
                    Text("Save Comment")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                }
                
                
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
                .onAppear { fetchUserDetails() // Busca os detalhes do usuário ao carregar a view
                }
            }
        }
        .padding()
    }
    
    
    // Função para salvar o comentário e a nota no Firebase
    func saveComment() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let commentData: [String: Any] = [
                "userName": userName,
                "userAge": dogBreed,
                "commentText": commentText,
                "rating": rating,
                "timestamp": Date().timeIntervalSince1970
            ]
            
            ref.child("comments").child(userId).childByAutoId().setValue(commentData) { error, _ in
                if let error = error {
                    print("Erro ao salvar comentário: \(error.localizedDescription)")
                } else {
                    print("Comentário salvo com sucesso!")
                    // Limpa os campos após salvar
                    commentText = ""
                    rating = 0
                }
            }
        } else {
            print("Nenhum usuário está logado.")
        }
    }
    
    //funcao para carregar oo usuario
    func fetchUserDetails() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Database.database().reference().child("users").child(uid)
        
        userRef.observeSingleEvent(of: .value) { snapshot  in
            if let userData = snapshot.value as? [String: Any] {
                self.userName = userData["name"] as? String ?? "Unknown User"
                self.dogBreed = userData["dogBreed"] as? String ?? "No Breed"
                
            }
        } withCancel: { error in
            print("Error fetching user data: \(error.localizedDescription)")
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
