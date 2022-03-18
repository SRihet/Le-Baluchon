//
//  ParseProtocol.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 23/02/2022.
//

import Foundation

/// Parse data using a `JSONDecoder`
protocol ParseProtocol {
    /**
     Decode an API response and return the requested resource

     - Attention: Webservices _must_ implemement this protocol

     - Parameters:
        - data: data to decode
        - decoder: JSON decoder
     */
    static func parse(_ data: Data, with decoder: JSONDecoder) -> Any
}
