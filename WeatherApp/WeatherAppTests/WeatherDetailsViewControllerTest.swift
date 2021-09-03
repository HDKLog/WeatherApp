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
        
        
        
        XCTAssertEqual(sut.titleLabel.text, "a title")
    }
}
