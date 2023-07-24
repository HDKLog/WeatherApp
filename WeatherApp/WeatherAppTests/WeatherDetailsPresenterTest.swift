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

        var startLoadingAnimationCalls: Int = 0
        func startLoadingAnimation() {
            startLoadingAnimationCalls += 1
        }

        var stopLoadingAnimationCalls: Int = 0
        func stopLoadingAnimation() {
            stopLoadingAnimationCalls += 1
        }

        var displayEmptyScreenCalls: Int = 0
        func displayEmptyScreen() {
            displayEmptyScreenCalls += 1
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

        var getGeographicWeatherForecastCalls: Int = 0
        var getGeographicWeatherForecastCoordinates: [GeographicLocation] = []
        var getGeographicWeatherForecastCompletions: [GeographicWeatherForecastResult] = []
        func getGeographicWeatherForecast(for coordinates: GeographicLocation, completion: @escaping GeographicWeatherForecastResult) {
            getGeographicWeatherForecastCalls += 1
            getGeographicWeatherForecastCoordinates.append(coordinates)
            getGeographicWeatherForecastCompletions.append(completion)
        }

        var getGeographicWeatherForCalls: Int = 0
        var getGeographicWeatherForCoordinates: [GeographicLocation] = []
        var getGeographicWeatherForCompletions: [GeographicWeatherResult] = []
        func getGeographicWeather(for coordinates: GeographicLocation, completion: @escaping GeographicWeatherResult) {
            getGeographicWeatherForCalls += 1
            getGeographicWeatherForCoordinates.append(coordinates)
            getGeographicWeatherForCompletions.append(completion)
        }

        var getCurrentLocationCalls: Int = 0
        var getCurrentLocationCompletions: [GeographicLocationResult] = []
        func getCurrentLocation(completion: @escaping GeographicLocationResult) {
            getCurrentLocationCalls += 1
            getCurrentLocationCompletions.append(completion)
        }

        var getIconCalls: Int = 0
        var getIconNames: [String] = []
        var getIconCompletions: [GeographicWeatherIconResult] = []
        func getIcon(named: String, completion: @escaping GeographicWeatherIconResult) {
            getIconCalls += 1
            getIconNames.append(named)
            getIconCompletions.append(completion)
        }
    }

    var mokedModel: GeographicWeather {
        GeographicWeather(coordinates: GeographicLocation(latitude: 1, longitude: 1),
                          weather: [GeographicWeather.Weather(id: 1, main: "Main", description: "Description", icon: "01d")],
                          base: "Base",
                          main: GeographicWeather.Parameters(temperature: 1.0, feelsLike: 1, temperatureMinimum: 1, temperatureMaximum: 1, pressure: 1, humidity: 1),
                          visibility: 1,
                          wind: GeographicWeather.Wind(speed: 1, degrees: 012),
                          clouds: GeographicWeather.Clouds(all: 1),
                          data: 1,
                          system: GeographicWeather.System(type: 1, id: 1, country: "Country", sunrise: 1, sunset: 1),
                          timezone: 1,
                          id: 1,
                          name: "name",
                          code: 1)
    }

    var error: URLError { URLError(.cannotConnectToHost) }

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

    func test_presenter_init_storesUseCaseAtInitialization() {

        let useCase = UseCase()
        let sut = makeSut(useCase: useCase)

        XCTAssertIdentical(sut.weatherAppUseCase as? UseCase, useCase)
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
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.success(location))
        useCase.getGeographicWeatherForCompletions.first?(.success(mokedModel))


        XCTAssertNotEqual(view.configureWithModelCalls, 0)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureCallsDisplayError() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(view.displayErrorCalls, 1)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureCallsDisplayErrorWithError() {


        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(view.displayErrorErrors.first as? URLError, error)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureLoadsDefaultLocationWeather() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(useCase.getGeographicWeatherForCoordinates.first, GeographicLocation.defaultCoordinates)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureAndLoadDefaultLocationWeatherSuccessDisplaysDefaultLocationWeather() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))
        useCase.getGeographicWeatherForCompletions.first?(.success(mokedModel))

        XCTAssertNotNil(view.configureWithModelModels.first)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureAndLoadDefaultLocationWeatherFailureDisplaysError() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))
        useCase.getGeographicWeatherForCompletions.first?(.failure(error))

        XCTAssertEqual(view.displayErrorErrors.last as? URLError, error)
    }

    func test_presenter_onViewDidLoad_beforeLoadCurrentLocationWeatherStartLoadingAnimation() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()

        XCTAssertEqual(view.startLoadingAnimationCalls, 1)
    }

    func test_presenter_onViewDidLoad_afterLoadCurrentLocationWeatherStopLoadingAnimation() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))
        useCase.getGeographicWeatherForCompletions.first?(.success(mokedModel))

        XCTAssertEqual(view.stopLoadingAnimationCalls, 1)
    }

    func test_presenter_onReloadData_startsLoadingAnimation() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.reloadData()

        XCTAssertEqual(view.startLoadingAnimationCalls, 1)
    }

    func test_presenter_onReloadData_beforeLoadCurrentLocationWeatherStartsLoadingAnimation() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.reloadData()

        XCTAssertEqual(view.startLoadingAnimationCalls, 1)
    }

    func test_presenter_onReloadData_onLoadCurrentLocationSucessLoadsCorrectLocationWeather() {

        let location = GeographicLocation(latitude: 1, longitude: 1)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.reloadData()
        useCase.getCurrentLocationCompletions.first?(.success(location))

        XCTAssertEqual(useCase.getGeographicWeatherForCoordinates.first, location)
    }

    func test_presenter_onReloadData_onLoadCurrentLocationFailureCallsDisplayError() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.reloadData()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(view.displayErrorCalls, 1)
    }

    func test_presenter_onReloadData_onLoadCurrentLocationFailureCallsDisplayErrorWithError() {


        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.reloadData()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(view.displayErrorErrors.first as? URLError, error)
    }

    func test_presenter_onReloadData_onLoadCurrentLocationFailureLoadsDefaultLocationWeather() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.reloadData()
        useCase.getCurrentLocationCompletions.first?(.failure(error))

        XCTAssertEqual(useCase.getGeographicWeatherForCoordinates.first, GeographicLocation.defaultCoordinates)
    }

    func test_presenter_onReloadData_onLoadCurrentLocationFailureAndLoadDefaultLocationWeatherSuccessDisplaysDefaultLocationWeather() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.reloadData()
        useCase.getCurrentLocationCompletions.first?(.failure(error))
        useCase.getGeographicWeatherForCompletions.first?(.success(mokedModel))

        XCTAssertNotNil(view.configureWithModelModels.first)
    }

    func test_presenter_onReloadData_onLoadCurrentLocationFailureAndLoadDefaultLocationWeatherFailureDisplaysError() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.reloadData()
        useCase.getCurrentLocationCompletions.first?(.failure(error))
        useCase.getGeographicWeatherForCompletions.first?(.failure(error))

        XCTAssertEqual(view.displayErrorErrors.last as? URLError, error)
    }
}
