import Foundation
import Testing
@testable import EmpikAssignment

struct AppConfigurationTests {
    private let validInfoDictionary: [String: Any] = [
        AppConfiguration.InfoPlistKey.geocodingAPIBaseURL: "https://geocoding.example.com/v1",
        AppConfiguration.InfoPlistKey.forecastAPIBaseURL: "https://forecast.example.com/v1",
        AppConfiguration.InfoPlistKey.fallbackLanguage: "en"
    ]

    @Test func readsValidValues() throws {
        let configuration = try AppConfiguration(infoDictionary: validInfoDictionary)

        #expect(try configuration == AppConfiguration(
            geocodingAPIBaseURL: #require(URL(string: "https://geocoding.example.com/v1")),
            forecastAPIBaseURL: #require(URL(string: "https://forecast.example.com/v1")),
            fallbackLanguage: "en"
        ))
    }

    @Test(arguments: [
        AppConfiguration.InfoPlistKey.geocodingAPIBaseURL,
        AppConfiguration.InfoPlistKey.forecastAPIBaseURL,
        AppConfiguration.InfoPlistKey.fallbackLanguage
    ])
    func throwsMissingValueWhenKeyIsAbsent(key: String) {
        var infoDictionary = validInfoDictionary
        infoDictionary[key] = nil

        #expect(throws: AppConfigurationError.missingValue(key: key)) {
            try AppConfiguration(infoDictionary: infoDictionary)
        }
    }

    @Test(arguments: [
        AppConfiguration.InfoPlistKey.geocodingAPIBaseURL,
        AppConfiguration.InfoPlistKey.forecastAPIBaseURL,
        AppConfiguration.InfoPlistKey.fallbackLanguage
    ])
    func throwsMissingValueWhenValueIsEmpty(key: String) {
        var infoDictionary = validInfoDictionary
        infoDictionary[key] = ""

        #expect(throws: AppConfigurationError.missingValue(key: key)) {
            try AppConfiguration(infoDictionary: infoDictionary)
        }
    }

    @Test(arguments: ["not a url", "geocoding.example.com", "$(GEOCODING_API_BASE_URL)"])
    func throwsInvalidURLForMalformedValue(value: String) {
        var infoDictionary = validInfoDictionary
        infoDictionary[AppConfiguration.InfoPlistKey.geocodingAPIBaseURL] = value

        #expect(throws: AppConfigurationError.invalidURL(key: AppConfiguration.InfoPlistKey.geocodingAPIBaseURL, value: value)) {
            try AppConfiguration(infoDictionary: infoDictionary)
        }
    }
}
