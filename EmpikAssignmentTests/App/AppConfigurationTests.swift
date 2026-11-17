import Foundation
import Testing
@testable import EmpikAssignment

struct AppConfigurationTests {
    private let validInfoDictionary: [String: Any] = [
        AppConfiguration.InfoPlistKey.geocodingAPIBaseURL: "https://geocoding.example.com/v1",
        AppConfiguration.InfoPlistKey.forecastAPIBaseURL: "https://forecast.example.com/v1"
    ]

    @Test func readsBaseURLsFromValidValues() throws {
        let configuration = try AppConfiguration(infoDictionary: validInfoDictionary)

        #expect(configuration.geocodingAPIBaseURL == URL(string: "https://geocoding.example.com/v1"))
        #expect(configuration.forecastAPIBaseURL == URL(string: "https://forecast.example.com/v1"))
    }

    @Test func throwsMissingValueWhenKeyIsAbsent() {
        var infoDictionary = validInfoDictionary
        infoDictionary[AppConfiguration.InfoPlistKey.forecastAPIBaseURL] = nil

        #expect(throws: AppConfigurationError.missingValue(key: AppConfiguration.InfoPlistKey.forecastAPIBaseURL)) {
            try AppConfiguration(infoDictionary: infoDictionary)
        }
    }

    @Test(arguments: ["", "not a url", "geocoding.example.com", "$(GEOCODING_API_BASE_URL)"])
    func throwsInvalidURLForMalformedValue(value: String) {
        var infoDictionary = validInfoDictionary
        infoDictionary[AppConfiguration.InfoPlistKey.geocodingAPIBaseURL] = value

        #expect(throws: AppConfigurationError.invalidURL(key: AppConfiguration.InfoPlistKey.geocodingAPIBaseURL, value: value)) {
            try AppConfiguration(infoDictionary: infoDictionary)
        }
    }
}
