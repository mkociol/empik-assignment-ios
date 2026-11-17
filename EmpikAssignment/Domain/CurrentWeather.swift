import Foundation

nonisolated struct CurrentWeather: Hashable {
    let temperature: Measurement<UnitTemperature>
    let cloudCoverPercent: Int
    let precipitationProbabilityPercent: Int?
}
