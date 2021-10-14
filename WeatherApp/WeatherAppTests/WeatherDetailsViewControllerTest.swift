//
//  WeatherDetailsViewControllerTest.swift
//  WeatherAppTests
//
//  Created by Gari Sarkisiani on 27.08.21.
//

import XCTest

@testable import WeatherApp
class WeatherDetailsViewControllerTest: XCTestCase {
    
    class DummyPresenter: WeatherDetailsPresentation {
        var wetherShareTriggered = false
        var viewDidLoaded = false
        func viewDidLoad() {
            viewDidLoaded = true
        }
        
        func shareWether() {
            wetherShareTriggered = true
        }
        
        
    }
    
    func test_viewController_renderTitleForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest(requestClouser: {_ in })
        let propertiesModel: [WeatherPropertyCellViewModel] = []
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: dataRequest,
                                                           locationDescription: "",
                                                           weatherDescription: "")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.configure(with: model)
        
        XCTAssertEqual(sut.titleLabel.text, "a title")
    }
    
    func test_viewController_triggerViewDidLoadAfterLoadingView() {
        
        let presenter = DummyPresenter()
        let sut = WeatherDetailsViewController()
        sut.presenter = presenter
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoaded)
    }
    
    func test_viewController_renderLocationDescriptionForViewModel() {
        let sut = WeatherDetailsViewController()
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest(requestClouser: {_ in })
        let propertiesModel: [WeatherPropertyCellViewModel] = []
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: dataRequest,
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
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest(requestClouser: {_ in })
        let propertiesModel: [WeatherPropertyCellViewModel] = []
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: dataRequest,
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
    
    func test_viewController_notRenderInvalidWeatherImageForViewModel() {
        
        let sut = WeatherDetailsViewController()
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest { handler in
            handler(Data())
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
        
        XCTAssertTrue(sut.descriptionView.weatherImage.image == nil)
    }
    
    func test_viewController_renderWeatherDescriptionForPropertyCellViewModel() {
        
        let sut = WeatherDetailsViewController()
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest { handler in
            handler(Data())
        }
        let propertiesModel: [WeatherPropertyCellViewModel] = [WeatherPropertyCellViewModel(icon: nil, description: "100Unit")]
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: dataRequest,
                                                           locationDescription: "a Loction Description",
                                                           weatherDescription: "a Weather Description")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.loadViewIfNeeded()
        sut.configure(with: model)
        
        let cell = sut.parametersView.dataSource?.collectionView(sut.parametersView, cellForItemAt: IndexPath(row: 0, section: 0)) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, "100Unit")
    }
    
    func test_viewController_renderWeatherIconForPropertyCellViewModel() {
        
        let sut = WeatherDetailsViewController()
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest { handler in
            handler(Data())
        }
        let image = DesignBook.Image.Icon.cloudRain.uiImage()
        let propertiesModel: [WeatherPropertyCellViewModel] = [WeatherPropertyCellViewModel(icon: image, description: "100Unit")]
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: dataRequest,
                                                           locationDescription: "a Loction Description",
                                                           weatherDescription: "a Weather Description")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.loadViewIfNeeded()
        sut.configure(with: model)
        
        let cell = sut.parametersView.dataSource?.collectionView(sut.parametersView, cellForItemAt: IndexPath(row: 0, section: 0)) as? WeatherPropertyCollectionViewCell
        XCTAssertNotEqual(cell?.iconView.image, nil)
    }
    
    func test_viewController_notRenderWeatherIconForPropertyCellViewModel() {
        
        let sut = WeatherDetailsViewController()
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest { handler in
            handler(Data())
        }
        let propertiesModel: [WeatherPropertyCellViewModel] = [WeatherPropertyCellViewModel(icon: nil, description: "100Unit")]
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: dataRequest,
                                                           locationDescription: "a Loction Description",
                                                           weatherDescription: "a Weather Description")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.loadViewIfNeeded()
        sut.configure(with: model)
        
        let cell = sut.parametersView.dataSource?.collectionView(sut.parametersView, cellForItemAt: IndexPath(row: 0, section: 0)) as? WeatherPropertyCollectionViewCell
        XCTAssertEqual(cell?.iconView.image, nil)
    }
    
    func test_viewController_triggerActionForShareButton() {
        
        let presenter = DummyPresenter()
        let sut = WeatherDetailsViewController()
        sut.presenter = presenter
        
        let dataRequest = WeatherDescriptionViewModel.DataRequest { handler in
            handler(Data())
        }
        let propertiesModel: [WeatherPropertyCellViewModel] = [WeatherPropertyCellViewModel(icon: nil, description: "100Unit")]
        let descriptionModel = WeatherDescriptionViewModel(weatherImage: dataRequest,
                                                           locationDescription: "a Loction Description",
                                                           weatherDescription: "a Weather Description")
        let model = WeatherDetailsViewModel(title: "a title",
                                            weatherDescription: descriptionModel,
                                            wetherParameters: propertiesModel)
        sut.loadViewIfNeeded()
        sut.configure(with: model)
        sut.shareView.button.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(presenter.wetherShareTriggered)
    }
}
