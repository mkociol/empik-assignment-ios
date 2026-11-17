import SwiftUI

struct InvalidCityNameView: View {
    let error: CityNameValidationError

    var body: some View {
        ContentUnavailableView {
            Label(.invalidCityNameTitle, systemImage: "exclamationmark.circle")
        } description: {
            Text(error.message)
        }
    }
}

#Preview("English") {
    InvalidCityNameView(error: .containsDigits)
}

#Preview("Polish, dark") {
    InvalidCityNameView(error: .consecutiveSpacesOrHyphens)
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    InvalidCityNameView(error: .containsSpecialCharacters)
        .dynamicTypeSize(.accessibility3)
}
