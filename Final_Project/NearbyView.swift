import SwiftUI
import MapKit
import CoreLocation

struct NearbyView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion()
    @State private var restaurants: [Restaurant] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: restaurants) { restaurant in
                    MapAnnotation(coordinate: restaurant.coordinate) {
                        VStack {
                            Image(systemName: "mappin")
                                .font(.title)
                                .foregroundColor(.red)
                                .background(Circle().fill(.white))
                            Text(restaurant.name)
                                .font(.caption)
                                .padding(4)
                                .cornerRadius(4)
                                .background(.white)
                        }
                    }
                }
                
                VStack {
                    SearchBar(text: $searchText, onSearch: {
                        searchRestaurants()
                    })
                    .padding()
                    Spacer()
                }
            }
            .navigationTitle("Nearby Restaurants")
            .onAppear {
                locationManager.requestLocation()
            }
            .onChange(of: locationManager.location) { newLocation in
                if let location = newLocation {
                    self.region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                    searchRestaurants()
                }
            }
        }
    }
    
    private func searchRestaurants() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText.isEmpty ? "restaurant" : searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for restaurants: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            restaurants = response.mapItems.map { item in
                Restaurant(
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate,
                    address: item.placemark.title ?? "No address available",
                    phone: item.phoneNumber ?? "No phone available"
                )
            }
        }
    }
}

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String
    let phone: String
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
} 
