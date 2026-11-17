nonisolated struct ForecastResponseDTO: Decodable {
    let timezone: String
    let currentUnits: UnitsDTO
    let current: CurrentDTO
    let hourlyUnits: UnitsDTO
    let hourly: HourlyDTO

    enum CodingKeys: String, CodingKey {
        case timezone
        case currentUnits = "current_units"
        case current
        case hourlyUnits = "hourly_units"
        case hourly
    }

    nonisolated struct UnitsDTO: Decodable {
        let temperature2m: String

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
        }
    }

    nonisolated struct CurrentDTO: Decodable {
        let temperature2m: Double
        let cloudCover: Int
        let precipitationProbability: Int?

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case cloudCover = "cloud_cover"
            case precipitationProbability = "precipitation_probability"
        }
    }

    nonisolated struct HourlyDTO: Decodable {
        let time: [Int]
        let temperature2m: [Double]
        let precipitationProbability: [Int?]

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2m = "temperature_2m"
            case precipitationProbability = "precipitation_probability"
        }
    }
}
