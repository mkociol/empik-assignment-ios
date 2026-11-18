import SwiftUI

struct SearchContentView: View {
    let state: SearchViewModel.State
    let history: SearchHistory

    let onRetry: () -> Void
    let onDeleteFromHistory: (City) -> Void
    let onClearHistory: () -> Void

    @Binding var selectedCity: City?

    var body: some View {
        List(selection: $selectedCity) {
            switch state {
            case .history:
                if !history.cities.isEmpty {
                    SearchHistorySection(cities: history.cities, onDelete: onDeleteFromHistory)
                }
            case let .results(cities):
                SearchResultsSection(cities: cities)
            case .invalidInput, .loading, .noResults, .failed:
                EmptyView()
            }
        }
        .overlay {
            SearchStateOverlay(state: state, isHistoryEmpty: history.cities.isEmpty, onRetry: onRetry)
        }
        .toolbar {
            if state == .history, !history.cities.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    ClearHistoryButton(onConfirm: onClearHistory)
                }
            }
        }
        .animatesChanges(of: state)
        .animatesChanges(of: history.cities)
    }
}

private struct SearchStateOverlay: View {
    let state: SearchViewModel.State
    let isHistoryEmpty: Bool
    let onRetry: () -> Void

    var body: some View {
        switch state {
        case .history:
            if isHistoryEmpty {
                SearchPromptView()
            }
        case let .invalidInput(error):
            InvalidCityNameView(error: error)
        case .loading:
            LoadingStateView()
        case .results:
            EmptyView()
        case let .noResults(query):
            EmptySearchResultView(query: query)
        case let .failed(failure):
            RemoteDataFailureView(failure: failure, retry: onRetry)
        }
    }
}

private struct SearchContentPreview: View {
    let state: SearchViewModel.State
    var history = SearchHistory(cities: [.previewSingapore, .previewKrakow])

    var body: some View {
        NavigationStack {
            SearchContentView(
                state: state,
                history: history,
                onRetry: {},
                onDeleteFromHistory: { _ in },
                onClearHistory: {},
                selectedCity: .constant(nil)
            )
        }
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
    SearchContentPreview(state: .failed(.offline))
}

#Preview("Error from API") {
    SearchContentPreview(state: .failed(.error(reason: "Parameter count must be between 1 and 100.")))
}

#Preview("Polish, dark") {
    SearchContentPreview(state: .history)
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}
