import Foundation
import CoreLocation

// MARK: - Location Error
public enum LocationError: LocalizedError {
    case locationDenied
    case locationUnknown
    
    public var errorDescription: String? {
        switch self {
        case .locationDenied:
            return "Location access is denied. Please enable it in Settings."
        case .locationUnknown:
            return "Unable to determine location."
        }
    }
}

// MARK: - Location Manager
public class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published public private(set) var location: CLLocation?
    @Published public private(set) var error: Error?
    @Published public private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    public override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10 // Update location when user moves 10 meters
    }
    
    public func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    public func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            error = LocationError.locationDenied
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
    }
}

// MARK: - Geocoder
public class Geocoder {
    public static let shared = Geocoder()
    private let geocoder = CLGeocoder()
    
    private init() {}
    
    public func geocode(address: String) async throws -> [CLPlacemark] {
        try await geocoder.geocodeAddressString(address)
    }
    
    public func reverseGeocode(location: CLLocation) async throws -> [CLPlacemark] {
        try await geocoder.reverseGeocodeLocation(location)
    }
}

// MARK: - Location View Model
@MainActor
public class LocationViewModel: ObservableObject {
    @Published public private(set) var location: CLLocation?
    @Published public private(set) var placemark: CLPlacemark?
    @Published public private(set) var error: Error?
    @Published public private(set) var isLoading = false
    
    private let locationManager = LocationManager()
    private let geocoder = Geocoder.shared
    
    public init() {
        locationManager.requestLocationPermission()
        
        // Observe location updates
        Task {
            for await _ in NotificationCenter.default.notifications(named: .init("LocationDidUpdate")) {
                if let location = locationManager.location {
                    self.location = location
                    await reverseGeocode(location: location)
                }
            }
        }
    }
    
    public func geocode(address: String) async {
        isLoading = true
        error = nil
        
        do {
            let placemarks = try await geocoder.geocode(address: address)
            placemark = placemarks.first
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func reverseGeocode(location: CLLocation) async {
        do {
            let placemarks = try await geocoder.reverseGeocode(location: location)
            placemark = placemarks.first
        } catch {
            self.error = error
        }
    }
} 