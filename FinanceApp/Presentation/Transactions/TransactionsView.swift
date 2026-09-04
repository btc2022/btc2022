import Observation
import SwiftUI

@MainActor @Observable
final class TransactionsViewModel {
    private let repository: any FinanceRepository
    var transactions: [Transaction] = []
    var accounts: [Account] = []
    var categories: [Category] = []
    var errorMessage: String?
    init(repository: any FinanceRepository) { self.repository = repository }
    func load() { do { transactions = try repository.transactions(); accounts = try repository.accounts(); categories = try repository.categories() } catch { errorMessage = error.localizedDescription } }
    func add(amount: Decimal, accountID: UUID, categoryID: UUID, date: Date, note: String) -> Bool {
        guard let account = accounts.first(where: { $0.id == accountID }) else { return false }
        do {
            try AddTransactionUseCase(repository: repository).execute(.init(accountID: accountID, categoryID: categoryID,
                amount: amount, currencyCode: account.currencyCode, date: date, kind: .expense, note: note))
            load(); return true
        } catch { errorMessage = error.localizedDescription; return false }
    }
}

struct TransactionsView: View {
    @State private var model: TransactionsViewModel
    @State private var showsAdd = false
    init(repository: any FinanceRepository) { _model = State(initialValue: TransactionsViewModel(repository: repository)) }
    var body: some View {
        NavigationStack {
            List(model.transactions) { transaction in
                VStack(alignment: .leading) {
                    Text(transaction.note.isEmpty ? String(localized: "transaction.expense") : transaction.note)
                    Text(transaction.amount.formatted(.currency(code: transaction.currencyCode))).foregroundStyle(.red)
                }.accessibilityElement(children: .combine)
            }
            .overlay { if model.transactions.isEmpty { ContentUnavailableView("transactions.empty", systemImage: "tray") } }
            .navigationTitle("tab.transactions")
            .toolbar { Button { showsAdd = true } label: { Label("transaction.add", systemImage: "plus") }.accessibilityIdentifier("addTransactionButton") }
            .sheet(isPresented: $showsAdd) { AddTransactionView(model: model, isPresented: $showsAdd) }
            .task { model.load() }
        }
    }
}

private struct AddTransactionView: View {
    let model: TransactionsViewModel
    @Binding var isPresented: Bool
    @State private var amountText = ""
    @State private var accountID: UUID?
    @State private var categoryID: UUID?
    @State private var date = Date()
    @State private var note = ""
    var body: some View {
        NavigationStack {
            Form {
                TextField("transaction.amount", text: $amountText).keyboardType(.decimalPad).accessibilityIdentifier("amountField")
                Picker("transaction.account", selection: $accountID) { Text("common.select").tag(nil as UUID?); ForEach(model.accounts) { Text($0.name).tag(Optional($0.id)) } }
                Picker("transaction.category", selection: $categoryID) { Text("common.select").tag(nil as UUID?); ForEach(model.categories) { Text($0.name).tag(Optional($0.id)) } }.accessibilityIdentifier("categoryPicker")
                DatePicker("transaction.date", selection: $date, in: ...Date.now, displayedComponents: .date)
                TextField("transaction.note", text: $note).accessibilityIdentifier("noteField")
                if let error = model.errorMessage { Text(error).foregroundStyle(.red).accessibilityIdentifier("validationError") }
            }
            .navigationTitle("transaction.add")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("common.cancel") { isPresented = false } }
                ToolbarItem(placement: .confirmationAction) { Button("common.save") { save() }.accessibilityIdentifier("saveTransactionButton") }
            }
            .onAppear { accountID = model.accounts.first?.id; categoryID = model.categories.first?.id }
        }
    }
    private func save() {
        let normalized = amountText.replacingOccurrences(of: ",", with: ".")
        guard let amount = Decimal(string: normalized, locale: Locale(identifier: "en_US_POSIX")),
              let accountID, let categoryID else { model.errorMessage = FinanceValidationError.invalidAmount.localizedDescription; return }
        if model.add(amount: amount, accountID: accountID, categoryID: categoryID, date: date, note: note) { isPresented = false }
    }
}
