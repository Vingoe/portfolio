//
//  TemplateListView.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import SwiftUI

struct TemplateListView: View {
    var cloudKit: CloudKitService

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(cloudKit.status)
                        .foregroundStyle(.secondary)
                }

                Section("Available Templates") {
                    if cloudKit.templates.isEmpty && !cloudKit.isLoading {
                        Text("No templates available")
                            .foregroundStyle(.secondary)
                    }

                    ForEach(cloudKit.templates) { template in
                        NavigationLink(value: template) {
                            VStack(alignment: .leading) {
                                Text(template.name)
                                    .font(.headline)
                                Text("\(template.fields.count) field(s)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Templates")
            .navigationDestination(for: TemplateInfo.self) { template in
                TemplateDetailView(template: template)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task { await cloudKit.fetchEntryTemplates() }
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    .disabled(cloudKit.isLoading)
                }
            }
            .task {
                await cloudKit.fetchEntryTemplates()
            }
        }
    }
}
