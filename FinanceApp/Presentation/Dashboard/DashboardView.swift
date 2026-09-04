import Observation
import SwiftUI

@MainActor @Observable
final class DashboardViewModel {
    private let repository: any FinanceRepository
    var account: Account?
    var balance: Decimal = 0
    var errorMessage: String?
    init(repository: any FinanceRepository) { self.repository = repository }
    func load() {
        do {
            account = try repository.accounts().first
            guard let account else { return }
            balance = try CalculateBalanceUseCase().execute(account: account, transactions: repository.transactions()).amount
        } catch { errorMessage = error.localizedDescription }
    }
}

struct DashboardView: View {
    @State private var model: DashboardViewModel
    init(repository: any FinanceRepository) { _model = State(initialValue: DashboardViewModel(repository: repository)) }
    var body: some View {
        NavigationStack {
            List {
                Section("dashboard.balance") {
                    Text(balanceText).font(.largeTitle.bold()).minimumScaleFactor(0.6)
                        .accessibilityLabel(String(localized: "dashboard.balance"))
                        .accessibilityValue(balanceText)
                }
                if let errorMessage = model.errorMessage { Text(errorMessage).foregroundStyle(.red) }
            }
            .navigationTitle("tab.dashboard").task { model.load() }
        }
    }
    private var balanceText: String {
        model.balance.formatted(.currency(code: model.account?.currencyCode ?? "UAH"))
    }
}
