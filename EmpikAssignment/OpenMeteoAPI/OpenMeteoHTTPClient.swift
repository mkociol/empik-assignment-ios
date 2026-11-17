import Foundation

nonisolated struct OpenMeteoHTTPClient {
    let configuration: OpenMeteoConfiguration
    let fetchData: @Sendable (URL) async throws -> (Data, URLResponse)

    func send<Request: OpenMeteoRequest>(_ request: Request) async throws -> Request.Response {
        let (data, response) = try await fetch(request.url(configuration: configuration))
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenMeteoAPIError.invalidResponse
        }
        guard (200 ..< 300).contains(httpResponse.statusCode) else {
            throw serverError(from: data)
        }
        return try decode(Request.Response.self, from: data)
    }

    private func fetch(_ url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await fetchData(url)
        } catch let urlError as URLError {
            throw error(for: urlError)
        }
    }

    private func error(for urlError: URLError) -> any Error {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .timedOut, .dataNotAllowed:
            OpenMeteoAPIError.offline
        case .cancelled:
            CancellationError()
        default:
            OpenMeteoAPIError.invalidResponse
        }
    }

    private func serverError(from data: Data) -> OpenMeteoAPIError {
        guard let errorDTO = try? JSONDecoder().decode(OpenMeteoErrorDTO.self, from: data) else {
            return .invalidResponse
        }
        return .server(reason: errorDTO.reason)
    }

    private func decode<Value: Decodable>(_ type: Value.Type, from data: Data) throws(OpenMeteoAPIError) -> Value {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw .invalidResponse
        }
    }
}
