import SwiftUI

struct ContentView: View {
    @State private var count = 0
    
    var body: some View {
        VStack {
            Text("Count: \(count)")
            Button("Increment") { count += 1 }
            Button("Decrement") { count -= 1 }
        }
    }
}

#Preview {
    ContentView()
}
