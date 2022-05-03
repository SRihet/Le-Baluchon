//
//  ParseProtocol.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 23/02/2022.
//

import Foundation

    // MARK: Parse Data with JSONDecoder

protocol ParseProtocol {
    /**
     Protocol for decode an API response and return the requested resource
     - Parameters:
        - data: data to decode
        - decoder: JSON decoder
     */
    static func parse(_ data: Data, with decoder: JSONDecoder) -> Any
}
