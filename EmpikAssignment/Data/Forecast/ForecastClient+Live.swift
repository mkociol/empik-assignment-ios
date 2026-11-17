import Foundation

extension ForecastClient {
    nonisolated static func live(
        httpClient: OpenMeteoHTTPClient,
        preferredTemperatureUnit: @escaping @Sendable () -> UnitTemperature
    ) -> ForecastClient {
        ForecastClient(fetchForecast: { coordinates in
            let request = ForecastRequest(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                temperatureUnit: OpenMeteoTemperatureUnit(preferredTemperatureUnit())
            )
            let response: ForecastResponseDTO
            do {
                response = try await httpClient.send(request)
            } catch let apiError as OpenMeteoAPIError {
                throw RemoteDataError(apiError)
            }
            do {
                return try response.toForecast()
            } catch {
                throw RemoteDataError.invalidResponse
            }
        })
    }
}
