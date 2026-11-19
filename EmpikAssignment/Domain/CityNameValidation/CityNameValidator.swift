nonisolated enum CityNameValidator {
    private static let separators: Set<Character> = [" ", "-"]

    static func validate(_ cityName: String) throws(CityNameValidationError) {
        if cityName.contains(where: \.isNumber) {
            throw .containsDigits
        }
        if cityName.contains(where: { !$0.isLetter && !separators.contains($0) }) {
            throw .containsSpecialCharacters
        }
        if let firstCharacter = cityName.first, separators.contains(firstCharacter) {
            throw .startsWithSpaceOrHyphen
        }
        if zip(cityName, cityName.dropFirst()).contains(where: { separators.contains($0) && separators.contains($1) }) {
            throw .consecutiveSpacesOrHyphens
        }
    }
}
