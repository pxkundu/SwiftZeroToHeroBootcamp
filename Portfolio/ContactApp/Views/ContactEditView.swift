import SwiftUI
import PhotosUI

struct ContactEditView: View {
    @ObservedObject var viewModel: ContactsViewModel
    let contact: Contact?
    
    @Environment(\.dismiss) private var dismiss
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var company: String = ""
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var birthday: Date = Date()
    @State private var phoneNumbers: [String] = [""]
    @State private var emailAddresses: [String] = [""]
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showingPhotoPicker = false
    
    init(viewModel: ContactsViewModel, contact: Contact?) {
        self.viewModel = viewModel
        self.contact = contact
        
        if let contact = contact {
            _firstName = State(initialValue: contact.firstName ?? "")
            _lastName = State(initialValue: contact.lastName ?? "")
            _company = State(initialValue: contact.company ?? "")
            _title = State(initialValue: contact.title ?? "")
            _notes = State(initialValue: contact.notes ?? "")
            _birthday = State(initialValue: contact.birthday ?? Date())
            _phoneNumbers = State(initialValue: contact.phoneNumbers as? [String] ?? [""])
            _emailAddresses = State(initialValue: contact.emailAddresses as? [String] ?? [""])
            _photoData = State(initialValue: contact.photo)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            if let photoData = photoData,
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
                            
                            PhotosPicker(selection: $selectedPhoto,
                                       matching: .images,
                                       photoLibrary: .shared()) {
                                Text("Edit Photo")
                                    .font(.caption)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                
                Section(header: Text("Company")) {
                    TextField("Company", text: $company)
                    TextField("Title", text: $title)
                }
                
                Section(header: Text("Phone Numbers")) {
                    ForEach(phoneNumbers.indices, id: \.self) { index in
                        HStack {
                            TextField("Phone Number", text: $phoneNumbers[index])
                                .keyboardType(.phonePad)
                            
                            if phoneNumbers.count > 1 {
                                Button(action: { removePhoneNumber(at: index) }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: addPhoneNumber) {
                        Label("Add Phone Number", systemImage: "plus.circle.fill")
                    }
                }
                
                Section(header: Text("Email Addresses")) {
                    ForEach(emailAddresses.indices, id: \.self) { index in
                        HStack {
                            TextField("Email", text: $emailAddresses[index])
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            if emailAddresses.count > 1 {
                                Button(action: { removeEmailAddress(at: index) }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Button(action: addEmailAddress) {
                        Label("Add Email Address", systemImage: "plus.circle.fill")
                    }
                }
                
                Section(header: Text("Birthday")) {
                    DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(contact == nil ? "New Contact" : "Edit Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveContact()
                        dismiss()
                    }
                    .disabled(firstName.isEmpty && lastName.isEmpty)
                }
            }
            .onChange(of: selectedPhoto) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        photoData = data
                    }
                }
            }
        }
    }
    
    private func addPhoneNumber() {
        phoneNumbers.append("")
    }
    
    private func removePhoneNumber(at index: Int) {
        phoneNumbers.remove(at: index)
    }
    
    private func addEmailAddress() {
        emailAddresses.append("")
    }
    
    private func removeEmailAddress(at index: Int) {
        emailAddresses.remove(at: index)
    }
    
    private func saveContact() {
        let filteredPhoneNumbers = phoneNumbers.filter { !$0.isEmpty }
        let filteredEmailAddresses = emailAddresses.filter { !$0.isEmpty }
        
        if let contact = contact {
            viewModel.updateContact(
                contact,
                firstName: firstName,
                lastName: lastName,
                phoneNumbers: filteredPhoneNumbers,
                emailAddresses: filteredEmailAddresses,
                company: company.isEmpty ? nil : company,
                title: title.isEmpty ? nil : title,
                notes: notes.isEmpty ? nil : notes,
                birthday: birthday,
                photo: photoData
            )
        } else {
            viewModel.createContact(
                firstName: firstName,
                lastName: lastName,
                phoneNumbers: filteredPhoneNumbers,
                emailAddresses: filteredEmailAddresses,
                company: company.isEmpty ? nil : company,
                title: title.isEmpty ? nil : title,
                notes: notes.isEmpty ? nil : notes,
                birthday: birthday,
                photo: photoData
            )
        }
    }
}

struct ContactEditView_Previews: PreviewProvider {
    static var previews: some View {
        ContactEditView(viewModel: ContactsViewModel(), contact: nil)
    }
} 