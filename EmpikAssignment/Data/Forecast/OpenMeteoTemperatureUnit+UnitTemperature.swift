import Foundation

extension OpenMeteoTemperatureUnit {
    nonisolated init(_ unit: UnitTemperature) {
        self = unit == .fahrenheit ? .fahrenheit : .celsius
    }
}
