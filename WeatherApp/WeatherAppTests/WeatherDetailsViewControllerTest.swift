//
//  WeatherDetailsViewControllerTest.swift
//  WeatherAppTests
//
//  Created by Gari Sarkisiani on 27.08.21.
//

import XCTest

@testable import WeatherApp
class WeatherDetailsViewControllerTest: XCTestCase {
    
    class Presenter: WeatherDetailsPresentation {

        var viewDidLoaded = false
        func viewDidLoad() {
            viewDidLoaded = true
        }
        var wetherShareTriggered = false
        var shareWetherCalls: Int = 0
        var shareWetherModels: [WeatherDescriptionViewModel] = []
        func shareWether(with model: WeatherDescriptionViewModel?) {
            wetherShareTriggered = true
        }
    }

    func makeSut(descriptionViewModel: WeatherDescriptionViewModel? = nil,
                 title: String? = nil,
                 propertiesViewModel: [WeatherPropertyCellViewModel] = [],
                 presenter: WeatherDetailsPresentation? = nil) -> WeatherDetailsViewController {

        let model = WeatherDetailsViewModel(title: title,
                                            weatherDescription: descriptionViewModel,
                                            wetherParameters: propertiesViewModel)

        let sut = WeatherDetailsViewController()
        sut.presenter = presenter

        sut.configure(with: model)
        return sut
    }
    
    func test_viewController_renderTitleForViewModel() {
        
        let imageData = Data()
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest { $0(imageData) },
                                                           locationDescription: nil,
                                                           weatherDescription: nil)

        let sut = makeSut(descriptionViewModel: descriptionModel, title: "a title")
        
        XCTAssertEqual(sut.titleLabel.text, "a title")
    }
    
    func test_viewController_triggerViewDidLoadAfterLoadingView() {
        
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoaded)
    }
    
    func test_viewController_renderLocationDescriptionForViewModel() {

        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest { $0(Data()) },
                                                           locationDescription: "a Loction Description",
                                                           weatherDescription: nil)

        let sut = makeSut(descriptionViewModel: descriptionModel)
        
        XCTAssertEqual(sut.descriptionView.locationDescriptionLabel.text, "a Loction Description")
    }
    
    func test_viewController_renderWeatherDescriptionForViewModel() {

        let weatherDescription = WeatherDescriptionViewModel.WeatherDescription(temperature: 1,
                                                                                temperatureUnit: .celsius,
                                                                                details: "a Weather Details")
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest { $0(Data()) },
                                                           locationDescription: nil,
                                                           weatherDescription: weatherDescription)

        let sut = makeSut(descriptionViewModel: descriptionModel)
        
        XCTAssertEqual(sut.descriptionView.weatherDescriptionLabel.text, weatherDescription.description)
    }
    
    func test_viewController_renderWeatherImageForViewModel() {
        
        let imageData = DesignBook.Image.Icon.Weather.Cloud.rain.uiImage().pngData()!
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest { $0(imageData) },
                                                           locationDescription: nil,
                                                           weatherDescription: nil)

        let sut = makeSut(descriptionViewModel: descriptionModel)
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.descriptionView.weatherImage.image)
    }
    
    func test_viewController_notRenderInvalidWeatherImageForViewModel() {

        let imageData = Data()
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest { $0(imageData) },
                                                           locationDescription: nil,
                                                           weatherDescription: nil)

        let sut = makeSut(descriptionViewModel: descriptionModel)
        sut.loadViewIfNeeded()
        
        XCTAssertNil(sut.descriptionView.weatherImage.image)
    }

    func test_viewController_renderWeatherDescriptionForPropertyDewPointCellViewModel() {

        let value = Int.random(in: 0...100)
        let dewPoint = WeatherPropertyCellViewModel.DewPointDescription(dewPoint: value)
        let propertiesModel = [WeatherPropertyCellViewModel(property: dewPoint)]

        let sut = makeSut(propertiesViewModel: propertiesModel)
        sut.loadViewIfNeeded()

        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.parametersView.dataSource
        let cell = dataSource?.collectionView(sut.parametersView, cellForItemAt: indexPath) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, "\(value)°C")
    }

    func test_viewController_renderWeatherDescriptionForPropertyHumidityCellViewModel() {

        let value = Int.random(in: 0...100)
        let dewPoint = WeatherPropertyCellViewModel.HumidityDescription(humidity: value)
        let propertiesModel = [WeatherPropertyCellViewModel(property: dewPoint)]

        let sut = makeSut(propertiesViewModel: propertiesModel)
        sut.loadViewIfNeeded()

        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.parametersView.dataSource
        let cell = dataSource?.collectionView(sut.parametersView, cellForItemAt: indexPath) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, "\(value)%")
    }
    
    func test_viewController_renderWeatherDescriptionForPropertyPressureCellViewModel() {

        let value = Double.random(in: 0...100)
        let pressure = WeatherPropertyCellViewModel.PressureDescription(pressure: value)
        let propertiesModel = [WeatherPropertyCellViewModel(property: pressure)]

        let sut = makeSut(propertiesViewModel: propertiesModel)
        sut.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.parametersView.dataSource
        let cell = dataSource?.collectionView(sut.parametersView, cellForItemAt: indexPath) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, "\(value) hPa")
    }

    func test_viewController_renderWeatherDescriptionForPropertySpeedCellViewModel() {

        let value = Double.random(in: 0...100)
        let pressure = WeatherPropertyCellViewModel.SpeedDescription(speed: value)
        let propertiesModel = [WeatherPropertyCellViewModel(property: pressure)]

        let sut = makeSut(propertiesViewModel: propertiesModel)
        sut.loadViewIfNeeded()

        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.parametersView.dataSource
        let cell = dataSource?.collectionView(sut.parametersView, cellForItemAt: indexPath) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, "\(value) km/h")
    }

    func test_viewController_renderWeatherDescriptionDirectionForPropertyCellViewModel() {

        let imageData = Data()
        let value = Double.random(in: 011...349)
        let direction =  WeatherPropertyCellViewModel.DirectionDescription(direction: value)
        let propertiesModel = [WeatherPropertyCellViewModel(property: direction)]
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest { $0(imageData) },
                                                           locationDescription: nil,
                                                           weatherDescription: nil)

        let sut = makeSut(descriptionViewModel: descriptionModel,
                          propertiesViewModel: propertiesModel)
        sut.loadViewIfNeeded()

        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.parametersView.dataSource
        let cell = dataSource?.collectionView(sut.parametersView, cellForItemAt: indexPath) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, "N")
    }
    
    func test_viewController_triggerActionForShareButton() {

        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.loadViewIfNeeded()
        sut.shareView.button.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(presenter.wetherShareTriggered)
    }
}
