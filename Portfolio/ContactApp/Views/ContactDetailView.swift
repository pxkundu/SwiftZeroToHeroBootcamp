import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    @ObservedObject var viewModel: ContactsViewModel
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        if let photoData = contact.photo,
                           let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                        
                        Text("\(contact.firstName ?? "") \(contact.lastName ?? "")")
                            .font(.title2)
                            .bold()
                        
                        if let company = contact.company {
                            Text(company)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical)
            }
            
            if let phoneNumbers = contact.phoneNumbers as? [String], !phoneNumbers.isEmpty {
                Section(header: Text("Phone")) {
                    ForEach(phoneNumbers, id: \.self) { number in
                        Button(action: { callNumber(number) }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.blue)
                                Text(number)
                            }
                        }
                    }
                }
            }
            
            if let emailAddresses = contact.emailAddresses as? [String], !emailAddresses.isEmpty {
                Section(header: Text("Email")) {
                    ForEach(emailAddresses, id: \.self) { email in
                        Button(action: { sendEmail(email) }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.blue)
                                Text(email)
                            }
                        }
                    }
                }
            }
            
            if let title = contact.title {
                Section(header: Text("Title")) {
                    Text(title)
                }
            }
            
            if let birthday = contact.birthday {
                Section(header: Text("Birthday")) {
                    Text(birthday, style: .date)
                }
            }
            
            if let notes = contact.notes, !notes.isEmpty {
                Section(header: Text("Notes")) {
                    Text(notes)
                }
            }
            
            if let groups = contact.groups?.allObjects as? [ContactGroup], !groups.isEmpty {
                Section(header: Text("Groups")) {
                    ForEach(groups, id: \.id) { group in
                        Text(group.name ?? "")
                    }
                }
            }
            
            Section {
                Button(action: { showingDeleteAlert = true }) {
                    HStack {
                        Spacer()
                        Text("Delete Contact")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            ContactEditView(viewModel: viewModel, contact: contact)
        }
        .alert("Delete Contact", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteContact(contact)
            }
        } message: {
            Text("Are you sure you want to delete this contact? This action cannot be undone.")
        }
    }
    
    private func callNumber(_ number: String) {
        guard let url = URL(string: "tel://\(number.replacingOccurrences(of: " ", with: ""))") else { return }
        UIApplication.shared.open(url)
    }
    
    private func sendEmail(_ email: String) {
        guard let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactDetailView(
                contact: Contact(context: CoreDataManager.shared.context),
                viewModel: ContactsViewModel()
            )
        }
    }
} 