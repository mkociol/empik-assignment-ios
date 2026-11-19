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
                selectedCity: selectedCityBinding,
                onHistoryCityDeleted: { viewModel.cityRemovedFromHistory($0) },
                onHistoryCleared: { viewModel.historyCleared() }
            )
        } detail: {
            if let selectedCity = viewModel.selectedCity {
                ForecastView(viewModel: compositionRoot.makeForecastViewModel(for: selectedCity))
                    .id(selectedCity.id)
            } else {
                NoCitySelectedView()
            }
        }
    }

    private var selectedCityBinding: Binding<City?> {
        Binding(get: { viewModel.selectedCity }, set: { viewModel.select($0) })
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
