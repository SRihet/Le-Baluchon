//
//  Translate.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 06/02/2022.
//

import Foundation

//struct Translate: Codable {
//    var text: String
////    var detectedLanguage: String
//}

struct TranslateModel: Codable {
    let data: DataClass!
}
struct DataClass: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let translatedText: String
}
