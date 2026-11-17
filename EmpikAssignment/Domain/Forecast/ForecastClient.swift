nonisolated struct ForecastClient {
    var fetchForecast: @Sendable (Coordinates) async throws -> Forecast
}
