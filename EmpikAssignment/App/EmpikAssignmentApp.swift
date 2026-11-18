import SwiftUI

@main
struct EmpikAssignmentApp: App {
    private let compositionRoot = CompositionRoot.live()

    var body: some Scene {
        WindowGroup {
            RootView(compositionRoot: compositionRoot)
        }
    }
}
