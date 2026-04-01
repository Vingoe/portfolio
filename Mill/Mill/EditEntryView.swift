import SwiftUI
import SwiftData

struct EditEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var entry: PropertyEntry

    var body: some View {
        Form {
            Section("Category") {
                TextField("Category", text: $entry.category)
            }

            Section("Details") {
                TextField("Title", text: $entry.title)

                TextField("Value", text: Binding(
                    get: { entry.value ?? "" },
                    set: { entry.value = $0.isEmpty ? nil : $0 }
                ))

                TextField("Notes", text: Binding(
                    get: { entry.notes ?? "" },
                    set: { entry.notes = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                .lineLimit(3...6)
            }

            Section {
                Button("Delete Entry", role: .destructive) {
                    modelContext.delete(entry)
                    dismiss()
                }
            }
        }
        .navigationTitle("Edit Entry")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: entry.title) {
            entry.updatedAt = Date()
        }
        .onChange(of: entry.value) {
            entry.updatedAt = Date()
        }
        .onChange(of: entry.notes) {
            entry.updatedAt = Date()
        }
        .onChange(of: entry.category) {
            entry.updatedAt = Date()
        }
    }
}

#Preview {
    NavigationStack {
        EditEntryView(entry: PropertyEntry(category: "Boiler", title: "Model", value: "Vaillant 832"))
    }
    .modelContainer(for: Property.self, inMemory: true)
}
