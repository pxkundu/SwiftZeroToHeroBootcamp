import SwiftUI

@main
struct ContactApp: App {
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContactListView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
} 