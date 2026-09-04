import Foundation

struct TransactionValidator {
    private let calendar: Calendar
    private let now: @Sendable () -> Date

    init(calendar: Calendar = .current, now: @escaping @Sendable () -> Date = Date.init) {
        self.calendar = calendar
        self.now = now
    }

    func validate(amount: Decimal, currencyCode: String, categoryID: UUID?, date: Date) throws {
        guard amount > .zero, amount.isFinite else { throw FinanceValidationError.invalidAmount }
        guard Locale.commonISOCurrencyCodes.contains(currencyCode.uppercased()) else {
            throw FinanceValidationError.invalidCurrency
        }
        guard categoryID != nil else { throw FinanceValidationError.missingCategory }
        guard date <= calendar.date(byAdding: .minute, value: 1, to: now()) ?? now() else {
            throw FinanceValidationError.dateInFuture
        }
    }
}
