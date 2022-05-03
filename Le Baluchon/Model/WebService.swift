//
//  WebService.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 23/02/2022.
//

import Foundation

// List of HTTP method
enum HTTPMethod: String {
    case post = "POST", get = "GET"
}

// List of APIs (webservice)
enum WebService {
    case currency, translate, weather
}

// MARK: - Fixer
struct CurrencyAPI {
    static private let endpoint = "http://data.fixer.io/api/latest"
    static private let accessKey = "?access_key=\(currencyApiKey)"
    static private let symbols = "&symbols=USD,JPY,CAD,AUD,CHF,DKK,CNY,IDR,GBP,BGN,HUF,ISK,NOK,HRK,RUB,SEK,UAH,CZK,EUR"


    static var url: String {
        return CurrencyAPI.endpoint + CurrencyAPI.accessKey  + CurrencyAPI.symbols
    }
}

// MARK: - Google Translation
struct TranslationAPI {
    static private let endpoint = "https://translation.googleapis.com/language/translate/v2"
    static private let accessKey = "?key=\(translationApiKey)"
    static let source = "&source="
    static let target = "&target="
    static let text = "&format=text&q="


    static var url: String {
        return TranslationAPI.endpoint + TranslationAPI.accessKey
    }
}

// MARK: - Open Weather Map
struct WeatherAPI {
    static private let endpoint = "https://api.openweathermap.org/data/2.5/weather?"
    static private let accessKey = "APPID=\(weatherApiKey)"
    static let city = "&q="
    static private let units = "&units=metric"
    static private let lang = "&lang=fr"


    static var url: String {
        return WeatherAPI.endpoint + WeatherAPI.accessKey + WeatherAPI.units + WeatherAPI.lang
    }
}
