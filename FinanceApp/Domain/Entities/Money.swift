import Foundation

struct Money: Equatable, Sendable {
    let amount: Decimal
    let currencyCode: String

    init(amount: Decimal, currencyCode: String) throws {
        guard amount.isFinite else { throw FinanceValidationError.invalidAmount }
        let normalized = currencyCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard Locale.commonISOCurrencyCodes.contains(normalized) else {
            throw FinanceValidationError.invalidCurrency
        }
        self.amount = amount
        self.currencyCode = normalized
    }
}

extension Decimal {
    var isFinite: Bool { !isNaN }
}
