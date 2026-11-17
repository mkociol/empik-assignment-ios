import Foundation

nonisolated struct CitySearchRequest: OpenMeteoRequest {
    typealias Response = GeocodingResponseDTO

    let cityName: String
    let language: String

    func url(configuration: AppConfiguration) -> URL {
        configuration.geocodingAPIBaseURL
            .appending(path: "search")
            .appending(queryItems: [
                URLQueryItem(name: "name", value: cityName),
                URLQueryItem(name: "count", value: "20"),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "format", value: "json")
            ])
    }
}
