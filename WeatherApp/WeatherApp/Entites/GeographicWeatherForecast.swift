//
//  GeographicWeatherForecast.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 31.08.21.
//

import Foundation

struct GeographicWeatherForecast: Codable {
    
    struct Forecast: Codable {
        struct Parameters: Codable {
            let temperature: Double
            let feelsLike: Double
            let temperatureMinimum: Double
            let temperatureMaximum: Double
            let pressure: Double
            let seaLevel: Double
            let groundLevel: Double
            let humidity: Int
            
            enum CodingKeys: String, CodingKey {
                case temperature = "temp"
                case feelsLike = "feels_like"
                case temperatureMinimum = "temp_min"
                case temperatureMaximum = "temp_max"
                case pressure = "pressure"
                case seaLevel = "sea_level"
                case groundLevel = "grnd_level"
                case humidity = "humidity"
            }
        }
        
        struct Weather: Codable {
            let id: Int64
            let main: String
            let description: String
            let icon: String
        }
        
        struct Clouds: Codable {
            let all: Int
        }
        
        struct Wind: Codable {
            let speed: Double
            let degrees: Int
            let gust: Double
            
            enum CodingKeys: String, CodingKey {
                case speed = "speed"
                case degrees = "deg"
                case gust = "gust"
            }
        }
        
        struct System: Codable {
            let partOfDay: String
            enum CodingKeys: String, CodingKey {
                case partOfDay = "pod"
            }
        }
        
        let dateTime: Double
        let main: Parameters
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let probabilityOfPrecipitation: Double
        let system: System
        let dateTimeText: String
        
        enum CodingKeys: String, CodingKey {
            case dateTime = "dt"
            case main = "main"
            case weather = "weather"
            case clouds = "clouds"
            case wind = "wind"
            case visibility = "visibility"
            case probabilityOfPrecipitation = "pop"
            case system = "sys"
            case dateTimeText = "dt_txt"
            
        }
    }
    
    struct City: Codable {
        
        let id: Int64
        let name: String
        let coord: GeographicLocation
        let country: String
        let population: Int
        let timezone: Int64
        let sunrise: Int64
        let sunset: Int64
    }
    
    let code: String
    let message: Int
    let count: Int
    let list: [Forecast]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message = "message"
        case count = "cnt"
        case list = "list"
        case city = "city"
    }
    
}
