//
//  TranslateTestCase.swift
//  Le BaluchonTests
//
//  Created by Stéphane Rihet on 06/04/2022.
//

import XCTest
@testable import Le_Baluchon

class TranslateTestCase: XCTestCase {

    var translate : NetWorker!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.translationCorrectData
            return (response, data, error)
        }
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        let session = URLSession(configuration: configuration)
        translate = NetWorker(session: session)
        expectation = XCTestExpectation(description: "Expectation")
    }
    
    // MARK: - Networker tests
    func testTranslateNetWorkerPostFailedCallbackIfError() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = MockResponseData.translationError
            let data: Data? = nil
            return (response, data, error)
        }
        // Call API
        translate.query(API: .translate, input: "École informatique") { (success, translation) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testTranslateNetWorkerPostFailedCallbackIfNoData() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }

        // Call API
        translate.query(API: .translate, input: "École informatique") { (success, translation) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testTranslateNetWorkerFailedCallbackIfIncorrectResponse() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseIncorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.translationCorrectData
            return (response, data, error)
        }

        // Call API
        translate.query(API: .translate, input: "École informatique") { (success, translation) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTranslateNetWorkerFailedCallbackIfIncorrectData() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.translationIncorrectData
            return (response, data, error)
        }

        // Call API
        translate.query(API: .translate, input: "École informatique") { (success, translation) in
            // Assert cases
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testTranslateNetWorkerPostSuccessCallbackIfCorrectDataAndNoError() {
        // Prepare mock response
        TestURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = MockResponseData.responseCorrect
            let error: Error? = nil
            let data: Data? = MockResponseData.translationCorrectData
            return (response, data, error)
        }

        // Call API
        translate.query(API: .translate, input: "input") { (success, translation) in
            // Assert cases
            let text = "computer school"
            XCTAssertTrue(success)
            XCTAssertNotNil(translation)
            let translation = translation as? TranslateModel
            XCTAssertEqual(text,translation?.data.translations[0].translatedText)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
