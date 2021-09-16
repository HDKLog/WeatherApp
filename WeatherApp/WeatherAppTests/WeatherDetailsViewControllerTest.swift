//
//  WeatherDetailsViewControllerTest.swift
//  WeatherAppTests
//
//  Created by Gari Sarkisiani on 27.08.21.
//

import XCTest

@testable import WeatherApp
class WeatherDetailsViewControllerTest: XCTestCase {
    
    func test_viewController_renderTitleForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let propertiesModel: [WeatherPropertyCellViewModel] = []
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest(requestClouser: {_ in }),
                                                           locationDescription: "",
                                                           weatherDescription: "")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.configure(with: model)
        
        XCTAssertEqual(sut.titleLabel.text, "a title")
    }
    
    func test_viewController_renderLocationDescriptionForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let propertiesModel: [WeatherPropertyCellViewModel] = []
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest(requestClouser: {_ in }),
                                                           locationDescription: "a Loction Description",
                                                           weatherDescription: "")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.configure(with: model)
        
        XCTAssertEqual(sut.descriptionView.locationDescriptionLabel.text, "a Loction Description")
    }
    
    func test_viewController_renderWeatherDescriptionForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let propertiesModel: [WeatherPropertyCellViewModel] = []
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: WeatherDescriptionViewModel.DataRequest(requestClouser: {_ in }),
                                                           locationDescription: "a Loction Description",
                                                           weatherDescription: "a Weather Description")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.configure(with: model)
        
        XCTAssertEqual(sut.descriptionView.weatherDescriptionLabel.text, "a Weather Description")
    }
    
    func test_viewController_renderWeatherImageForViewModel() {
        
        let sut = WeatherDetailsViewController()
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest { handler in
            let image = DesignBook.Image.Icon.cloudRain.uiImage()
            handler(image.pngData()!)
        }
        let propertiesModel: [WeatherPropertyCellViewModel] = []
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: dataRequest,
                                                           locationDescription: "a Loction Description",
                                                           weatherDescription: "a Weather Description")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.configure(with: model)
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.descriptionView.weatherImage.image != nil)
    }
}
