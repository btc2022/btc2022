import Foundation

protocol FinanceAPIClient: Sendable {
    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

enum FinanceAPIError: Error { case insecureTransport, invalidResponse }

struct HTTPSFinanceAPIClient: FinanceAPIClient {
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }

    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        guard request.url?.scheme?.lowercased() == "https" else { throw FinanceAPIError.insecureTransport }
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw FinanceAPIError.invalidResponse }
        return (data, http)
    }
}
