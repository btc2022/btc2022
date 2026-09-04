import SwiftData

@MainActor
final class DependencyContainer {
    let modelContainer: ModelContainer
    let repository: any FinanceRepository
    let authenticator: any AppAuthenticating
    let apiClient: any FinanceAPIClient
    let secretStore: any SecretStore

    init(inMemory: Bool = false) throws {
        let schema = Schema([StoredAccount.self, StoredCategory.self, StoredTransaction.self, StoredBudget.self])
        modelContainer = try ModelContainer(for: schema,
            configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)])
        repository = SwiftDataFinanceRepository(context: modelContainer.mainContext)
        authenticator = AppAuthenticator()
        apiClient = HTTPSFinanceAPIClient()
        secretStore = KeychainStore()
    }
}
