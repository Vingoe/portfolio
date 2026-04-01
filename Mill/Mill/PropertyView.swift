import SwiftUI
import SwiftData

struct PropertyView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var properties: [Property]

    @State private var showingAddEntry = false
    @State private var showingSetupSheet = false
    @State private var newPropertyName = ""

    private var property: Property? {
        properties.first
    }

    private var groupedEntries: [(category: String, entries: [PropertyEntry])] {
        guard let entries = property?.entries else { return [] }
        let grouped = Dictionary(grouping: entries, by: \.category)
        return grouped
            .map { (category: $0.key, entries: $0.value.sorted { $0.createdAt < $1.createdAt }) }
            .sorted { $0.category < $1.category }
    }

    var body: some View {
        NavigationStack {
            Group {
                if let property {
                    propertyContent(property)
                } else {
                    ContentUnavailableView(
                        "No Property",
                        systemImage: "house",
                        description: Text("Tap the button below to set up your property.")
                    )
                }
            }
            .navigationTitle(property?.name ?? "My Property")
            .toolbar {
                if property != nil {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showingAddEntry = true
                        } label: {
                            Label("Add Entry", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                if let property {
                    AddEntryView(property: property)
                }
            }
            .onAppear {
                if properties.isEmpty {
                    showingSetupSheet = true
                }
            }
            .sheet(isPresented: $showingSetupSheet, onDismiss: {
                if properties.isEmpty {
                    // User dismissed without saving — create a default
                    let defaultProperty = Property(name: "My Property")
                    modelContext.insert(defaultProperty)
                }
            }) {
                setupSheet
            }
        }
    }

    @ViewBuilder
    private func propertyContent(_ property: Property) -> some View {
        if groupedEntries.isEmpty {
            ContentUnavailableView(
                "No Entries Yet",
                systemImage: "doc.text",
                description: Text("Add entries manually or browse templates to get started.")
            )
        } else {
            List {
                ForEach(groupedEntries, id: \.category) { group in
                    Section(group.category) {
                        ForEach(group.entries) { entry in
                            NavigationLink {
                                EditEntryView(entry: entry)
                            } label: {
                                entryRow(entry)
                            }
                        }
                        .onDelete { offsets in
                            deleteEntries(from: group.entries, at: offsets)
                        }
                    }
                }
            }
        }
    }

    private func entryRow(_ entry: PropertyEntry) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title)
                .font(.body)
            if let value = entry.value, !value.isEmpty {
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func deleteEntries(from entries: [PropertyEntry], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
    }

    private var setupSheet: some View {
        NavigationStack {
            Form {
                Section("Property Name") {
                    TextField("e.g. 23 Oak Lane", text: $newPropertyName)
                }
            }
            .navigationTitle("Set Up Property")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingSetupSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let name = newPropertyName.trimmingCharacters(in: .whitespacesAndNewlines)
                        let property = Property(name: name.isEmpty ? "My Property" : name)
                        modelContext.insert(property)
                        showingSetupSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    PropertyView()
        .modelContainer(for: Property.self, inMemory: true)
}
