nonisolated enum CityNameValidator {
    private static let consecutiveSpacesOrHyphens = ["  ", "--", " -", "- "]

    static func validate(_ cityName: String) -> CityNameValidationResult {
        if cityName.isEmpty {
            return .incomplete
        }
        if cityName.contains(where: \.isNumber) {
            return .invalid(.containsDigits)
        }
        if cityName.contains(where: { !$0.isLetter && !isSpaceOrHyphen($0) }) {
            return .invalid(.containsSpecialCharacters)
        }
        if cityName.hasPrefix(" ") || cityName.hasPrefix("-") {
            return .invalid(.startsWithSpaceOrHyphen)
        }
        if consecutiveSpacesOrHyphens.contains(where: { cityName.contains($0) }) {
            return .invalid(.consecutiveSpacesOrHyphens)
        }
        if cityName.hasSuffix(" ") || cityName.hasSuffix("-") {
            return .incomplete
        }
        return .valid
    }

    private static func isSpaceOrHyphen(_ character: Character) -> Bool {
        character == " " || character == "-"
    }
}
