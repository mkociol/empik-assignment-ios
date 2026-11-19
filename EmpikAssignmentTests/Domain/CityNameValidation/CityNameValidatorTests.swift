import Testing
@testable import EmpikAssignment

struct CityNameValidatorTests {
    @Test(arguments: [
        "Kraków",
        "Bielsko-Biała",
        "Nowy Sącz",
        "Kędzierzyn-Koźle",
        "Łódź",
        "Zürich",
        "São Paulo",
        "Москва",
        "Nowy ",
        "Bielsko-"
    ])
    func acceptsValidCityName(_ cityName: String) {
        #expect(throws: Never.self) { try CityNameValidator.validate(cityName) }
    }

    @Test(arguments: ["Kraków2", "3city", "-Kraków2"])
    func rejectsCityNameWithDigits(_ cityName: String) {
        #expect(throws: CityNameValidationError.containsDigits) { try CityNameValidator.validate(cityName) }
    }

    @Test(arguments: [
        "St. Moritz",
        "L'Aquila",
        "Kraków!",
        "Kraków🙂",
    ])
    func rejectsCityNameWithSpecialCharacters(_ cityName: String) {
        #expect(throws: CityNameValidationError.containsSpecialCharacters) { try CityNameValidator.validate(cityName) }
    }

    @Test(arguments: [" Kraków", "-Kraków", " ", "-"])
    func rejectsCityNameStartingWithSpaceOrHyphen(_ cityName: String) {
        #expect(throws: CityNameValidationError.startsWithSpaceOrHyphen) { try CityNameValidator.validate(cityName) }
    }

    @Test(arguments: ["Bielsko--Biała", "Bielsko -Biała", "Bielsko- Biała"])
    func rejectsCityNameWithConsecutiveSpacesOrHyphens(_ cityName: String) {
        #expect(throws: CityNameValidationError.consecutiveSpacesOrHyphens) { try CityNameValidator.validate(cityName) }
    }
}
