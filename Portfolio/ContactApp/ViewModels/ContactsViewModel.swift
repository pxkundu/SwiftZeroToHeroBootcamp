import Foundation
import CoreData
import SwiftUI

class ContactsViewModel: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var groups: [ContactGroup] = []
    @Published var searchText: String = ""
    @Published var selectedGroup: ContactGroup?
    @Published var showingAddContact = false
    @Published var showingAddGroup = false
    @Published var showingEditContact = false
    @Published var selectedContact: Contact?
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadContacts()
        loadGroups()
    }
    
    func loadContacts() {
        if let group = selectedGroup {
            contacts = group.contacts?.allObjects as? [Contact] ?? []
        } else {
            contacts = coreDataManager.fetchContacts()
        }
    }
    
    func loadGroups() {
        groups = coreDataManager.fetchGroups()
    }
    
    func searchContacts() {
        if searchText.isEmpty {
            loadContacts()
        } else {
            contacts = coreDataManager.searchContacts(query: searchText)
        }
    }
    
    func createContact(firstName: String, lastName: String, phoneNumbers: [String], emailAddresses: [String], company: String?, title: String?, notes: String?, birthday: Date?, photo: Data?) {
        let contact = coreDataManager.createContact(
            firstName: firstName,
            lastName: lastName,
            phoneNumbers: phoneNumbers,
            emailAddresses: emailAddresses,
            company: company,
            title: title,
            notes: notes,
            birthday: birthday,
            photo: photo
        )
        
        if let group = selectedGroup {
            coreDataManager.addContactToGroup(contact, group: group)
        }
        
        loadContacts()
    }
    
    func updateContact(_ contact: Contact, firstName: String, lastName: String, phoneNumbers: [String], emailAddresses: [String], company: String?, title: String?, notes: String?, birthday: Date?, photo: Data?) {
        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumbers = phoneNumbers
        contact.emailAddresses = emailAddresses
        contact.company = company
        contact.title = title
        contact.notes = notes
        contact.birthday = birthday
        contact.photo = photo
        contact.modifiedAt = Date()
        
        coreDataManager.saveContext()
        loadContacts()
    }
    
    func deleteContact(_ contact: Contact) {
        coreDataManager.deleteContact(contact)
        loadContacts()
    }
    
    func toggleFavorite(_ contact: Contact) {
        contact.isFavorite.toggle()
        coreDataManager.saveContext()
        loadContacts()
    }
    
    func createGroup(name: String) {
        _ = coreDataManager.createGroup(name: name)
        loadGroups()
    }
    
    func deleteGroup(_ group: ContactGroup) {
        coreDataManager.deleteGroup(group)
        loadGroups()
        if selectedGroup == group {
            selectedGroup = nil
            loadContacts()
        }
    }
    
    func selectGroup(_ group: ContactGroup?) {
        selectedGroup = group
        loadContacts()
    }
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                let fullName = "\(contact.firstName ?? "") \(contact.lastName ?? "")"
                return fullName.localizedCaseInsensitiveContains(searchText) ||
                       (contact.company ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var contactsBySection: [(String, [Contact])] {
        let grouped = Dictionary(grouping: filteredContacts) { contact in
            let firstLetter = String(contact.lastName?.prefix(1) ?? "#")
            return firstLetter.uppercased()
        }
        
        return grouped.sorted { $0.key < $1.key }
    }
} 