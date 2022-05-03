//
//  CurrencyTestCase.swift
//  Le BaluchonTests
//
//  Created by Stéphane Rihet on 05/04/2022.
//

import XCTest
@testable import Le_Baluchon

class CurrencyTestCase: XCTestCase {
    
    var currency : NetWorker!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.currencyCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        currency = NetWorker(session: session)
        expectation = XCTestExpectation(description: "Expectation")
    }
    
    // MARK: - Networker tests
    func testCurrencyNetWorkerPostFailedCallbackIfError() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = MockResponseData.currencyError
            let data: Data? = nil
            return (response, data, error)
        }
        
        // Call API
        currency.query(API: .currency, input: "") { (success, currency) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testCurrencyNetWorkerPostFailedCallbackIfNoData() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }
        
        // Call API
        currency.query(API: .currency, input: "") { (success, currency) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCurrencyNetWorkerFailedCallbackIfIncorrectResponse() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.currencyCorrectData
            return (response, data, error)
        }
        
        // Call API
        currency.query(API: .currency, input: "") { (success, currency) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCurrencyNetWorkerFailedCallbackIfIncorrectData() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.currencyIncorrectData
            return (response, data, error)
        }
        
        // Call API
        currency.query(API: .currency, input: "") { (success, currency) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(currency)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCurrencyNetWorkerPostSuccessCallbackIfCorrectDataAndNoError() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.currencyCorrectData
            return (response, data, error)
        }
        
        // Call API
        currency.query(API: .currency, input: "") { (success, currency) in
            // Assert cases
            let success = true
            let date = "2022-04-11"
            let base = "EUR"
            let rateUSD = 1.088364
            let rateAUD = 1.46756
            let rateIDR = 15633.537025
            let rateSEK = 10.328561
            let rateCZK = 24.424637
            XCTAssertTrue(success)
            XCTAssertNotNil(currency)
            let currency = currency as? CurrencyModel
            print(currency!.rates)
            XCTAssertEqual(success, currency!.success)
            XCTAssertEqual(date, currency!.date)
            XCTAssertEqual(base, currency!.base)
            XCTAssertEqual(rateUSD, currency!.rates.USD)
            XCTAssertEqual(rateIDR, currency!.rates.IDR)
            XCTAssertEqual(rateAUD, currency!.rates.AUD)
            XCTAssertEqual(rateSEK, currency!.rates.SEK)
            XCTAssertEqual(rateCZK, currency!.rates.CZK)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
