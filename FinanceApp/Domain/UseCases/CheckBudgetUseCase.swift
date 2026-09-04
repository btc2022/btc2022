import Foundation

struct BudgetStatus: Equatable {
    let spent: Decimal
    let remaining: Decimal
    let isExceeded: Bool
}

struct CheckBudgetUseCase {
    func execute(budget: Budget, transactions: [Transaction]) throws -> BudgetStatus {
        guard budget.startsAt <= budget.endsAt else { throw FinanceValidationError.invalidBudgetPeriod }
        let relevant = transactions.filter {
            $0.categoryID == budget.categoryID && $0.kind == .expense &&
            $0.date >= budget.startsAt && $0.date <= budget.endsAt
        }
        guard relevant.allSatisfy({ $0.currencyCode == budget.currencyCode }) else {
            throw FinanceValidationError.currencyMismatch
        }
        let spent = relevant.reduce(Decimal.zero) { $0 + $1.amount }
        return BudgetStatus(spent: spent, remaining: budget.limit - spent, isExceeded: spent > budget.limit)
    }
}
