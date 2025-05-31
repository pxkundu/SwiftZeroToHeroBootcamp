import SwiftUI
import PlaygroundSupport

// MARK: - Arrays
print("=== Arrays ===")
// Creating arrays
var numbers = [1, 2, 3, 4, 5]
var fruits = ["Apple", "Banana", "Orange"]

// Array operations
print("First fruit: \(fruits[0])")
fruits.append("Mango")
print("After append: \(fruits)")
fruits.insert("Grape", at: 1)
print("After insert: \(fruits)")
fruits.remove(at: 2)
print("After remove: \(fruits)")

// Array iteration
print("\nIterating through fruits:")
for fruit in fruits {
    print("- \(fruit)")
}

// Array methods
print("\nArray methods:")
print("Count: \(fruits.count)")
print("Is empty: \(fruits.isEmpty)")
print("Contains 'Apple': \(fruits.contains("Apple"))")

// MARK: - Dictionaries
print("\n=== Dictionaries ===")
// Creating dictionaries
var scores = ["John": 85, "Alice": 92, "Bob": 78]
var settings = ["darkMode": true, "notifications": false]

// Dictionary operations
print("John's score: \(scores["John"] ?? 0)")
scores["Charlie"] = 88
print("After adding Charlie: \(scores)")
scores["John"] = 90
print("After updating John: \(scores)")
scores.removeValue(forKey: "Bob")
print("After removing Bob: \(scores)")

// Dictionary iteration
print("\nIterating through scores:")
for (name, score) in scores {
    print("\(name): \(score)")
}

// MARK: - Optionals
print("\n=== Optionals ===")
// Optional variables
var name: String? = "John"
var age: Int? = nil

// Optional binding
if let unwrappedName = name {
    print("Name is: \(unwrappedName)")
} else {
    print("Name is nil")
}

// Nil coalescing
let actualAge = age ?? 0
print("Age is: \(actualAge)")

// Optional chaining
struct Person {
    var name: String
    var address: Address?
}

struct Address {
    var street: String
    var city: String
}

let person = Person(name: "Alice", address: Address(street: "123 Main St", city: "Boston"))
print("City: \(person.address?.city ?? "Unknown")")

// MARK: - Practical Example: Todo List with Optionals
struct TodoItem {
    var title: String
    var description: String?
    var dueDate: Date?
    var priority: Int?
    
    func displayInfo() {
        print("\nTodo: \(title)")
        if let desc = description {
            print("Description: \(desc)")
        }
        if let date = dueDate {
            print("Due: \(date)")
        }
        if let pri = priority {
            print("Priority: \(pri)")
        }
    }
}

// Create some todo items
let todo1 = TodoItem(title: "Buy groceries", description: "Milk, eggs, bread", priority: 1)
let todo2 = TodoItem(title: "Call mom", dueDate: Date(), priority: 2)
let todo3 = TodoItem(title: "Exercise", description: "30 minutes jogging")

// Display todo items
print("\n=== Todo List Example ===")
todo1.displayInfo()
todo2.displayInfo()
todo3.displayInfo()

// MARK: - SwiftUI Preview
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Swift Collections & Optionals")
                .font(.title)
                .padding()
            
            Text("Check the console output for examples")
                .foregroundColor(.secondary)
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView()) 