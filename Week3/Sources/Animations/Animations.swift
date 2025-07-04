import SwiftUI

// MARK: - Animation Types
public enum AnimationType: String, CaseIterable {
    case easeInOut = "Ease In Out"
    case spring = "Spring"
    case linear = "Linear"
    case easeIn = "Ease In"
    case easeOut = "Ease Out"
    
    public var animation: Animation {
        switch self {
        case .easeInOut:
            return .easeInOut(duration: 0.5)
        case .spring:
            return .spring(response: 0.5, dampingFraction: 0.5)
        case .linear:
            return .linear(duration: 0.5)
        case .easeIn:
            return .easeIn(duration: 0.5)
        case .easeOut:
            return .easeOut(duration: 0.5)
        }
    }
}

// MARK: - Custom Transition
public struct SlideTransition: ViewModifier {
    let isPresented: Bool
    
    public init(isPresented: Bool) {
        self.isPresented = isPresented
    }
    
    public func body(content: Content) -> some View {
        content
            .offset(x: isPresented ? 0 : -UIScreen.main.bounds.width)
            .opacity(isPresented ? 1 : 0)
    }
}

public extension View {
    func slideTransition(isPresented: Bool) -> some View {
        modifier(SlideTransition(isPresented: isPresented))
    }
}

// MARK: - Animated Card View
public struct AnimatedCardView: View {
    @State private var isFlipped = false
    @State private var rotation: Double = 0
    
    public init() {}
    
    public var body: some View {
        VStack {
            ZStack {
                // Front of card
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .frame(width: 200, height: 300)
                    .overlay(
                        Text("Front")
                            .font(.title)
                            .foregroundColor(.white)
                    )
                    .opacity(isFlipped ? 0 : 1)
                
                // Back of card
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green)
                    .frame(width: 200, height: 300)
                    .overlay(
                        Text("Back")
                            .font(.title)
                            .foregroundColor(.white)
                    )
                    .opacity(isFlipped ? 1 : 0)
            }
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0)
            )
            
            Button("Flip Card") {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                    rotation += 180
                    isFlipped.toggle()
                }
            }
            .buttonStyle(.bordered)
            .padding()
        }
    }
}

// MARK: - Animation Demo View
public struct AnimationDemoView: View {
    @State private var isExpanded = false
    @State private var selectedAnimation = AnimationType.easeInOut
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Animation Type Picker
                Picker("Animation Type", selection: $selectedAnimation) {
                    ForEach(AnimationType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Animated Square
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .frame(width: isExpanded ? 200 : 100, height: isExpanded ? 200 : 100)
                    .rotationEffect(.degrees(rotation))
                    .scaleEffect(scale)
                    .offset(x: offset)
                    .opacity(opacity)
                    .animation(selectedAnimation.animation, value: isExpanded)
                    .animation(selectedAnimation.animation, value: rotation)
                    .animation(selectedAnimation.animation, value: scale)
                    .animation(selectedAnimation.animation, value: offset)
                    .animation(selectedAnimation.animation, value: opacity)
                
                // Animation Controls
                VStack(spacing: 10) {
                    Button("Expand/Collapse") {
                        isExpanded.toggle()
                    }
                    
                    Button("Rotate") {
                        rotation += 90
                    }
                    
                    Button("Scale") {
                        scale = scale == 1 ? 1.5 : 1
                    }
                    
                    Button("Move") {
                        offset = offset == 0 ? 50 : 0
                    }
                    
                    Button("Fade") {
                        opacity = opacity == 1 ? 0.5 : 1
                    }
                }
                .buttonStyle(.bordered)
                
                // Transition Demo
                VStack {
                    Text("Transition Demo")
                        .font(.headline)
                    
                    if isExpanded {
                        Text("Hello, World!")
                            .font(.title)
                            .padding()
                            .background(Color.green.opacity(0.3))
                            .cornerRadius(10)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .slide
                            ))
                    }
                }
                .animation(selectedAnimation.animation, value: isExpanded)
                
                Spacer()
            }
            .navigationTitle("Animations")
        }
    }
} 