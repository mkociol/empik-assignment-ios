import SwiftUI

struct ForecastView: View {
    @State private var viewModel: ForecastViewModel

    init(viewModel: ForecastViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            SkyGradientBackground()
            ForecastContentView(state: viewModel.state, onRetry: retry)
                .animatesChanges(of: viewModel.state)
        }
        .navigationTitle(viewModel.city.name)
        .task { await viewModel.send(.appeared) }
    }

    private func retry() {
        Task { await viewModel.send(.retryTapped) }
    }
}

#Preview("Light") {
    NavigationStack {
        ForecastView(viewModel: .preview())
    }
}

#Preview("Polish, dark") {
    NavigationStack {
        ForecastView(viewModel: .preview())
    }
    .environment(\.locale, Locale(identifier: "pl"))
    .preferredColorScheme(.dark)
}
