import SwiftUI

struct NoteListView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showingNewNote = false
    
    var body: some View {
        NavigationView {
            List {
                if !viewModel.pinnedNotes.isEmpty {
                    Section(header: Text("Pinned")) {
                        ForEach(viewModel.pinnedNotes) { note in
                            NoteRow(note: note, viewModel: viewModel)
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    ForEach(viewModel.unpinnedNotes) { note in
                        NoteRow(note: note, viewModel: viewModel)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search notes")
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewNote = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NoteEditView(viewModel: viewModel, note: nil)
            }
        }
    }
}

struct NoteRow: View {
    let note: Note
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        NavigationLink(destination: NoteDetailView(note: note, viewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(note.title)
                    .font(.headline)
                
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(note.modifiedAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: { viewModel.togglePin(note) }) {
                        Image(systemName: note.isPinned ? "pin.fill" : "pin")
                            .foregroundColor(note.isPinned ? .blue : .gray)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
} 