import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import UIKit

//Wandrey
//Page created to show the idea of the ratings and comments by user. Need to polish and finish.

struct ReviewRateView: View {
    
    var park: Parklist?
    @State private var reviews: [Review] = [] // Lista de revisões existentes
    @State private var newReview: String = "" // Nova revisão do usuário
    
    @State private var comment = ""
    @State private var userName = ""
    @State private var dogBreed = ""
    @State private var dogName = ""
    @State private var userAge = ""
    
    private var db = Firestore.firestore() // Instância do Firestore
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                if let park = park {
                    Text("Review for \(park.name)")
                        .font(.title)
                        .padding()
                    
                    // Caixa de texto para o comentário
                    TextField("Enter your review", text: $comment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    // Botão para salvar o comentário
                    Button(action: saveReview) {
                        Text("Submit Review")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    // Lista de comentários existentes
                    List(reviews.indices, id: \.self) { index in
                        let review = reviews[index]
                        VStack(alignment: .leading) {
                            Text("\(review.userName) (\(review.dogBreed) - \(review.dogName), \(review.userAge) years):")
                                .font(.headline)
                            Text(review.review)
                                .font(.body)
                            Text("Posted on \(review.timestamp.dateValue(), formatter: dateFormatter)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                        .onAppear(perform: fetchReviews)
                        } else {
                            Text("No park selected.")
                                .font(.title)
                                .padding()
                            }
                        }
                        .padding()
                        .onAppear(perform: fetchUserDetails)
                    }
            }
        
        // Função para buscar as informações do usuário no Firebase
        private func fetchUserDetails() {
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            db.collection("users").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    self.userName = document.get("userName") as? String ?? ""
                    self.dogBreed = document.get("dogBreed") as? String ?? ""
                    self.dogName = document.get("dogName") as? String ?? ""
                    self.userAge = document.get("userAge") as? String ?? ""
                } else {
                    print("User details not found")
                }
            }
        }
        
        // Função para salvar o comentário no Firestore
        private func saveReview() {
            guard let park = park else { return }
            
            let reviewData: [String: Any] = [
                "review": comment,
                "userName": userName,
                "dogBreed": dogBreed,
                "dogName": dogName,
                "userAge": userAge,
                "timestamp": FieldValue.serverTimestamp() // Correção para usar o timestamp do Firestore
            ]
            
            db.collection("parks").document(park.id.uuidString).collection("reviews").addDocument(data: reviewData) { error in
                if let error = error {
                    print("Error saving review: \(error)")
                } else {
                    print("Review saved successfully!")
                    fetchReviews() // Atualiza a lista após salvar
                    comment = "" // Limpa o campo de texto
                }
            }
        }
        
        // Função para buscar os comentários do Firestore
        private func fetchReviews() {
            guard let park = park else { return }
            
            db.collection("parks").document(park.id.uuidString).collection("reviews").order(by: "timestamp", descending: false).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching reviews: \(error)")
                } else if let snapshot = snapshot {
                    reviews = snapshot.documents.compactMap { doc in
                        try? doc.data(as: Review.self)
                    }
                }
            }
        }
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }()
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
