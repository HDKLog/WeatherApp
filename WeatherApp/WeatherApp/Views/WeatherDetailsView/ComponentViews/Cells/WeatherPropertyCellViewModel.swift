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
    
    init(icon: UIImage?, description: String?) {
        self.icon = icon
        self.description = description
    }
    
    init(icon: UIImage?, direction: Double?) {
        self.icon = icon
        
        guard let direction = direction else {
            self.description = "-"
            return
        }
        
        if (011...349).contains(direction) {
            self.description = "N"
        } else if (012...033).contains(direction) {
            self.description = "NNE"
        } else if (034...056).contains(direction) {
            self.description = "NE"
        } else if (057...078).contains(direction) {
            self.description = "ENE"
        } else if (079...101).contains(direction) {
            self.description = "E"
        } else if (102...123).contains(direction) {
            self.description = "ESE"
        } else if (124...146).contains(direction) {
            self.description = "SE"
        } else if (147...168).contains(direction) {
            self.description = "SSE"
        }else if (169...191).contains(direction) {
            self.description = "S"
        }else if (192...213).contains(direction) {
            self.description = "SSW"
        }else if (214...236).contains(direction) {
            self.description = "SW"
        }else if (237...258).contains(direction) {
            self.description = "WSW"
        }else if (259...281).contains(direction) {
            self.description = "W"
        }else if (282...303).contains(direction) {
            self.description = "WNW"
        }else if (304...326).contains(direction) {
            self.description = "NW"
        }else if (327...348).contains(direction) {
            self.description = "NNW"
        } else {
            self.description = "-"
        }
    }
}
