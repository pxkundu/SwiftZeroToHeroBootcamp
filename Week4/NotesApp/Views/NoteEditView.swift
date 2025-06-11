import SwiftUI

struct NoteEditView: View {
    @ObservedObject var viewModel: NotesViewModel
    let note: Note?
    
    @State private var title: String
    @State private var content: String
    @State private var tags: String
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: NotesViewModel, note: Note?) {
        self.viewModel = viewModel
        self.note = note
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
        _tags = State(initialValue: note?.tags.joined(separator: ", ") ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                }
                
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
                
                Section(header: Text("Tags (comma-separated)")) {
                    TextField("Tags", text: $tags)
                }
            }
            .navigationTitle(note == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveNote() {
        let tagArray = tags
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        if let existingNote = note {
            var updatedNote = existingNote
            updatedNote.title = title
            updatedNote.content = content
            updatedNote.tags = tagArray
            updatedNote.modifiedAt = Date()
            viewModel.updateNote(updatedNote)
        } else {
            let newNote = Note(
                title: title,
                content: content,
                tags: tagArray
            )
            viewModel.addNote(title: newNote.title, content: newNote.content)
        }
    }
} 