import SwiftUI
import PlaygroundSupport

// MARK: - Counter App Model
class CounterModel: ObservableObject {
    @Published var count: Int = 0
    @Published var history: [String] = []
    
    func increment() {
        count += 1
        addToHistory("Incremented to \(count)")
    }
    
    func decrement() {
        count -= 1
        addToHistory("Decremented to \(count)")
    }
    
    func reset() {
        count = 0
        addToHistory("Reset to 0")
    }
    
    private func addToHistory(_ action: String) {
        let timestamp = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        history.insert("\(formatter.string(from: timestamp)): \(action)", at: 0)
    }
}

// MARK: - Counter Button View
struct CounterButton: View {
    let title: String
    let action: () -> Void
    let color: Color
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 100, height: 44)
                .background(color)
                .cornerRadius(10)
        }
    }
}

// MARK: - History Row View
struct HistoryRow: View {
    let entry: String
    
    var body: some View {
        Text(entry)
            .font(.subheadline)
            .padding(.vertical, 4)
    }
}

// MARK: - Counter View
struct CounterView: View {
    @StateObject private var model = CounterModel()
    @State private var showingHistory = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Counter Display
                Text("\(model.count)")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(model.count >= 0 ? .blue : .red)
                
                // Counter Controls
                HStack(spacing: 20) {
                    CounterButton(title: "-", action: model.decrement, color: .red)
                    CounterButton(title: "Reset", action: model.reset, color: .gray)
                    CounterButton(title: "+", action: model.increment, color: .green)
                }
                
                // History Button
                Button(action: { showingHistory.toggle() }) {
                    HStack {
                        Image(systemName: "clock")
                        Text("Show History")
                    }
                    .foregroundColor(.blue)
                }
                
                // History List
                if showingHistory {
                    List {
                        ForEach(model.history, id: \.self) { entry in
                            HistoryRow(entry: entry)
                        }
                    }
                    .frame(height: 200)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Counter App")
        }
    }
}

// MARK: - Preview
PlaygroundPage.current.setLiveView(CounterView()) 