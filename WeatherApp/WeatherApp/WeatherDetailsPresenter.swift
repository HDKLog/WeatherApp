//
//  WeatherDetailsPresenter.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

protocol WeatherDetailsPresentation {
    func viewDidLoad()
    func shareWether()
}

class WeatherDetailsPresenter: WeatherDetailsPresentation {
    
    var view: WeatherDetailsView!
    var rooter: WeatherAppRoutering!
    
    init(view: WeatherDetailsView, rooter: WeatherAppRoutering) {
        self.view = view
        self.rooter = rooter
    }
    
    func viewDidLoad() {
        
        let parameters = [WeatherPropertyCellViewModel(icon: UIImage(named: "icon-weather-4-cloud-rain"), description: "49%"),
                          WeatherPropertyCellViewModel(icon: UIImage(named: "icon-weather-63-raindrop"), description: "-"),
                          WeatherPropertyCellViewModel(icon: UIImage(named: "icon-weather-100-pressure-reading"), description: "1032 hPa"),
                          WeatherPropertyCellViewModel(icon: UIImage(named: "icon-weather-13-cloud-wind"), description: "3.6 km/h"),
                          WeatherPropertyCellViewModel(icon: UIImage(named: "icon-weather-90-compass"), description: "S")]
        
        let weatherDescription = WeatherDescriptionViewModel(weatherImage: nil,
                                                             locationDescription: "Meria, GE",
                                                             weatherDescription: "20^ | Clear Sky")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: weatherDescription,
                                            wetherParameters: parameters)
        view.configure(with: model)
    }
    
    func shareWether() {
    }
}
