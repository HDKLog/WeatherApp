//
//  OpenWeatherApiJsonQuery.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 05.09.21.
//

import Foundation

class OpenWeatherApiJsonQuery: OpenWeatherApiQuery {
    
    enum QueryType: String {
        case weather = "weather"
        case forecast = "forecast"
    }
    
    enum Unit: String {
        case standard = "standard"
        case metric = "metric"
        case imperia = "imperia"
    }
    
    static let token = "e9826ddefc1718ac6962acbfc2e4838e"
    static let version = "2.5"
    static let apiUrl = "https://api.openweathermap.org/data/\(version)/"
    
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
        parameters["units"] = unit.rawValue
        return self
    }
    
    func getUrl() -> URL? {
        let paramStr = parameters.map { $0.0 + "=" + $0.1 }.joined(separator: "&")
        let urlString = OpenWeatherApiJsonQuery.apiUrl + type.rawValue + "?" + paramStr
        return URL(string: urlString)
    }
}
