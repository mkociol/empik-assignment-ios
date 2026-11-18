import Foundation
import Testing
@testable import EmpikAssignment

struct GeocodingResponseDTOTests {
    @Test func mapsResultsToCitiesInOrder() throws {
        let cities = try decodeGeocodingResponse(lodzResponse).toCities()

        #expect(cities == [
            City(
                id: 3_093_133,
                name: "Łódź",
                region: "Województwo łódzkie",
                country: "Polska",
                coordinates: Coordinates(latitude: 51.77058, longitude: 19.47395)
            ),
            City(
                id: 3_093_132,
                name: "Łódź",
                region: "województwo wielkopolskie",
                country: "Polska",
                coordinates: Coordinates(latitude: 52.2545, longitude: 16.74231)
            )
        ])
    }

    @Test func mapsMissingAdmin1ToNilRegion() throws {
        let cities = try decodeGeocodingResponse(RecordedGeocodingResponse.singapore).toCities()

        #expect(cities == [
            City(
                id: 1_880_252,
                name: "Singapore",
                region: nil,
                country: "Singapur",
                coordinates: Coordinates(latitude: 1.28967, longitude: 103.85007)
            )
        ])
    }

    @Test func mapsResponseWithoutResultsToEmptyList() throws {
        let cities = try decodeGeocodingResponse(noResultsResponse).toCities()

        #expect(cities.isEmpty)
    }

    /// Real responses for "Łódź", "Singapore" and "Xyzqwv" (language=pl, count=2 and 1).
    private let lodzResponse = """
    {"results":[{"id":3093133,"name":"Łódź","latitude":51.77058,"longitude":19.47395,"elevation":214.0,\
    "feature_code":"PPLA","country_code":"PL","admin1_id":3337493,"admin2_id":6697536,"admin3_id":7531754,\
    "timezone":"Europe/Warsaw","population":639890,"country_id":798544,"country":"Polska",\
    "admin1":"Województwo łódzkie","admin2":"Łódź","admin3":"Łódź"},{"id":3093132,"name":"Łódź",\
    "latitude":52.2545,"longitude":16.74231,"elevation":79.0,"feature_code":"PPL","country_code":"PL",\
    "admin1_id":3337498,"admin2_id":7530994,"admin3_id":7533192,"timezone":"Europe/Warsaw","country_id":798544,\
    "country":"Polska","admin1":"województwo wielkopolskie","admin2":"Powiat poznański","admin3":"Stęszew"}],\
    "generationtime_ms":0.23961067}
    """

    private let noResultsResponse = """
    {"generationtime_ms":0.20253658}
    """

    private func decodeGeocodingResponse(_ json: String) throws -> GeocodingResponseDTO {
        try JSONDecoder().decode(GeocodingResponseDTO.self, from: Data(json.utf8))
    }
}
