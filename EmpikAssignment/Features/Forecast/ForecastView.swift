import SwiftUI

struct ForecastView: View {
    let viewModel: ForecastViewModel

    var body: some View {
        ZStack {
            SkyGradientBackground()
            ForecastContentView(state: viewModel.state, onRetry: retry)
        }
        .navigationTitle(viewModel.city.name)
        .task { await viewModel.send(.appeared) }
    }

    private func retry() {
        Task { await viewModel.send(.retryTapped) }
    }
}

#Preview {
    NavigationStack {
        ForecastView(viewModel: .preview())
    }
}
