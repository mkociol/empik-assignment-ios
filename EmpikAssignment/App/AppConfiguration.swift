import Foundation

nonisolated struct AppConfiguration: Equatable {
    let geocodingAPIBaseURL: URL
    let forecastAPIBaseURL: URL
    let fallbackLanguage: String
}

nonisolated enum AppConfigurationError: Error, Equatable {
    case missingValue(key: String)
    case invalidURL(key: String, value: String)
}

extension AppConfiguration {
    nonisolated enum InfoPlistKey {
        static let geocodingAPIBaseURL = "GeocodingAPIBaseURL"
        static let forecastAPIBaseURL = "ForecastAPIBaseURL"
        static let fallbackLanguage = "FallbackLanguage"
    }

    nonisolated init(infoDictionary: [String: Any]) throws(AppConfigurationError) {
        geocodingAPIBaseURL = try Self.url(for: InfoPlistKey.geocodingAPIBaseURL, in: infoDictionary)
        forecastAPIBaseURL = try Self.url(for: InfoPlistKey.forecastAPIBaseURL, in: infoDictionary)
        fallbackLanguage = try Self.text(for: InfoPlistKey.fallbackLanguage, in: infoDictionary)
    }

    private nonisolated static func url(for key: String, in infoDictionary: [String: Any]) throws(AppConfigurationError) -> URL {
        let value = try text(for: key, in: infoDictionary)
        guard
            let url = URL(string: value),
            let scheme = url.scheme, ["http", "https"].contains(scheme),
            url.host() != nil
        else {
            throw .invalidURL(key: key, value: value)
        }
        return url
    }

    private nonisolated static func text(for key: String, in infoDictionary: [String: Any]) throws(AppConfigurationError) -> String {
        guard let value = infoDictionary[key] as? String, !value.isEmpty else {
            throw .missingValue(key: key)
        }
        return value
    }
}
