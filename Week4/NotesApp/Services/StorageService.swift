import Foundation

class StorageService {
    static let shared = StorageService()
    private var notes: [Note] = []
    
    private init() {
        loadNotes()
    }
    
    // MARK: - CRUD Operations
    
    func getAllNotes() -> [Note] {
        return notes.sorted { $0.modifiedAt > $1.modifiedAt }
    }
    
    func getNote(id: UUID) -> Note? {
        return notes.first { $0.id == id }
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    func deleteNote(id: UUID) {
        notes.removeAll { $0.id == id }
        saveNotes()
    }
    
    // MARK: - Search and Filter
    
    func searchNotes(query: String) -> [Note] {
        let lowercasedQuery = query.lowercased()
        return notes.filter { note in
            note.title.lowercased().contains(lowercasedQuery) ||
            note.content.lowercased().contains(lowercasedQuery) ||
            note.tags.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
    
    func getPinnedNotes() -> [Note] {
        return notes.filter { $0.isPinned }
    }
    
    // MARK: - Private Methods
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }
} 