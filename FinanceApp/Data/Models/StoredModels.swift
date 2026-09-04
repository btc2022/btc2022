import Foundation
import SwiftData

@Model final class StoredAccount {
    @Attribute(.unique) var id: UUID
    var name: String
    var currencyCode: String
    var openingBalance: Decimal
    init(_ value: Account) { id = value.id; name = value.name; currencyCode = value.currencyCode; openingBalance = value.openingBalance }
    var entity: Account { Account(id: id, name: name, currencyCode: currencyCode, openingBalance: openingBalance) }
}

@Model final class StoredCategory {
    @Attribute(.unique) var id: UUID
    var name: String
    var kindRawValue: String
    init(_ value: Category) { id = value.id; name = value.name; kindRawValue = value.kind.rawValue }
    var entity: Category { Category(id: id, name: name, kind: Category.Kind(rawValue: kindRawValue) ?? .expense) }
}

@Model final class StoredTransaction {
    @Attribute(.unique) var id: UUID
    var accountID: UUID
    var categoryID: UUID
    var amount: Decimal
    var currencyCode: String
    var date: Date
    var kindRawValue: String
    var note: String
    init(_ value: Transaction) {
        id = value.id; accountID = value.accountID; categoryID = value.categoryID
        amount = value.amount; currencyCode = value.currencyCode; date = value.date
        kindRawValue = value.kind.rawValue; note = value.note
    }
    var entity: Transaction {
        Transaction(id: id, accountID: accountID, categoryID: categoryID, amount: amount,
                    currencyCode: currencyCode, date: date,
                    kind: Transaction.Kind(rawValue: kindRawValue) ?? .expense, note: note)
    }
}

@Model final class StoredBudget {
    @Attribute(.unique) var id: UUID
    var categoryID: UUID
    var limit: Decimal
    var currencyCode: String
    var startsAt: Date
    var endsAt: Date
    init(_ value: Budget) {
        id = value.id; categoryID = value.categoryID; limit = value.limit
        currencyCode = value.currencyCode; startsAt = value.startsAt; endsAt = value.endsAt
    }
    var entity: Budget { Budget(id: id, categoryID: categoryID, limit: limit, currencyCode: currencyCode, startsAt: startsAt, endsAt: endsAt) }
}
