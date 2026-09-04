import XCTest

final class AddExpenseUITests: XCTestCase {
    func testAddsExpense() {
        let app = XCUIApplication(); app.launchArguments = ["--uitesting", "-AppleLanguages", "(en)"]; app.launch()
        app.tabBars.buttons["Transactions"].tap()
        app.buttons["addTransactionButton"].tap()
        let amount = app.textFields["amountField"]; amount.tap(); amount.typeText("42.50")
        app.textFields["noteField"].tap(); app.textFields["noteField"].typeText("Coffee")
        app.buttons["saveTransactionButton"].tap()
        XCTAssertTrue(app.staticTexts["Coffee"].waitForExistence(timeout: 2))
    }
}
