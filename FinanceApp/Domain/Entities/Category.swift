import Foundation

struct Category: Identifiable, Equatable, Sendable {
    enum Kind: String, Codable, Sendable { case income, expense }
    let id: UUID
    var name: String
    var kind: Kind
}
