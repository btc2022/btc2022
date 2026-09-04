import SwiftUI

struct RootView: View {
    let repository: any FinanceRepository
    var body: some View {
        TabView {
            DashboardView(repository: repository).tabItem { Label("tab.dashboard", systemImage: "chart.pie") }
            TransactionsView(repository: repository).tabItem { Label("tab.transactions", systemImage: "list.bullet.rectangle") }
            BudgetsView(repository: repository).tabItem { Label("tab.budgets", systemImage: "gauge.with.dots.needle.50percent") }
            SettingsView().tabItem { Label("tab.settings", systemImage: "gearshape") }
        }
    }
}
