import Testing
@testable import EmpikAssignment

struct RootViewModelTests {
    @Test func deletingSelectedCityFromHistoryClearsSelection() {
        let viewModel = RootViewModel()
        viewModel.send(.selectionChanged(.krakow))

        viewModel.send(.historyCityDeleted(.krakow))

        #expect(viewModel.selectedCity == nil)
    }

    @Test func deletingAnotherCityFromHistoryKeepsSelection() {
        let viewModel = RootViewModel()
        viewModel.send(.selectionChanged(.krakow))

        viewModel.send(.historyCityDeleted(.lodz))

        #expect(viewModel.selectedCity == .krakow)
    }

    @Test func clearingHistoryClearsSelection() {
        let viewModel = RootViewModel()
        viewModel.send(.selectionChanged(.krakow))

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

        viewModel.send(.selectionChanged(.krakow))

        #expect(viewModel.selectedCity == .krakow)
    }

    @Test func clearingSelectionRemovesCity() {
        let viewModel = RootViewModel()
        viewModel.send(.selectionChanged(.krakow))

        viewModel.send(.selectionChanged(nil))

        #expect(viewModel.selectedCity == nil)
    }
}
