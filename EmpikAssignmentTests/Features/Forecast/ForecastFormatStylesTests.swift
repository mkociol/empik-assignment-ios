import Foundation
import Testing
@testable import EmpikAssignment

struct ForecastFormatStylesTests {
    private let polish = Locale(identifier: "pl_PL")
    private let american = Locale(identifier: "en_US")

    @Test func temperatureIsRoundedToWholeDegrees() {
        let temperature = Measurement(value: 5.7, unit: UnitTemperature.celsius)

        #expect(temperature.formatted(.weatherTemperature.locale(polish)) == "6°")
    }

    @Test func temperatureUsesUnitPreferredInUserRegion() {
        let temperature = Measurement(value: 5.7, unit: UnitTemperature.celsius)

        #expect(temperature.formatted(.weatherTemperature.locale(american)) == "42°")
    }

    @Test func hourIsShownInCityTimeZone() throws {
        let moment = Date(timeIntervalSince1970: 1_794_938_400)

        #expect(try moment.formatted(.hour(in: #require(TimeZone(identifier: "Europe/Warsaw"))).locale(polish)) == "19:00")
        #expect(try moment.formatted(.hour(in: #require(TimeZone(identifier: "Asia/Singapore"))).locale(polish)) == "2:00")
    }
}
