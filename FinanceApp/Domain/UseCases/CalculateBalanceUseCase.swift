import Foundation

struct CalculateBalanceUseCase {
    func execute(account: Account, transactions: [Transaction]) throws -> Money {
        var balance = account.openingBalance
        for transaction in transactions where transaction.accountID == account.id {
            guard transaction.currencyCode == account.currencyCode else {
                throw FinanceValidationError.currencyMismatch
            }
            balance += transaction.kind == .income ? transaction.amount : -transaction.amount
        }
        return try Money(amount: balance, currencyCode: account.currencyCode)
    }
}
