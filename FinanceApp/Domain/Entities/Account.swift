import Foundation

struct Account: Identifiable, Equatable, Sendable {
    let id: UUID
    var name: String
    let currencyCode: String
    let openingBalance: Decimal
}
