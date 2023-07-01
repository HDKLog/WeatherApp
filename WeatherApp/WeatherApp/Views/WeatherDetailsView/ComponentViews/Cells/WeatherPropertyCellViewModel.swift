//
//  WeatherPropertyCellViewModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 29.08.21.
//

import UIKit

struct WeatherPropertyCellViewModel {
    static let resuableId = "WeatherPropertyCell"
    let icon: UIImage?
    let description: String?
    
    init(icon: UIImage?, description: CustomStringConvertible?) {
        self.icon = icon
        self.description = description?.description
    }
}

extension WeatherPropertyCellViewModel {
    struct DirectionDescription: CustomStringConvertible {
        let direction: Double
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
