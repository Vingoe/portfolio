import SwiftUI
import SwiftData

struct AddEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let property: Property

    @State private var category = ""
    @State private var title = ""
    @State private var value = ""
    @State private var notes = ""

    // Existing categories for autocomplete suggestions
    private var existingCategories: [String] {
        let categories = property.entries.map(\.category)
        return Array(Set(categories)).sorted()
    }

    private var filteredCategories: [String] {
        guard !category.isEmpty else { return existingCategories }
        return existingCategories.filter {
            $0.localizedCaseInsensitiveContains(category) && $0 != category
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    TextField("e.g. Boiler, Electrics, Roof", text: $category)
                        .autocorrectionDisabled()

                    if !filteredCategories.isEmpty {
                        ForEach(filteredCategories, id: \.self) { suggestion in
                            Button(suggestion) {
                                category = suggestion
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }

                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Value (optional)", text: $value)
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(category.trimmingCharacters(in: .whitespaces).isEmpty ||
                              title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveEntry() {
        let entry = PropertyEntry(
            category: category.trimmingCharacters(in: .whitespaces),
            title: title.trimmingCharacters(in: .whitespaces),
            value: value.isEmpty ? nil : value.trimmingCharacters(in: .whitespaces),
            notes: notes.isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces),
            property: property
        )
        modelContext.insert(entry)
        dismiss()
    }
}

#Preview {
    AddEntryView(property: Property(name: "Test Property"))
        .modelContainer(for: Property.self, inMemory: true)
}
