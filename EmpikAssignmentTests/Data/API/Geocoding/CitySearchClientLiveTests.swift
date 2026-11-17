import Foundation
import Testing
@testable import EmpikAssignment

struct CitySearchClientLiveTests {
    private let configuration = AppConfiguration.example

    @Test func searchesInPreferredLanguageAndReturnsCities() async throws {
        let httpClient = OpenMeteoHTTPClient(configuration: configuration, fetchData: { url in
            #expect(url.query()?.contains("language=pl") == true)
            return (
                Data(singaporeResponse.utf8),
                HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            )
        })
        let client = CitySearchClient.live(httpClient: httpClient, preferredLanguage: { "pl" })

        let cities = try await client.searchCities("Singapore")

        #expect(cities == [
            City(
                id: 1_880_252,
                name: "Singapore",
                region: nil,
                coordinates: Coordinates(latitude: 1.28967, longitude: 103.85007)
            )
        ])
    }

    /// Recorded real response for "Singapore" (language=pl).
    private let singaporeResponse = """
    {"results":[{"id":1880252,"name":"Singapore","latitude":1.28967,"longitude":103.85007,"elevation":23.0,\
    "feature_code":"PPLC","country_code":"SG","timezone":"Asia/Singapore","population":5638700,\
    "country_id":1880251,"country":"Singapur"}],"generationtime_ms":0.11539459}
    """
}
