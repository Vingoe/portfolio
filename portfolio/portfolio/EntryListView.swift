//
//  EntryListView.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import SwiftUI
import SwiftData

struct EntryListView: View {
    @Query(sort: \UserEntry.updatedAt, order: .reverse) private var entries: [UserEntry]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                if entries.isEmpty {
                    ContentUnavailableView(
                        "No Entries",
                        systemImage: "doc.text",
                        description: Text("Browse templates to create your first entry.")
                    )
                }

                ForEach(entries) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.templateName)
                                .font(.headline)
                            Text(entry.updatedAt, style: .relative)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteEntries)
            }
            .navigationTitle("My Entries")
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
    }
}
