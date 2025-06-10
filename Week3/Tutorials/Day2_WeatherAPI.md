# Day 2: Weather API Integration

## Overview
Today we'll dive into integrating with a real-world API - the OpenWeatherMap API. We'll learn how to model complex data structures and handle real-time weather data.

## Topics Covered
1. Weather Data Modeling
2. API Integration
3. Data Transformation
4. Error Handling
5. Response Processing

## Key Components

### Weather Data Models
```swift
public struct WeatherData: Codable {
    public let weather: [WeatherCondition]
    public let main: MainWeather
    public let wind: Wind
    public let clouds: Clouds
    public let sys: System
    public let name: String
    public let visibility: Int
    public let dt: Int
}
```

### Weather Service
```swift
public class WeatherService {
    private let apiKey: String
    private let session: URLSession
    
    public func fetchWeather(for city: String) async throws -> WeatherData
    public func fetchForecast(for city: String) async throws -> ForecastData
}
```

### Data Transformation
```swift
public struct MainWeather: Codable {
    public let temp: Double
    public let feels_like: Double
    
    public var temperature: String {
        String(format: "%.1f°C", temp)
    }
}
```

## Practical Exercise
1. Set up OpenWeatherMap API access
2. Implement weather data models
3. Create the weather service
4. Handle weather data transformation
5. Test with different cities

## Best Practices
1. Use proper data modeling
2. Implement data transformation methods
3. Handle API errors gracefully
4. Cache weather data when appropriate
5. Format data for display

## Additional Resources
- [OpenWeatherMap API Documentation](https://openweathermap.org/api)
- [Swift Codable](https://developer.apple.com/documentation/swift/codable)
- [Swift String Formatting](https://developer.apple.com/documentation/swift/string/format(_:_:)) 