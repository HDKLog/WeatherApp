//
//  WeatherForecastPresenter.swift
//  WeatherApp
//
//  Created by Gari Sarkisiani on 30.08.21.
//

import UIKit

protocol WeatherForecastPresentation {
    func viewDidLoad()
}

class WeatherForecastPresenter: WeatherForecastPresentation {
    
    var view: WeatherForecastView!
    var router: WeatherAppRoutering!
    
    let weatherForecastUseCase = WeatherForecastUseCase()
    let weatherIconUseCases = WeatherAppIconsUseCase()
    let locationUsecase = WeatherAppLocationUseCase()
    
    init(view: WeatherForecastView, router: WeatherAppRoutering) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        
        loadForecast()
    }
    
    func handleResult(entity: GeographicWeatherForecast) {
        
        let rows: [WeatherForecastViewModel.Section] = entity.list.map {
            
            let imageName = $0.weather.first!.icon
            let dataRequest = WeatherForecastTableViewCellModel.DataRequest { [weak self] handler in
                
                self?.weatherIconUseCases.getIcon(named: imageName) { [weak self]result in
                    switch result {
                    case .success(let data):
                        handler(data)
                    case .failure(let error):
                        self?.view.displayError(error: error)
                    }
                }
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "HH:mm"
            
            let date = Date(timeIntervalSince1970: $0.dateTime)
            let description = $0.weather.first?.description ?? ""
            let normalizedDescription = description.prefix(1).uppercased() + description.dropFirst()
            let rowModel = WeatherForecastTableViewCellModel(image: dataRequest,
                                                             time: dateFormatter.string(from: date),
                                                             description: normalizedDescription,
                                                             temperature: "\(Int($0.main.temperature))°")
            dateFormatter.dateFormat = "EEEE"
            let timeString = dateFormatter.string(from: date)
            return WeatherForecastViewModel.Section(title: timeString.uppercased(), rows: [rowModel])
        }
        
        let sections = rows.reduce(into: [WeatherForecastViewModel.Section]()) { result, section in
            if let index = result.firstIndex(where: {  $0.title == section.title}) {
                let existingSection = result[index]
                var rows = existingSection.rows
                rows.append(contentsOf: section.rows)
                result[index] = WeatherForecastViewModel.Section(title: existingSection.title , rows: rows)
            } else {
                result.append(section)
            }
        }
        
        let model = WeatherForecastViewModel(title: "\(entity.city.name), \(entity.city.country)",
                                             sections: sections)
        view.configure(with: model)
        view.reloadList()
    }
    
    private func loadGeograpicWeather(coordinates: GeographicLocation) {
        weatherForecastUseCase.getGeographicWeather(for: coordinates) { [weak self] result in
            switch result {
            case .success(let entity):
                self?.handleResult(entity: entity)
            case .failure(let error):
                self?.view.displayError(error: error)
            }
        }
    }
    
    private func loadForecast() {
        
        locationUsecase.getCurrentLocation {[weak self] result in
            switch result {
            case .success(let location):
                self?.loadGeograpicWeather(coordinates: location)
            case .failure(let error):
                self?.loadGeograpicWeather(coordinates: GeographicLocation.defaultCoordinates)
                self?.view.displayError(error: error)
            }
        }
    }
}
