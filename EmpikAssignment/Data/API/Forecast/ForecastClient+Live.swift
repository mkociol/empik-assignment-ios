import Foundation

extension ForecastClient {
    nonisolated static func live(
        httpClient: OpenMeteoHTTPClient,
        preferredTemperatureUnit: @escaping @Sendable () -> UnitTemperature
    ) -> ForecastClient {
        ForecastClient(fetchForecast: { coordinates in
            let request = ForecastRequest(coordinates: coordinates, temperatureUnit: preferredTemperatureUnit())
            let response = try await httpClient.send(request)
            do {
                return try response.toForecast()
            } catch {
                throw RemoteDataError.invalidResponse
            }
        })
    }
}
