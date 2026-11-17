import Foundation
@testable import EmpikAssignment

extension AppConfiguration {
    nonisolated static let example = AppConfiguration(
        geocodingAPIBaseURL: URL(string: "https://geocoding.example.com/v1")!,
        forecastAPIBaseURL: URL(string: "https://forecast.example.com/v1")!,
        fallbackLanguage: "en"
    )
}
