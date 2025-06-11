# Portfolio App Design and Implementation

## Overview
This tutorial covers the design and implementation of a professional portfolio app using SwiftUI, focusing on modern design principles, animations, and interactive features.

## Prerequisites
- Basic understanding of SwiftUI
- Familiarity with design principles
- Knowledge of animations and transitions

## Design Principles

### 1. Modern UI Components
```swift
struct ModernCard: View {
    let title: String
    let description: String
    let image: Image
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 8)
    }
}
```

### 2. Custom Navigation
```swift
struct CustomNavigationBar: View {
    @Binding var selectedTab: Int
    let tabs: [String]
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: { selectedTab = index }) {
                    Text(tabs[index])
                        .fontWeight(selectedTab == index ? .bold : .regular)
                        .foregroundColor(selectedTab == index ? .primary : .secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(radius: 4)
    }
}
```

### 3. Animated Transitions
```swift
struct AnimatedTransition: ViewModifier {
    let isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isPresented ? 1 : 0)
            .scaleEffect(isPresented ? 1 : 0.8)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isPresented)
    }
}

extension View {
    func animatedTransition(isPresented: Bool) -> some View {
        modifier(AnimatedTransition(isPresented: isPresented))
    }
}
```

## Portfolio Sections

### 1. Hero Section
```swift
struct HeroSection: View {
    let name: String
    let title: String
    let bio: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image("profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue, lineWidth: 4))
            
            Text(name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(title)
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text(bio)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
```

### 2. Projects Section
```swift
struct ProjectsSection: View {
    let projects: [Project]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Projects")
                .font(.title)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(projects) { project in
                        ProjectCard(project: project)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProjectCard: View {
    let project: Project
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(project.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 280, height: 160)
                .clipped()
                .cornerRadius(12)
            
            Text(project.title)
                .font(.headline)
            
            Text(project.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(project.technologies, id: \.self) { tech in
                    Text(tech)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .frame(width: 280)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 8)
    }
}
```

### 3. Skills Section
```swift
struct SkillsSection: View {
    let skills: [Skill]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Skills")
                .font(.title)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(skills) { skill in
                    SkillCard(skill: skill)
                }
            }
        }
        .padding()
    }
}

struct SkillCard: View {
    let skill: Skill
    
    var body: some View {
        VStack {
            Image(systemName: skill.icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
            
            Text(skill.name)
                .font(.headline)
            
            Text(skill.level)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
```

## Interactive Features

### 1. Contact Form
```swift
struct ContactForm: View {
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var isSubmitting = false
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            TextEditor(text: $message)
                .frame(height: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2))
                )
            
            Button(action: submitForm) {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Send Message")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .disabled(isSubmitting)
        }
        .padding()
    }
    
    private func submitForm() {
        isSubmitting = true
        // Implement form submission logic
    }
}
```

### 2. Social Links
```swift
struct SocialLinks: View {
    let links: [SocialLink]
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(links) { link in
                Link(destination: link.url) {
                    Image(systemName: link.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
    }
}
```

## Best Practices

1. **Design**
   - Use consistent spacing and typography
   - Implement dark mode support
   - Ensure responsive layouts
   - Follow iOS design guidelines

2. **Performance**
   - Optimize image loading
   - Implement lazy loading
   - Use efficient animations
   - Minimize view updates

3. **Accessibility**
   - Add proper labels
   - Support VoiceOver
   - Implement dynamic type
   - Ensure sufficient contrast

## Exercises

1. Create a modern hero section
2. Implement project cards with animations
3. Design an interactive skills section
4. Build a contact form with validation
5. Add social media integration

## Next Steps
- Implement data persistence
- Add analytics tracking
- Create a blog section
- Implement push notifications

## Resources
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)
- [SwiftUI Animations](https://developer.apple.com/documentation/swiftui/animation) 