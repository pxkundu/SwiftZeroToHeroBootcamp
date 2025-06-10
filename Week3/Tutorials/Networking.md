# Networking in Swift

This guide covers the fundamentals of networking in Swift, focusing on URLSession, async/await, and best practices for API integration.

## Table of Contents
1. [URLSession Basics](#urlsession-basics)
2. [Async/Await](#asyncawait)
3. [Error Handling](#error-handling)
4. [Best Practices](#best-practices)
5. [Example Implementation](#example-implementation)

## URLSession Basics

URLSession is Apple's networking framework that provides an API for downloading and uploading data to and from endpoints.

### Key Components:
- URLSession: The main class for network requests
- URLSessionTask: Represents a single network request
- URLRequest: Configures how a request should be made
- URLResponse: Contains the response from the server

### Basic GET Request:
```swift
let url = URL(string: "https://api.example.com/data")!
let task = URLSession.shared.dataTask(with: url) { data, response, error in
    if let error = error {
        print("Error: \(error)")
        return
    }
    
    guard let data = data else {
        print("No data received")
        return
    }
    
    // Process data
}
task.resume()
```

## Async/Await

Swift's modern concurrency model makes networking code cleaner and easier to understand.

### Async Function:
```swift
func fetchData() async throws -> Data {
    let url = URL(string: "https://api.example.com/data")!
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidResponse
    }
    
    return data
}
```

### Using Async Functions:
```swift
Task {
    do {
        let data = try await fetchData()
        // Process data
    } catch {
        print("Error: \(error)")
    }
}
```

## Error Handling

Proper error handling is crucial for robust networking code.

### Custom Error Types:
```swift
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case serverError(Int)
    case decodingError(Error)
}
```

### Error Handling Example:
```swift
func fetchData() async throws -> Data {
    guard let url = URL(string: "https://api.example.com/data") else {
        throw NetworkError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse
    }
    
    switch httpResponse.statusCode {
    case 200...299:
        return data
    case 400...499:
        throw NetworkError.clientError(httpResponse.statusCode)
    case 500...599:
        throw NetworkError.serverError(httpResponse.statusCode)
    default:
        throw NetworkError.invalidResponse
    }
}
```

## Best Practices

1. **URL Configuration**:
   - Use URLComponents for building URLs
   - Handle URL encoding properly
   - Validate URLs before making requests

2. **Request Configuration**:
   - Set appropriate timeout intervals
   - Configure caching policy
   - Add necessary headers

3. **Response Handling**:
   - Check HTTP status codes
   - Validate response data
   - Handle different content types

4. **Security**:
   - Use HTTPS
   - Implement certificate pinning
   - Handle sensitive data properly

5. **Performance**:
   - Implement caching
   - Use background sessions for large downloads
   - Cancel unnecessary requests

## Example Implementation

Here's a complete example of a network client:

```swift
class NetworkClient {
    static let shared = NetworkClient()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func post<T: Encodable, U: Decodable>(_ data: T, to url: URL) async throws -> U {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(data)
        
        let (responseData, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(U.self, from: responseData)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
```

## Usage Example

```swift
struct User: Codable {
    let id: Int
    let name: String
}

// Fetching data
Task {
    do {
        let url = URL(string: "https://api.example.com/users/1")!
        let user: User = try await NetworkClient.shared.fetch(User.self, from: url)
        print("User: \(user.name)")
    } catch {
        print("Error: \(error)")
    }
}

// Posting data
Task {
    do {
        let url = URL(string: "https://api.example.com/users")!
        let newUser = User(id: 0, name: "John Doe")
        let createdUser: User = try await NetworkClient.shared.post(newUser, to: url)
        print("Created user: \(createdUser.name)")
    } catch {
        print("Error: \(error)")
    }
}
```

## Additional Resources

- [Apple's URLSession Documentation](https://developer.apple.com/documentation/foundation/urlsession)
- [Swift Concurrency Documentation](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency)
- [REST API Best Practices](https://restfulapi.net/)
- [HTTP Status Codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status) 