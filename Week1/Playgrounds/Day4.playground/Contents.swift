import SwiftUI
import PlaygroundSupport

// MARK: - Basic SwiftUI Components
struct BasicComponentsView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Text
            Text("Hello, SwiftUI!")
                .font(.title)
                .foregroundColor(.blue)
            
            // Image
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            // Button
            Button(action: {
                print("Button tapped!")
            }) {
                Text("Tap Me")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - State Management
struct CounterView: View {
    @State private var count = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .font(.title)
            
            HStack(spacing: 20) {
                Button(action: {
                    count -= 1
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 30))
                }
                
                Button(action: {
                    count += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30))
                }
            }
        }
    }
}

// MARK: - Layout and Styling
struct LayoutView: View {
    var body: some View {
        VStack(spacing: 20) {
            // HStack example
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.blue.opacity(Double(index + 1) * 0.3))
                        .frame(width: 50, height: 50)
                }
            }
            
            // ZStack example
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                
                Text("ZStack")
                    .font(.headline)
            }
            
            // Custom styling
            Text("Styled Text")
                .font(.title)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.2))
                )
        }
    }
}

// MARK: - Navigation
struct NavigationExampleView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Detail View 1")) {
                    Text("Item 1")
                }
                NavigationLink(destination: Text("Detail View 2")) {
                    Text("Item 2")
                }
                NavigationLink(destination: Text("Detail View 3")) {
                    Text("Item 3")
                }
            }
            .navigationTitle("Navigation Example")
        }
    }
}

// MARK: - Main View
struct ContentView: View {
    var body: some View {
        TabView {
            BasicComponentsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Basics")
                }
            
            CounterView()
                .tabItem {
                    Image(systemName: "number")
                    Text("Counter")
                }
            
            LayoutView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Layout")
                }
            
            NavigationExampleView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Navigation")
                }
        }
    }
}

// MARK: - Preview
PlaygroundPage.current.setLiveView(ContentView()) 