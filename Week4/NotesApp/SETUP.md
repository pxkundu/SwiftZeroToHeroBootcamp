# Notes App Setup Guide

## Prerequisites
- macOS (Latest version recommended)
- Xcode 16 or later
- iOS 16.0+ simulator or physical device

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/pxkundu/SwiftZeroToHeroBootcamp.git
cd SwiftZeroToHeroBootcamp/Week4/NotesApp
```

### 2. Open the Project
1. Launch Xcode
2. Select "Open a project or file"
3. Navigate to the `Week4/NotesApp` directory
4. Click "Open"

### 3. Configure the Project
1. In Xcode, select the "NotesApp" project in the navigator
2. Select the "NotesApp" target
3. In the "Signing & Capabilities" tab:
   - Select your development team
   - Update the Bundle Identifier if needed (e.g., "com.yourname.NotesApp")

### 4. Run the App
1. Select a simulator or connected device from the device menu in the toolbar
2. Click the "Play" button (▶️) or press `Cmd + R` to build and run the app

## Project Structure
```
NotesApp/
├── Models/
│   └── Note.swift           # Data model for notes
├── Views/
│   ├── NoteListView.swift   # Main list view
│   ├── NoteDetailView.swift # Note detail view
│   └── NoteEditView.swift   # Note creation/editing view
├── ViewModels/
│   └── NotesViewModel.swift # Business logic and state management
├── Services/
│   └── StorageService.swift # Data persistence service
└── NotesApp.swift           # App entry point
```

## Features
- Create, read, update, and delete notes
- Search notes by title, content, or tags
- Pin/unpin important notes
- Add tags to notes
- Automatic date tracking
- Persistent storage using JSON

## Troubleshooting

### Common Issues

1. **Build Errors**
   - Clean the build folder (Cmd + Shift + K)
   - Clean the build folder and remove derived data (Cmd + Shift + K, then hold Option)
   - Restart Xcode

2. **Simulator Issues**
   - Reset the simulator (Device > Erase All Content and Settings)
   - Try a different simulator device

3. **Data Persistence Issues**
   - The app uses UserDefaults for storage
   - To reset all data, delete the app from the simulator/device and reinstall

### Debugging Tips
- Use the Xcode debug console to view print statements
- Enable breakpoints for debugging
- Use the Xcode memory debugger to check for memory issues

## Development Notes

### Data Storage
- The app uses JSON-based storage with UserDefaults
- Data is automatically saved when changes are made
- No additional setup required for data persistence

### Architecture
- MVVM (Model-View-ViewModel) architecture
- SwiftUI for the user interface
- Observable objects for state management

## Next Steps
1. Test the basic functionality:
   - Create a new note
   - Edit an existing note
   - Search for notes
   - Pin/unpin notes
   - Add tags to notes

2. Explore the code:
   - Review the model structure
   - Understand the view hierarchy
   - Study the view model implementation

## Resources
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Swift Documentation](https://docs.swift.org/swift-book/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)

## Support
If you encounter any issues:
1. Check the troubleshooting section
2. Review the error messages in Xcode
3. Search for similar issues in the documentation
4. Create an issue in the repository

Happy coding! 🚀 