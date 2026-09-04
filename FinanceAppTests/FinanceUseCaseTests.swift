import XCTest
@testable import FinanceApp

@MainActor
final class FinanceUseCaseTests: XCTestCase {
    func testAddingValidExpensePersistsIt() throws {
        let account = Account(id: UUID(), name: "Main", currencyCode: "UAH", openingBalance: 0)
        let category = Category(id: UUID(), name: "Food", kind: .expense)
        let repository = RepositorySpy(account: account, category: category)
        let result = try AddTransactionUseCase(repository: repository).execute(.init(
            accountID: account.id, categoryID: category.id, amount: 125.50,
            currencyCode: "uah", date: .now, kind: .expense, note: "Lunch"))
        XCTAssertEqual(result.amount, 125.50)
        XCTAssertEqual(result.currencyCode, "UAH")
        XCTAssertEqual(repository.saved.count, 1)
    }

    func testBalanceUsesDecimalWithoutBinaryFloatingPoint() throws {
        let account = Account(id: UUID(), name: "Main", currencyCode: "USD", openingBalance: 100)
        let categoryID = UUID()
        let values = [
            Transaction(id: UUID(), accountID: account.id, categoryID: categoryID, amount: Decimal(string: "0.10")!, currencyCode: "USD", date: .now, kind: .income, note: ""),
            Transaction(id: UUID(), accountID: account.id, categoryID: categoryID, amount: Decimal(string: "0.20")!, currencyCode: "USD", date: .now, kind: .expense, note: "")
        ]
        XCTAssertEqual(try CalculateBalanceUseCase().execute(account: account, transactions: values).amount, Decimal(string: "99.90"))
    }

    func testBudgetReportsExceededAmount() throws {
        let categoryID = UUID(); let now = Date()
        let budget = Budget(id: UUID(), categoryID: categoryID, limit: 100, currencyCode: "USD", startsAt: now.addingTimeInterval(-100), endsAt: now.addingTimeInterval(100))
        let expense = Transaction(id: UUID(), accountID: UUID(), categoryID: categoryID, amount: 120, currencyCode: "USD", date: now, kind: .expense, note: "")
        let status = try CheckBudgetUseCase().execute(budget: budget, transactions: [expense])
        XCTAssertTrue(status.isExceeded); XCTAssertEqual(status.remaining, -20)
    }
}

@MainActor
private final class RepositorySpy: FinanceRepository {
    let account: Account; let category: Category; var saved: [Transaction] = []
    init(account: Account, category: Category) { self.account = account; self.category = category }
    func accounts() throws -> [Account] { [account] }
    func categories() throws -> [Category] { [category] }
    func transactions() throws -> [Transaction] { saved }
    func budgets() throws -> [Budget] { [] }
    func add(_ transaction: Transaction) throws { saved.append(transaction) }
    func seedIfNeeded() throws {}
}
