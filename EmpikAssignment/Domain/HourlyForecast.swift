import Foundation

nonisolated struct HourlyForecast: Hashable {
    let date: Date
    let temperature: Measurement<UnitTemperature>
    let precipitationProbabilityPercent: Int?
}
