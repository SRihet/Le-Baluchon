//
//  WebService.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 23/02/2022.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST", get = "GET"
}

enum WebService {
    case currency, translate, weather
}

// MARK: - Fixer
struct CurrencyAPI {
    static private let endpoint = "http://data.fixer.io/api/latest"
    static private let accessKey = "?access_key=7b69386e28de35a6d89f696e02ab43eb"


    static var url: String { return CurrencyAPI.endpoint + CurrencyAPI.accessKey }
}

// MARK: - Google Translation
struct TranslationAPI {
    static private let endpoint = "https://translation.googleapis.com/language/translate/v2"
    static private let accessKey = "?key=AIzaSyDKs64sJB69928OzGkKuSy7Njsen7dTuqg"
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
    static private let accessKey = "APPID=531b5e5af3cf2eb606b0b9f9bad625a4"
    static let city = "&q="
    static private let units = "&units=metric"
    static private let lang = "&lang=en"


    static var url: String {
        return WeatherAPI.endpoint + WeatherAPI.accessKey + WeatherAPI.units + WeatherAPI.lang
    }
}
