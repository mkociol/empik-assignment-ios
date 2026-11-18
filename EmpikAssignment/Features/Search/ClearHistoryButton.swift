import SwiftUI

struct ClearHistoryButton: View {
    let onConfirm: () -> Void

    @State private var isConfirmationPresented = false

    var body: some View {
        Button(.searchHistoryClearButton) {
            isConfirmationPresented = true
        }
        .accessibilityLabel(Text(.searchHistoryClearButtonAccessibilityLabel))
        .confirmationDialog(
            Text(.clearHistoryDialogTitle),
            isPresented: $isConfirmationPresented,
            titleVisibility: .visible
        ) {
            Button(.clearHistoryDialogConfirmButton, role: .destructive, action: onConfirm)
            Button(.clearHistoryDialogCancelButton, role: .cancel) {}
        }
    }
}

private struct ClearHistoryButtonPreview: View {
    var body: some View {
        NavigationStack {
            List {}
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        ClearHistoryButton(onConfirm: {})
                    }
                }
        }
    }
}

#Preview("English") {
    ClearHistoryButtonPreview()
}

#Preview("Polish, dark") {
    ClearHistoryButtonPreview()
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}
