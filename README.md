# FinanceApp

A local-first SwiftUI personal finance application organized with Clean Architecture and MVVM. It targets iOS 26 and uses Swift 6, `Decimal` money values, ISO 4217 codes, SwiftData, LocalAuthentication, and Keychain.

## Open and test

Open `FinanceApp.xcodeproj` in Xcode 26, or run:

```sh
xcodebuild test -project FinanceApp.xcodeproj -scheme FinanceApp -destination 'platform=iOS Simulator,name=iPhone 17'
```

No API credentials belong in source control. Store secrets through `KeychainStore`; API implementations must use `FinanceAPIClient`, which rejects non-HTTPS requests.
