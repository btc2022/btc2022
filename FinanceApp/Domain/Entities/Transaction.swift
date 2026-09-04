import Foundation

struct Transaction: Identifiable, Equatable, Sendable {
    enum Kind: String, Codable, Sendable { case income, expense }
    let id: UUID
    let accountID: UUID
    let categoryID: UUID
    let amount: Decimal
    let currencyCode: String
    let date: Date
    let kind: Kind
    let note: String
}
