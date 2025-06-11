import Foundation

struct Note: Identifiable, Codable {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var modifiedAt: Date
    var tags: [String]
    var isPinned: Bool
    
    init(id: UUID = UUID(), title: String, content: String, tags: [String] = [], isPinned: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.tags = tags
        self.isPinned = isPinned
    }
} 