import Observation

@Observable
final class RootViewModel {
    private(set) var selectedCity: City?

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
