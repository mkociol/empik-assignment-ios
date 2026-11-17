#if DEBUG
extension ForecastViewModel {
    static func preview() -> ForecastViewModel {
        ForecastViewModel(
            city: .previewKrakow,
            forecastClient: ForecastClient(fetchForecast: { _ in .previewKrakow })
        )
    }
}
#endif
