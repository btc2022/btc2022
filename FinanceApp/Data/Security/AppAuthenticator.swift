import LocalAuthentication

protocol AppAuthenticating { func authenticate() async -> Bool }

struct AppAuthenticator: AppAuthenticating {
    func authenticate() async -> Bool {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else { return false }
        do {
            return try await context.evaluatePolicy(.deviceOwnerAuthentication,
                localizedReason: String(localized: "auth.reason"))
        } catch { return false }
    }
}
