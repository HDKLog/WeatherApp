//
//  WeatherDetailsPresenter.swift
//  WeatherAppTests
//
//  Created by Gari Sarkisyan on 02.07.23.
//

import XCTest
@testable import WeatherApp

final class WeatherDetailsPresenterTest: XCTestCase {

    class View: WeatherDetailsView {

        var configureWithModel: WeatherDetailsViewModel?
        var configureWithModelCalls: Int = 0
        func configure(with model: WeatherDetailsViewModel) {
            configureWithModel = model
            configureWithModelCalls += 1
        }

        func showSharePopUp(description: WeatherDescriptionViewModel?) {}
        func displayError(error: Error) {}
    }

    class Router: WeatherAppRoutering {

        var rootToTabIndex: WeatherAppRouteringTab?
        var rootToTabCalls: Int = 0
        func rootTo(tab index: WeatherAppRouteringTab) {
            rootToTabIndex = index
            rootToTabCalls += 1
        }
    }

    func makeSut(view: WeatherDetailsView? = nil,
                 router: WeatherAppRoutering? = nil) -> WeatherDetailsPresenter {

        let sut = WeatherDetailsPresenter(view: view, router: router)

        return sut
    }

    func test_init_storesViewAtInitialization() {

        let view = View()
        let sut = makeSut(view: view)

        XCTAssertIdentical(sut.view as? View, view)
    }

    func test_init_storesRouterAtInitialization() {

        let router = Router()
        let sut = makeSut(router: router)

        XCTAssertIdentical(sut.router as? Router, router)
    }
}
