nonisolated struct CitySearchClient {
    /// Shorter names are not searched: a single letter matches too many places to be useful.
    static let minimumCityNameLength = 2

    var searchCities: @Sendable (String) async throws -> [City]
}
