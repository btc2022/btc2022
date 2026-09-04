import SwiftUI

struct BudgetsView: View {
    let repository: any FinanceRepository
    @State private var budgets: [Budget] = []
    var body: some View {
        NavigationStack {
            List(budgets) { budget in
                LabeledContent("budget.limit", value: budget.limit.formatted(.currency(code: budget.currencyCode)))
            }
            .overlay { if budgets.isEmpty { ContentUnavailableView("budgets.empty", systemImage: "gauge") } }
            .navigationTitle("tab.budgets").task { budgets = (try? repository.budgets()) ?? [] }
        }
    }
}
