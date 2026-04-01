import SwiftUI

struct TemplateCategoryListView: View {
    @Environment(CloudKitService.self) private var cloudKit

    var body: some View {
        NavigationStack {
            Group {
                if cloudKit.isLoading {
                    ProgressView("Loading templates...")
                } else if let error = cloudKit.errorMessage {
                    ContentUnavailableView {
                        Label("Couldn't Load Templates", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(error)
                    } actions: {
                        Button("Try Again") {
                            Task { await cloudKit.fetchTemplates() }
                        }
                    }
                } else if cloudKit.templateCategories.isEmpty {
                    ContentUnavailableView(
                        "No Templates Available",
                        systemImage: "doc.on.doc",
                        description: Text("Templates will appear here once they're published.")
                    )
                } else {
                    List(cloudKit.templateCategories, id: \.self) { category in
                        NavigationLink {
                            TemplateDetailView(
                                category: category,
                                templates: cloudKit.templatesByCategory[category] ?? []
                            )
                        } label: {
                            HStack {
                                Text(category)
                                Spacer()
                                let count = cloudKit.templatesByCategory[category]?.count ?? 0
                                Text("\(count) entries")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Templates")
            .task {
                if cloudKit.templateCategories.isEmpty {
                    await cloudKit.fetchTemplates()
                }
            }
        }
    }
}

#Preview {
    TemplateCategoryListView()
        .environment(CloudKitService())
}
