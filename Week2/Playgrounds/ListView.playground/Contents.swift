import SwiftUI
import PlaygroundSupport

// MARK: - Todo Item Model
struct TodoItem: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

// MARK: - Todo List View
struct TodoListView: View {
    @State private var items = [
        TodoItem(title: "Learn SwiftUI", isCompleted: false),
        TodoItem(title: "Build Todo App", isCompleted: false),
        TodoItem(title: "Practice Lists", isCompleted: true)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    HStack {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isCompleted ? .green : .gray)
                        
                        Text(item.title)
                            .strikethrough(item.isCompleted)
                    }
                }
            }
            .navigationTitle("Todo List")
        }
    }
}

// MARK: - Preview
PlaygroundPage.current.setLiveView(TodoListView()) 