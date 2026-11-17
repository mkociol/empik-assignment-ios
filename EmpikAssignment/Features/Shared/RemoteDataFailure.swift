enum RemoteDataFailure: Equatable {
    case offline
    case error(reason: String?)

    init(_ error: any Error) {
        switch error as? RemoteDataError {
        case .offline:
            self = .offline
        case let .server(reason):
            self = .error(reason: reason)
        case .invalidResponse, nil:
            self = .error(reason: nil)
        }
    }
}
