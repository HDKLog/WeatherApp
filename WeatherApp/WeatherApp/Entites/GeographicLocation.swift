//
//  GeographicLocation.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 03.09.21.
//

import Foundation

struct GeographicLocation: Codable, Equatable {
    static let defaultCoordinates = GeographicLocation(latitude: 41.695014, longitude: 44.830604)
    
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lon"
        case longitude = "lat"
    }
}
