import SwiftUI

struct PercentageText: View {
    let percent: Int?

    var body: some View {
        if let percent {
            Text(percent, format: .percent)
        } else {
            Text(verbatim: "–")
                .accessibilityLabel(Text(.noDataAccessibilityLabel))
        }
    }
}

#Preview {
    VStack {
        PercentageText(percent: 98)
        PercentageText(percent: nil)
    }
}
