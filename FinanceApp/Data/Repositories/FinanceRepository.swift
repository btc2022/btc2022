import Foundation

@MainActor
protocol FinanceRepository {
    func accounts() throws -> [Account]
    func categories() throws -> [Category]
    func transactions() throws -> [Transaction]
    func budgets() throws -> [Budget]
    func add(_ transaction: Transaction) throws
    func seedIfNeeded() throws
}
