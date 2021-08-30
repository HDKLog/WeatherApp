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
        
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: nil,
                                                           locationDescription: "a description",
                                                           weatherDescription: "a weather")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: [])
        sut.configure(with: model)
        
        XCTAssertEqual(sut.titleLabel.text, "a title")
    }
    
    func test_viewController_renderLocationDescriptionForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: nil,
                                                           locationDescription: "a description",
                                                           weatherDescription: "a weather")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: [])
        sut.configure(with: model)
        
        XCTAssertEqual(sut.descriptionView.locationDescriptionLabel.text, "a description")
    }
    
    func test_viewController_renderWeatherDescriptionForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: nil,
                                                           locationDescription: "a description",
                                                           weatherDescription: "a weather")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: [])
        sut.configure(with: model)
        
        XCTAssertEqual(sut.descriptionView.weatherDescriptionLabel.text, "a weather")
    }

}
