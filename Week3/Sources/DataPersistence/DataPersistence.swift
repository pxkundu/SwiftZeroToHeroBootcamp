import Foundation

// MARK: - Data Store Protocol
public protocol DataStore {
    associatedtype Item: Codable
    
    func save(_ item: Item) throws
    func load() throws -> Item?
    func delete() throws
}

// MARK: - UserDefaults Store
public class UserDefaultsStore<Item: Codable>: DataStore {
    private let key: String
    private let defaults: UserDefaults
    
    public init(key: String, defaults: UserDefaults = .standard) {
        self.key = key
        self.defaults = defaults
    }
    
    public func save(_ item: Item) throws {
        let data = try JSONEncoder().encode(item)
        defaults.set(data, forKey: key)
    }
    
    public func load() throws -> Item? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        return try JSONDecoder().decode(Item.self, from: data)
    }
    
    public func delete() throws {
        defaults.removeObject(forKey: key)
    }
}

// MARK: - File Store
public class FileStore<Item: Codable>: DataStore {
    private let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    public func save(_ item: Item) throws {
        let data = try JSONEncoder().encode(item)
        try data.write(to: fileURL)
    }
    
    public func load() throws -> Item? {
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return try JSONDecoder().decode(Item.self, from: data)
    }
    
    public func delete() throws {
        try FileManager.default.removeItem(at: fileURL)
    }
}

// MARK: - Keychain Store
public class KeychainStore<Item: Codable>: DataStore {
    private let key: String
    private let service: String
    
    public init(key: String, service: String) {
        self.key = key
        self.service = service
    }
    
    public func save(_ item: Item) throws {
        let data = try JSONEncoder().encode(item)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }
    
    public func load() throws -> Item? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data else {
            return nil
        }
        
        return try JSONDecoder().decode(Item.self, from: data)
    }
    
    public func delete() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

// MARK: - Keychain Error
public enum KeychainError: LocalizedError {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
    
    public var errorDescription: String? {
        switch self {
        case .saveFailed(let status):
            return "Failed to save to keychain: \(status)"
        case .loadFailed(let status):
            return "Failed to load from keychain: \(status)"
        case .deleteFailed(let status):
            return "Failed to delete from keychain: \(status)"
        }
    }
}

// MARK: - Data Store Manager
public class DataStoreManager {
    private let userDefaults: UserDefaultsStore<UserPreferences>
    private let fileStore: FileStore<AppData>
    private let keychainStore: KeychainStore<SecureData>
    
    public init() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("app_data.json")
        
        self.userDefaults = UserDefaultsStore(key: "user_preferences")
        self.fileStore = FileStore(fileURL: documentsURL)
        self.keychainStore = KeychainStore(key: "secure_data", service: "com.example.app")
    }
    
    public func saveUserPreferences(_ preferences: UserPreferences) throws {
        try userDefaults.save(preferences)
    }
    
    public func loadUserPreferences() throws -> UserPreferences? {
        try userDefaults.load()
    }
    
    public func saveAppData(_ data: AppData) throws {
        try fileStore.save(data)
    }
    
    public func loadAppData() throws -> AppData? {
        try fileStore.load()
    }
    
    public func saveSecureData(_ data: SecureData) throws {
        try keychainStore.save(data)
    }
    
    public func loadSecureData() throws -> SecureData? {
        try keychainStore.load()
    }
}

// MARK: - Example Models
public struct UserPreferences: Codable {
    public var theme: String
    public var notifications: Bool
    public var language: String
    
    public init(theme: String = "light", notifications: Bool = true, language: String = "en") {
        self.theme = theme
        self.notifications = notifications
        self.language = language
    }
}

public struct AppData: Codable {
    public var lastSyncDate: Date
    public var cachedItems: [String: String]
    
    public init(lastSyncDate: Date = Date(), cachedItems: [String: String] = [:]) {
        self.lastSyncDate = lastSyncDate
        self.cachedItems = cachedItems
    }
}

public struct SecureData: Codable {
    public var apiKey: String
    public var refreshToken: String
    
    public init(apiKey: String, refreshToken: String) {
        self.apiKey = apiKey
        self.refreshToken = refreshToken
    }
} 