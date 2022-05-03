//
//  MockResponseData.swift
//  Le BaluchonTests
//
//  Created by Stéphane Rihet on 06/04/2022.
//

import Foundation


class MockResponseData {
    
    // MARK: - Valid data
    static var currencyCorrectData: Data? {
        let bundle = Bundle(for: MockResponseData.self)
        let url = bundle.url(forResource: "Currency", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var translationCorrectData: Data? {
        let bundle = Bundle(for: MockResponseData.self)
        let url = bundle.url(forResource: "Translation", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: MockResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}

// MARK: - Response
extension MockResponseData {
    // HTTP status code is 200
    static let responseCorrect = HTTPURLResponse(
        url: URL(string: "https://google.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    // HTTP status code is 500
    static let responseIncorrect = HTTPURLResponse(
        url: URL(string: "https://google.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
}

// MARK: - Invalid data
extension MockResponseData {
    static let currencyIncorrectData = "erreur".data(using: .utf8)!
    static let translationIncorrectData = "erreur".data(using: .utf8)!
    static let weatherIncorrectData = "erreur".data(using: .utf8)!

}

// MARK: - Error
extension MockResponseData {
    class CurrencyError: Error {}
    static let currencyError = CurrencyError()
    
    class TranslationError: Error {}
    static let translationError = TranslationError()

    class WeatherError: Error {}
    static let weatherError = WeatherError()

}
