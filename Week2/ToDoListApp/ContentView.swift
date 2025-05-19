import SwiftUI

struct ContentView: View {
    @State private var tasks = [String]()
    @State private var newTask = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter task", text: $newTask)
                Button("Add") { if !newTask.isEmpty { tasks.append(newTask); newTask = "" } }
                List(tasks, id: \.self) { task in Text(task) }
            }
            .navigationTitle("To-Do List")
        }
    }
}

#Preview {
    ContentView()
}
