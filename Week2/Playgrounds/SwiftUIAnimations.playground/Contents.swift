import SwiftUI
import PlaygroundSupport

// MARK: - Animated Todo Item
struct AnimatedTodoItem: View {
    let title: String
    @State private var isCompleted = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(isCompleted ? .green : .gray)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isCompleted.toggle()
                    }
                }
            
            Text(title)
                .strikethrough(isCompleted)
                .foregroundColor(isCompleted ? .gray : .primary)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .offset(x: offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation.width
                }
                .onEnded { gesture in
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
        )
    }
}

// MARK: - Animated List
struct AnimatedTodoList: View {
    @State private var items = [
        "Learn SwiftUI Animations",
        "Build Todo App",
        "Practice Gestures",
        "Master Transitions"
    ]
    @State private var showingAddItem = false
    @State private var newItemTitle = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(items, id: \.self) { item in
                        AnimatedTodoItem(title: item)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .onDelete { indexSet in
                        withAnimation {
                            items.remove(atOffsets: indexSet)
                        }
                    }
                }
                .listStyle(.plain)
                
                if showingAddItem {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showingAddItem = false
                            }
                        }
                    
                    VStack {
                        TextField("New Todo", text: $newItemTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        HStack {
                            Button("Cancel") {
                                withAnimation {
                                    showingAddItem = false
                                }
                            }
                            
                            Button("Add") {
                                withAnimation {
                                    items.append(newItemTitle)
                                    newItemTitle = ""
                                    showingAddItem = false
                                }
                            }
                            .disabled(newItemTitle.isEmpty)
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .navigationTitle("Animated Todo")
            .navigationBarItems(trailing: Button(action: {
                withAnimation {
                    showingAddItem = true
                }
            }) {
                Image(systemName: "plus")
            })
        }
    }
}

// MARK: - Custom Transitions
struct SlideTransition: ViewModifier {
    let isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: isPresented ? 0 : UIScreen.main.bounds.width)
            .animation(.spring(), value: isPresented)
    }
}

// MARK: - Main View
struct ContentView: View {
    var body: some View {
        TabView {
            AnimatedTodoList()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Todo List")
                }
            
            // Animation Examples
            VStack(spacing: 20) {
                Text("Animation Examples")
                    .font(.title)
                
                // Rotation Animation
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 50))
                    .rotationEffect(.degrees(360))
                    .animation(
                        Animation.linear(duration: 2)
                            .repeatForever(autoreverses: false),
                        value: true
                    )
                
                // Scale Animation
                Text("Scale")
                    .font(.title2)
                    .scaleEffect(1.2)
                    .animation(
                        Animation.easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: true
                    )
                
                // Opacity Animation
                Text("Fade")
                    .font(.title2)
                    .opacity(0.5)
                    .animation(
                        Animation.easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: true
                    )
            }
            .tabItem {
                Image(systemName: "sparkles")
                Text("Animations")
            }
        }
    }
}

// MARK: - Preview
PlaygroundPage.current.setLiveView(ContentView()) 