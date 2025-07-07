import SwiftUI

struct ContactListView: View {
    @StateObject private var viewModel = ContactsViewModel()
    @State private var showingAddContact = false
    @State private var showingAddGroup = false
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.selectedGroup == nil {
                    Section {
                        NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                            Label("Favorites", systemImage: "star.fill")
                        }
                    }
                }
                
                ForEach(viewModel.contactsBySection, id: \.0) { section in
                    Section(header: Text(section.0)) {
                        ForEach(section.1, id: \.id) { contact in
                            NavigationLink(destination: ContactDetailView(contact: contact, viewModel: viewModel)) {
                                ContactRow(contact: contact)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .searchable(text: $viewModel.searchText, prompt: "Search Contacts")
            .onChange(of: viewModel.searchText) { _ in
                viewModel.searchContacts()
            }
            .navigationTitle(viewModel.selectedGroup?.name ?? "Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddContact = true }) {
                            Label("New Contact", systemImage: "person.badge.plus")
                        }
                        
                        if viewModel.selectedGroup == nil {
                            Button(action: { showingAddGroup = true }) {
                                Label("New Group", systemImage: "person.3")
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                if viewModel.selectedGroup != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("All Contacts") {
                            viewModel.selectGroup(nil)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddContact) {
                ContactEditView(viewModel: viewModel, contact: nil)
            }
            .sheet(isPresented: $showingAddGroup) {
                GroupEditView(viewModel: viewModel)
            }
        }
    }
}

struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        HStack {
            if let photoData = contact.photo,
               let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading) {
                Text("\(contact.firstName ?? "") \(contact.lastName ?? "")")
                    .font(.headline)
                if let company = contact.company {
                    Text(company)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if contact.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}

struct FavoritesView: View {
    @ObservedObject var viewModel: ContactsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.contacts.filter { $0.isFavorite }, id: \.id) { contact in
                NavigationLink(destination: ContactDetailView(contact: contact, viewModel: viewModel)) {
                    ContactRow(contact: contact)
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
} 