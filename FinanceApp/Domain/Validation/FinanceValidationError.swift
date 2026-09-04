import Foundation

enum FinanceValidationError: LocalizedError, Equatable {
    case invalidAmount
    case invalidCurrency
    case missingCategory
    case dateInFuture
    case invalidBudgetPeriod
    case currencyMismatch

    var errorDescription: String? {
        switch self {
        case .invalidAmount: String(localized: "validation.amount")
        case .invalidCurrency: String(localized: "validation.currency")
        case .missingCategory: String(localized: "validation.category")
        case .dateInFuture: String(localized: "validation.date")
        case .invalidBudgetPeriod: String(localized: "validation.budgetPeriod")
        case .currencyMismatch: String(localized: "validation.currencyMismatch")
        }
    }
}
