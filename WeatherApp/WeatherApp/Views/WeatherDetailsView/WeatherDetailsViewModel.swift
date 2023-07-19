//
//  WeatherDetailsViewModel.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 27.08.21.
//

import Foundation
import UIKit

struct WeatherDetailsViewModel {
    static var templateModel: WeatherDetailsViewModel  {
        WeatherDetailsViewModel(
            title: "Today",
            weatherDescription: .templateModel,
            wetherParameters: []
        )
    }
    let title: String?
    let weatherDescription: WeatherDescriptionViewModel?
    let wetherParameters: [WeatherPropertyCellViewModel]
}
