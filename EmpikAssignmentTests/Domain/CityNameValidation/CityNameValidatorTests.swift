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
        "Москва"
    ])
    func acceptsValidCityName(_ cityName: String) {
        #expect(CityNameValidator.validate(cityName) == .valid)
    }

    @Test(arguments: ["", "Nowy ", "Bielsko-"])
    func treatsUnfinishedCityNameAsIncomplete(_ cityName: String) {
        #expect(CityNameValidator.validate(cityName) == .incomplete)
    }

    @Test(arguments: ["Kraków2", "3city", "-Kraków2"])
    func rejectsCityNameWithDigits(_ cityName: String) {
        #expect(CityNameValidator.validate(cityName) == .invalid(.containsDigits))
    }

    @Test(arguments: [
        "St. Moritz",
        "L'Aquila",
        "Kraków!",
        "Kraków🙂",
    ])
    func rejectsCityNameWithSpecialCharacters(_ cityName: String) {
        #expect(CityNameValidator.validate(cityName) == .invalid(.containsSpecialCharacters))
    }

    @Test(arguments: [" Kraków", "-Kraków", " ", "-"])
    func rejectsCityNameStartingWithSpaceOrHyphen(_ cityName: String) {
        #expect(CityNameValidator.validate(cityName) == .invalid(.startsWithSpaceOrHyphen))
    }

    @Test(arguments: ["Bielsko--Biała", "Bielsko -Biała", "Bielsko- Biała"])
    func rejectsCityNameWithConsecutiveSpacesOrHyphens(_ cityName: String) {
        #expect(CityNameValidator.validate(cityName) == .invalid(.consecutiveSpacesOrHyphens))
    }
}
