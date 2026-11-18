import Testing
@testable import EmpikAssignment

struct SearchHistoryTests {
    @Test func addingNewCityPutsItFirst() {
        var history = SearchHistory(cities: [.krakow])

        history.add(.lodz)

        #expect(history.cities == [.lodz, .krakow])
    }

    @Test func addingExistingCityMovesItFirstWithoutDuplicate() {
        var history = SearchHistory(cities: [.lodz, .nowySacz, .krakow])

        history.add(.krakow)

        #expect(history.cities == [.krakow, .lodz, .nowySacz])
    }

    @Test func addingExistingCityWithChangedDataReplacesOldVersion() {
        var history = SearchHistory(cities: [.lodz, .krakow])
        let krakowInEnglish = City(
            id: City.krakow.id,
            name: "Krakow",
            region: "Lesser Poland",
            country: "Poland",
            coordinates: City.krakow.coordinates
        )

        history.add(krakowInEnglish)

        #expect(history.cities == [krakowInEnglish, .lodz])
    }

    @Test func removingCityKeepsOrderOfOtherCities() {
        var history = SearchHistory(cities: [.krakow, .lodz, .nowySacz])

        history.remove(.lodz)

        #expect(history.cities == [.krakow, .nowySacz])
    }

    @Test func removingCityNotInHistoryChangesNothing() {
        var history = SearchHistory(cities: [.krakow, .lodz])

        history.remove(.nowySacz)

        #expect(history.cities == [.krakow, .lodz])
    }

    @Test func removeAllClearsHistory() {
        var history = SearchHistory(cities: [.krakow, .lodz, .nowySacz])

        history.removeAll()

        #expect(history.cities.isEmpty)
    }
}
