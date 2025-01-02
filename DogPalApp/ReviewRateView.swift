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
                                        List(reviews, id: \.id) { review in
                                            Text("\(review.userName) (\(review.dogBreed) - \(review.dogName), \(review.userAge) years): \(review.review)")
                                        }
                                        .onAppear(perform: fetchReviews) // Carrega os comentários ao abrir a página
                                    } else {
                                        Text("No park selected.")
                                            .font(.title)
                                            .padding()
                                    }
                                }
                                .padding()
                                .onAppear(perform: fetchUserDetails) // Busca as informações do usuário ao abrir a página
                            }

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
