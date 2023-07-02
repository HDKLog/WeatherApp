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
        var wetherShareTriggered = false
        var viewDidLoaded = false
        func viewDidLoad() {
            viewDidLoaded = true
        }
        
        func shareWether() {
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

        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest { $0(Data()) },
                                                           locationDescription: nil,
                                                           weatherDescription: "a Weather Description")

        let sut = makeSut(descriptionViewModel: descriptionModel)
        
        XCTAssertEqual(sut.descriptionView.weatherDescriptionLabel.text, "a Weather Description")
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
    
    func test_viewController_renderWeatherDescriptionForPropertyCellViewModel() {

        let propertiesModel = [WeatherPropertyCellViewModel(icon: nil, description: "100Unit")]

        let sut = makeSut(propertiesViewModel: propertiesModel)
        sut.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.parametersView.dataSource
        let cell = dataSource?.collectionView(sut.parametersView, cellForItemAt: indexPath) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, "100Unit")
    }

    func test_viewController_renderWeatherDescriptionDirectionForPropertyCellViewModel() {

        let imageData = Data()
        let windDirection = WeatherPropertyCellViewModel.DirectionDescription(direction: Double.random(in: 011...349))
        let propertiesModel = [WeatherPropertyCellViewModel(icon: nil, description: windDirection)]
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
    
    func test_viewController_renderWeatherIconForPropertyCellViewModel() {

        let image = DesignBook.Image.Icon.Weather.Cloud.rain.uiImage()
        let propertiesModel = [WeatherPropertyCellViewModel(icon: image, description: "100Unit")]

        let sut = makeSut(propertiesViewModel: propertiesModel)
        sut.loadViewIfNeeded()

        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.parametersView.dataSource
        let cell = dataSource?.collectionView(sut.parametersView, cellForItemAt: indexPath) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.iconView.image?.pngData(), image.pngData())
    }
    
    func test_viewController_notRenderWeatherEmptyIconForPropertyCellViewModel() {

        let propertiesModel = [WeatherPropertyCellViewModel(icon: nil, description: "100Unit")]

        let sut = makeSut(propertiesViewModel: propertiesModel)
        sut.loadViewIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.parametersView.dataSource
        let cell = dataSource?.collectionView(sut.parametersView, cellForItemAt: indexPath) as? WeatherPropertyCollectionViewCell
        XCTAssertNil(cell?.iconView.image)
    }
    
    
    func test_viewController_triggerActionForShareButton() {

        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)

        sut.loadViewIfNeeded()
        sut.shareView.button.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(presenter.wetherShareTriggered)
    }
}
