//
//  WeatherDescriptionViewModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

protocol WeatherDescriptionIconDataLoader {
    func loadDataForIcon(named name: String?, complition: @escaping ((Data) -> Void))
}

struct WeatherDescriptionViewModel {
    
    struct WeatherDescription: CustomStringConvertible {
        enum TemperatureUnit: String {
            case celsius = "C"
            case fahrenheit = "F"
        }

        let temperature: Int
        let temperatureUnit: TemperatureUnit
        let details: String?

        var description: String { "\(temperature)°\(temperatureUnit.rawValue) \(details.flatMap { " | " + $0 } ?? "" )" }
    }
    
    let weatherIconName: String?
    let weatherIconLoader: WeatherDescriptionIconDataLoader?
    let locationDescription: String?
    let weatherDescription: WeatherDescription?

    var sharedDescription: String { "\(weatherDescription?.description ?? ""), \(locationDescription ?? "")" }
}


extension WeatherDescriptionViewModel {
    static var templateModel: WeatherDescriptionViewModel {
        WeatherDescriptionViewModel(
            weatherIconName: "011",
            weatherIconLoader: nil,
            locationDescription: "No location info, CC",
            weatherDescription: .templateModel
        )
    }
}

extension WeatherDescriptionViewModel.WeatherDescription {
    static var templateModel: WeatherDescriptionViewModel.WeatherDescription{
        WeatherDescriptionViewModel.WeatherDescription(
            temperature: 0,
            temperatureUnit: .celsius,
            details: "No weather details"
        )
    }

}
