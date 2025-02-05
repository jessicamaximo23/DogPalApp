//
//  ParksView.swift
//  DogPalApp
//
//  Created by Jessica Maximo on 2024-11-14.
//


import SwiftUI
import MapKit


struct ParksView: View {
    
    @State private var searchText = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var closestPark: Parklist?
    
    @State private var route: MKRoute?
    
    
    
    // Lista de parques com nome e coordenadas
    let parks = [
        Parklist(name: "Mount Royal Park", coordinate: CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673)),
        Parklist(name: "Jean-Drapeau Park", coordinate: CLLocationCoordinate2D(latitude: 45.5088, longitude: -73.5530)),
        Parklist(name: "La Fontaine Park", coordinate: CLLocationCoordinate2D(latitude: 45.527290, longitude: -73.570457)),
        Parklist(name: "Jarry Park", coordinate: CLLocationCoordinate2D(latitude: 45.4230, longitude: -73.6032)),
        Parklist(name: "Berri Park", coordinate: CLLocationCoordinate2D(latitude: 45.4710, longitude: -73.5590)),
        Parklist(name: "Lachine Canal Park", coordinate: CLLocationCoordinate2D(latitude: 45.4485, longitude: -73.5752)),
        Parklist(name: "Parc des Rapides", coordinate: CLLocationCoordinate2D(latitude: 45.4539, longitude: -73.6787)),
        Parklist(name: "Parc Angrignon", coordinate: CLLocationCoordinate2D(latitude: 45.4537, longitude: -73.5942)),
        Parklist(name: "Parc Maisonneuve", coordinate: CLLocationCoordinate2D(latitude: 45.5540, longitude: -73.5777)),
        Parklist(name: "Parc de la Visitation", coordinate: CLLocationCoordinate2D(latitude: 45.5473, longitude: -73.6360)),
        Parklist(name: "Dorchester Square", coordinate: CLLocationCoordinate2D(latitude: 45.4984, longitude: -73.5678)),
        Parklist(name: "Parc du Mont-Saint-Bruno", coordinate: CLLocationCoordinate2D(latitude: 45.5165, longitude: -73.3167)),
        Parklist(name: "Biodome and Botanical Garden", coordinate: CLLocationCoordinate2D(latitude: 45.5576, longitude: -73.5456)),
        Parklist(name: "Parc de la Fontaine", coordinate: CLLocationCoordinate2D(latitude: 45.5205, longitude: -73.6165)),
        Parklist(name: "Park Avenue Green Alley", coordinate: CLLocationCoordinate2D(latitude: 45.5225, longitude: -73.5773)),
        Parklist(name: "Parc Mont-Royal Summit", coordinate: CLLocationCoordinate2D(latitude: 45.5100, longitude: -73.5800)),
        Parklist(name: "Beaver Lake", coordinate: CLLocationCoordinate2D(latitude: 45.5075, longitude: -73.5794)),
        Parklist(name: "Parc Jeanne-Mance", coordinate: CLLocationCoordinate2D(latitude: 45.5119, longitude: -73.5806)),
        Parklist(name: "Westmount Park", coordinate: CLLocationCoordinate2D(latitude: 45.4936, longitude: -73.6021)),
        Parklist(name: "Parc Outremont", coordinate: CLLocationCoordinate2D(latitude: 45.5136, longitude: -73.6116)),
        Parklist(name: "Parc du Bois-de-Liesse", coordinate: CLLocationCoordinate2D(latitude: 45.5121, longitude: -73.7595)),
        Parklist(name: "Parc des Iles-de-Boucherville", coordinate: CLLocationCoordinate2D(latitude: 45.5585, longitude: -73.4990)),
        Parklist(name: "Parc Beaudet", coordinate: CLLocationCoordinate2D(latitude: 45.4862, longitude: -73.6583)),
        Parklist(name: "Parc Nature de l'Île-de-la-Visitation", coordinate: CLLocationCoordinate2D(latitude: 45.5595, longitude: -73.6543)),
        Parklist(name: "Parc du Millénaire", coordinate: CLLocationCoordinate2D(latitude: 45.5020, longitude: -73.6083)),
        Parklist(name: "Parc des Moulins", coordinate: CLLocationCoordinate2D(latitude: 45.4410, longitude: -73.5535)),
        Parklist(name: "Parc de la Rivière-des-Prairies", coordinate: CLLocationCoordinate2D(latitude: 45.6193, longitude: -73.6651)),
        Parklist(name: "Parc Léon-Provancher", coordinate: CLLocationCoordinate2D(latitude: 45.5654, longitude: -73.6026)),
        Parklist(name: "Parc de l'Anse-à-l'Orme", coordinate: CLLocationCoordinate2D(latitude: 45.4815, longitude: -73.9302))
    ]
    
    
    
    var body: some View {
        
        VStack {
            Image("DogPalLogo2")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 350, height: 150)
            
            // Campo de busca para o usuário digitar endereço ou código postal
            TextField("Enter address or postal code", text: $searchText, onCommit: {
                geocodeAddress(address: searchText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .frame(height: 50)
            
            MapView(region: $region, route: route, parks: parks)
                .edgesIgnoringSafeArea(.all)
            
            // Show the closest park
            if let closestPark = closestPark {
                
                Text("The nearest park is: ") +
                Text("\(closestPark.name)")
                    .foregroundColor(Color.textFields) +
                Text("\nEnjoy your visit!")
                Spacer()
            }
            
            NavigationLink(destination: ReviewRateView()) {
                Text("Review Parks")
                    .foregroundColor(Color.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(50)
                    .padding(.top, 20)
                    .shadow(radius: 5)
            }
            .disabled(closestPark == nil) // Desabilita o botão se nenhum parque estiver selecionado
            .padding()
        }
    }
    
    
    // Função para geocodificar o endereço e calcular a distância
    func geocodeAddress(address: String) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate {
                userLocation = coordinate
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                findClosestPark(userLocation: coordinate)
            }
        }
    }
    
    
    // Função para encontrar o parque mais próximo
    func findClosestPark(userLocation: CLLocationCoordinate2D) {
        
        var closest: Parklist?
        var minDistance: CLLocationDistance = .greatestFiniteMagnitude
        
        for park in parks {
            let parkLocation = CLLocation(latitude: park.coordinate.latitude, longitude: park.coordinate.longitude)
            let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let distance = userCLLocation.distance(from: parkLocation)
            
            if distance < minDistance {
                minDistance = distance
                closest = park
            }
        }
        
        if let closestPark = closest {
            self.closestPark = closestPark
            getRoute(to: closestPark)
        }
    }
    
    func getRoute(to park: Parklist) {
        
        guard let userLocation = userLocation else { return }
        
        let userPlaceMark = MKPlacemark(coordinate: userLocation)
        let parkPlaceMark = MKPlacemark(coordinate: park.coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlaceMark)
        request.destination = MKMapItem(placemark: parkPlaceMark)
        request.transportType = .automobile // Você pode alterar para .walking se preferir caminhar
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.route = route
            }
        }
    }
    
    
    
    
    struct Parklist: Identifiable {
        var id = UUID()
        var name: String
        var coordinate: CLLocationCoordinate2D
    }
    
    
    struct MapView: UIViewRepresentable {
        @Binding var region: MKCoordinateRegion
        var route: MKRoute?
        var parks: [Parklist]
        
        func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.showsUserLocation = true
            mapView.delegate = context.coordinator  // Adicionando o delegate
            return mapView
        }
        
        func updateUIView(_ uiView: MKMapView, context: Context) {
            uiView.setRegion(region, animated: true)
            
            // Remover anotações antigas
            uiView.removeAnnotations(uiView.annotations)
            
            // Adicionar os parques ao mapa
            let annotations = parks.map { park in
                return MKPointAnnotation(__coordinate: park.coordinate, title: park.name, subtitle: nil)
            }
            uiView.addAnnotations(annotations)
            
            // Remover sobreposições antigas
            uiView.removeOverlays(uiView.overlays)
            
            // Adicionar a rota ao mapa
            if let route = route {
                uiView.addOverlay(route.polyline)
            }
        }
        
        func makeCoordinator() -> MapCoordinator {
            return MapCoordinator()
        }
    }
    
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                
                // Cor laranja para a rota
                renderer.strokeColor = .orange
                renderer.lineWidth = 4
                
                // Definir a linha como tracejada
                renderer.lineDashPattern = [4, 4]  // Padrão de linha tracejada
                
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}


#Preview {
    ParksView()
}
