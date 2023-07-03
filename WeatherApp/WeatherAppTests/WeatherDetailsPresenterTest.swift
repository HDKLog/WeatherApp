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

        var configureWithModelCalls: Int = 0
        var configureWithModelModels: [WeatherDetailsViewModel] = []
        func configure(with model: WeatherDetailsViewModel) {
            configureWithModelCalls += 1
            configureWithModelModels.append(model)
        }

        var showSharePopUpCalls: Int = 0
        var showSharePopUpDescriptions: [WeatherDescriptionViewModel?] = []
        func showSharePopUp(description: WeatherDescriptionViewModel?) {
            showSharePopUpCalls += 1
            showSharePopUpDescriptions.append(description)
        }

        var displayErrorCalls: Int = 0
        var displayErrorErrors: [Error] = []
        func displayError(error: Error) {
            displayErrorCalls += 1
            displayErrorErrors.append(error)
        }
    }

    class Router: WeatherAppRoutering {

        var rootToTabIndex: WeatherAppRouteringTab?
        var rootToTabCalls: Int = 0
        func rootTo(tab index: WeatherAppRouteringTab) {
            rootToTabIndex = index
            rootToTabCalls += 1
        }
    }

    class UseCase: WeatherAppUseableCase {

        var getGeographicWeatherForecastForCalls: Int = 0
        var getGeographicWeatherForecastForCoordinates: [WeatherApp.GeographicLocation] = []
        var getGeographicWeatherForecastForCompletions: [WeatherApp.GeographicWeatherForecastResult] = []
        func getGeographicWeatherForecast(for coordinates: WeatherApp.GeographicLocation, completion: @escaping WeatherApp.GeographicWeatherForecastResult) {
            getGeographicWeatherForecastForCalls += 1
            getGeographicWeatherForecastForCoordinates.append(coordinates)
            getGeographicWeatherForecastForCompletions.append(completion)
        }

        var getGeographicWeatherForCalls: Int = 0
        var getGeographicWeatherForCoordinates: [WeatherApp.GeographicLocation] = []
        var getGeographicWeatherForCompletions: [WeatherApp.GeographicWeatherResult] = []
        func getGeographicWeather(for coordinates: WeatherApp.GeographicLocation, completion: @escaping WeatherApp.GeographicWeatherResult) {
            getGeographicWeatherForCalls += 1
            getGeographicWeatherForCoordinates.append(coordinates)
            getGeographicWeatherForCompletions.append(completion)
        }

        var getCurrentLocationCalls: Int = 0
        var getCurrentLocationCompletions: [WeatherApp.GeographicLocationResult] = []
        func getCurrentLocation(completion: @escaping WeatherApp.GeographicLocationResult) {
            getCurrentLocationCalls += 1
            getCurrentLocationCompletions.append(completion)
        }

        var getIconCalls: Int = 0
        var getIconCompletions: [WeatherApp.GeographicWeatherIconResult] = []
        func getIcon(named: String, completion: @escaping WeatherApp.GeographicWeatherIconResult) {
            getIconCalls += 1
            getIconCompletions.append(completion)
        }


    }

    func makeSut(view: WeatherDetailsView? = nil,
                 router: WeatherAppRoutering? = nil,
                 useCase: WeatherAppUseableCase? = nil) -> WeatherDetailsPresenter {

        let sut = WeatherDetailsPresenter(view: view, router: router, weatherAppUseCase: useCase)

        return sut
    }

    func test_presenter_init_storesViewAtInitialization() {

        let view = View()
        let sut = makeSut(view: view)

        XCTAssertIdentical(sut.view as? View, view)
    }

    func test_presenter_init_storesRouterAtInitialization() {

        let router = Router()
        let sut = makeSut(router: router)

        XCTAssertIdentical(sut.router as? Router, router)
    }

    func test_presenter_onViewDidLoad_loadsCurrentLocation() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()

        XCTAssertEqual(useCase.getCurrentLocationCalls, 1)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationSucessLoadsCurrentLocationWeather() {

        let location = GeographicLocation(latitude: 1, longitude: 1)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.success(location))

        XCTAssertEqual(useCase.getGeographicWeatherForCalls, 1)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationSucessLoadsCorrectLocationWeather() {

        let location = GeographicLocation(latitude: 1, longitude: 1)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.success(location))

        XCTAssertEqual(useCase.getGeographicWeatherForCoordinates.first, location)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationSucessDisplayLocationWeather() {

        let location = GeographicLocation(latitude: 1, longitude: 1)
        let model = GeographicWeather(coordinates: location,
                                      weather: [GeographicWeather.Weather(id: 1, main: "Main", description: "Description", icon: "01d")],
                                      base: "Base",
                                      main: GeographicWeather.Parameters(temperature: 1.0, feelsLike: 1, temperatureMinimum: 1, temperatureMaximum: 1, pressure: 1, humidity: 1),
                                      visibility: 1,
                                      wind: GeographicWeather.Wind(speed: 1, degrees: 1),
                                      clouds: GeographicWeather.Clouds(all: 1),
                                      data: 1,
                                      system: GeographicWeather.System(type: 1, id: 1, country: "Country", sunrise: 1, sunset: 1),
                                      timezone: 1,
                                      id: 1,
                                      name: "name",
                                      code: 1)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.success(location))
        useCase.getGeographicWeatherForCompletions.first?(.success(model))


        XCTAssertEqual(view.configureWithModelCalls, 1)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureCallsDisplayError() {

        let error = NSError(domain: "testDomain", code: -4)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(view.displayErrorCalls, 1)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureCallsDisplayErrorWithError() {

        let error = NSError(domain: "testDomain", code: -4)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertIdentical(view.displayErrorErrors.first as? NSError, error)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureLoadsDefaultLocationWeather() {

        let error = NSError(domain: "testDomain", code: -4)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(useCase.getGeographicWeatherForCoordinates.first, GeographicLocation.defaultCoordinates)
    }

    func test_presenter_onViewDidLoad_onLoadDefaultLocationWeatherSuccess() {

        let error = NSError(domain: "testDomain", code: -4)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(useCase.getGeographicWeatherForCoordinates.first, GeographicLocation.defaultCoordinates)
    }
}
