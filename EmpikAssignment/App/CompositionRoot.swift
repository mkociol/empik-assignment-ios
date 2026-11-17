import Foundation

struct CompositionRoot {
    let configuration: AppConfiguration

    static func live(bundle: Bundle = .main) -> CompositionRoot {
        let configuration: AppConfiguration
        do {
            configuration = try AppConfiguration(infoDictionary: bundle.infoDictionary ?? [:])
        } catch {
            fatalError("Invalid app configuration: \(error). Check Configuration/*.xcconfig.")
        }
        return CompositionRoot(configuration: configuration)
    }
}
