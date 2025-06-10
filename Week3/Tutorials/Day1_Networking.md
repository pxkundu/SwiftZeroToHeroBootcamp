# Day 1: Networking Fundamentals

## Overview
Today we'll explore the fundamentals of networking in Swift, focusing on creating a robust API client that can handle various types of requests and responses.

## Topics Covered
1. Creating a Generic API Client
2. Handling API Endpoints
3. Error Handling
4. Request Configuration
5. Response Validation

## Key Components

### API Client Protocol
```swift
public protocol APIClient {
    func fetch<T: Decodable>(_ type: T.Type, from endpoint: APIEndpoint) async throws -> T
    func post<T: Encodable, U: Decodable>(_ data: T, to endpoint: APIEndpoint) async throws -> U
}
```

### API Endpoint Enumeration
```swift
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
```

### Error Handling
```swift
public enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case unauthorized
    case networkError(Error)
}
```

## Practical Exercise
1. Implement the `DefaultAPIClient` class
2. Create sample models for API responses
3. Test the client with different endpoints
4. Handle various error scenarios

## Best Practices
1. Use async/await for asynchronous operations
2. Implement proper error handling
3. Configure request timeouts and cache policies
4. Validate responses before processing
5. Use type-safe endpoints

## Additional Resources
- [URLSession Documentation](https://developer.apple.com/documentation/foundation/urlsession)
- [Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency)
- [Error Handling in Swift](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling)
