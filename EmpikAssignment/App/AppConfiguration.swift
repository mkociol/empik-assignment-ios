import Foundation

nonisolated struct AppConfiguration: Equatable {
    let geocodingAPIBaseURL: URL
    let forecastAPIBaseURL: URL
}

nonisolated enum AppConfigurationError: Error, Equatable {
    case missingValue(key: String)
    case invalidURL(key: String, value: String)
}

extension AppConfiguration {
    nonisolated enum InfoPlistKey {
        static let geocodingAPIBaseURL = "GeocodingAPIBaseURL"
        static let forecastAPIBaseURL = "ForecastAPIBaseURL"
    }

    nonisolated init(infoDictionary: [String: Any]) throws(AppConfigurationError) {
        geocodingAPIBaseURL = try Self.url(for: InfoPlistKey.geocodingAPIBaseURL, in: infoDictionary)
        forecastAPIBaseURL = try Self.url(for: InfoPlistKey.forecastAPIBaseURL, in: infoDictionary)
    }

    private nonisolated static func url(for key: String, in infoDictionary: [String: Any]) throws(AppConfigurationError) -> URL {
        guard let value = infoDictionary[key] as? String else {
            throw .missingValue(key: key)
        }
        guard
            let url = URL(string: value),
            let scheme = url.scheme, ["http", "https"].contains(scheme),
            url.host() != nil
        else {
            throw .invalidURL(key: key, value: value)
        }
        return url
    }
}
