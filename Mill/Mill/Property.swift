import Foundation
import SwiftData

@Model
final class Property {
    var name: String
    var address: String?
    var notes: String?
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \PropertyEntry.property)
    var entries: [PropertyEntry] = []

    init(name: String, address: String? = nil, notes: String? = nil) {
        self.name = name
        self.address = address
        self.notes = notes
        self.createdAt = Date()
    }
}
