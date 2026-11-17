import Foundation
import Testing
@testable import EmpikAssignment

struct CitySearchRequestTests {
    private let configuration = AppConfiguration(
        geocodingAPIBaseURL: URL(string: "https://geocoding.example.com/v1")!,
        forecastAPIBaseURL: URL(string: "https://forecast.example.com/v1")!
    )

    @Test func buildsURLWithEncodedName() {
        let request = CitySearchRequest(cityName: "Bielsko-Biała", language: "pl")

        #expect(request.url(configuration: configuration).absoluteString ==
            "https://geocoding.example.com/v1/search?name=Bielsko-Bia%C5%82a&count=20&language=pl&format=json")
    }

    @Test func buildsURLWithEncodedSpace() {
        let request = CitySearchRequest(cityName: "Nowy Sącz", language: "en")

        #expect(request.url(configuration: configuration).absoluteString ==
            "https://geocoding.example.com/v1/search?name=Nowy%20S%C4%85cz&count=20&language=en&format=json")
    }
}
