//
//  CloudKitService.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import Foundation
import CloudKit

@Observable
final class CloudKitService {
    private let container = CKContainer(identifier: "icloud.com.oakwood.portfolio")

    var records: [CKRecord] = []
    var status: String = "Ready"
    var isLoading = false

    func fetchEntryTemplates() async {
        isLoading = true
        status = "Fetching..."

        let database = container.publicCloudDatabase
        let query = CKQuery(recordType: "entrytemplate", predicate: NSPredicate(value: true))

        do {
            let (results, _) = try await database.records(matching: query)
            var fetched: [CKRecord] = []
            for (_, result) in results {
                switch result {
                case .success(let record):
                    fetched.append(record)
                case .failure(let error):
                    print("Record error: \(error)")
                }
            }
            records = fetched
            status = "Fetched \(fetched.count) record(s)"
        } catch {
            status = "Error: \(error.localizedDescription)"
            print("CloudKit fetch error: \(error)")
        }

        isLoading = false
    }
}
