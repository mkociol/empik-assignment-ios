import SwiftUI

struct SearchContentView: View {
    let state: SearchViewModel.State
    let history: SearchHistory
    @Binding var selectedCity: City?
    let onRetry: () -> Void
    let onDeleteFromHistory: (City) -> Void
    let onClearHistory: () -> Void

    var body: some View {
        switch state {
        case .history:
            if history.cities.isEmpty {
                SearchPromptView()
            } else {
                SearchHistoryList(
                    cities: history.cities,
                    selectedCity: $selectedCity,
                    onDelete: onDeleteFromHistory,
                    onClearAll: onClearHistory
                )
            }
        case let .invalidInput(error):
            InvalidCityNameView(error: error)
        case .loading:
            LoadingStateView()
        case let .results(cities):
            SearchResultsList(cities: cities, selectedCity: $selectedCity)
        case let .noResults(query):
            EmptySearchResultView(query: query)
        case .offline:
            OfflineStateView(retry: onRetry)
        case let .error(reason):
            ErrorStateView(reason: reason, retry: onRetry)
        }
    }
}

private struct SearchContentPreview: View {
    let state: SearchViewModel.State
    var history = SearchHistory(cities: [.previewSingapore, .previewKrakow])

    var body: some View {
        SearchContentView(
            state: state,
            history: history,
            selectedCity: .constant(nil),
            onRetry: {},
            onDeleteFromHistory: { _ in },
            onClearHistory: {}
        )
    }
}

#Preview("History") {
    SearchContentPreview(state: .history)
}

#Preview("No history yet") {
    SearchContentPreview(state: .history, history: SearchHistory())
}

#Preview("Invalid input") {
    SearchContentPreview(state: .invalidInput(.containsDigits))
}

#Preview("Loading") {
    SearchContentPreview(state: .loading)
}

#Preview("Results") {
    SearchContentPreview(state: .results([.previewKrakow, .previewLodz]))
}

#Preview("No results") {
    SearchContentPreview(state: .noResults(query: "Xyzqwv"))
}

#Preview("Offline") {
    SearchContentPreview(state: .offline)
}

#Preview("Error from API") {
    SearchContentPreview(state: .error(reason: "Parameter count must be between 1 and 100."))
}

#Preview("Polish, dark") {
    SearchContentPreview(state: .history)
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}
