import Testing
@testable import EmpikAssignment

struct RootViewModelTests {
    @Test func deletingSelectedCityFromHistoryClearsSelection() {
        let viewModel = RootViewModel()
        viewModel.select(.krakow)

        viewModel.cityRemovedFromHistory(.krakow)

        #expect(viewModel.selectedCity == nil)
    }

    @Test func deletingAnotherCityFromHistoryKeepsSelection() {
        let viewModel = RootViewModel()
        viewModel.select(.krakow)

        viewModel.cityRemovedFromHistory(.lodz)

        #expect(viewModel.selectedCity == .krakow)
    }

    @Test func clearingHistoryClearsSelection() {
        let viewModel = RootViewModel()
        viewModel.select(.krakow)

        viewModel.historyCleared()

        #expect(viewModel.selectedCity == nil)
    }

    @Test func changingSelectionStoresCity() {
        let viewModel = RootViewModel()

        viewModel.select(.krakow)

        #expect(viewModel.selectedCity == .krakow)
    }

    @Test func clearingSelectionRemovesCity() {
        let viewModel = RootViewModel()
        viewModel.select(.krakow)

        viewModel.select(nil)

        #expect(viewModel.selectedCity == nil)
    }
}
