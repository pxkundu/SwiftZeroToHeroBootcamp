import Foundation

// MARK: - API Client Protocol
public protocol APIClient {
    func fetch<T: Decodable>(_ type: T.Type, from endpoint: APIEndpoint) async throws -> T
    func post<T: Encodable, U: Decodable>(_ data: T, to endpoint: APIEndpoint) async throws -> U
}

// MARK: - API Endpoint
public enum APIEndpoint {
    case users
    case posts
    case comments
    case custom(String)
    
    public var path: String {
        switch self {
        case .users: return "/users"
        case .posts: return "/posts"
        case .comments: return "/comments"
        case .custom(let path): return path
        }
    }
}

// MARK: - API Configuration
public struct APIConfiguration {
    public let baseURL: String
    public let apiKey: String?
    public let timeoutInterval: TimeInterval
    public let cachePolicy: URLRequest.CachePolicy
    
    public static let `default` = APIConfiguration(
        baseURL: "https://api.example.com",
        apiKey: nil,
        timeoutInterval: 30,
        cachePolicy: .returnCacheDataElseLoad
    )
    
    public init(baseURL: String, apiKey: String?, timeoutInterval: TimeInterval, cachePolicy: URLRequest.CachePolicy) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }
}

// MARK: - API Error
public enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case unauthorized
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .unauthorized:
            return "Unauthorized access"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Default API Client
public class DefaultAPIClient: APIClient {
    private let configuration: APIConfiguration
    private let session: URLSession
    
    public init(configuration: APIConfiguration = .default) {
        self.configuration = configuration
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = configuration.timeoutInterval
        config.requestCachePolicy = configuration.cachePolicy
        self.session = URLSession(configuration: config)
    }
    
    public func fetch<T: Decodable>(_ type: T.Type, from endpoint: APIEndpoint) async throws -> T {
        let url = try makeURL(for: endpoint)
        let request = try makeRequest(for: url)
        
        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            return try decode(data)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    public func post<T: Encodable, U: Decodable>(_ data: T, to endpoint: APIEndpoint) async throws -> U {
        let url = try makeURL(for: endpoint)
        var request = try makeRequest(for: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(data)
            
            let (responseData, response) = try await session.data(for: request)
            try validateResponse(response)
            return try decode(responseData)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    private func makeURL(for endpoint: APIEndpoint) throws -> URL {
        var components = URLComponents(string: configuration.baseURL)
        components?.path = endpoint.path
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        return url
    }
    
    private func makeRequest(for url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        
        if let apiKey = configuration.apiKey {
            request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        }
        
        return request
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError(httpResponse.statusCode)
        default:
            throw APIError.invalidResponse
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

// MARK: - Example Models
public struct User: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let email: String
    
    public init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

public struct Post: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let body: String
    public let userId: Int
    
    public init(id: Int, title: String, body: String, userId: Int) {
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
    }
} 