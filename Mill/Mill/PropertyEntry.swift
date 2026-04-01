import Foundation
import SwiftData

@Model
final class PropertyEntry {
    var category: String
    var title: String
    var value: String?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date

    var property: Property?

    init(category: String, title: String, value: String? = nil, notes: String? = nil, property: Property? = nil) {
        self.category = category
        self.title = title
        self.value = value
        self.notes = notes
        self.property = property
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
