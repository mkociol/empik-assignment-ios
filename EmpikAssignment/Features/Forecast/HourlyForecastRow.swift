import SwiftUI

/// One hour of the forecast: a row of a `Grid` (columns line up across hours) or, at accessibility text sizes,
/// two lines that don't need the extra width.
struct HourlyForecastRow: View {
    let hour: HourlyForecast
    let timeZone: TimeZone
    let isCurrentHour: Bool
    let isStacked: Bool

    var body: some View {
        if isStacked {
            VStack(alignment: .leading, spacing: Spacing.small) {
                HStack {
                    HourText(date: hour.date, timeZone: timeZone, isCurrentHour: isCurrentHour)
                    Spacer()
                    TemperatureText(temperature: hour.temperature)
                }
                PrecipitationChanceLabel(percent: hour.precipitationProbabilityPercent)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel)
        } else {
            // Modifiers on a GridRow apply to each cell, so the first cell reads the whole row and the others are hidden.
            GridRow {
                HourText(date: hour.date, timeZone: timeZone, isCurrentHour: isCurrentHour)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel(accessibilityLabel)
                PrecipitationChanceLabel(percent: hour.precipitationProbabilityPercent)
                    .gridColumnAlignment(.leading)
                    .accessibilityHidden(true)
                TemperatureText(temperature: hour.temperature)
                    .gridColumnAlignment(.trailing)
                    .accessibilityHidden(true)
            }
        }
    }

    /// One sentence with the temperature before the chance of precipitation, instead of the visual order of the parts.
    private var accessibilityLabel: Text {
        let hourDescription = isCurrentHour ? String(localized: .hourlyForecastNow) : hour.date.formatted(.hour(in: timeZone))
        let temperature = hour.temperature.formatted(.weatherTemperature)
        guard let percent = hour.precipitationProbabilityPercent else {
            return Text(.hourlyForecastRowAccessibilityLabelWithoutPrecipitation(hourDescription, temperature))
        }
        return Text(.hourlyForecastRowAccessibilityLabel(hourDescription, temperature, percent.formatted(.percent)))
    }
}

private struct HourText: View {
    let date: Date
    let timeZone: TimeZone
    let isCurrentHour: Bool

    var body: some View {
        if isCurrentHour {
            Text(.hourlyForecastNow)
        } else {
            Text(date, format: .hour(in: timeZone))
        }
    }
}

private struct PrecipitationChanceLabel: View {
    let percent: Int?

    var body: some View {
        Label {
            PercentageText(percent: percent)
        } icon: {
            Image(systemName: "umbrella")
        }
        .foregroundStyle(.secondary)
    }
}

private struct TemperatureText: View {
    let temperature: Measurement<UnitTemperature>

    var body: some View {
        Text(temperature, format: .weatherTemperature)
            .font(.headline)
            .monospacedDigit()
    }
}

private struct HourlyForecastRowPreview: View {
    let isStacked: Bool

    private let hours = Forecast.previewKrakow.hourly
    private let timeZone = Forecast.previewKrakow.timeZone

    var body: some View {
        let hourWithoutPrecipitation = HourlyForecast(
            date: hours[2].date,
            temperature: hours[2].temperature,
            precipitationProbabilityPercent: nil
        )
        let rows = ForEach([hours[0], hours[1], hourWithoutPrecipitation], id: \.date) { hour in
            HourlyForecastRow(hour: hour, timeZone: timeZone, isCurrentHour: hour.date == hours[0].date, isStacked: isStacked)
        }
        Group {
            if isStacked {
                VStack(alignment: .leading, spacing: Spacing.medium) { rows }
            } else {
                Grid(alignment: .leading, horizontalSpacing: Spacing.medium, verticalSpacing: Spacing.small) { rows }
            }
        }
        .padding()
    }
}

#Preview("Grid rows") {
    HourlyForecastRowPreview(isStacked: false)
}

#Preview("Grid rows, Polish, dark") {
    HourlyForecastRowPreview(isStacked: false)
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Stacked rows, large text") {
    HourlyForecastRowPreview(isStacked: true)
        .dynamicTypeSize(.accessibility3)
}
