/// Stands in for the debounce wait: holds the first wait until `endFirstWait()`
/// and, like `Task.sleep`, throws when the waiting task was cancelled.
actor HeldFirstDebounce {
    private var hasFirstWaitStarted = false
    private var firstWait: CheckedContinuation<Void, Never>?
    private var firstWaitStartObserver: CheckedContinuation<Void, Never>?

    func wait() async throws {
        if !hasFirstWaitStarted {
            hasFirstWaitStarted = true
            await withCheckedContinuation { continuation in
                firstWait = continuation
                firstWaitStartObserver?.resume()
                firstWaitStartObserver = nil
            }
        }
        try Task.checkCancellation()
    }

    func untilFirstWaitStarts() async {
        guard firstWait == nil else { return }
        await withCheckedContinuation { continuation in
            firstWaitStartObserver = continuation
        }
    }

    func endFirstWait() {
        firstWait?.resume()
        firstWait = nil
    }
}
