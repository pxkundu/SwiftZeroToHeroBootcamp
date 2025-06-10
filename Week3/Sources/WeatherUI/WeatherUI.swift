import SwiftUI

// MARK: - Weather View Model
@MainActor
public class WeatherViewModel: ObservableObject {
    @Published public private(set) var currentWeather: WeatherData?
    @Published public private(set) var forecast: ForecastData?
    @Published public private(set) var isLoading = false
    @Published public private(set) var error: Error?
    
    private let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    public func fetchWeather(for city: String) async {
        isLoading = true
        error = nil
        
        do {
            currentWeather = try await weatherService.fetchWeather(for: city)
            forecast = try await weatherService.fetchForecast(for: city)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

// MARK: - Weather Detail View
public struct WeatherDetailView: View {
    let weather: WeatherData
    
    public init(weather: WeatherData) {
        self.weather = weather
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // City and Country
            Text("\(weather.name), \(weather.sys.country)")
                .font(.title)
                .bold()
            
            // Weather Icon
            if let iconURL = weather.weather.first?.iconURL {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }
            
            // Temperature
            Text(weather.main.temperature)
                .font(.system(size: 48, weight: .bold))
            
            // Weather Description
            Text(weather.weather.first?.description.capitalized ?? "")
                .font(.title2)
            
            // Additional Details
            HStack(spacing: 20) {
                WeatherDetailItem(title: "Feels Like", value: weather.main.feelsLike)
                WeatherDetailItem(title: "Humidity", value: "\(weather.main.humidity)%")
                WeatherDetailItem(title: "Wind", value: "\(weather.wind.speed) m/s")
            }
        }
        .padding()
    }
}

// MARK: - Weather Detail Item
public struct WeatherDetailItem: View {
    let title: String
    let value: String
    
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    public var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
    }
}

// MARK: - Forecast View
public struct ForecastView: View {
    let forecast: ForecastData
    
    public init(forecast: ForecastData) {
        self.forecast = forecast
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(forecast.list) { item in
                    ForecastItemView(item: item)
                }
            }
            .padding()
        }
    }
}

// MARK: - Forecast Item View
public struct ForecastItemView: View {
    let item: ForecastData.ForecastItem
    
    public init(item: ForecastData.ForecastItem) {
        self.item = item
    }
    
    public var body: some View {
        VStack {
            Text(item.date, style: .time)
                .font(.caption)
            
            if let iconURL = item.weather.first?.iconURL {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }
            
            Text(item.main.temperature)
                .font(.headline)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Weather Search View
public struct WeatherSearchView: View {
    @State private var searchText = ""
    @ObservedObject var viewModel: WeatherViewModel
    
    public init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Enter city name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                Button("Search") {
                    Task {
                        await viewModel.fetchWeather(for: searchText)
                    }
                }
                .disabled(searchText.isEmpty)
            }
            .padding()
            
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                    .padding()
            } else if let weather = viewModel.currentWeather {
                WeatherDetailView(weather: weather)
                
                if let forecast = viewModel.forecast {
                    ForecastView(forecast: forecast)
                }
            }
            
            Spacer()
        }
    }
} 