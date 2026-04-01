//
//  TemplateDetailView.swift
//  portfolio
//
//  Created by Paul Vingoe on 01/04/2026.
//

import SwiftUI

struct TemplateDetailView: View {
    let template: TemplateInfo
    @State private var showingCreateEntry = false

    var body: some View {
        List {
            Section("Template Fields") {
                if template.fields.isEmpty {
                    Text("No fields defined")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(template.fields, id: \.self) { field in
                        Text(field)
                    }
                }
            }
        }
        .navigationTitle(template.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Create Entry") {
                    showingCreateEntry = true
                }
            }
        }
        .sheet(isPresented: $showingCreateEntry) {
            CreateEntryView(template: template)
        }
    }
}
