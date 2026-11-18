import Testing
@testable import EmpikAssignment

struct RootViewModelTests {
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

    @Test func deletingSelectedCityFromHistoryClearsSelection() {
        let viewModel = RootViewModel()
        viewModel.send(.selectionChanged(krakow))

        viewModel.send(.historyCityDeleted(krakow))

        #expect(viewModel.selectedCity == nil)
    }

    @Test func deletingAnotherCityFromHistoryKeepsSelection() {
        let viewModel = RootViewModel()
        viewModel.send(.selectionChanged(krakow))

        viewModel.send(.historyCityDeleted(lodz))

        #expect(viewModel.selectedCity == krakow)
    }

    @Test func clearingHistoryClearsSelection() {
        let viewModel = RootViewModel()
        viewModel.send(.selectionChanged(krakow))

        viewModel.send(.historyCleared)

        #expect(viewModel.selectedCity == nil)
    }

    @Test func changingSearchTextStoresIt() {
        let viewModel = RootViewModel()

        viewModel.send(.searchTextChanged("Kraków"))

        #expect(viewModel.searchText == "Kraków")
    }

    @Test func changingSelectionStoresCity() {
        let viewModel = RootViewModel()

        viewModel.send(.selectionChanged(krakow))

        #expect(viewModel.selectedCity == krakow)
    }

    @Test func clearingSelectionRemovesCity() {
        let viewModel = RootViewModel()
        viewModel.send(.selectionChanged(krakow))

        viewModel.send(.selectionChanged(nil))

        #expect(viewModel.selectedCity == nil)
    }
}
