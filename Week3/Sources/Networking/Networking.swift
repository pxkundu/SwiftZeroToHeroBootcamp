import Foundation

// MARK: - Network Request
public struct NetworkRequest {
    public let url: URL
    public let method: HTTPMethod
    public let headers: [String: String]
    public let body: Data?
    
    public init(url: URL, method: HTTPMethod = .get, headers: [String: String] = [:], body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
}

// MARK: - HTTP Method
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - Network Response
public struct NetworkResponse {
    public let data: Data
    public let response: HTTPURLResponse
    
    public var statusCode: Int {
        response.statusCode
    }
    
    public var headers: [AnyHashable: Any] {
        response.allHeaderFields
    }
}

// MARK: - Network Error
public enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error with status code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Network Client
public protocol NetworkClient {
    func send(_ request: NetworkRequest) async throws -> NetworkResponse
}

// MARK: - Default Network Client
public class DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func send(_ request: NetworkRequest) async throws -> NetworkResponse {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            return NetworkResponse(data: data, response: httpResponse)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}

// MARK: - Network Client Extension
public extension NetworkClient {
    func send<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        let response = try await send(request)
        return try JSONDecoder().decode(T.self, from: response.data)
    }
    
    func send<T: Encodable>(_ request: NetworkRequest, with body: T) async throws -> NetworkResponse {
        var request = request
        request.body = try JSONEncoder().encode(body)
        return try await send(request)
    }
} 