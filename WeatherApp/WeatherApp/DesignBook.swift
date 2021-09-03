//
//  DesignBook.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 01.09.21.
//

import UIKit

struct DesignBook {
    struct Image {
        struct ImageWrapper {
            let name: String
            func uiImage() -> UIImage {
                return UIImage(named: name)!
            }
        }
        
        struct Icon {
            static let cloudRain = ImageWrapper(name: "icon-weather-4-cloud-rain")
            static let raindrop = ImageWrapper(name: "icon-weather-63-raindrop")
            static let pressureReading = ImageWrapper(name: "icon-weather-100-pressure-reading")
            static let cloudWind = ImageWrapper(name: "icon-weather-13-cloud-wind")
            static let compass = ImageWrapper(name: "icon-weather-90-compass")
        }
    }
    
    struct Color {
        struct ColorWrapper {
            let name: String
            func uiColor() -> UIColor {
                return UIColor(named: name)!
            }
        }
        
        struct Background {
            static let main = ColorWrapper(name: "color-background-main")
            static let list = ColorWrapper(name: "color-background-list")
        }
        
        struct Foreground {
            static let highlited = ColorWrapper(name: "color-foreground-highlited")
            static let action = ColorWrapper(name: "color-foreground-action")
            static let element = ColorWrapper(name: "color-foreground-element")
            static let inverse = ColorWrapper(name: "color-foreground-inverse")
        }
    }
}
