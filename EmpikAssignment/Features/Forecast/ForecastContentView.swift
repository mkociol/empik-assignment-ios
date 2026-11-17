import SwiftUI

struct ForecastContentView: View {
    let state: ForecastViewModel.State
    let onRetry: () -> Void

    var body: some View {
        switch state {
        case .loading:
            LoadingStateView()
        case let .loaded(forecast):
            ForecastDetailsView(forecast: forecast)
        case let .failed(failure):
            RemoteDataFailureView(failure: failure, retry: onRetry)
        }
    }
}

private struct ForecastContentPreview: View {
    let state: ForecastViewModel.State

    var body: some View {
        ZStack {
            SkyGradientBackground()
            ForecastContentView(state: state, onRetry: {})
        }
    }
}

#Preview("Loading") {
    ForecastContentPreview(state: .loading)
}

#Preview("Loaded") {
    ForecastContentPreview(state: .loaded(.previewKrakow))
}

#Preview("Offline") {
    ForecastContentPreview(state: .failed(.offline))
}

#Preview("Error from API") {
    ForecastContentPreview(state: .failed(.error(reason: "Latitude must be in range of -90 to 90°. Given: 200.0.")))
}
