import Testing
@testable import EmpikAssignment

struct SearchHistoryTests {
    private let krakow = City(
        id: 3_094_802,
        name: "Kraków",
        region: "Województwo małopolskie",
        coordinates: Coordinates(latitude: 50.06143, longitude: 19.93658)
    )
    private let lodz = City(
        id: 3_093_133,
        name: "Łódź",
        region: "Województwo łódzkie",
        coordinates: Coordinates(latitude: 51.77058, longitude: 19.47395)
    )
    private let nowySacz = City(
        id: 763_534,
        name: "Nowy Sącz",
        region: "Województwo małopolskie",
        coordinates: Coordinates(latitude: 49.62177, longitude: 20.69705)
    )

    @Test func addingNewCityPutsItFirst() {
        var history = SearchHistory(cities: [krakow])

        history.add(lodz)

        #expect(history.cities == [lodz, krakow])
    }

    @Test func addingExistingCityMovesItFirstWithoutDuplicate() {
        var history = SearchHistory(cities: [lodz, nowySacz, krakow])

        history.add(krakow)

        #expect(history.cities == [krakow, lodz, nowySacz])
    }

    @Test func addingExistingCityWithChangedDataReplacesOldVersion() {
        var history = SearchHistory(cities: [lodz, krakow])
        let krakowInEnglish = City(
            id: krakow.id,
            name: "Krakow",
            region: "Lesser Poland",
            coordinates: krakow.coordinates
        )

        history.add(krakowInEnglish)

        #expect(history.cities == [krakowInEnglish, lodz])
    }

    @Test func removingCityKeepsOrderOfOtherCities() {
        var history = SearchHistory(cities: [krakow, lodz, nowySacz])

        history.remove(lodz)

        #expect(history.cities == [krakow, nowySacz])
    }

    @Test func removingCityNotInHistoryChangesNothing() {
        var history = SearchHistory(cities: [krakow, lodz])

        history.remove(nowySacz)

        #expect(history.cities == [krakow, lodz])
    }

    @Test func removeAllClearsHistory() {
        var history = SearchHistory(cities: [krakow, lodz, nowySacz])

        history.removeAll()

        #expect(history.cities.isEmpty)
    }
}
