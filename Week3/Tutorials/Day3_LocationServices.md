# Day 3: Location Services

## Overview
Today we'll explore Core Location framework and learn how to implement location-based features in our apps, including location tracking, geocoding, and reverse geocoding.

## Topics Covered
1. Core Location Framework
2. Location Permissions
3. Location Updates
4. Geocoding
5. Reverse Geocoding

## Key Components

### Location Manager
```swift
public class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published public private(set) var location: CLLocation?
    @Published public private(set) var error: Error?
    @Published public private(set) var authorizationStatus: CLAuthorizationStatus
}
```

### Geocoder
```swift
public class Geocoder {
    public static let shared = Geocoder()
    private let geocoder = CLGeocoder()
    
    public func geocode(address: String) async throws -> [CLPlacemark]
    public func reverseGeocode(location: CLLocation) async throws -> [CLPlacemark]
}
```

### Location View Model
```swift
@MainActor
public class LocationViewModel: ObservableObject {
    @Published public private(set) var location: CLLocation?
    @Published public private(set) var placemark: CLPlacemark?
    @Published public private(set) var error: Error?
}
```

## Practical Exercise
1. Set up location permissions
2. Implement location tracking
3. Create geocoding functionality
4. Handle location errors
5. Build a location-based UI

## Best Practices
1. Request appropriate location permissions
2. Handle location errors gracefully
3. Implement proper error messages
4. Use async/await for geocoding
5. Cache location data when appropriate

## Additional Resources
- [Core Location Documentation](https://developer.apple.com/documentation/corelocation)
- [Location and Maps Programming Guide](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/LocationAwarenessPG/Introduction/Introduction.html)
- [Privacy in Location Services](https://developer.apple.com/documentation/corelocation/providing_location_services_in_your_app) 