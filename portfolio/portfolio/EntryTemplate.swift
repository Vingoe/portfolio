//
//  EntryTemplate.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import Foundation
import SwiftData

@Model
final class EntryTemplate {
    var ckRecordName: String
    var name: String

    init(ckRecordName: String, name: String) {
        self.ckRecordName = ckRecordName
        self.name = name
    }
}
