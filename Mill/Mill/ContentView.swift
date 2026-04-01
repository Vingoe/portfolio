import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            PropertyView()
                .tabItem {
                    Label("My Property", systemImage: "house")
                }

            TemplateCategoryListView()
                .tabItem {
                    Label("Templates", systemImage: "doc.on.doc")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Property.self, inMemory: true)
        .environment(CloudKitService())
}
