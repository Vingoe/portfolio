import SwiftUI
import SwiftData

struct TemplateDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var properties: [Property]

    let category: String
    let templates: [EntryTemplate]

    @State private var addedToProperty = false

    private var property: Property? {
        properties.first
    }

    var body: some View {
        List {
            Section {
                ForEach(templates) { template in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(template.title)
                            .font(.body)
                        if let suggested = template.suggestedValue {
                            Text(suggested)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } footer: {
                Text("These entries will be added to your property with blank values for you to fill in.")
            }

            Section {
                Button {
                    addTemplatesToProperty()
                } label: {
                    HStack {
                        Spacer()
                        if addedToProperty {
                            Label("Added!", systemImage: "checkmark.circle.fill")
                        } else {
                            Label("Add to My Property", systemImage: "plus.circle")
                        }
                        Spacer()
                    }
                }
                .disabled(addedToProperty || property == nil)
            }
        }
        .navigationTitle(category)
    }

    private func addTemplatesToProperty() {
        guard let property else { return }

        for template in templates {
            let entry = PropertyEntry(
                category: category,
                title: template.title,
                value: template.suggestedValue,
                property: property
            )
            modelContext.insert(entry)
        }

        addedToProperty = true
    }
}

#Preview {
    let templates = [
        EntryTemplate(id: "1", category: "Boiler", title: "Model", suggestedValue: nil, sortOrder: 0),
        EntryTemplate(id: "2", category: "Boiler", title: "Service Date", suggestedValue: nil, sortOrder: 1),
        EntryTemplate(id: "3", category: "Boiler", title: "Engineer", suggestedValue: nil, sortOrder: 2)
    ]

    NavigationStack {
        TemplateDetailView(category: "Boiler", templates: templates)
    }
    .modelContainer(for: Property.self, inMemory: true)
}
