//
//  UserEntry.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import Foundation
import SwiftData

@Model
final class UserEntry {
    var templateRecordName: String
    var templateName: String
    var fieldValuesData: Data
    var notes: String
    var createdAt: Date
    var updatedAt: Date

    init(
        templateRecordName: String,
        templateName: String,
        fieldValues: [String: String] = [:],
        notes: String = ""
    ) {
        self.templateRecordName = templateRecordName
        self.templateName = templateName
        self.fieldValuesData = (try? JSONEncoder().encode(fieldValues)) ?? Data()
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    var fieldValues: [String: String] {
        get {
            (try? JSONDecoder().decode([String: String].self, from: fieldValuesData)) ?? [:]
        }
        set {
            fieldValuesData = (try? JSONEncoder().encode(newValue)) ?? Data()
            updatedAt = Date()
        }
    }
}
