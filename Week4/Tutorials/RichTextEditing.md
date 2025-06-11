# Rich Text Editing in Notes App

## Overview
This tutorial covers the implementation of rich text editing features in our Notes app, including text formatting, styling, and custom text attributes.

## Prerequisites
- Basic understanding of SwiftUI
- Familiarity with UIKit components
- Knowledge of NSAttributedString

## Implementation

### 1. Custom Text Editor View
```swift
struct RichTextEditor: UIViewRepresentable {
    @Binding var text: NSAttributedString
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        
        // Configure text attributes
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label
        ]
        textView.typingAttributes = attributes
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor
        
        init(_ parent: RichTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.attributedText
        }
    }
}
```

### 2. Formatting Toolbar
```swift
struct FormattingToolbar: View {
    @Binding var selectedStyle: TextStyle
    @Binding var selectedFont: UIFont
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack {
            // Bold Button
            Button(action: { toggleBold() }) {
                Image(systemName: "bold")
                    .foregroundColor(selectedStyle.contains(.bold) ? .blue : .gray)
            }
            
            // Italic Button
            Button(action: { toggleItalic() }) {
                Image(systemName: "italic")
                    .foregroundColor(selectedStyle.contains(.italic) ? .blue : .gray)
            }
            
            // Font Picker
            Picker("Font", selection: $selectedFont) {
                ForEach(availableFonts, id: \.self) { font in
                    Text(font.fontName).tag(font)
                }
            }
            
            // Color Picker
            ColorPicker("Text Color", selection: $selectedColor)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private func toggleBold() {
        selectedStyle.toggle(.bold)
    }
    
    private func toggleItalic() {
        selectedStyle.toggle(.italic)
    }
}
```

### 3. Text Style Management
```swift
struct TextStyle: OptionSet {
    let rawValue: Int
    
    static let bold = TextStyle(rawValue: 1 << 0)
    static let italic = TextStyle(rawValue: 1 << 1)
    static let underline = TextStyle(rawValue: 1 << 2)
    static let strikethrough = TextStyle(rawValue: 1 << 3)
    
    mutating func toggle(_ style: TextStyle) {
        if contains(style) {
            remove(style)
        } else {
            insert(style)
        }
    }
}

class TextFormattingManager {
    static let shared = TextFormattingManager()
    
    func applyStyle(_ style: TextStyle, to text: NSAttributedString) -> NSAttributedString {
        let mutableText = NSMutableAttributedString(attributedString: text)
        let range = NSRange(location: 0, length: text.length)
        
        if style.contains(.bold) {
            mutableText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
        }
        
        if style.contains(.italic) {
            mutableText.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 16), range: range)
        }
        
        if style.contains(.underline) {
            mutableText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        
        if style.contains(.strikethrough) {
            mutableText.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        
        return mutableText
    }
}
```

### 4. Lists and Indentation
```swift
struct ListFormatting {
    enum ListType {
        case bullet
        case numbered
        case checkbox
    }
    
    static func createList(_ type: ListType, items: [String]) -> NSAttributedString {
        let mutableText = NSMutableAttributedString()
        
        for (index, item) in items.enumerated() {
            let prefix: String
            switch type {
            case .bullet:
                prefix = "• "
            case .numbered:
                prefix = "\(index + 1). "
            case .checkbox:
                prefix = "☐ "
            }
            
            let listItem = NSAttributedString(string: prefix + item + "\n")
            mutableText.append(listItem)
        }
        
        return mutableText
    }
}
```

### 5. Image and Link Handling
```swift
struct RichTextAttachment {
    static func insertImage(_ image: UIImage, at index: Int, in text: NSAttributedString) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let imageString = NSAttributedString(attachment: attachment)
        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.insert(imageString, at: index)
        
        return mutableText
    }
    
    static func addLink(_ url: URL, text: String, in range: NSRange, to attributedText: NSAttributedString) -> NSAttributedString {
        let mutableText = NSMutableAttributedString(attributedString: attributedText)
        mutableText.addAttribute(.link, value: url, range: range)
        return mutableText
    }
}
```

## Best Practices

1. **Performance**
   - Use lazy loading for large documents
   - Implement text caching
   - Optimize image handling

2. **User Experience**
   - Provide visual feedback for formatting changes
   - Implement undo/redo functionality
   - Add keyboard shortcuts

3. **Accessibility**
   - Support VoiceOver
   - Implement proper accessibility labels
   - Maintain readable text sizes

## Exercises

1. Implement basic text formatting (bold, italic, underline)
2. Add support for custom fonts and colors
3. Create a list formatting system
4. Implement image insertion and handling
5. Add link detection and handling

## Next Steps
- Implement markdown support
- Add table formatting
- Create custom text styles
- Implement export to different formats

## Resources
- [UITextView Documentation](https://developer.apple.com/documentation/uikit/uitextview)
- [NSAttributedString Documentation](https://developer.apple.com/documentation/foundation/nsattributedstring)
- [TextKit Programming Guide](https://developer.apple.com/documentation/uikit/textkit) 