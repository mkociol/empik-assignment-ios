import Foundation
import Testing
@testable import EmpikAssignment

struct CitySearchClientLiveTests {
    private let configuration = OpenMeteoConfiguration.example

    @Test func searchesInPreferredLanguageAndReturnsCities() async throws {
        let httpClient = OpenMeteoHTTPClient(configuration: configuration, fetchData: { url in
            #expect(url.query()?.contains("language=pl") == true)
            return (
                Data(RecordedGeocodingResponse.singapore.utf8),
                HTTPURLResponse.stub(url: url, statusCode: 200)
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

    @Test func reportsOfflineAsRemoteDataError() async {
        let httpClient = OpenMeteoHTTPClient(configuration: configuration, fetchData: { _ in
            throw URLError(.notConnectedToInternet)
        })
        let client = CitySearchClient.live(httpClient: httpClient, preferredLanguage: { "pl" })

        await #expect(throws: RemoteDataError.offline) {
            try await client.searchCities("Kraków")
        }
    }
}
