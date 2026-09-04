import Foundation

struct AddTransactionRequest: Sendable {
    let accountID: UUID
    let categoryID: UUID?
    let amount: Decimal
    let currencyCode: String
    let date: Date
    let kind: Transaction.Kind
    let note: String
}

@MainActor
struct AddTransactionUseCase {
    let repository: any FinanceRepository
    var validator = TransactionValidator()

    @discardableResult
    func execute(_ request: AddTransactionRequest) throws -> Transaction {
        try validator.validate(amount: request.amount, currencyCode: request.currencyCode,
                               categoryID: request.categoryID, date: request.date)
        guard let categoryID = request.categoryID else { throw FinanceValidationError.missingCategory }
        guard let account = try repository.accounts().first(where: { $0.id == request.accountID }),
              account.currencyCode == request.currencyCode.uppercased() else {
            throw FinanceValidationError.currencyMismatch
        }
        let transaction = Transaction(id: UUID(), accountID: request.accountID,
                                      categoryID: categoryID, amount: request.amount,
                                      currencyCode: request.currencyCode.uppercased(), date: request.date,
                                      kind: request.kind, note: request.note.trimmingCharacters(in: .whitespacesAndNewlines))
        try repository.add(transaction)
        return transaction
    }
}
