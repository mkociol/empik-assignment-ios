import SwiftUI

struct CurrentTemperatureView: View {
    let temperature: Measurement<UnitTemperature>

    var body: some View {
        Text(temperature, format: .weatherTemperature)
            .largeDisplayFont()
            .frame(maxWidth: .infinity)
            .accessibilityLabel(Text(.currentTemperatureAccessibilityLabel(temperature.formatted(.weatherTemperature))))
    }
}

#Preview("English") {
    CurrentTemperatureView(temperature: Forecast.previewKrakow.current.temperature)
        .padding()
        .background(SkyGradientBackground())
}

#Preview("Polish, dark") {
    CurrentTemperatureView(temperature: Forecast.previewKrakow.current.temperature)
        .padding()
        .background(SkyGradientBackground())
        .environment(\.locale, Locale(identifier: "pl"))
        .preferredColorScheme(.dark)
}

#Preview("Large text") {
    CurrentTemperatureView(temperature: Forecast.previewKrakow.current.temperature)
        .padding()
        .background(SkyGradientBackground())
        .dynamicTypeSize(.accessibility3)
}
