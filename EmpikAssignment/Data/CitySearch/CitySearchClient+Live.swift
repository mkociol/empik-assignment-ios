extension CitySearchClient {
    nonisolated static func live(
        httpClient: OpenMeteoHTTPClient,
        preferredLanguage: @escaping @Sendable () -> String
    ) -> CitySearchClient {
        CitySearchClient(searchCities: { cityName in
            let request = CitySearchRequest(cityName: cityName, language: preferredLanguage())
            do {
                return try await httpClient.send(request).toCities()
            } catch let apiError as OpenMeteoAPIError {
                throw RemoteDataError(apiError)
            }
        })
    }
}
