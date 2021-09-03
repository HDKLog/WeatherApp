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
}
