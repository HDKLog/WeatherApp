//
//  WeatherForecastPresenterTest.swift
//  WeatherAppTests
//
//  Created by Gari Sarkisyan on 16.07.23.
//

import XCTest
@testable import WeatherApp

final class WeatherForecastPresenterTest: XCTestCase {

    class View: WeatherForecastView {
        var configureWithModelCalls: Int = 0
        var configureWithModelModels: [WeatherForecastViewModel] = []
        func configure(with model: WeatherForecastViewModel) {
            configureWithModelCalls += 1
            configureWithModelModels.append(model)
        }

        var reloadListCalls: Int = 0
        func reloadList() {
            reloadListCalls += 1
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

    var mokedModel: GeographicWeatherForecast {
        GeographicWeatherForecast(code: "200",
                                  message: 0,
                                  count: 2,
                                  list: [GeographicWeatherForecast.Forecast(dateTime: 1689465600.0,
                                                                            main: GeographicWeatherForecast.Forecast.Parameters(
                                                                                temperature: 22.25,
                                                                                feelsLike: 22.31,
                                                                                temperatureMinimum: 19.1,
                                                                                temperatureMaximum: 22.25,
                                                                                pressure: 1011.0,
                                                                                seaLevel: 1011.0,
                                                                                groundLevel: 1008.0,
                                                                                humidity: 68
                                                                            ),
                                                                            weather: [
                                                                                GeographicWeatherForecast.Forecast.Weather(
                                                                                    id: 801,
                                                                                    main: "Clouds",
                                                                                    description: "few clouds",
                                                                                    icon: "02d"
                                                                                )],
                                                                            clouds: GeographicWeatherForecast.Forecast.Clouds(all: 20),
                                                                            wind: GeographicWeatherForecast.Forecast.Wind(
                                                                                speed: 4.18,
                                                                                degrees: 260,
                                                                                gust: 5.24
                                                                            ),
                                                                            visibility: 10000,
                                                                            probabilityOfPrecipitation: 0.0,
                                                                            system: GeographicWeatherForecast.Forecast.System(partOfDay: "d"),
                                                                            dateTimeText: "2023-07-16 00:00:00")

                                        ],
                                  city: GeographicWeatherForecast.City(
                                    id: 5391959,
                                    name: "San Francisco",
                                    coord: GeographicLocation(latitude: -122.4064, longitude: 37.7858),
                                    country: "US",
                                    population: 805235,
                                    timezone: -25200,
                                    sunrise: 1689425965,
                                    sunset: 1689478280
                                  )
        )
    }

    var error: URLError { URLError(.cannotConnectToHost) }

    func makeSut(view: WeatherForecastView? = nil,
                 router: WeatherAppRoutering? = nil,
                 useCase: WeatherAppUseableCase? = nil) -> WeatherForecastPresenter {

        let sut = WeatherForecastPresenter(view: view, router: router, weatherAppUseCase: useCase)

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

    func test_presenter_onViewDidLoad_loadsCurrentLocationForecast() {

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

        XCTAssertEqual(useCase.getGeographicWeatherForecastCalls, 1)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationSucessLoadsCorrectLocationWeather() {

        let location = GeographicLocation(latitude: 1, longitude: 1)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.success(location))

        XCTAssertEqual(useCase.getGeographicWeatherForecastCoordinates.first, location)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationSucessDisplayLocationWeather() {

        let location = GeographicLocation(latitude: 1, longitude: 1)
        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.success(location))
        useCase.getGeographicWeatherForecastCompletions.first?(.success(mokedModel))


        XCTAssertEqual(view.configureWithModelCalls, 1)
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

        XCTAssertEqual(useCase.getGeographicWeatherForecastCoordinates.first, GeographicLocation.defaultCoordinates)
    }

    func test_presenter_onViewDidLoad_onLoadCurrentLocationFailureAndLoadDefaultLocationWeatherSuccessDisplaysDefaultLocationWeather() {

        let useCase = UseCase()
        let view = View()
        let sut = makeSut(view: view, useCase: useCase)

        sut.viewDidLoad()
        useCase.getCurrentLocationCompletions.first?(.failure(error))
        useCase.getGeographicWeatherForecastCompletions.first?(.success(mokedModel))

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
}
