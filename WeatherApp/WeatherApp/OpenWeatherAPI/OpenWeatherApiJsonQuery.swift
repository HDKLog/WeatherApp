//
//  OpenWeatherApiJsonQuery.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 05.09.21.
//

import Foundation

class OpenWeatherApiJsonQuery: OpenWeatherApiQuery {
    
    enum QueryType: String {
        case Weather = "weather"
        case Forecast = "forecast"
    }
    
    enum Unit: String {
        case standard = "standard"
        case metric = "metric"
        case imperia = "imperia"
    }
    
    static let token = "e9826ddefc1718ac6962acbfc2e4838e"
    static let apiUrl = "https://api.openweathermap.org/data/2.5/"
    
    var parameters: [String: String] = [:]
    var type: QueryType
    
    init(type: QueryType) {
        self.type = type
        parameters["appid"] = OpenWeatherApiJsonQuery.token
    }
    
    func withLocation(latitude: Double, longitude: Double) -> OpenWeatherApiJsonQuery {
        parameters["lat"] = "\(latitude)"
        parameters["lon"] = "\(longitude)"
        return self
    }
    
    func withUnits(unit: Unit) -> OpenWeatherApiJsonQuery {
        parameters["unit"] = unit.rawValue
        return self
    }
    
    func getUrl() -> URL? {
        let paramStr = parameters.map { $0.0 + "=" + $0.1 }.joined(separator: "&")
        let urlString = OpenWeatherApiJsonQuery.apiUrl + type.rawValue + "?" + paramStr
        return URL(string: urlString)
    }
}
