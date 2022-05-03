//
//  Currency.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 28/03/2022.
//

import Foundation

// MARK: Struct model for match Fixer JSON response

struct CurrencyModel: Codable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates : Rates
}

struct Rates: Codable {
    let USD, JPY, CAD, AUD, CHF, DKK, CNY, IDR, GBP, BGN, HUF, ISK, NOK, HRK, RUB, SEK, UAH, CZK, EUR : Double
}
