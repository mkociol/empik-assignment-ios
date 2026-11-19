nonisolated enum CityNameValidationError: Error, Equatable {
    case containsDigits
    case containsSpecialCharacters
    case startsWithSpaceOrHyphen
    case consecutiveSpacesOrHyphens
}
