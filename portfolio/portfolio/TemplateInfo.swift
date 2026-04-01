//
//  TemplateInfo.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import Foundation
import CloudKit

struct TemplateInfo: Identifiable, Hashable {
    let id: String
    let name: String
    let fields: [String]

    init(record: CKRecord) {
        self.id = record.recordID.recordName
        self.name = record["name"] as? String ?? "Untitled"
        // Extract field names from the record, excluding system/meta keys
        let excludedKeys: Set<String> = ["name"]
        self.fields = record.allKeys()
            .filter { !excludedKeys.contains($0) }
            .sorted()
    }
}
