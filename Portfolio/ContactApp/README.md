# iOS Contact App Clone

A modern iOS contact management application built with SwiftUI, replicating the core functionality of the native iOS Contacts app.

## Features

- Contact Management
  - Create, read, update, and delete contacts
  - Multiple phone numbers and email addresses per contact
  - Contact groups and favorites
  - Contact sharing and export

- User Interface
  - Native iOS design patterns
  - Dark mode support
  - Smooth animations and transitions
  - Search functionality
  - Alphabetical indexing

- Data Management
  - Local storage using Core Data
  - Contact synchronization
  - Data backup and restore
  - Import/Export functionality

## Project Structure

```
ContactApp/
├── Models/         # Data models and Core Data entities
├── Views/          # SwiftUI views and view components
├── ViewModels/     # View models and business logic
├── Services/       # Data services and managers
├── Utilities/      # Helper functions and extensions
└── Resources/      # Assets, localization files, etc.
```

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- macOS 12.0+

## Setup

1. Clone the repository:
```bash
git clone https://github.com/pxkundu/SwiftZeroToHeroBootcamp.git
cd SwiftZeroToHeroBootcamp/Portfolio/ContactApp
```

2. Open the project in Xcode:
```bash
open ContactApp.xcodeproj
```

3. Build and run the project (⌘R)

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Core Data entities and data structures
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and state management
- **Services**: Data persistence and business services

## Features to Implement

- [ ] Contact CRUD operations
- [ ] Contact groups
- [ ] Favorites
- [ ] Search functionality
- [ ] Contact sharing
- [ ] Import/Export
- [ ] Dark mode support
- [ ] Localization
- [ ] Unit tests
- [ ] UI tests

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Apple's Human Interface Guidelines
- SwiftUI Documentation
- Core Data Documentation 