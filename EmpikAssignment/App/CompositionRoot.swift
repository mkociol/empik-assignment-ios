import Foundation

struct CompositionRoot {
    let citySearchClient: CitySearchClient
    let forecastClient: ForecastClient

    static func live(bundle: Bundle = .main) -> CompositionRoot {
        let configuration: AppConfiguration
        do {
            configuration = try AppConfiguration(infoDictionary: bundle.infoDictionary ?? [:])
        } catch {
            fatalError("Invalid app configuration: \(error). Check Configuration/*.xcconfig.")
        }
        let httpClient = OpenMeteoHTTPClient(
            configuration: configuration,
            fetchData: { url in try await URLSession.shared.data(from: url) }
        )
        return CompositionRoot(
            citySearchClient: .live(
                httpClient: httpClient,
                preferredLanguage: { bundle.preferredLocalizations.first ?? configuration.fallbackLanguage }
            ),
            forecastClient: .live(
                httpClient: httpClient,
                preferredTemperatureUnit: { UnitTemperature(forLocale: .autoupdatingCurrent, usage: .weather) }
            )
        )
    }
}
