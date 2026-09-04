import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("settings.security") { Label("settings.localAuth", systemImage: "faceid") }
                Section("settings.privacy") { Text("settings.secrets") }
            }.navigationTitle("tab.settings")
        }
    }
}
