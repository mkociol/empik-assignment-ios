import SwiftUI

struct RemoteDataFailureView: View {
    let failure: RemoteDataFailure
    let retry: () -> Void

    var body: some View {
        switch failure {
        case .offline:
            OfflineStateView(retry: retry)
        case let .error(reason):
            ErrorStateView(reason: reason, retry: retry)
        }
    }
}

#Preview("Offline") {
    RemoteDataFailureView(failure: .offline, retry: {})
}

#Preview("Error from API") {
    RemoteDataFailureView(failure: .error(reason: "Parameter count must be between 1 and 100."), retry: {})
}
