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
    func shareWether()
}

class WeatherDetailsPresenter: NSObject, WeatherDetailsPresentation {
    
    var view: WeatherDetailsView?
    var router: WeatherAppRoutering?
    
    let weatherAppUseCase: WeatherAppUseableCase?
    
    var weatherDescription: WeatherDescriptionViewModel?
    
    init(view: WeatherDetailsView?, router: WeatherAppRoutering?, weatherAppUseCase: WeatherAppUseableCase?) {
        self.view = view
        self.router = router
        self.weatherAppUseCase = weatherAppUseCase
    }
    
    func viewDidLoad() {
        loadWeather()
    }
    
    
    
    func shareWether() {
        view?.showSharePopUp(description: weatherDescription)
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
            WeatherPropertyCellViewModel(
                icon: DesignBook.Image.Icon.Weather.Cloud.rain.uiImage(),
                description: "\(entity.main.humidity)%"
            ),
            WeatherPropertyCellViewModel(
                icon: DesignBook.Image.Icon.Weather.raindrop.uiImage(),
                description: "-"
            ),
            WeatherPropertyCellViewModel(
                icon: DesignBook.Image.Icon.Weather.Pressure.reading.uiImage(),
                description: "\(entity.main.pressure) hPa"
            ),
            WeatherPropertyCellViewModel(
                icon: DesignBook.Image.Icon.Weather.Pressure.reading.uiImage(),
                description: "\(entity.wind.speed) km/h"
            ),
            WeatherPropertyCellViewModel(
                icon: DesignBook.Image.Icon.Weather.compass.uiImage(),
                description: WeatherPropertyCellViewModel.DirectionDescription(direction: entity.wind.degrees)
            )
        ]
        
        let dataRequest = entity.weather.first.flatMap { self.dataRequestForIcon(named: $0.icon) }
        
        let firstDescription = entity.weather.first?.description ?? "-"
        let description = firstDescription.prefix(1).uppercased() + firstDescription.dropFirst()
        weatherDescription = WeatherDescriptionViewModel(weatherImage: dataRequest,
                                                             locationDescription: "\(entity.name), \(entity.system.country)",
                                                             weatherDescription: "\(Int(entity.main.temperature))° | \(description)")
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

extension WeatherDetailsPresenter : CLLocationManagerDelegate {
    
}
