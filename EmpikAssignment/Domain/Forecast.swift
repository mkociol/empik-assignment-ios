import Foundation

nonisolated struct Forecast: Hashable {
    let current: CurrentWeather
    let hourly: [HourlyForecast]
    let timeZone: TimeZone
}
