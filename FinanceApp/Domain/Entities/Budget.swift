import Foundation

struct Budget: Identifiable, Equatable, Sendable {
    let id: UUID
    let categoryID: UUID
    let limit: Decimal
    let currencyCode: String
    let startsAt: Date
    let endsAt: Date
}
