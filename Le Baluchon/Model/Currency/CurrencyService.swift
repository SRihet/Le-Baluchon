//
//  CurrencyService.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 28/03/2022.
//

import Foundation


class CurrencyService {
    
    // MARK: Build a URL to access Fixer API
    
    static func createRequest() -> URLRequest {
        let completeURL = CurrencyAPI.url
        let url = URL(string: completeURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}

extension CurrencyService: ParseProtocol {
    
    // MARK: Parse JSON response
    
    static func parse(_ data: Data, with decoder: JSONDecoder) -> Any {
        guard let json = try? JSONDecoder().decode(CurrencyModel.self, from: data) else {
            return (-1)
        }
        let resource = json
        return resource
    }
}
