# Day 4: Data Caching and Persistence

## Overview
Today we'll explore different caching strategies in Swift, including memory and disk caching, and learn how to implement efficient data persistence in our apps.

## Topics Covered
1. Memory Caching
2. Disk Caching
3. Cache Management
4. Data Persistence
5. Cache Cleanup

## Key Components

### Cache Protocol
```swift
public protocol Cache {
    associatedtype Key: Hashable
    associatedtype Value
    
    func set(_ value: Value, forKey key: Key)
    func get(forKey key: Key) -> Value?
    func remove(forKey key: Key)
    func clear()
}
```

### Memory Cache
```swift
public actor MemoryCache<Key: Hashable, Value> {
    private var cache: [Key: Value] = [:]
    private let maxSize: Int
    
    public func set(_ value: Value, forKey key: Key)
    public func get(forKey key: Key) -> Value?
}
```

### Disk Cache
```swift
public actor DiskCache<Key: Hashable, Value: Codable> {
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let maxSize: Int
    
    public func set(_ value: Value, forKey key: Key) throws
    public func get(forKey key: Key) throws -> Value?
}
```

## Practical Exercise
1. Implement memory cache
2. Create disk cache
3. Set up cache manager
4. Handle cache cleanup
5. Test caching strategies

## Best Practices
1. Use appropriate cache types
2. Implement size limits
3. Handle cache cleanup
4. Use async/await for operations
5. Implement proper error handling

## Additional Resources
- [FileManager Documentation](https://developer.apple.com/documentation/foundation/filemanager)
- [Swift Actors](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/actors)
- [Data Persistence](https://developer.apple.com/documentation/foundation/data_persistence) 