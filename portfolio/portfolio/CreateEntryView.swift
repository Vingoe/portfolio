//
//  CreateEntryView.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import SwiftUI
import SwiftData

struct CreateEntryView: View {
    let template: TemplateInfo

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var fieldValues: [String: String] = [:]
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Fields") {
                    ForEach(template.fields, id: \.self) { field in
                        TextField(field, text: binding(for: field))
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    private func binding(for field: String) -> Binding<String> {
        Binding(
            get: { fieldValues[field, default: ""] },
            set: { fieldValues[field] = $0 }
        )
    }

    private func save() {
        let entry = UserEntry(
            templateRecordName: template.id,
            templateName: template.name,
            fieldValues: fieldValues,
            notes: notes
        )
        modelContext.insert(entry)
        dismiss()
    }
}
