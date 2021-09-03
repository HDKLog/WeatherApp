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
    var router: WeatherAppRoutering!
    
    let weatherDetailUseCase = WeatherDetailsUseCase()
    let weatherAppIconsUseCase = WeatherAppIconsUseCase()
    
    init(view: WeatherDetailsView, router: WeatherAppRoutering) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        
        let coordinates = GeographicWeather.Coordinates(latitude: 41.695014, longitude: 44.830604)
        weatherDetailUseCase.getGeographicWeather(for: coordinates) { [weak self]result in
            switch result {
            case .success(let weatherEntity):
                self?.handle(entity:weatherEntity)
                
            case .failure(let error):
                self?.view.displayError(error: error)
            }
        }
    }
    
    func  handle(entity: GeographicWeather) {
        
        let parameters = [WeatherPropertyCellViewModel(icon: DesignBook.Image.Icon.cloudRain.uiImage(),
                                                       description: "\(entity.main.humidity)%"),
                          WeatherPropertyCellViewModel(icon: DesignBook.Image.Icon.raindrop.uiImage(),
                                                       description: "-"),
                          WeatherPropertyCellViewModel(icon: DesignBook.Image.Icon.pressureReading.uiImage(),
                                                       description: "\(entity.main.pressure) hPa"),
                          WeatherPropertyCellViewModel(icon: DesignBook.Image.Icon.cloudWind.uiImage(),
                                                       description: "\(entity.wind.speed) km/h"),
                          WeatherPropertyCellViewModel(icon: DesignBook.Image.Icon.compass.uiImage(),
                                                       description: "\(entity.wind.degrees)")]
        
        weatherAppIconsUseCase.getIcon(named: entity.weather.first?.icon ?? "" ) {[weak self] result in
            
            var image: UIImage?
            switch result {
            case .success(let data):
                image = UIImage(data: data)
            case .failure(let error):
                self?.view.displayError(error: error)
            }
            
            let firstDescription = entity.weather.first?.description ?? "-"
            let description = firstDescription.prefix(1).uppercased() + firstDescription.dropFirst()
            let weatherDescription = WeatherDescriptionViewModel(weatherImage: image,
                                                                 locationDescription: "\(entity.name), \(entity.system.country)",
                                                                 weatherDescription: "\(Int(entity.main.temperature))° | \(description)")
            let model = WeatherDetailsViewModel(title: "Today",
                                                weatherDescription: weatherDescription,
                                                wetherParameters: parameters)
            self?.view.configure(with: model)
            
        }
    }
    
    func shareWether() {
    }
}
