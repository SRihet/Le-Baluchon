//
//  WeathertestCase.swift
//  Le BaluchonTests
//
//  Created by Stéphane Rihet on 06/04/2022.
//

import XCTest
@testable import Le_Baluchon

class WeatherTestCase: XCTestCase {

    var weather : NetWorker!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.weatherCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        weather = NetWorker(session: session)
        expectation = XCTestExpectation(description: "Expectation")
    }
    
    // MARK: - Networker tests
    func testWeatherNetWorkerPostFailedCallbackIfError() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = MockResponseData.weatherError
            let data: Data? = nil
            return (response, data, error)
        }

        // Call API
        weather.query(API: .weather, input: "Londres") { (success, weather) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testWeatherNetWorkerPostFailedCallbackIfNoData() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }
        
        // Call API
        weather.query(API: .weather, input: "Londres") { (success, weather) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testWeatherNetWorkerFailedCallbackIfIncorrectResponse() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.translationCorrectData
            return (response, data, error)
        }
        
        // Call API
        weather.query(API: .weather, input: "Londres") { (success, weather) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testWeatherNetWorkerFailedCallbackIfIncorrectData() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.translationIncorrectData
            return (response, data, error)
        }
        
        // Call API
        weather.query(API: .weather, input: "Londres") { (success, weather) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testWeatherNetWorkerPostSuccessCallbackIfCorrectDataAndNoError() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.weatherCorrectData
            return (response, data, error)
        }
        
        // Call API
        weather.query(API: .weather, input: "Londres") { (success, weather) in
            // Assert cases
            let temp = 14.22
            let temp_min = 13.33
            let temp_max = 15.15
            let weatherMain = "Clouds"
            let weatherdescription = "nuageux"
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            let weather =  weather as? WeatherModel
            XCTAssertEqual(temp, weather?.main.temp)
            XCTAssertEqual(temp_min, weather?.main.temp_min)
            XCTAssertEqual(temp_max, weather?.main.temp_max)
            XCTAssertEqual(weatherMain, weather!.weather[0].main)
            XCTAssertEqual(weatherdescription, weather!.weather[0].description)

            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
