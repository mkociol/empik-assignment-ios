import SwiftUI

struct HourlyForecastCard: View {
    let hours: [HourlyForecast]
    let timeZone: TimeZone

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text(.hourlyForecastTitle)
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                if dynamicTypeSize.isAccessibilitySize {
                    HourlyForecastRows(hours: hours, timeZone: timeZone, isStacked: true)
                } else {
                    Grid(alignment: .leading, horizontalSpacing: Spacing.medium, verticalSpacing: Spacing.small) {
                        HourlyForecastRows(hours: hours, timeZone: timeZone, isStacked: false)
                    }
                }
            }
        }
    }
}

private struct HourlyForecastRows: View {
    let hours: [HourlyForecast]
    let timeZone: TimeZone
    let isStacked: Bool

    var body: some View {
        ForEach(hours, id: \.date) { hour in
            Divider()
            HourlyForecastRow(
                hour: hour,
                timeZone: timeZone,
                isCurrentHour: hour.date == hours.first?.date,
                isStacked: isStacked
            )
        }
    }
}

#Preview("English") {
    ScrollView {
        HourlyForecastCard(hours: Forecast.previewKrakow.hourly, timeZone: Forecast.previewKrakow.timeZone)
            .padding()
    }
    .background(SkyGradientBackground())
}

#Preview("Polish, dark") {
    ScrollView {
        HourlyForecastCard(hours: Forecast.previewKrakow.hourly, timeZone: Forecast.previewKrakow.timeZone)
            .padding()
    }
    .background(SkyGradientBackground())
    .environment(\.locale, Locale(identifier: "pl"))
    .preferredColorScheme(.dark)
}

#Preview("Large text") {
    ScrollView {
        HourlyForecastCard(hours: Forecast.previewKrakow.hourly, timeZone: Forecast.previewKrakow.timeZone)
            .padding()
    }
    .background(SkyGradientBackground())
    .dynamicTypeSize(.accessibility3)
}
