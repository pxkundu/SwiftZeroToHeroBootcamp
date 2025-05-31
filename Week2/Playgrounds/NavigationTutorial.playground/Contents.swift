import SwiftUI
import PlaygroundSupport

// MARK: - Todo Item Model
struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool
}

// MARK: - Todo Detail View
struct TodoDetailView: View {
    let item: TodoItem
    @State private var isCompleted: Bool
    
    init(item: TodoItem) {
        self.item = item
        _isCompleted = State(initialValue: item.isCompleted)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(item.title)
                .font(.title)
                .padding(.bottom)
            
            Text(item.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            Toggle("Completed", isOn: $isCompleted)
                .padding(.top)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Todo Details")
    }
}

// MARK: - Todo List View
struct TodoListView: View {
    @State private var items = [
        TodoItem(title: "Learn SwiftUI", description: "Complete the SwiftUI tutorial and build a sample app", isCompleted: false),
        TodoItem(title: "Build Todo App", description: "Create a fully functional todo app with persistence", isCompleted: false),
        TodoItem(title: "Practice Navigation", description: "Master SwiftUI navigation and list views", isCompleted: true)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: TodoDetailView(item: item)) {
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .gray)
                            
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add new todo
                        let newItem = TodoItem(
                            title: "New Todo",
                            description: "Add details here",
                            isCompleted: false
                        )
                        items.append(newItem)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// MARK: - Preview
PlaygroundPage.current.setLiveView(TodoListView()) 