nonisolated enum CityNameValidationResult: Equatable {
    case valid
    case incomplete
    case invalid(CityNameValidationError)
}
