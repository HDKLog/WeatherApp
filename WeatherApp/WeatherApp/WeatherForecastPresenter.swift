//
//  WeatherForecastPresenter.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import Foundation

protocol WeatherForecastPresentation {
    func viewDidLoad()
}

class WeatherForecastPresenter: WeatherForecastPresentation {
    
    var view: WeatherForecastView!
    var router: WeatherAppRoutering!
    
    init(view: WeatherForecastView, router: WeatherAppRoutering) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        let model = WeatherForecastViewModel(title: "Meria, GE")
        view.configure(with: model)
    }
}
