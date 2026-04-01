import Foundation
import CloudKit

@Observable
final class CloudKitService {
    private let container = CKContainer(identifier: "iCloud.com.oakwood.portfolio")
    private var publicDB: CKDatabase { container.publicCloudDatabase }

    var templateCategories: [String] = []
    var templatesByCategory: [String: [EntryTemplate]] = [:]
    var isLoading = false
    var errorMessage: String?

    func fetchTemplates() async {
        isLoading = true
        errorMessage = nil

        let query = CKQuery(
            recordType: "EntryTemplate",
            predicate: NSPredicate(value: true)
        )
        query.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true)]

        do {
            let (results, _) = try await publicDB.records(matching: query)

            var templates: [EntryTemplate] = []
            for (_, result) in results {
                if let record = try? result.get() {
                    let template = EntryTemplate(
                        id: record.recordID.recordName,
                        category: record["category"] as? String ?? "",
                        title: record["title"] as? String ?? "",
                        suggestedValue: record["suggestedValue"] as? String,
                        sortOrder: record["sortOrder"] as? Int ?? 0
                    )
                    templates.append(template)
                }
            }

            let grouped = Dictionary(grouping: templates, by: \.category)
            await MainActor.run {
                self.templatesByCategory = grouped
                self.templateCategories = grouped.keys.sorted()
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
