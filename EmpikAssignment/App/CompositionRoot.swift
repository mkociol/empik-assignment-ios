import Foundation
import OSLog
import SwiftData

struct CompositionRoot {
    private let citySearchClient: CitySearchClient
    private let forecastClient: ForecastClient
    private let searchHistoryRepository: SearchHistoryRepository
    private let searchLogger: Logger

    func makeRootViewModel() -> RootViewModel {
        RootViewModel()
    }

    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(
            citySearchClient: citySearchClient,
            searchHistoryRepository: searchHistoryRepository,
            logger: searchLogger
        )
    }

    func makeForecastViewModel(for city: City) -> ForecastViewModel {
        ForecastViewModel(city: city, forecastClient: forecastClient)
    }

    static func live(bundle: Bundle = .main) -> CompositionRoot {
        let configuration = loadConfiguration(from: bundle)
        let httpClient = OpenMeteoHTTPClient(
            configuration: OpenMeteoConfiguration(
                geocodingAPIBaseURL: configuration.geocodingAPIBaseURL,
                forecastAPIBaseURL: configuration.forecastAPIBaseURL
            ),
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
            ),
            searchHistoryRepository: makeSearchHistoryRepository(),
            searchLogger: Logger(subsystem: bundle.bundleIdentifier ?? "EmpikAssignment", category: "Search")
        )
    }

    private static func loadConfiguration(from bundle: Bundle) -> AppConfiguration {
        do {
            return try AppConfiguration(infoDictionary: bundle.infoDictionary ?? [:])
        } catch {
            fatalError("Invalid app configuration: \(error). Check Configuration/*.xcconfig.")
        }
    }

    /// Search history is optional, so if the store can't be opened the app keeps working without saving it.
    private static func makeSearchHistoryRepository() -> SearchHistoryRepository {
        do {
            let modelContainer = try ModelContainer(
                for: SearchHistoryEntry.self,
                configurations: ModelConfiguration("SearchHistory")
            )
            return .swiftData(modelContainer: modelContainer)
        } catch {
            return SearchHistoryRepository(load: { SearchHistory() }, save: { _ in })
        }
    }

    #if DEBUG
    static func preview() -> CompositionRoot {
        CompositionRoot(
            citySearchClient: CitySearchClient(searchCities: { _ in [.previewKrakow, .previewLodz] }),
            forecastClient: ForecastClient(fetchForecast: { _ in .previewKrakow }),
            searchHistoryRepository: SearchHistoryRepository(
                load: { SearchHistory(cities: [.previewSingapore, .previewKrakow]) },
                save: { _ in }
            ),
            searchLogger: Logger(.disabled)
        )
    }
    #endif
}
