//
//  Weather.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 23/02/2022.
//

import Foundation

// MARK: Struct model for match OpenWeatherMap JSON response

struct WeatherModel: Codable {
    let weather: [WeatherElement]
    let main: Main
    let id: Int
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherElement: Codable {
    let description, main: String
}
