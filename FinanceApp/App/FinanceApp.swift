import SwiftData
import SwiftUI

@main
struct FinanceApp: App {
    private let dependencies: DependencyContainer
    @State private var isUnlocked = ProcessInfo.processInfo.arguments.contains("--uitesting")

    init() {
        do { dependencies = try DependencyContainer() }
        catch { fatalError("Unable to initialize the protected local store: \(error.localizedDescription)") }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if isUnlocked { RootView(repository: dependencies.repository) }
                else { LockedView { isUnlocked = await dependencies.authenticator.authenticate() } }
            }
            .task { try? dependencies.repository.seedIfNeeded() }
        }
        .modelContainer(dependencies.modelContainer)
    }
}

private struct LockedView: View {
    let unlock: () async -> Void
    var body: some View {
        ContentUnavailableView {
            Label("auth.locked", systemImage: "lock.shield")
        } description: { Text("auth.description") } actions: {
            Button("auth.unlock") { Task { await unlock() } }.buttonStyle(.borderedProminent)
        }
    }
}
