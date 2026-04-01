//
//  EntryDetailView.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import SwiftUI
import SwiftData

struct EntryDetailView: View {
    @Bindable var entry: UserEntry
    @State private var isEditing = false

    var body: some View {
        List {
            Section("Template") {
                Text(entry.templateName)
                    .foregroundStyle(.secondary)
            }

            Section("Fields") {
                let values = entry.fieldValues
                if values.isEmpty {
                    Text("No fields")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(values.keys.sorted(), id: \.self) { key in
                        LabeledContent(key, value: values[key] ?? "")
                    }
                }
            }

            Section("Notes") {
                Text(entry.notes.isEmpty ? "No notes" : entry.notes)
                    .foregroundStyle(entry.notes.isEmpty ? .secondary : .primary)
            }

            Section {
                LabeledContent("Created", value: entry.createdAt.formatted())
                LabeledContent("Updated", value: entry.updatedAt.formatted())
            }
        }
        .navigationTitle("Entry")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { isEditing = true }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditEntryView(entry: entry)
        }
    }
}
