import SwiftUI

struct SearchHistorySection: View {
    let cities: [City]
    let onDelete: (City) -> Void
    let onClearAll: () -> Void

    @State private var isClearConfirmationPresented = false

    var body: some View {
        Section {
            ForEach(cities) { city in
                NavigationLink(value: city) {
                    CityRow(city: city)
                }
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
                .accessibilityLabel(Text(.searchHistoryClearButtonAccessibilityLabel))
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
    List {
        SearchHistorySection(cities: [.previewSingapore, .previewKrakow, .previewLodz], onDelete: { _ in }, onClearAll: {})
    }
}

#Preview("Polish, dark") {
    List {
        SearchHistorySection(cities: [.previewSingapore, .previewKrakow, .previewLodz], onDelete: { _ in }, onClearAll: {})
    }
    .environment(\.locale, Locale(identifier: "pl"))
    .preferredColorScheme(.dark)
}

#Preview("Large text") {
    List {
        SearchHistorySection(cities: [.previewKrakow, .previewLlanfairpwll], onDelete: { _ in }, onClearAll: {})
    }
    .dynamicTypeSize(.accessibility3)
}
