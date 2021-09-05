//
//  OpenWeatherApiFileQuery.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 05.09.21.
//

import Foundation

class OpenWeatherApiFileQuery: OpenWeatherApiQuery {
    
    enum SuffixType: String {
        case x2 = "@2x"
    }
    
    enum Extention: String {
        case png = "png"
    }
    
    static let apiUrl = "https://openweathermap.org/img/wn/"
    
    var extention: Extention
    var suffixType: SuffixType
    var fileName: String = ""
    
    init(type: SuffixType, extention: Extention) {
        self.suffixType = type
        self.extention = extention
    }
    
    func withFileName(name: String) -> OpenWeatherApiFileQuery {
        fileName = name
        return self
    }
    
    func getUrl() -> URL? {
        let urlString = OpenWeatherApiFileQuery.apiUrl + fileName + suffixType.rawValue + "." + extention.rawValue
        return URL(string: urlString)
    }
}
