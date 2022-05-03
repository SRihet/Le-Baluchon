//
//  Translate.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 06/02/2022.
//

import Foundation

// MARK: Struct model for match Google Translate JSON response

struct TranslateModel: Codable {
    let data: DataClass
}
struct DataClass: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
}
