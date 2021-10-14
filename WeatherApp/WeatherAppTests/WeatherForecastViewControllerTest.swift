//
//  WeatherForecastViewControllerTest.swift
//  WeatherAppTests
//
//  Created by Gari Sarkisiani on 14.10.21.
//

import XCTest
@testable import WeatherApp

class WeatherForecastViewControllerTest: XCTestCase {
    
    class DummyPresenter: WeatherForecastPresentation {
        var wetherShareTriggered = false
        var viewDidLoaded = false
        func viewDidLoad() {
            viewDidLoaded = true
        }
        
        func shareWether() {
            wetherShareTriggered = true
        }
        
        
    }

    func test_viewDidLoad_RenderTitle() {
        
        let sut = WeatherForecastViewController()
        
        let forecastViewModel: [WeatherForecastViewModel.Section] = []
        let model = WeatherForecastViewModel(title: "a title",
                                             sections: forecastViewModel)
        sut.configure(with: model)
        
        XCTAssertEqual(sut.titleLabel.text, "a title")
    }
    
    func test_viewController_triggerViewDidLoadAfterLoadingView() {
        
        let presenter = DummyPresenter()
        let sut = WeatherForecastViewController()
        sut.presenter = presenter
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoaded)
    }
    
    func test_viewController_doesNotRenderForWeatherForecastViewModelWithZeroWeatherForecastSections() {
        
        let sut = WeatherForecastViewController()
        
        let forecastViewModel: [WeatherForecastViewModel.Section] = []
        let model = WeatherForecastViewModel(title: "a title",
                                             sections: forecastViewModel)
        
        sut.loadViewIfNeeded()
        sut.configure(with: model)
        
        XCTAssertEqual(sut.tableView.numberOfSections, 0)
    }
    
    func test_viewController_doesNotRenderForWeatherForecastViewModelWithEmptyWeatherForecastSections() {
        
        let sut = WeatherForecastViewController()
        
        let emptySection = WeatherForecastViewModel.Section(title: "", rows: [])
        let forecastViewModel: [WeatherForecastViewModel.Section] = [emptySection]
        let model = WeatherForecastViewModel(title: "a title",
                                             sections: forecastViewModel)
        
        sut.loadViewIfNeeded()
        sut.configure(with: model)
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
}
