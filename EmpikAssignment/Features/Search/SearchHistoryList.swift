import SwiftUI

struct SearchHistoryList: View {
    let cities: [City]
    @Binding var selectedCity: City?
    let onDelete: (City) -> Void
    let onClearAll: () -> Void

    @State private var isClearConfirmationPresented = false

    var body: some View {
        List(selection: $selectedCity) {
            Section {
                ForEach(cities) { city in
                    CityRow(city: city)
                        .tag(city)
                        .swipeActions {
                            Button(role: .destructive) {
                                onDelete(city)
                            } label: {
                                Label(.searchHistoryDeleteButton, systemImage: "trash")
                            }
                        }
                }
            } header: {
                HStack {
                    Text(.searchHistoryHeader)
                    Spacer()
                    Button(.searchHistoryClearButton) {
                        isClearConfirmationPresented = true
                    }
                }
            }
        }
        .confirmationDialog(
            Text(.clearHistoryDialogTitle),
            isPresented: $isClearConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button(.clearHistoryDialogConfirmButton, role: .destructive, action: onClearAll)
            Button(.clearHistoryDialogCancelButton, role: .cancel) {}
        }
    }
}

#Preview("English") {
    SearchHistoryList(
        cities: [.previewSingapore, .previewKrakow, .previewLodz],
        selectedCity: .constant(nil),
        onDelete: { _ in },
        onClearAll: {}
    )
}

#Preview("Polish, dark") {
    SearchHistoryList(
        cities: [.previewSingapore, .previewKrakow, .previewLodz],
        selectedCity: .constant(nil),
        onDelete: { _ in },
        onClearAll: {}
    )
    .environment(\.locale, Locale(identifier: "pl"))
    .preferredColorScheme(.dark)
}

#Preview("Large text") {
    SearchHistoryList(
        cities: [.previewKrakow, .previewLlanfairpwll],
        selectedCity: .constant(nil),
        onDelete: { _ in },
        onClearAll: {}
    )
    .dynamicTypeSize(.accessibility3)
}
