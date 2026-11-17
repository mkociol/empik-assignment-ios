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
            .accessibilityElement(children: .combine)
        } else {
            GridRow {
                HourText(date: hour.date, timeZone: timeZone, isCurrentHour: isCurrentHour)
                    .frame(maxWidth: .infinity, alignment: .leading)
                PrecipitationChanceLabel(percent: hour.precipitationProbabilityPercent)
                    .gridColumnAlignment(.leading)
                TemperatureText(temperature: hour.temperature)
                    .gridColumnAlignment(.trailing)
            }
            .accessibilityElement(children: .combine)
        }
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
                .accessibilityLabel(Text(.weatherConditionsPrecipitationProbability))
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
