extension CitySearchClient {
    nonisolated static func live(
        httpClient: OpenMeteoHTTPClient,
        preferredLanguage: @escaping @Sendable () -> String
    ) -> CitySearchClient {
        CitySearchClient(searchCities: { cityName in
            let request = CitySearchRequest(cityName: cityName, language: preferredLanguage())
            return try await httpClient.send(request).toCities()
        })
    }
}
