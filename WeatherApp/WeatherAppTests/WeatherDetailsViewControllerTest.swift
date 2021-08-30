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
        
        let model = WeatherDetailsViewModel(title: "a title",
                                            locationDescription: "a description",
                                            wetherDescription: "a weather",
                                            wetherParameters: [])
        sut.configure(with: model)
        
        XCTAssertEqual(sut.titleLabel.text, "a title")
    }
    
    func test_viewController_renderLocationDescriptionForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let model = WeatherDetailsViewModel(title: "a title",
                                            locationDescription: "a description",
                                            wetherDescription: "a weather",
                                            wetherParameters: [])
        sut.configure(with: model)
        
        XCTAssertEqual(sut.locationDescriptionLabel.text, "a description")
    }
    
    func test_viewController_renderWeatherDescriptionForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let model = WeatherDetailsViewModel(title: "a title",
                                            locationDescription: "a description",
                                            wetherDescription: "a weather",
                                            wetherParameters: [])
        sut.configure(with: model)
        
        XCTAssertEqual(sut.weatherDescriptionLabel.text, "a weather")
    }

}
