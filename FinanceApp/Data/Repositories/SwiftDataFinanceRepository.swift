import Foundation
import SwiftData

@MainActor
final class SwiftDataFinanceRepository: FinanceRepository {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }

    func accounts() throws -> [Account] { try context.fetch(FetchDescriptor<StoredAccount>()).map(\.entity) }
    func categories() throws -> [Category] { try context.fetch(FetchDescriptor<StoredCategory>()).map(\.entity) }
    func transactions() throws -> [Transaction] {
        try context.fetch(FetchDescriptor<StoredTransaction>()).map(\.entity).sorted { $0.date > $1.date }
    }
    func budgets() throws -> [Budget] { try context.fetch(FetchDescriptor<StoredBudget>()).map(\.entity) }

    func add(_ transaction: Transaction) throws {
        // A transaction groups insert and save so partially persisted financial changes cannot escape.
        try context.transaction {
            context.insert(StoredTransaction(transaction))
            try context.save()
        }
    }

    func seedIfNeeded() throws {
        guard try accounts().isEmpty else { return }
        let account = Account(id: UUID(), name: String(localized: "account.main"), currencyCode: "UAH", openingBalance: 0)
        let category = Category(id: UUID(), name: String(localized: "category.food"), kind: .expense)
        try context.transaction {
            context.insert(StoredAccount(account))
            context.insert(StoredCategory(category))
            try context.save()
        }
    }
}
