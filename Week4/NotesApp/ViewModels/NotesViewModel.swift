import Foundation
import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText: String = ""
    @Published var selectedNote: Note?
    @Published var showingNewNote = false
    @Published var showingEditNote = false
    
    private let storage = StorageService.shared
    
    init() {
        loadNotes()
    }
    
    func loadNotes() {
        notes = storage.getAllNotes()
    }
    
    func addNote(title: String, content: String) {
        let note = Note(title: title, content: content)
        storage.addNote(note)
        loadNotes()
    }
    
    func updateNote(_ note: Note) {
        storage.updateNote(note)
        loadNotes()
    }
    
    func deleteNote(_ note: Note) {
        storage.deleteNote(id: note.id)
        loadNotes()
    }
    
    func togglePin(_ note: Note) {
        var updatedNote = note
        updatedNote.isPinned.toggle()
        storage.updateNote(updatedNote)
        loadNotes()
    }
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        }
        return storage.searchNotes(query: searchText)
    }
    
    var pinnedNotes: [Note] {
        notes.filter { $0.isPinned }
    }
    
    var unpinnedNotes: [Note] {
        notes.filter { !$0.isPinned }
    }
} 