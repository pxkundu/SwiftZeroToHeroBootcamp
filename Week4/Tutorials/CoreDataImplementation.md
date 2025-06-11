# Core Data Implementation in Notes App

## Overview
This tutorial covers the implementation of Core Data in our Notes app, including data model design, CRUD operations, and advanced features like search and filtering.

## Prerequisites
- Basic understanding of Swift and SwiftUI
- Xcode 16+
- Familiarity with MVVM architecture

## Data Model Design

### 1. Creating the Data Model
```swift
// Note.xcdatamodeld
Entity: Note
Attributes:
- id: UUID
- title: String
- content: String
- createdAt: Date
- modifiedAt: Date
- tags: [String]
- isPinned: Boolean
- color: String (for theming)

Entity: Attachment
Attributes:
- id: UUID
- fileName: String
- fileType: String
- fileData: Binary
- createdAt: Date

Relationships:
Note -> Attachments (one-to-many)
```

### 2. Core Data Stack Setup
```swift
class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
```

## CRUD Operations

### 1. Create
```swift
func createNote(title: String, content: String) -> Note {
    let note = Note(context: viewContext)
    note.id = UUID()
    note.title = title
    note.content = content
    note.createdAt = Date()
    note.modifiedAt = Date()
    
    try? viewContext.save()
    return note
}
```

### 2. Read
```swift
func fetchNotes() -> [Note] {
    let request: NSFetchRequest<Note> = Note.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.modifiedAt, ascending: false)]
    
    do {
        return try viewContext.fetch(request)
    } catch {
        print("Error fetching notes: \(error)")
        return []
    }
}
```

### 3. Update
```swift
func updateNote(_ note: Note, title: String, content: String) {
    note.title = title
    note.content = content
    note.modifiedAt = Date()
    
    try? viewContext.save()
}
```

### 4. Delete
```swift
func deleteNote(_ note: Note) {
    viewContext.delete(note)
    try? viewContext.save()
}
```

## Advanced Features

### 1. Search and Filtering
```swift
func searchNotes(query: String) -> [Note] {
    let request: NSFetchRequest<Note> = Note.fetchRequest()
    request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@", query, query)
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.modifiedAt, ascending: false)]
    
    do {
        return try viewContext.fetch(request)
    } catch {
        print("Error searching notes: \(error)")
        return []
    }
}
```

### 2. Tag Management
```swift
func addTag(_ tag: String, to note: Note) {
    var tags = note.tags ?? []
    if !tags.contains(tag) {
        tags.append(tag)
        note.tags = tags
        try? viewContext.save()
    }
}

func removeTag(_ tag: String, from note: Note) {
    var tags = note.tags ?? []
    tags.removeAll { $0 == tag }
    note.tags = tags
    try? viewContext.save()
}
```

### 3. Batch Operations
```swift
func deleteAllNotes() {
    let request: NSFetchRequest<NSFetchRequestResult> = Note.fetchRequest()
    let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
    
    do {
        try viewContext.execute(batchDelete)
        try viewContext.save()
    } catch {
        print("Error deleting all notes: \(error)")
    }
}
```

## Best Practices

1. **Error Handling**
   - Always use try-catch blocks for Core Data operations
   - Implement proper error handling and user feedback
   - Log errors for debugging

2. **Performance**
   - Use batch operations for large datasets
   - Implement proper indexing for frequently searched attributes
   - Use background contexts for heavy operations

3. **Data Migration**
   - Plan for future model changes
   - Implement lightweight migration when possible
   - Test migrations thoroughly

## Exercises

1. Implement the basic CRUD operations for the Notes app
2. Add search functionality with multiple criteria
3. Implement tag management system
4. Create a batch import/export feature
5. Add data validation and error handling

## Next Steps
- Implement CloudKit sync
- Add data backup functionality
- Create data migration strategy
- Implement conflict resolution

## Resources
- [Core Data Programming Guide](https://developer.apple.com/documentation/coredata)
- [Core Data Best Practices](https://developer.apple.com/documentation/coredata/loading_and_displaying_a_large_data_feed)
- [Core Data with CloudKit](https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit) 