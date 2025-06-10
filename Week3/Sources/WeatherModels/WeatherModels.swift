import Foundation

// MARK: - Weather Models
public struct WeatherData: Codable {
    public let weather: [WeatherCondition]
    public let main: MainWeather
    public let wind: Wind
    public let clouds: Clouds
    public let sys: System
    public let name: String
    public let visibility: Int
    public let dt: Int
    
    public struct WeatherCondition: Codable, Identifiable {
        public let id: Int
        public let main: String
        public let description: String
        public let icon: String
        
        public var iconURL: URL? {
            URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        }
        
        public init(id: Int, main: String, description: String, icon: String) {
            self.id = id
            self.main = main
            self.description = description
            self.icon = icon
        }
    }
    
    public struct MainWeather: Codable {
        public let temp: Double
        public let feels_like: Double
        public let temp_min: Double
        public let temp_max: Double
        public let pressure: Int
        public let humidity: Int
        
        public var temperature: String {
            String(format: "%.1f°C", temp)
        }
        
        public var feelsLike: String {
            String(format: "%.1f°C", feels_like)
        }
        
        public init(temp: Double, feels_like: Double, temp_min: Double, temp_max: Double, pressure: Int, humidity: Int) {
            self.temp = temp
            self.feels_like = feels_like
            self.temp_min = temp_min
            self.temp_max = temp_max
            self.pressure = pressure
            self.humidity = humidity
        }
    }
    
    public struct Wind: Codable {
        public let speed: Double
        public let deg: Int
        
        public var direction: String {
            let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
            let index = Int((Double(deg) + 22.5).truncatingRemainder(dividingBy: 360) / 45.0)
            return directions[index]
        }
        
        public init(speed: Double, deg: Int) {
            self.speed = speed
            self.deg = deg
        }
    }
    
    public struct Clouds: Codable {
        public let all: Int
        
        public init(all: Int) {
            self.all = all
        }
    }
    
    public struct System: Codable {
        public let country: String
        public let sunrise: Int
        public let sunset: Int
        
        public var sunriseTime: Date {
            Date(timeIntervalSince1970: TimeInterval(sunrise))
        }
        
        public var sunsetTime: Date {
            Date(timeIntervalSince1970: TimeInterval(sunset))
        }
        
        public init(country: String, sunrise: Int, sunset: Int) {
            self.country = country
            self.sunrise = sunrise
            self.sunset = sunset
        }
    }
    
    public init(weather: [WeatherCondition], main: MainWeather, wind: Wind, clouds: Clouds, sys: System, name: String, visibility: Int, dt: Int) {
        self.weather = weather
        self.main = main
        self.wind = wind
        self.clouds = clouds
        self.sys = sys
        self.name = name
        self.visibility = visibility
        self.dt = dt
    }
}

// MARK: - Forecast Models
public struct ForecastData: Codable {
    public let list: [ForecastItem]
    public let city: City
    
    public struct ForecastItem: Codable, Identifiable {
        public let dt: Int
        public let main: WeatherData.MainWeather
        public let weather: [WeatherData.WeatherCondition]
        public let clouds: WeatherData.Clouds
        public let wind: WeatherData.Wind
        public let visibility: Int
        public let pop: Double
        public let dt_txt: String
        
        public var id: Int { dt }
        
        public var date: Date {
            Date(timeIntervalSince1970: TimeInterval(dt))
        }
        
        public init(dt: Int, main: WeatherData.MainWeather, weather: [WeatherData.WeatherCondition], clouds: WeatherData.Clouds, wind: WeatherData.Wind, visibility: Int, pop: Double, dt_txt: String) {
            self.dt = dt
            self.main = main
            self.weather = weather
            self.clouds = clouds
            self.wind = wind
            self.visibility = visibility
            self.pop = pop
            self.dt_txt = dt_txt
        }
    }
    
    public struct City: Codable {
        public let id: Int
        public let name: String
        public let country: String
        public let sunrise: Int
        public let sunset: Int
        
        public init(id: Int, name: String, country: String, sunrise: Int, sunset: Int) {
            self.id = id
            self.name = name
            self.country = country
            self.sunrise = sunrise
            self.sunset = sunset
        }
    }
    
    public init(list: [ForecastItem], city: City) {
        self.list = list
        self.city = city
    }
}

// MARK: - Weather Service
public class WeatherService {
    private let apiKey: String
    private let session: URLSession
    
    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    public func fetchWeather(for city: String) async throws -> WeatherData {
        let url = makeWeatherURL(for: city)
        return try await fetchData(from: url)
    }
    
    public func fetchForecast(for city: String) async throws -> ForecastData {
        let url = makeForecastURL(for: city)
        return try await fetchData(from: url)
    }
    
    private func makeWeatherURL(for city: String) -> URL {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components.url!
    }
    
    private func makeForecastURL(for city: String) -> URL {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")!
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components.url!
    }
    
    private func fetchData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
} 