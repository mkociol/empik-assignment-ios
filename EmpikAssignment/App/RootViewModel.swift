import Observation

@Observable
final class RootViewModel {
    enum Action {
        case searchTextChanged(String)
        case selectionChanged(City?)
        case historyCityDeleted(City)
        case historyCleared
    }

    private(set) var selectedCity: City?
    private(set) var searchText = ""

    func send(_ action: Action) {
        switch action {
        case let .searchTextChanged(text):
            searchText = text
        case let .selectionChanged(city):
            selectedCity = city
        case let .historyCityDeleted(city):
            if selectedCity == city {
                selectedCity = nil
            }
        case .historyCleared:
            selectedCity = nil
        }
    }
}
