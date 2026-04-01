import SwiftUI
import SwiftData

@main
struct MillApp: App {
    @State private var cloudKitService = CloudKitService()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Property.self,
            PropertyEntry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environment(cloudKitService)
    }
}
