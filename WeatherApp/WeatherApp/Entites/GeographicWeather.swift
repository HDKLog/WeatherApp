//
//  GeographicWeather.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import Foundation

struct GeographicWeather: Codable {
    
    struct Weather: Codable {
        let id: Int64
        let main: String
        let description: String
        let icon: String
    }

    struct Parameters: Codable {
        let temperature: Double
        let feelsLike: Double
        let temperatureMinimum: Double
        let temperatureMaximum: Double
        let pressure: Double
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feels_like"
            case temperatureMinimum = "temp_min"
            case temperatureMaximum = "temp_max"
            case pressure = "pressure"
            case humidity = "humidity"
        }
    }

    struct Wind: Codable {
        let speed: Double
        let degrees: Int
        
        enum CodingKeys: String, CodingKey {
            case speed = "speed"
            case degrees = "deg"
        }
    }

    struct Clouds: Codable {
        let all: Int
    }

    struct System: Codable {
        let type: Int
        let id: Int64
        let country: String
        let sunrise: Int64
        let sunset: Int64
        
    }
    
    let coordinates: GeographicLocation
    let weather: [Weather]
    let base: String
    let main: Parameters
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let data: Int64
    let system: System
    let timezone: Int64
    let id: Int64
    let name: String
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weather = "weather"
        case base = "base"
        case main = "main"
        case visibility = "visibility"
        case wind = "wind"
        case clouds = "clouds"
        case data = "dt"
        case system = "sys"
        case timezone = "timezone"
        case id = "id"
        case name = "name"
        case code = "cod"
    }
}
