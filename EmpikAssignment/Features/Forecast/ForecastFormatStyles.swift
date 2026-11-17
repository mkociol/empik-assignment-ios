import Foundation

extension FormatStyle where Self == Measurement<UnitTemperature>.FormatStyle {
    /// Whole degrees in the user's preferred unit, e.g. "6°".
    static var weatherTemperature: Self {
        .measurement(width: .narrow, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))
    }
}

extension FormatStyle where Self == Date.FormatStyle {
    /// Time of day in the city's time zone, e.g. "19:00".
    static func hour(in timeZone: TimeZone) -> Self {
        Date.FormatStyle(date: .omitted, time: .shortened, timeZone: timeZone)
    }
}
