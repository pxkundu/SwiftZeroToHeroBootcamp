# Data Persistence in SwiftUI

This guide explains how to implement data persistence in your SwiftUI apps using UserDefaults and the Codable protocol.

## Table of Contents
1. [Understanding UserDefaults](#understanding-userdefaults)
2. [The Codable Protocol](#the-codable-protocol)
3. [Implementing Data Persistence](#implementing-data-persistence)
4. [Best Practices](#best-practices)

## Understanding UserDefaults

UserDefaults is a simple key-value storage system provided by iOS. It's perfect for storing small amounts of data like user preferences, settings, and simple app state.

### Key Concepts:
- Key-value storage
- Persists between app launches
- Thread-safe
- Limited to simple data types

### Basic Usage:
```swift
// Storing data
UserDefaults.standard.set("value", forKey: "key")

// Retrieving data
let value = UserDefaults.standard.string(forKey: "key")
```

## The Codable Protocol

Codable is a protocol that combines Encodable and Decodable, allowing you to convert Swift objects to and from external representations (like JSON).

### Making a Type Codable:
```swift
struct TodoItem: Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}
```

### Encoding and Decoding:
```swift
// Encoding
let encoder = JSONEncoder()
let data = try encoder.encode(todoItem)

// Decoding
let decoder = JSONDecoder()
let todoItem = try decoder.decode(TodoItem.self, from: data)
```

## Implementing Data Persistence

Here's a step-by-step guide to implementing data persistence in your Todo app:

1. **Create a Data Model**:
```swift
struct TodoItem: Codable, Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}
```

2. **Create a Data Store**:
```swift
class TodoStore: ObservableObject {
    @Published var items: [TodoItem] = []
    private let defaults = UserDefaults.standard
    private let itemsKey = "todoItems"
    
    init() {
        loadItems()
    }
    
    func loadItems() {
        if let data = defaults.data(forKey: itemsKey),
           let items = try? JSONDecoder().decode([TodoItem].self, from: data) {
            self.items = items
        }
    }
    
    func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: itemsKey)
        }
    }
}
```

3. **Use the Store in Your Views**:
```swift
struct TodoListView: View {
    @StateObject private var store = TodoStore()
    
    var body: some View {
        List(store.items) { item in
            Text(item.title)
        }
    }
}
```

## Best Practices

1. **Error Handling**:
   - Always handle encoding/decoding errors
   - Provide fallback values when data is missing

2. **Performance**:
   - Don't store large amounts of data in UserDefaults
   - Consider using Core Data for larger datasets

3. **Security**:
   - Don't store sensitive data in UserDefaults
   - Use Keychain for sensitive information

4. **Code Organization**:
   - Keep data persistence logic separate from views
   - Use a dedicated store class for data management

## Common Pitfalls

1. **Thread Safety**:
   - UserDefaults is thread-safe, but your custom code might not be
   - Always access UserDefaults on the main thread

2. **Data Size**:
   - UserDefaults has a size limit
   - Consider alternatives for large datasets

3. **Type Safety**:
   - Always use type-safe methods when possible
   - Avoid force unwrapping

## Next Steps

1. Try implementing data persistence in your Todo app
2. Experiment with different data structures
3. Add error handling to your persistence code
4. Consider implementing undo/redo functionality

## Additional Resources

- [Apple Documentation: UserDefaults](https://developer.apple.com/documentation/foundation/userdefaults)
- [Apple Documentation: Codable](https://developer.apple.com/documentation/swift/codable)
- [SwiftUI Data Flow](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app) 