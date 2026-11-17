import Foundation
@testable import EmpikAssignment

extension OpenMeteoConfiguration {
    nonisolated static let example = OpenMeteoConfiguration(
        geocodingAPIBaseURL: URL(string: "https://geocoding.example.com/v1")!,
        forecastAPIBaseURL: URL(string: "https://forecast.example.com/v1")!
    )
}
