//
//  WeatherForecastViewControllerTest.swift
//  WeatherAppTests
//
//  Created by Gari Sarkisiani on 14.10.21.
//

import XCTest
@testable import WeatherApp

class WeatherForecastViewControllerTest: XCTestCase {
    
    class Presenter: WeatherForecastPresentation {
        var viewDidLoaded = false
        func viewDidLoad() {
            viewDidLoaded = true
        }
    }

    func makeSut(title: String? = nil,
                 sections: [WeatherForecastViewModel.Section] = [],
                 presenter: WeatherForecastPresentation? = nil) -> WeatherForecastViewController {

        let sut = WeatherForecastViewController()
        let model = WeatherForecastViewModel(title: title, sections: sections)
        sut.configure(with: model)
        sut.presenter = presenter
        return sut
    }

    func test_viewDidLoad_RenderTitle() {
        
        let sut = makeSut(title: "a title")
        
        XCTAssertEqual(sut.titleLabel.text, "a title")
    }
    
    func test_viewController_triggerViewDidLoadAfterLoadingView() {
        
        let presenter = Presenter()
        let sut = makeSut(presenter: presenter)
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoaded)
    }

    func test_viewController_hasCellsForecastViewModelWithWeatherForecastSectionsRows() {

        let dataRequest = WeatherForecastTableViewCellModel.DataRequest { $0(Data()) }
        let tableViewCellModel = WeatherForecastTableViewCellModel(image: dataRequest, time: nil, description: nil, temperature: nil)
        let rows = [tableViewCellModel, tableViewCellModel]
        let emptySection = WeatherForecastViewModel.Section(title: nil, rows: rows)
        let sut = makeSut(sections: [emptySection])

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
    }

    func test_viewController_renderForWeatherForecastViewModelWithWeatherForecastSectionsRowsCell() {

        let imageData = DesignBook.Image.Icon.Weather.Cloud.wind.uiImage().pngData()!
        let dataRequest = WeatherForecastTableViewCellModel.DataRequest { $0(imageData) }
        let tableViewCellModel = WeatherForecastTableViewCellModel(image: dataRequest, time: "16:00", description: "description", temperature: "15")
        let rows = [tableViewCellModel, tableViewCellModel]
        let emptySection = WeatherForecastViewModel.Section(title: nil, rows: rows)
        let sut = makeSut(sections: [emptySection])

        sut.loadViewIfNeeded()

        let indexPath = IndexPath(row: 0, section: 0)
        let dataSource = sut.tableView.dataSource
        let cell = dataSource?.tableView(sut.tableView, cellForRowAt: indexPath) as? WeatherForecastTableViewCell
        XCTAssertNotNil(cell?.weatherImageView.image)
        XCTAssertEqual(cell?.timeLabel.text, "16:00")
        XCTAssertEqual(cell?.descriptionLabel.text, "description")
        XCTAssertEqual(cell?.temperatureLabel.text, "15")
    }
    
    func test_viewController_doesNotRenderForWeatherForecastViewModelWithZeroWeatherForecastSections() {
        
        let sut = makeSut()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfSections, 0)
    }
    
    func test_viewController_doesNotRenderForWeatherForecastViewModelWithEmptyWeatherForecastSections() {

        let emptySection = WeatherForecastViewModel.Section(title: "", rows: [])
        let sut = makeSut(sections: [emptySection])
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
}
