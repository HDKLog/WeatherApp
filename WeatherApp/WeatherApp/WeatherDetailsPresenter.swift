//
//  WeatherDetailsPresenter.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit
import CoreLocation

protocol WeatherDetailsPresentation {
    func viewDidLoad()
    func shareWether(with model: WeatherDescriptionViewModel?)
}

class WeatherDetailsPresenter: NSObject, WeatherDetailsPresentation {
    
    var view: WeatherDetailsView?
    var router: WeatherAppRoutering?
    
    let weatherAppUseCase: WeatherAppUseableCase?
    
    init(view: WeatherDetailsView?, router: WeatherAppRoutering?, weatherAppUseCase: WeatherAppUseableCase?) {
        self.view = view
        self.router = router
        self.weatherAppUseCase = weatherAppUseCase
    }
    
    func viewDidLoad() {
        loadWeather()
    }
    
    
    
    func shareWether(with model: WeatherDescriptionViewModel?) {
        view?.showSharePopUp(description: model)
    }
    
    private func loadGeograpicWeather(coordinates: GeographicLocation) {
        weatherAppUseCase?.getGeographicWeather(for: coordinates) { [weak self] result in
            switch result {
            case .success(let weatherEntity):
                self?.handle(entity:weatherEntity)
                
            case .failure(let error):
                self?.view?.displayError(error: error)
            }
        }
    }

    private func dataRequestForIcon(named name: String) -> WeatherDescriptionViewModel.DataRequest {

        WeatherDescriptionViewModel.DataRequest { [weak self] handler in
            self?.weatherAppUseCase?.getIcon(named: name) { [weak self] result in
                switch result {
                case .success(let data):
                    handler(data)
                case .failure(let error):
                    self?.view?.displayError(error: error)
                }
            }
        }
    }
    
    private func  handle(entity: GeographicWeather) {
        
        let parameters = [
            WeatherPropertyCellViewModel(property: WeatherPropertyCellViewModel.HumidityDescription(humidity: entity.main.humidity)),
            WeatherPropertyCellViewModel(property: WeatherPropertyCellViewModel.DewPointDescription(dewPoint: 0)),
            WeatherPropertyCellViewModel(property: WeatherPropertyCellViewModel.PressureDescription(pressure: entity.main.pressure)),
            WeatherPropertyCellViewModel(property: WeatherPropertyCellViewModel.SpeedDescription(speed: entity.wind.speed)),
            WeatherPropertyCellViewModel(property: WeatherPropertyCellViewModel.DirectionDescription(direction: entity.wind.degrees))
        ]
        
        let dataRequest = entity.weather.first.flatMap { self.dataRequestForIcon(named: $0.icon) }
        
        let firstDescription: String? = entity.weather.first?.description
        let details = firstDescription.flatMap { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }
        let description = WeatherDescriptionViewModel.WeatherDescription(temperature: Int(entity.main.temperature),
                                                                         temperatureUnit: .celsius,
                                                                         details: details)
        let weatherDescription = WeatherDescriptionViewModel(weatherImage: dataRequest,
                                                             locationDescription: "\(entity.name), \(entity.system.country)",
                                                             weatherDescription: description )
        let model = WeatherDetailsViewModel(title: "Today",
                                            weatherDescription: weatherDescription,
                                            wetherParameters: parameters)
        view?.configure(with: model)
    }
    
    private func loadWeather() {
        
        weatherAppUseCase?.getCurrentLocation {[weak self] result in
            switch result {
            case .success(let location):
                self?.loadGeograpicWeather(coordinates: location)
            case .failure(let error):
                self?.loadGeograpicWeather(coordinates:GeographicLocation.defaultCoordinates)
                self?.view?.displayError(error: error)
            }
        }
    }
}
