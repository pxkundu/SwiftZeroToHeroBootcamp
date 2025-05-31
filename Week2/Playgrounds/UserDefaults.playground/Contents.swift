import SwiftUI
import PlaygroundSupport

// MARK: - Todo Item Model
struct TodoItem: Codable, Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

// MARK: - Todo Store
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
    
    func addItem(_ title: String) {
        let item = TodoItem(title: title)
        items.append(item)
        saveItems()
    }
    
    func toggleItem(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
            saveItems()
        }
    }
}

// MARK: - Todo List View
struct TodoListView: View {
    @StateObject private var store = TodoStore()
    @State private var newItemTitle = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Add new item
                HStack {
                    TextField("New todo", text: $newItemTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Add") {
                        if !newItemTitle.isEmpty {
                            store.addItem(newItemTitle)
                            newItemTitle = ""
                        }
                    }
                }
                .padding()
                
                // List of items
                List {
                    ForEach(store.items) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    store.toggleItem(item)
                                }
                            
                            Text(item.title)
                                .strikethrough(item.isCompleted)
                        }
                    }
                }
            }
            .navigationTitle("Todo List")
        }
    }
}

// MARK: - Preview
PlaygroundPage.current.setLiveView(TodoListView()) 