import SwiftUI

struct GroupEditView: View {
    @ObservedObject var viewModel: ContactsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var groupName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Name")) {
                    TextField("Name", text: $groupName)
                }
            }
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.createGroup(name: groupName)
                        dismiss()
                    }
                    .disabled(groupName.isEmpty)
                }
            }
        }
    }
}

struct GroupListView: View {
    @ObservedObject var viewModel: ContactsViewModel
    @State private var showingAddGroup = false
    
    var body: some View {
        List {
            ForEach(viewModel.groups, id: \.id) { group in
                Button(action: { viewModel.selectGroup(group) }) {
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.blue)
                        Text(group.name ?? "")
                        Spacer()
                        if viewModel.selectedGroup == group {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    viewModel.deleteGroup(viewModel.groups[index])
                }
            }
        }
        .navigationTitle("Groups")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddGroup = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddGroup) {
            GroupEditView(viewModel: viewModel)
        }
    }
}

struct GroupEditView_Previews: PreviewProvider {
    static var previews: some View {
        GroupEditView(viewModel: ContactsViewModel())
    }
} 