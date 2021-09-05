//
//  OpenWeatherAPIQuery.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 05.09.21.
//

import Foundation

protocol OpenWeatherApiQuery {
    func getUrl() -> URL?
}
