import XCTest
@testable import FinanceApp

final class TransactionValidatorTests: XCTestCase {
    private let now = Date(timeIntervalSince1970: 1_700_000_000)
    func testRejectsZeroAmount() { XCTAssertThrowsError(try validator.validate(amount: 0, currencyCode: "USD", categoryID: UUID(), date: now)) { XCTAssertEqual($0 as? FinanceValidationError, .invalidAmount) } }
    func testRejectsUnknownCurrency() { XCTAssertThrowsError(try validator.validate(amount: 1, currencyCode: "XYZ", categoryID: UUID(), date: now)) { XCTAssertEqual($0 as? FinanceValidationError, .invalidCurrency) } }
    func testRequiresCategory() { XCTAssertThrowsError(try validator.validate(amount: 1, currencyCode: "EUR", categoryID: nil, date: now)) { XCTAssertEqual($0 as? FinanceValidationError, .missingCategory) } }
    func testRejectsFutureDate() { XCTAssertThrowsError(try validator.validate(amount: 1, currencyCode: "EUR", categoryID: UUID(), date: now.addingTimeInterval(3600))) { XCTAssertEqual($0 as? FinanceValidationError, .dateInFuture) } }
    private var validator: TransactionValidator { TransactionValidator(calendar: Calendar(identifier: .gregorian), now: { now }) }
}
