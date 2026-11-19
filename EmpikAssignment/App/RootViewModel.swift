import Observation

@Observable
final class RootViewModel {
    private(set) var selectedCity: City?
    private(set) var searchText = ""

    func updateSearchText(_ text: String) {
        searchText = text
    }

    func select(_ city: City?) {
        selectedCity = city
    }

    func cityRemovedFromHistory(_ city: City) {
        if selectedCity == city {
            selectedCity = nil
        }
    }

    func historyCleared() {
        selectedCity = nil
    }
}
