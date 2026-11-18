import SwiftUI

struct SearchView: View {
    let searchText: String
    let onHistoryCityDeleted: (City) -> Void
    let onHistoryCleared: () -> Void

    @Binding var selectedCity: City?

    @State private var viewModel: SearchViewModel

    init(
        viewModel: SearchViewModel,
        searchText: String,
        selectedCity: Binding<City?>,
        onHistoryCityDeleted: @escaping (City) -> Void,
        onHistoryCleared: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        _selectedCity = selectedCity

        self.searchText = searchText
        self.onHistoryCityDeleted = onHistoryCityDeleted
        self.onHistoryCleared = onHistoryCleared
    }

    var body: some View {
        SearchContentView(
            state: viewModel.state,
            history: viewModel.history,
            onRetry: retry,
            onDeleteFromHistory: deleteFromHistory,
            onClearHistory: clearHistory,
            selectedCity: $selectedCity
        )
        .navigationTitle(Text(.searchTitle))
        .task { await viewModel.send(.appeared) }
        .task(id: searchText) { await viewModel.send(.queryChanged(searchText)) }
        .onChange(of: selectedCity) { _, city in citySelected(city) }
    }

    private func citySelected(_ city: City?) {
        guard let city else { return }
        Task { await viewModel.send(.citySelected(city)) }
    }

    private func retry() {
        Task { await viewModel.send(.retryTapped) }
    }

    private func deleteFromHistory(_ city: City) {
        onHistoryCityDeleted(city)
        Task { await viewModel.send(.historyCityDeleted(city)) }
    }

    private func clearHistory() {
        onHistoryCleared()
        Task { await viewModel.send(.clearHistoryConfirmed) }
    }
}

#Preview {
    @Previewable @State var selectedCity: City?
    @Previewable @State var searchText = ""

    NavigationSplitView {
        SearchView(
            viewModel: .preview(),
            searchText: searchText,
            selectedCity: $selectedCity,
            onHistoryCityDeleted: { _ in },
            onHistoryCleared: {}
        )
    } detail: {
        Text(verbatim: selectedCity?.name ?? "")
    }
    .searchable(text: $searchText, prompt: Text(.searchFieldPrompt))
}
