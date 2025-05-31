import SwiftUI
import PlaygroundSupport

// MARK: - Todo Item Model
struct TodoItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, description: String = "", isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }
}

// MARK: - Todo Store
class TodoStore: ObservableObject {
    @Published var items: [TodoItem] = []
    
    // Create
    func addItem(_ item: TodoItem) {
        items.append(item)
    }
    
    // Read
    func getItem(withId id: UUID) -> TodoItem? {
        items.first { $0.id == id }
    }
    
    // Update
    func updateItem(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
    
    // Delete
    func deleteItem(withId id: UUID) {
        items.removeAll { $0.id == id }
    }
    
    // Toggle completion
    func toggleCompletion(for item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
}

// MARK: - Todo Item Row
struct TodoItemRow: View {
    let item: TodoItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.headline)
                if !item.description.isEmpty {
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Todo View
struct AddTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store: TodoStore
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Todo Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section {
                    Button("Add Todo") {
                        let newItem = TodoItem(
                            title: title,
                            description: description
                        )
                        store.addItem(newItem)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("New Todo")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Todo List View
struct TodoListView: View {
    @StateObject private var store = TodoStore()
    @State private var showingAddTodo = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.items) { item in
                    TodoItemRow(
                        item: item,
                        onToggle: { store.toggleCompletion(for: item) },
                        onDelete: { store.deleteItem(withId: item.id) }
                    )
                }
            }
            .navigationTitle("Todo List")
            .navigationBarItems(trailing: Button(action: {
                showingAddTodo = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(store: store)
            }
        }
    }
}

// MARK: - Preview
PlaygroundPage.current.setLiveView(TodoListView()) 