nonisolated struct CitySearchClient {
    var searchCities: @Sendable (String) async throws -> [City]
}
