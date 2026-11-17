import SwiftUI

struct SearchView: View {
    let viewModel: SearchViewModel
    @Binding var selectedCity: City?

    @State private var searchText = ""

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
        .searchable(text: $searchText, prompt: Text(.searchFieldPrompt))
        .task { await viewModel.send(.appeared) }
        .task(id: searchText) { await viewModel.send(.queryChanged(searchText)) }
        .task(id: selectedCity) {
            guard let selectedCity else { return }
            await viewModel.send(.citySelected(selectedCity))
        }
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

    NavigationSplitView {
        SearchView(viewModel: .preview(), selectedCity: $selectedCity)
    } detail: {
        Text(verbatim: selectedCity?.name ?? "")
    }
}
