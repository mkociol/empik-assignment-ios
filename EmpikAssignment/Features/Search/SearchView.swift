import SwiftUI

struct SearchView: View {
    let searchText: String
    @Binding var selectedCity: City?

    @State private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel, searchText: String, selectedCity: Binding<City?>) {
        _viewModel = State(initialValue: viewModel)
        self.searchText = searchText
        _selectedCity = selectedCity
    }

    var body: some View {
        SearchContentView(
            state: viewModel.state,
            history: viewModel.history,
            selectedCity: $selectedCity,
            onRetry: retry,
            onDeleteFromHistory: deleteFromHistory,
            onClearHistory: clearHistory
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
        Task { await viewModel.send(.historyCityDeleted(city)) }
    }

    private func clearHistory() {
        Task { await viewModel.send(.clearHistoryConfirmed) }
    }
}

#Preview {
    @Previewable @State var selectedCity: City?
    @Previewable @State var searchText = ""

    NavigationSplitView {
        SearchView(viewModel: .preview(), searchText: searchText, selectedCity: $selectedCity)
    } detail: {
        Text(verbatim: selectedCity?.name ?? "")
    }
    .searchable(text: $searchText, prompt: Text(.searchFieldPrompt))
}
