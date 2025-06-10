import Foundation

// MARK: - Cache Protocol
public protocol Cache {
    associatedtype Key: Hashable
    associatedtype Value
    
    func set(_ value: Value, forKey key: Key)
    func get(forKey key: Key) -> Value?
    func remove(forKey key: Key)
    func clear()
}

// MARK: - Memory Cache
public actor MemoryCache<Key: Hashable, Value> {
    private var cache: [Key: Value] = [:]
    private let maxSize: Int
    
    public init(maxSize: Int = 100) {
        self.maxSize = maxSize
    }
    
    public func set(_ value: Value, forKey key: Key) {
        if cache.count >= maxSize {
            cache.removeValue(forKey: cache.keys.first!)
        }
        cache[key] = value
    }
    
    public func get(forKey key: Key) -> Value? {
        cache[key]
    }
    
    public func remove(forKey key: Key) {
        cache.removeValue(forKey: key)
    }
    
    public func clear() {
        cache.removeAll()
    }
}

// MARK: - Disk Cache
public actor DiskCache<Key: Hashable, Value: Codable> {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let maxSize: Int
    
    public init(maxSize: Int = 1000) throws {
        self.maxSize = maxSize
        
        let cachesDirectory = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        
        cacheDirectory = cachesDirectory.appendingPathComponent("DiskCache")
        try fileManager.createDirectory(
            at: cacheDirectory,
            withIntermediateDirectories: true
        )
    }
    
    public func set(_ value: Value, forKey key: Key) throws {
        let data = try JSONEncoder().encode(value)
        let fileURL = cacheDirectory.appendingPathComponent(String(describing: key))
        try data.write(to: fileURL)
        
        // Clean up if needed
        try cleanupIfNeeded()
    }
    
    public func get(forKey key: Key) throws -> Value? {
        let fileURL = cacheDirectory.appendingPathComponent(String(describing: key))
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return try JSONDecoder().decode(Value.self, from: data)
    }
    
    public func remove(forKey key: Key) throws {
        let fileURL = cacheDirectory.appendingPathComponent(String(describing: key))
        try fileManager.removeItem(at: fileURL)
    }
    
    public func clear() throws {
        try fileManager.removeItem(at: cacheDirectory)
        try fileManager.createDirectory(
            at: cacheDirectory,
            withIntermediateDirectories: true
        )
    }
    
    private func cleanupIfNeeded() throws {
        let contents = try fileManager.contentsOfDirectory(
            at: cacheDirectory,
            includingPropertiesForKeys: [.creationDateKey]
        )
        
        if contents.count > maxSize {
            let sortedFiles = try contents.sorted { file1, file2 in
                let date1 = try file1.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date()
                let date2 = try file2.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date()
                return date1 < date2
            }
            
            let filesToRemove = sortedFiles.prefix(contents.count - maxSize)
            for file in filesToRemove {
                try fileManager.removeItem(at: file)
            }
        }
    }
}

// MARK: - Cache Manager
@MainActor
public class CacheManager: ObservableObject {
    private let memoryCache: MemoryCache<String, Data>
    private let diskCache: DiskCache<String, Data>
    
    @Published public private(set) var memoryCacheSize: Int = 0
    @Published public private(set) var diskCacheSize: Int = 0
    @Published public private(set) var error: Error?
    
    public init() {
        memoryCache = MemoryCache(maxSize: 100)
        diskCache = try! DiskCache(maxSize: 1000)
    }
    
    public func cacheData(_ data: Data, forKey key: String) async {
        do {
            // Cache in memory
            await memoryCache.set(data, forKey: key)
            
            // Cache on disk
            try await diskCache.set(data, forKey: key)
            
            // Update sizes
            await updateCacheSizes()
        } catch {
            self.error = error
        }
    }
    
    public func getData(forKey key: String) async -> Data? {
        // Try memory cache first
        if let data = await memoryCache.get(forKey: key) {
            return data
        }
        
        // Try disk cache
        do {
            if let data = try await diskCache.get(forKey: key) {
                // Cache in memory for future use
                await memoryCache.set(data, forKey: key)
                return data
            }
        } catch {
            self.error = error
        }
        
        return nil
    }
    
    public func clearCache() async {
        do {
            await memoryCache.clear()
            try await diskCache.clear()
            await updateCacheSizes()
        } catch {
            self.error = error
        }
    }
    
    private func updateCacheSizes() async {
        // In a real app, you would implement proper size tracking
        memoryCacheSize = Int.random(in: 0...100)
        diskCacheSize = Int.random(in: 0...1000)
    }
} 