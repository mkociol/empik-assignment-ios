import Foundation

extension CityNameValidationError {
    var message: LocalizedStringResource {
        switch self {
        case .containsDigits: .cityNameValidationContainsDigits
        case .containsSpecialCharacters: .cityNameValidationContainsSpecialCharacters
        case .startsWithSpaceOrHyphen: .cityNameValidationStartsWithSpaceOrHyphen
        case .consecutiveSpacesOrHyphens: .cityNameValidationConsecutiveSpacesOrHyphens
        }
    }
}
