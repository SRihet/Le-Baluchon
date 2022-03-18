//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 23/02/2022.
//

import Foundation

class WeatherService {
    
    static func createRequest(for parameters: String) -> URLRequest {
        let encodedParameters = parameters.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        let completeURL = WeatherAPI.url + encodedParameters!
        print(completeURL)
        let url = URL(string: completeURL)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue

        return request
    }
    
}

extension WeatherService: ParseProtocol {
    static func parse(_ data: Data, with decoder: JSONDecoder) -> Any {
        guard let json = try? decoder.decode(WeatherModel.self, from: data) else {
            return (-1)
        }

        let resource = json
        return resource
    }
}

