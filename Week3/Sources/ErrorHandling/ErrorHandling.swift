import Foundation

// MARK: - App Error
public enum AppError: LocalizedError {
    case network(NetworkError)
    case validation(ValidationError)
    case persistence(PersistenceError)
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .validation(let error):
            return "Validation error: \(error.localizedDescription)"
        case .persistence(let error):
            return "Persistence error: \(error.localizedDescription)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Validation Error
public enum ValidationError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case invalidAge
    case requiredField(String)
    case custom(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email format"
        case .invalidPassword:
            return "Password must be at least 8 characters"
        case .invalidAge:
            return "Age must be between 18 and 100"
        case .requiredField(let field):
            return "\(field) is required"
        case .custom(let message):
            return message
        }
    }
}

// MARK: - Persistence Error
public enum PersistenceError: LocalizedError {
    case saveFailed
    case loadFailed
    case deleteFailed
    case notFound
    case invalidData
    
    public var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save data"
        case .loadFailed:
            return "Failed to load data"
        case .deleteFailed:
            return "Failed to delete data"
        case .notFound:
            return "Data not found"
        case .invalidData:
            return "Invalid data format"
        }
    }
}

// MARK: - Error Handler
public protocol ErrorHandler {
    func handle(_ error: Error)
}

// MARK: - Default Error Handler
public class DefaultErrorHandler: ErrorHandler {
    private let logger: ErrorLogger
    
    public init(logger: ErrorLogger = DefaultErrorLogger()) {
        self.logger = logger
    }
    
    public func handle(_ error: Error) {
        logger.log(error)
        
        switch error {
        case let appError as AppError:
            handleAppError(appError)
        default:
            handleUnknownError(error)
        }
    }
    
    private func handleAppError(_ error: AppError) {
        // Handle specific app errors
        switch error {
        case .network:
            // Handle network errors
            break
        case .validation:
            // Handle validation errors
            break
        case .persistence:
            // Handle persistence errors
            break
        case .unknown:
            // Handle unknown errors
            break
        }
    }
    
    private func handleUnknownError(_ error: Error) {
        // Handle unknown errors
    }
}

// MARK: - Error Logger
public protocol ErrorLogger {
    func log(_ error: Error)
}

// MARK: - Default Error Logger
public class DefaultErrorLogger: ErrorLogger {
    public func log(_ error: Error) {
        print("Error: \(error.localizedDescription)")
        if let appError = error as? AppError {
            print("App Error: \(appError)")
        }
    }
}

// MARK: - Error Handling Extension
public extension Error {
    var appError: AppError {
        if let appError = self as? AppError {
            return appError
        }
        return .unknown(self)
    }
} 