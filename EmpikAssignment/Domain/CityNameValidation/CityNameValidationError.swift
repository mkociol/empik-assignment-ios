nonisolated enum CityNameValidationError: Equatable {
    case containsDigits
    case containsSpecialCharacters
    case startsWithSpaceOrHyphen
    case consecutiveSpacesOrHyphens
}
