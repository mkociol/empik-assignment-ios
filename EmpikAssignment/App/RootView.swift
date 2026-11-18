import SwiftUI

struct RootView: View {
    private let compositionRoot: CompositionRoot

    @State private var viewModel: RootViewModel

    init(compositionRoot: CompositionRoot) {
        self.compositionRoot = compositionRoot
        _viewModel = State(initialValue: compositionRoot.makeRootViewModel())
    }

    var body: some View {
        NavigationSplitView {
            SearchView(
                viewModel: compositionRoot.makeSearchViewModel(),
                searchText: viewModel.searchText,
                selectedCity: selectedCityBinding,
                onHistoryCityDeleted: { viewModel.send(.historyCityDeleted($0)) },
                onHistoryCleared: { viewModel.send(.historyCleared) }
            )
        } detail: {
            if let selectedCity = viewModel.selectedCity {
                ForecastView(viewModel: compositionRoot.makeForecastViewModel(for: selectedCity))
                    .id(selectedCity.id)
            } else {
                NoCitySelectedView()
            }
        }
        // On the split view, not on the sidebar: the search field belongs to the whole container and survives going back.
        .searchable(text: searchTextBinding, prompt: Text(.searchFieldPrompt))
    }

    private var selectedCityBinding: Binding<City?> {
        Binding(get: { viewModel.selectedCity }, set: { viewModel.send(.selectionChanged($0)) })
    }

    private var searchTextBinding: Binding<String> {
        Binding(get: { viewModel.searchText }, set: { viewModel.send(.searchTextChanged($0)) })
    }
}

#Preview("iPhone") {
    RootView(compositionRoot: .preview())
}

#Preview("iPhone, Polish, dark") {
    RootView(compositionRoot: .preview())
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("iPhone, large text") {
    RootView(compositionRoot: .preview())
        .dynamicTypeSize(.accessibility3)
}

#Preview("Landscape", traits: .landscapeLeft) {
    RootView(compositionRoot: .preview())
}
