//
//  EditEntryView.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import SwiftUI
import SwiftData

struct EditEntryView: View {
    @Bindable var entry: UserEntry
    @Environment(\.dismiss) private var dismiss

    @State private var fieldValues: [String: String] = [:]
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Fields") {
                    ForEach(fieldValues.keys.sorted(), id: \.self) { key in
                        TextField(key, text: binding(for: key))
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
            .onAppear {
                fieldValues = entry.fieldValues
                notes = entry.notes
            }
        }
    }

    private func binding(for key: String) -> Binding<String> {
        Binding(
            get: { fieldValues[key, default: ""] },
            set: { fieldValues[key] = $0 }
        )
    }

    private func save() {
        entry.fieldValues = fieldValues
        entry.notes = notes
        dismiss()
    }
}
