import Foundation

struct EntryTemplate: Identifiable {
    let id: String
    let category: String
    let title: String
    let suggestedValue: String?
    let sortOrder: Int
}
