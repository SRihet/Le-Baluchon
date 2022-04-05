//
//  CurrencyService.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 28/03/2022.
//

import Foundation


class CurrencyService {
    
    var rateResult: [Double] =  [1.096419,134.679232,1.365804, 1.436128,1.015398,7.437127,6.977393,15741.897361, 0.835258, 1.95485,370.363935,141.602923,9.557894,7.540846, 92.718717, 10.30756,32.308035,24.339746]
    
    static func createRequest() -> URLRequest {
        let completeURL = CurrencyAPI.url
        let url = URL(string: completeURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}

extension CurrencyService: ParseProtocol {
    static func parse(_ data: Data, with decoder: JSONDecoder) -> Any {
        guard let json = try? JSONDecoder().decode(CurrencyModel.self, from: data) else {
            return (-1)
        }
        let resource = json
        return resource
    }
}
