nonisolated enum ForecastMappingError: Error, Equatable {
    case unknownTimeZone(String)
    case unknownTemperatureUnit(String)
    case hourlyValuesCountMismatch
}
