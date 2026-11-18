import SwiftUI

struct RootView: View {
    private let compositionRoot: CompositionRoot

    @State private var selectedCity: City?
    @State private var searchText = ""

    init(compositionRoot: CompositionRoot) {
        self.compositionRoot = compositionRoot
    }

    var body: some View {
        NavigationSplitView {
            SearchView(viewModel: compositionRoot.makeSearchViewModel(), searchText: searchText, selectedCity: $selectedCity)
        } detail: {
            if let selectedCity {
                ForecastView(viewModel: compositionRoot.makeForecastViewModel(for: selectedCity))
                    .id(selectedCity.id)
            } else {
                NoCitySelectedView()
            }
        }
        // On the split view, not on the sidebar: the search field belongs to the whole container and survives going back.
        .searchable(text: $searchText, prompt: Text(.searchFieldPrompt))
    }
}

#Preview("iPhone") {
    RootView(compositionRoot: .preview())
}

#Preview("iPad", traits: .landscapeLeft) {
    RootView(compositionRoot: .preview())
}
