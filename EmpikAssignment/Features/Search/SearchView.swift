import SwiftUI

struct SearchView: View {
    let onHistoryCityDeleted: (City) -> Void
    let onHistoryCleared: () -> Void

    @Binding var selectedCity: City?

    @State private var viewModel: SearchViewModel
    @State private var searchText = ""

    init(
        viewModel: SearchViewModel,
        selectedCity: Binding<City?>,
        onHistoryCityDeleted: @escaping (City) -> Void,
        onHistoryCleared: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        _selectedCity = selectedCity

        self.onHistoryCityDeleted = onHistoryCityDeleted
        self.onHistoryCleared = onHistoryCleared
    }

    var body: some View {
        SearchContentView(
            state: viewModel.state,
            history: viewModel.history,
            canClearHistory: viewModel.canClearHistory,
            onRetry: retry,
            onDeleteFromHistory: deleteFromHistory,
            onClearHistory: clearHistory,
            selectedCity: $selectedCity
        )
        .navigationTitle(Text(.searchTitle))
        .searchable(text: $searchText, prompt: Text(.searchFieldPrompt))
        .task { await viewModel.loadHistory() }
        .task(id: searchText) { await viewModel.queryChanged(searchText) }
        .onChange(of: selectedCity) { _, city in citySelected(city) }
    }

    private func citySelected(_ city: City?) {
        guard let city else { return }
        Task { await viewModel.citySelected(city) }
    }

    private func retry() {
        Task { await viewModel.retrySearch() }
    }

    private func deleteFromHistory(_ city: City) {
        onHistoryCityDeleted(city)
        Task { await viewModel.removeFromHistory(city) }
    }

    private func clearHistory() {
        onHistoryCleared()
        Task { await viewModel.clearHistory() }
    }
}

private struct SearchViewPreview: View {
    @State private var selectedCity: City?

    var body: some View {
        NavigationSplitView {
            SearchView(
                viewModel: .preview(),
                selectedCity: $selectedCity,
                onHistoryCityDeleted: { _ in },
                onHistoryCleared: {}
            )
        } detail: {
            Text(verbatim: selectedCity?.name ?? "")
        }
    }
}

#Preview("Light") {
    SearchViewPreview()
}

#Preview("Polish, dark") {
    SearchViewPreview()
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}
