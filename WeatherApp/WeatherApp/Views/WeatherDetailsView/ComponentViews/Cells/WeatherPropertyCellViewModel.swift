//
//  WeatherPropertyCellViewModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 29.08.21.
//

import UIKit

struct WeatherPropertyCellViewModel {
    static let resuableId = "WeatherPropertyCell"
    let property: WeatherProperty
}

protocol WeatherProperty: CustomStringConvertible {
    var icon: UIImage? { get }
}

extension WeatherPropertyCellViewModel {

    struct DewPointDescription: WeatherProperty {
        let dewPoint: Int
        var icon: UIImage? { DesignBook.Image.Icon.Weather.raindrop.uiImage() }
        var description: String { "\(dewPoint)°C" }
    }

    struct HumidityDescription: WeatherProperty {
        let humidity: Int
        var icon: UIImage? { DesignBook.Image.Icon.Weather.Cloud.rain.uiImage() }
        var description: String { "\(humidity)%" }
    }

    struct PressureDescription: WeatherProperty {
        let pressure: Double
        var icon: UIImage? { DesignBook.Image.Icon.Weather.Pressure.reading.uiImage() }
        var description: String { "\(pressure) hPa" }
    }

    struct SpeedDescription: WeatherProperty {
        let speed: Double
        var icon: UIImage? { DesignBook.Image.Icon.Weather.Cloud.wind.uiImage() }
        var description: String { "\(speed) km/h" }
    }

    struct DirectionDescription: WeatherProperty {
        let direction: Double
        var icon: UIImage? { DesignBook.Image.Icon.Weather.compass.uiImage() }
        var description: String {
            if (011...349).contains(direction) {
                return "N"
            } else if (012...033).contains(direction) {
                return "NNE"
            } else if (034...056).contains(direction) {
                return "NE"
            } else if (057...078).contains(direction) {
                return "ENE"
            } else if (079...101).contains(direction) {
                return "E"
            } else if (102...123).contains(direction) {
                return "ESE"
            } else if (124...146).contains(direction) {
                return "SE"
            } else if (147...168).contains(direction) {
                return "SSE"
            }else if (169...191).contains(direction) {
                return "S"
            }else if (192...213).contains(direction) {
                return "SSW"
            }else if (214...236).contains(direction) {
                return "SW"
            }else if (237...258).contains(direction) {
                return "WSW"
            }else if (259...281).contains(direction) {
                return "W"
            }else if (282...303).contains(direction) {
                return "WNW"
            }else if (304...326).contains(direction) {
                return "NW"
            }else if (327...348).contains(direction) {
                return "NNW"
            } else {
                return "-"
            }
        }
    }
}
